From: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Subject: RE: [ PATCH 1/4 ] mpt fusion SoftReset handler
Date: Thu, 30 Oct 2008 23:40:07 +0530
Message-ID: <B73941C4DE6A3D4EA1AE128E9565E244238A270573@inbmail01.lsi.com>
References: <200810301718.09570.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44304 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499AbYJ3SON convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2008 14:14:13 -0400
In-Reply-To: <200810301718.09570.bs@q-leap.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hi Bernd,
Response inline
Thanks
Sathya


-----Original Message-----
From: Bernd Schubert [mailto:bs@q-leap.de]
Sent: Thursday, October 30, 2008 9:48 PM
To: Prakash, Sathya
Cc: Linux SCSI Mailing List; Moore, Eric; James Bottomley; DL-MPT Fusion Linux
Subject: Re: [ PATCH 1/4 ] mpt fusion SoftReset handler

Hello Sathya,

thanks for review! See below for my comments.

On Thursday 30 October 2008 16:37:33 Prakash, Sathya wrote:
> Bernd,
> My comments are inlined with /*SP. Except those the patch looks good
> Thanks Sathya

> +       for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +               if (MptResetHandlers[cb_idx])
> +                       mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> +       }
> +
>
> /*SP: Move the following PRE_RESET signal after issuing the MUR. This
> will cause the firmware to fault sometime */
>
> +       for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +               if (MptResetHandlers[cb_idx])
> +                       mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);
> +       }
> +
> +       /* Disable reply interrupts (also blocks FreeQ) */
> +       CHIPREG_WRITE32(&ioc->chip->IntMask, 0xFFFFFFFF);
> +       ioc->active = 0;
> +       time_count = jiffies;
> +       rc = SendIocReset(ioc, MPI_FUNCTION_IOC_MESSAGE_UNIT_RESET,
> sleepFlag); +       if (rc != 0)
> +               goto out;

You mean

mpt_signal_reset(cb_idx, ioc, MPT_IOC_PRE_RESET);

here? But at this point we already did a reset, so MPT_IOC_PRE_RESET seems a bit odd. But if you are sure... (I really wish I had the MPT docs).

[...]

/* Yes Here. There name PRE_RESET is confusing, if you see the action inside PRE_RESET in mptscsih.c it clears the pending requests issued to firmware. Before sending the MUR to FW. There is possibility that when firmware before processing the MUR tries to find the request to do DMA and couldn't find that because the driver cleared it already in PRE_RESET and hence resulted in fault.


>
> @@ -680,6 +680,7 @@ static int mptctl_do_reset(unsigned long
>         dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset
> called.\n", iocp->name));
>
> +       /* FIXME: Can we call mptSoftHardResetHandler() here? */
> /*SP No It should be retained as a last option to clear firmware
> faults using utilities */ if (mpt_HardResetHandler(iocp, CAN_SLEEP) !=
> 0) {

Ok, I will remove this hunk then.


Cheers,
Bernd

--
Bernd Schubert
Q-Leap Networks GmbH
