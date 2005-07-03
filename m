From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Subject: Re: aha2940 on 2.6.9
Date: Sun, 03 Jul 2005 21:33:37 +0900 (JST)
Message-ID: <20050703.213337.-1300550695.chamas@h4.dion.ne.jp>
References: <20041117.142325.74756248.chamas@h4.dion.ne.jp>
	<1115479839.5094.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hfep01.dion.ne.jp ([203.181.105.67]:28810 "EHLO
	hfep01.dion.ne.jp") by vger.kernel.org with ESMTP id S261402AbVGCMdj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Jul 2005 08:33:39 -0400
In-Reply-To: <1115479839.5094.2.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, reiserfs-list@namesys.com

 Hello,
I'm sorry for too late replying.

From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: aha2940 on 2.6.9
Date: Sat, 07 May 2005 10:30:39 -0500

> On Wed, 2004-11-17 at 14:23 +0900, Ken-ichirou MATSUZAWA wrote:
> >  Hello, I'm using kernel-2.6 with aha2940.
> > until 2.6.8.1 it works fine but since 2.6.9, I've been getting message:
> > 
> >   Nov 17 13:45:48 plath kernel: FAILED
> >   Nov 17 13:45:48 plath kernel:   status = 1, message = 00, host = 0, driver = 08
> >   Nov 17 13:45:48 plath kernel:   Current sd: sense = 70  5
> >   Nov 17 13:45:48 plath kernel: ASC=20 ASCQ= 0
> >   Nov 17 13:45:48 plath kernel: Raw sense data:0x70 0x00 0x05 0x00 0x00 0x00 0x00 0x0a 0x00 0x00 0x00 0x00 0x20 0x00 0x00 0x00 0x00 0x00 
> 
> The error is coming from the device, and has nothing to do with the
> driver.  It's ILLEGAL REQUEST, INVALID COMMAND OPERATION CODE.
> 
> That means that something sent the device a SCSI command it didn't
> understand.  Without knowing what the command was it's hard to say, but
> my best guess would be that some userland program is sending commands to
> the device and got one wrong.

The messages is logged only on reiserfs and I searched what system
call make this messages. It was fdatasync.

Simply opening a file with O_RDONLY, then call fdatasync (or fsync)
without do anything, the messages was logged. reiserfs_sync_file()
seems to not check dirty flags and is this related to the messages?

Thanks,
