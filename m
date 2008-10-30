From: Bernd Schubert <bs@q-leap.de>
Subject: Re: [ PATCH 1/4 ] mpt fusion SoftReset handler
Date: Thu, 30 Oct 2008 17:18:08 +0100
Message-ID: <200810301718.09570.bs@q-leap.de>
References: <B73941C4DE6A3D4EA1AE128E9565E244238A270557@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:58527 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758087AbYJ3QSP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2008 12:18:15 -0400
In-Reply-To: <B73941C4DE6A3D4EA1AE128E9565E244238A270557@inbmail01.lsi.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, DL-MPT Fusion Linux <DL-MPTFusionLinux@lsi.com>

Hello Sathya,

thanks for review! See below for my comments.

On Thursday 30 October 2008 16:37:33 Prakash, Sathya wrote:
> Bernd,
> My comments are inlined with /*SP. Except those the patch looks good
> Thanks
> Sathya

> +       for (cb_idx = MPT_MAX_PROTOCOL_DRIVERS-1; cb_idx; cb_idx--) {
> +               if (MptResetHandlers[cb_idx])
> +                       mpt_signal_reset(cb_idx, ioc, MPT_IOC_SETUP_RESET);
> +       }
> +
>
> /*SP: Move the following PRE_RESET signal after issuing the MUR. This will
> cause the firmware to fault sometime */
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

here? But at this point we already did a reset, so MPT_IOC_PRE_RESET seems a 
bit odd. But if you are sure... (I really wish I had the MPT docs).

[...]

>
> @@ -680,6 +680,7 @@ static int mptctl_do_reset(unsigned long
>         dctlprintk(iocp, printk(MYIOC_s_DEBUG_FMT "mptctl_do_reset
> called.\n", iocp->name));
>
> +       /* FIXME: Can we call mptSoftHardResetHandler() here? */
> /*SP No It should be retained as a last option to clear firmware faults
> using utilities */ if (mpt_HardResetHandler(iocp, CAN_SLEEP) != 0) {

Ok, I will remove this hunk then.


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH
