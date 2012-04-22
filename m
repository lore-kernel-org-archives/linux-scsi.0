From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 12/12] scsi_transport_sas: fix delete vs scan race
Date: Sun, 22 Apr 2012 08:43:22 -0700
Message-ID: <CABE8wwssa-_MsCTe0FJeCLY5KTk1sRcsmUjF8Sb-5sofc=zuFQ@mail.gmail.com>
References: <20120413233343.8025.18101.stgit@dwillia2-linux.jf.intel.com>
	<20120413233752.8025.97983.stgit@dwillia2-linux.jf.intel.com>
	<1335091115.13208.14.camel@dabdike.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42173 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146Ab2DVPnZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Apr 2012 11:43:25 -0400
Received: by bkcji2 with SMTP id ji2so291364bkc.25
        for <linux-scsi@vger.kernel.org>; Sun, 22 Apr 2012 08:43:23 -0700 (PDT)
In-Reply-To: <1335091115.13208.14.camel@dabdike.lan>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Sun, Apr 22, 2012 at 3:38 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2012-04-13 at 16:37 -0700, Dan Williams wrote:
>> The following crash results from cases where the end_device has been
>> removed before scsi_sysfs_add_sdev has had a chance to run.
>>
>> =A0BUG: unable to handle kernel NULL pointer dereference at 00000000=
00000098
>> =A0IP: [<ffffffff8115e100>] sysfs_create_dir+0x32/0xb6
>> =A0...
>> =A0Call Trace:
>> =A0 [<ffffffff8125e4a8>] kobject_add_internal+0x120/0x1e3
>> =A0 [<ffffffff81075149>] ? trace_hardirqs_on+0xd/0xf
>> =A0 [<ffffffff8125e641>] kobject_add_varg+0x41/0x50
>> =A0 [<ffffffff8125e70b>] kobject_add+0x64/0x66
>> =A0 [<ffffffff8131122b>] device_add+0x12d/0x63a
>> =A0 [<ffffffff814b65ea>] ? _raw_spin_unlock_irqrestore+0x47/0x56
>> =A0 [<ffffffff8107de15>] ? module_refcount+0x89/0xa0
>> =A0 [<ffffffff8132f348>] scsi_sysfs_add_sdev+0x4e/0x28a
>> =A0 [<ffffffff8132dcbb>] do_scan_async+0x9c/0x145
>>
>> ...teach sas_rphy_remove to wait for async scanning to quiesce befor=
e
>> removing the end_device. =A0It seems this is a more general problem =
[1],
>> but this patch only addresses sas transport.
>>
>> [1]: 23edb6e [SCSI] mpt2sas: Do not set sas_device->starget to NULL =
from
>> the slave_destroy callback when all the LUNS have been deleted
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>> =A0drivers/scsi/scsi_transport_sas.c | =A0 =A06 +++++-
>> =A01 file changed, 5 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_t=
ransport_sas.c
>> index f7565fc..47abb90 100644
>> --- a/drivers/scsi/scsi_transport_sas.c
>> +++ b/drivers/scsi/scsi_transport_sas.c
>> @@ -33,8 +33,9 @@
>> =A0#include <linux/bsg.h>
>>
>> =A0#include <scsi/scsi.h>
>> -#include <scsi/scsi_device.h>
>> =A0#include <scsi/scsi_host.h>
>> +#include <scsi/scsi_scan.h>
>> +#include <scsi/scsi_device.h>
>> =A0#include <scsi/scsi_transport.h>
>> =A0#include <scsi/scsi_transport_sas.h>
>>
>> @@ -1667,6 +1668,9 @@ sas_rphy_remove(struct sas_rphy *rphy)
>> =A0{
>> =A0 =A0 =A0 struct device *dev =3D &rphy->dev;
>>
>> + =A0 =A0 /* prevent device_del() while child device_add() may be in=
-flight */
>> + =A0 =A0 scsi_complete_async_scans();
>> +
>> =A0 =A0 =A0 switch (rphy->identify.device_type) {
>
> This doesn't really fix the problem, it merely narrows the window (we
> still crash in the much shorter window if another async scan starts
> after you check for completion).

Oh, I was under the impression that async scanning was only the
initial scan and everything was sync thereafter since
scsi_finish_async_scan() clears the host ->async_scan flag?

> Isn't the fix that will prevent all of
> this to hold the scan mutex across scsi_remove_device() ... in which
> case it should probably be part of scsi_remove_device()?

I thought along these lines initially, but in this case we're crashing
because the sas rphy is removed before the starget is added, so
scsi_remove_device() is out of the picture.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
