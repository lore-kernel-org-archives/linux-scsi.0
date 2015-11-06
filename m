From: KY Srinivasan <kys@microsoft.com>
Subject: RE: [PATCH RESEND] scsi_sysfs: protect against double execution of
 __scsi_remove_device()
Date: Fri, 6 Nov 2015 17:48:03 +0000
Message-ID: <BY2PR0301MB1654AA3DFEEACB17958AA06AA0280@BY2PR0301MB1654.namprd03.prod.outlook.com>
References: <1446824969-7049-1-git-send-email-vkuznets@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1446824969-7049-1-git-send-email-vkuznets@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Vitaly Kuznetsov <vkuznets@redhat.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Friday, November 6, 2015 7:49 AM
> To: James E.J. Bottomley <JBottomley@odin.com>
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; KY Srinivasan
> <kys@microsoft.com>; Bart Van Assche <bart.vanassche@sandisk.com>
> Subject: [PATCH RESEND] scsi_sysfs: protect against double execution of
> __scsi_remove_device()
> 
> On some host errors storvsc module tries to remove sdev by scheduling a job
> which does the following:
> 
>    sdev = scsi_device_lookup(wrk->host, 0, 0, wrk->lun);
>    if (sdev) {
>        scsi_remove_device(sdev);
>        scsi_device_put(sdev);
>    }
> 
> While this code seems correct the following crash is observed:
> 
>  general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
>  RIP: 0010:[<ffffffff81169979>]  [<ffffffff81169979>] bdi_destroy+0x39/0x220
>  ...
>  [<ffffffff814aecdc>] ? _raw_spin_unlock_irq+0x2c/0x40
>  [<ffffffff8127b7db>] blk_cleanup_queue+0x17b/0x270
>  [<ffffffffa00b54c4>] __scsi_remove_device+0x54/0xd0 [scsi_mod]
>  [<ffffffffa00b556b>] scsi_remove_device+0x2b/0x40 [scsi_mod]
>  [<ffffffffa00ec47d>] storvsc_remove_lun+0x3d/0x60 [hv_storvsc]
>  [<ffffffff81080791>] process_one_work+0x1b1/0x530
>  ...
> 
> The problem comes with the fact that many such jobs (for the same device)
> are being scheduled simultaneously. While scsi_remove_device() uses
> shost->scan_mutex and scsi_device_lookup() will fail for a device in
> SDEV_DEL state there is no protection against someone who did
> scsi_device_lookup() before we actually entered __scsi_remove_device().
> So
> the whole scenario looks like that: two callers do simultaneous (or
> preemption happens) calls to scsi_device_lookup() ant these calls succeed
> for both of them, after that they try doing scsi_remove_device().
> shost->scan_mutex only serializes their calls to __scsi_remove_device()
> and we end up doing the cleanup path twice.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>

James,

I too have a bunch of patches in your queue (sent about a month ago).
Should I resend them as well.

Regards,

K. Y
