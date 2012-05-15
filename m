From: Mark Salyzyn <mark_salyzyn@xyratex.com>
Subject: Re: [PATCH][SCSI] panic within ses.ko during insmod
Date: Mon, 14 May 2012 17:11:11 -0700
Message-ID: <026B04FB-FAF6-4EF5-A162-BC7FDB5DB145@xyratex.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com> <1321028069.21400.24.camel@nebulus.xyus.xyratex.com> <4EBD948E.9000104@interlog.com> <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com> <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com> <1329667370.2806.6.camel@dabdike.int.hansenpartnership.com> <8A8902EE-82F3-4CBA-82D6-D689B49C28BC@xyratex.com> <CAA9_cmf-r4iQ=CeAWS0AwrtdmvbDbsWuyA5s7ujnp-C274r-Yg@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1257)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xyratex198.xyratex.com ([194.131.166.198]:35192 "EHLO
	XY01EX22.xy01.xyratex.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932714Ab2EOALV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 May 2012 20:11:21 -0400
In-Reply-To: <CAA9_cmf-r4iQ=CeAWS0AwrtdmvbDbsWuyA5s7ujnp-C274r-Yg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mark Salyzyn <mark_salyzyn@xyratex.com>, linux-scsi <linux-scsi@vger.kernel.org>, dgilbert@interlog.com, James Bottomley <James.Bottomley@hansenpartnership.com>

It appears so, I did a 100% fresh pull of the tree, and the fix in scsi_device.h is there.

NAK this patch

Sincerely -- Mark Salyzyn

On May 11, 2012, at 12:08 PM, Dan Williams wrote:

> On Thu, May 10, 2012 at 1:48 PM, Mark Salyzyn <mark_salyzyn@xyratex.com> wrote:
>> Rarely, ses.ko load while scanning was taking place resulted in a panic. Discovered that the panic occurred while the inquiry field for a scsi device was NULL and an unprotected call to scsi_device_enclosure() occurred. Suggest that the inline function scsi_device_enclosure be modified, but for this panic, we can address this specific issue as outlined at the bottom of this patch submission.
>> 
>> device BUG: unable to handle kernel NULL pointer dereference at 0000000000000006
>> IP: [<ffffffffa00230f1>] ses_intf_add+0x2f1/0x5e0 [ses]
> 
> Wasn't this fixed by:
> 
> commit d1e12de804f9d8ad114786ca7c2ce593cba79891
> Author: Krishnasamy, Somasundaram <Somasundaram.Krishnasamy@lsi.com>
> Date:   Mon Feb 28 18:13:22 2011 -0500
> 
>    [SCSI] ses: Avoid kernel panic when lun 0 is not mapped
> 
>    During device discovery, scsi mid layer sends INQUIRY command to LUN
>    0. If the LUN 0 is not mapped to host, it creates a temporary
>    scsi_device with LUN id 0 and sends REPORT_LUNS command to it. After
>    the REPORT_LUNS succeeds, it walks through the LUN table and adds each
>    LUN found to sysfs. At the end of REPORT_LUNS lun table scan, it will
>    delete the temporary scsi_device of LUN 0.
> 
>    When scsi devices are added to sysfs, it calls add_dev function of all
>    the registered class interfaces. If ses driver has been registered,
>    ses_intf_add() of ses module will be called. This function calls
>    scsi_device_enclosure() to check the inquiry data for EncServ
>    bit. Since inquiry was not allocated for temporary LUN 0 scsi_device,
>    it will cause NULL pointer exception.
> 
>    To fix the problem, sdev->inquiry is checked for NULL before reading it.
> 
>    Signed-off-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@lsi.com>
>    Signed-off-by: Babu Moger <babu.moger@lsi.com>
>    Cc: stable@kernel.org
>    Signed-off-by: James Bottomley <James.Bottomley@suse.de>
> 
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f171c65..2d3ec50 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -462,7 +462,7 @@ static inline int scsi_device_qas(struct scsi_device *sdev)
> }
> static inline int scsi_device_enclosure(struct scsi_device *sdev)
> {
> -       return sdev->inquiry[6] & (1<<6);
> +       return sdev->inquiry ? (sdev->inquiry[6] & (1<<6)) : 1;
> }
> 
> static inline int scsi_device_protection(struct scsi_device *sdev)

