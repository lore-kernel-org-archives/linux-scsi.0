From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [PATCH] Add compat_ioctl to mptctl
Date: Wed, 19 Jan 2005 11:25:42 -0700
Message-ID: <91888D455306F94EBD4D168954A9457CEAA513@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:4589 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261827AbVASS0I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Jan 2005 13:26:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@muc.de>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Tuesday, January 18, 2005 4:22 AM, Andi Kleen wrote:
> 
> Convert mptctl driver to new compat_ioctl entry point.
> 
> Only compile tested.
> 
> Signed-off-by: Andi Kleen <ak@muc.de>
> 

This doesn't compile. Andi - Pls fix, resend, and
I will test.

Three issues are:

(1) incompatible number of paramters being passed 
when calling __mptctl_ioctl; look at line 649
(2) definition of unlocked_ioctl is three parameters, however
mptctl_ioctl is having four paramters; line 2686
(3) compat_mptctl_ioctl - is passing NULL pointer to mptctl_ioctl,
this will panic in __mptctl_ioctl; look at line 2820, then line 566

Here is output of compiling:

emoore-test5:/usr/src/linux-2.6.11-rc1-bk7 # make modules
  CHK     include/linux/version.h
make[1]: `arch/x86_64/kernel/asm-offsets.s' is up to date.
  CC [M]  drivers/message/fusion/mptctl.o
drivers/message/fusion/mptctl.c: In function `mptctl_ioctl':
drivers/message/fusion/mptctl.c:649: warning: passing arg 1 of
`__mptctl_ioctl' from incompatible pointer type
drivers/message/fusion/mptctl.c:649: warning: passing arg 2 of
`__mptctl_ioctl' makes integer from pointer without a cast
drivers/message/fusion/mptctl.c:649: error: too many arguments to function
`__mptctl_ioctl'
drivers/message/fusion/mptctl.c: At top level:
drivers/message/fusion/mptctl.c:2686: warning: initialization from
incompatible pointer type
make[3]: *** [drivers/message/fusion/mptctl.o] Error 1
make[2]: *** [drivers/message/fusion] Error 2
make[1]: *** [drivers/message] Error 2
