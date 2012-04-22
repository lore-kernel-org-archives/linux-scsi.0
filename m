From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/12] scsi_transport_sas: fix delete vs scan race
Date: Sun, 22 Apr 2012 18:15:24 +0100
Message-ID: <1335114924.13208.27.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233752.8025.97983.stgit@dwillia2-linux.jf.intel.com>
	 <1335091115.13208.14.camel@dabdike.lan>
	 <CABE8wwssa-_MsCTe0FJeCLY5KTk1sRcsmUjF8Sb-5sofc=zuFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CABE8wwssa-_MsCTe0FJeCLY5KTk1sRcsmUjF8Sb-5sofc=zuFQ@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2012-04-22 at 08:43 -0700, Dan Williams wrote:
> On Sun, Apr 22, 2012 at 3:38 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> > On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> >> The following crash results from cases where the end_device has been
> >> removed before scsi_sysfs_add_sdev has had a chance to run.
> >>
> >>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
> >>  IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
> >>  ...
> >>  Call Trace:
> >>   [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
> >>   [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
> >>   [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
> >>   [<ffffffff8125e70b>] kobject_add+0x64/0x66
> >>   [<ffffffff8131122b>] device_add+0x12d/0x63a
> >>   [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
> >>   [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
> >>   [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
> >>   [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145
> >>
> >> ...teach sas_rphy_remove to wait for async scanning to quiesce before
> >> removing the end_device.  It seems this is a more general problem [1],
> >> but this patch only addresses sas transport.
> >>
> >> [1]: 23edb6e [SCSI] mpt2sas: Do not set sas_device->starget to NULL from
> >> the slave_destroy callback when all the LUNS have been deleted
> >>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >> ---
> >>  drivers/scsi/scsi_transport_sas.c |    6 +++++-
> >>  1 file changed, 5 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> >> index f7565fc..47abb90 100644
> >> --- a/drivers/scsi/scsi_transport_sas.c
> >> +++ b/drivers/scsi/scsi_transport_sas.c
> >> @@ -33,8 +33,9 @@
> >>  #include <linux/bsg.h>
> >>
> >>  #include <scsi/scsi.h>
> >> -#include <scsi/scsi_device.h>
> >>  #include <scsi/scsi_host.h>
> >> +#include <scsi/scsi_scan.h>
> >> +#include <scsi/scsi_device.h>
> >>  #include <scsi/scsi_transport.h>
> >>  #include <scsi/scsi_transport_sas.h>
> >>
> >> @@ -1667,6 +1668,9 @@ sas_rphy_remove(struct sas_rphy *rphy)
> >>  {
> >>       struct device *dev = &rphy->dev;
> >>
> >> +     /* prevent device_del() while child device_add() may be in-flight */
> >> +     scsi_complete_async_scans();
> >> +
> >>       switch (rphy->identify.device_type) {
> >
> > This doesn't really fix the problem, it merely narrows the window (we
> > still crash in the much shorter window if another async scan starts
> > after you check for completion).
> 
> Oh, I was under the impression that async scanning was only the
> initial scan and everything was sync thereafter since
> scsi_finish_async_scan() clears the host ->async_scan flag?

Async scan here means any scan in a different thread, right ... it just
has to be asynchronous relative to us?  So that includes the manually
initiated ones and hotplug ones, doesn't it?

> > Isn't the fix that will prevent all of
> > this to hold the scan mutex across scsi_remove_device() ... in which
> > case it should probably be part of scsi_remove_device()?
> 
> I thought along these lines initially, but in this case we're crashing
> because the sas rphy is removed before the starget is added, so
> scsi_remove_device() is out of the picture.

Just adding the sequence

mutex_lock(&shost->scan_mutex);
mutex_unlock(&shost->scan_mutex);

is logically a subset of

scsi_complete_async_scans()

So putting it here:

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index f7565fc..c89bba6 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1669,7 +1669,9 @@ sas_rphy_remove(struct sas_rphy *rphy)
 
 	switch (rphy->identify.device_type) {
 	case SAS_END_DEVICE:
+		mutex_lock(&shost->scan_mutex);
 		scsi_remove_target(dev);
+		mutex_unlock(&shost->scan_mutex);
 		break;
 	case SAS_EDGE_EXPANDER_DEVICE:
 	case SAS_FANOUT_EXPANDER_DEVICE:

should definitely be equivalent to scsi_complete_async_scans() above the
switch statement.  The questions are a) should it be inside
scsi_remove_target() because that seems to be the sync point and b) does
it fix all the races.

James


