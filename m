From: Josip Rodin <joy@entuzijast.net>
Subject: Re: kernel 2.6.26.3 qla2xxx oopsing on Fire 280R
Date: Thu, 11 Sep 2008 13:37:27 +0200
Message-ID: <20080911113727.GA24487@orion.carnet.hr>
References: <20080904093929.GA29006@orion.carnet.hr> <20080908211331.GC22598@plap4-2.qlogic.org> <20080909015321.GA14147@orion.carnet.hr> <20080909020102.GE25591@plap4-2.qlogic.org> <20080909143932.GA27117@orion.carnet.hr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orion.CARNet.hr ([161.53.160.90]:45229 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbYIKLh3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 07:37:29 -0400
Content-Disposition: inline
In-Reply-To: <20080909143932.GA27117@orion.carnet.hr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Sep 09, 2008 at 04:39:32PM +0200, Josip Rodin wrote:
> On Mon, Sep 08, 2008 at 07:01:02PM -0700, Andrew Vasquez wrote:
> > Yes, please do try the patch.  Could you also enable error-logging via
> > the ql2xextended_error_logging module parameter:
> > 
> > 	# insmod qla2xxx.ko ql2xextended_error_logging=1
> > 
> > And send the kernel messages...  Thanks, AV
> 
> OK, I reset the bisection, pulled the latest updates, applied your patch
> and added the parameter to the initrd module setup, rebuilt after an
> all-enter make oldconfig. After rebooting, it failed to load the firmware:
> 
> scsi(0): **** Load RISC code **** 
> firmware: requesting ql2200_fw.bin 
> scsi(0): Failed to load firmware image (ql2200_fw.bin). 
> qla2xxx 0001:00:04.0: Firmware image unavailable. 

OK, so I did git reset --hard bed475c4cde5d12f537f445bdd0a5a3bb5684481
to get back to the point which the bisection said was the problem, and
yet that version of 2.6.27-rc2 also exhibited the firmware problem.

Then I went back up to git reset --hard bf6583b5831d3195c45f98ec3016499389cbe18f
to see if it'll do that again, and that 2.6.26 *also* did the same.

So I reviewed my steps and concluded that the only other thing different was
adding ql2xextended_error_logging=1. I undid that change, rebuilt the
initramfs image, and then the machine booted fine!

So, um, please fix the debugging code so that it doesn't cause more bugs... :/

In the meantime, I'll go back up to bed475c4cde5d12f537f445bdd0a5a3bb5684481
and see how it does with the debugging patch.

-- 
     2. That which causes joy or happiness.
