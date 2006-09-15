From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI timeouts with sym-2 driver
Date: Fri, 15 Sep 2006 11:40:59 -0600
Message-ID: <20060915174059.GI2585@parisc-linux.org>
References: <824B13109773064F92372DAB2F3B3C9D0EFB1F02@emss35m05.us.lmco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:35464 "EHLO
	mail.parisc-linux.org") by vger.kernel.org with ESMTP
	id S1750848AbWIORlA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 13:41:00 -0400
Content-Disposition: inline
In-Reply-To: <824B13109773064F92372DAB2F3B3C9D0EFB1F02@emss35m05.us.lmco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jones, David G" <david.g.jones@lmco.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Sep 15, 2006 at 01:36:37PM -0400, Jones, David G wrote:
> Everything works fine until I try to use the hard drive and PC card at
> the same time. Then I get SCSI timeouts for the PC card reader and
> eventually I/O errors for the PCCard devices. Continously copying a file
> from the PCCard reader to the hard drive results in these messages in
> the kernel log :

Sounds like you've got both these devices on the same interrupt; is that
true?  If so, I'd urge you to examine both of the interrupt handlers; it
feels like one of the drivers is not playing well with the other when an
interrupt occurs on both at the same time.  Or maybe it's a problem in
the arch code where it doesn't call both handlers?

In any case, trying a recent 2.6 kernel may give better results.
