From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi disk: report size without overflow
Date: Sat, 22 Oct 2005 09:44:36 -0500
Message-ID: <1129992276.3373.13.camel@mulgrave>
References: <20051020205532.16b65fa7.rdunlap@xenotime.net>
	 <1129915249.3440.42.camel@mulgrave>
	 <Pine.LNX.4.58.0510211345080.32061@shark.he.net>
	 <1129928527.23920.62.camel@dale.velocity.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:7826 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932233AbVJVOoo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 10:44:44 -0400
In-Reply-To: <1129928527.23920.62.camel@dale.velocity.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dale Blount <linux-kernel@dale.us>
Cc: "Randy.Dunlap" <rdunlap@xenotime.net>, scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>

On Fri, 2005-10-21 at 17:02 -0400, Dale Blount wrote:
> I'll agree with that as well, but there should be a note left on
> CONFIG_LBD's help menu that states 1TB (or whatever the actual limit is)
> instead of 2TB then.

No one's really bothered to find out, I suspect.  If the kernel is using
block offsets as all unsigned (which I'm  not sure anyone's fully
validated), and the block size is 512, then 2TB is the limit.  For
signed, which is a safer assumption, it's 1TB.  However, you also have
the constant source of overflow danger, like you just discovered.  Every
arithmetical calculation has to divide first then multiply (because the
reverse will overflow). Note also that fdisk overflows beyond a certain
point (which I suspect is also 1TB).

> Also are there any performance implications for using CONFIG_LBD?

Yes, on 32 bits sector_t becomes unsigned long long (a 64 bit quantity).
This takes double the storage (or registers).  I don't think it will
affect storage performance any, but it increases the sizes in the kernel
and makes the processor do a bit more work.

James


