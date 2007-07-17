From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: aic7xxx: tape always rewinds since linux-2.6.15
Date: Tue, 17 Jul 2007 22:20:19 +0300 (EEST)
Message-ID: <Pine.LNX.4.64.0707172217560.6665@kai.makisara.local>
References: <469CFD36.4090306@frankoni.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:35213 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbXGQTUW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2007 15:20:22 -0400
In-Reply-To: <469CFD36.4090306@frankoni.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Hempel <lists@frankoni.net>
Cc: linux-scsi@vger.kernel.org

On Tue, 17 Jul 2007, Frank Hempel wrote:

> Hello,
> 
> I have expierenced a problem with the aic7xxx driver or the scsi tape support
> in the linux kernel.
> 
> [Problem Description]
> Under linux kernels since 2.6.15 every "action" I issue to the tape drive (I
> mainly do this via <mt> from the cpio package) is done but additionaly to
> every mt call a tape rewind is done too. So for example positioning the tape
> at some particular position is impossible because after the positioning itself
> it is rewinded automagically.
> Under kernels before and including 2.6.14.7 this problem did not occur.
> 
...
> [Attachments]
> kernel-config                 ... the relevant scsi-switches for all the
> kernels I used
> 14.7.dmesg                    ... the (hopefully) relevant dmesg output from
> 2.6.14.7 kernel
> 14.7.mt-status-after-boot     ... the output of "mt status" after boot (tape
> was at block 0)
> 14.7.mt-fsf-2.kern.log        ... the kernel output during "mt fsf 2"
> 14.7.mt-status-after-mt-fsf-2 ... the output of "mt status" after "mt fsf 2"
> (file number is now *2*)

/dev/tape is link to /dev/nst0 or the environment variable TAPE has value 
/dev/nst0?

> 15.dmesg                      ... the (hopefully) relevant dmesg output from
> 2.15 kernel
> 15.mt-status-after-boot       ... the output of "mt -f /dev/st0 status" after
> boot (tape was at block 0)
> 15.mt-fsf-2.kern.log          ... the kernel output during "mt -f /dev/st0 fsf
> 2"
The device /dev/st0 is usually the auto-rewind device and, by definition, 
the tape is rewound after the device is closed. You should use /dev/nst0 
if you don't want the tape to be rewound after close.

If the tape was not rewound before 2.6.15 when you used /dev/st0, that 
was a problem.

-- 
Kai
