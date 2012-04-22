From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 12/12] scsi_transport_sas: fix delete vs scan race
Date: Sun, 22 Apr 2012 11:38:35 +0100
Message-ID: <1335091115.13208.14.camel@dabdike.lan>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	 <20120413233752.8025.97983.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20120413233752.8025.97983.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
> The following crash results from cases where the end_device has been
> removed before scsi_sysfs_add_sdev has had a chance to run.
> 
>  BUG: unable to handle kernel NULL pointer dereference at 0000000000000098
>  IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
>  ...
>  Call Trace:
>   [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
>   [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
>   [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
>   [<ffffffff8125e70b>] kobject_add+0x64/0x66
>   [<ffffffff8131122b>] device_add+0x12d/0x63a
>   [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
>   [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
>   [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
>   [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145
> 
> ...teach sas_rphy_remove to wait for async scanning to quiesce before
> removing the end_device.  It seems this is a more general problem [1],
> but this patch only addresses sas transport.
> 
> [1]: 23edb6e [SCSI] mpt2sas: Do not set sas_device->starget to NULL from
> the slave_destroy callback when all the LUNS have been deleted
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/scsi/scsi_transport_sas.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index f7565fc..47abb90 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -33,8 +33,9 @@
>  #include <linux/bsg.h>
>  
>  #include <scsi/scsi.h>
> -#include <scsi/scsi_device.h>
>  #include <scsi/scsi_host.h>
> +#include <scsi/scsi_scan.h>
> +#include <scsi/scsi_device.h>
>  #include <scsi/scsi_transport.h>
>  #include <scsi/scsi_transport_sas.h>
>  
> @@ -1667,6 +1668,9 @@ sas_rphy_remove(struct sas_rphy *rphy)
>  {
>  	struct device *dev = &rphy->dev;
>  
> +	/* prevent device_del() while child device_add() may be in-flight */
> +	scsi_complete_async_scans();
> +
>  	switch (rphy->identify.device_type) {

This doesn't really fix the problem, it merely narrows the window (we
still crash in the much shorter window if another async scan starts
after you check for completion).  Isn't the fix that will prevent all of
this to hold the scan mutex across scsi_remove_device() ... in which
case it should probably be part of scsi_remove_device()?

James


