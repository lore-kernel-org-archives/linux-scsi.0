From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Wed, 28 Mar 2012 08:18:15 +0100
Message-ID: <1332919095.2869.2.camel@dabdike>
References: <102582.72180.qm@web100001.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41154 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751942Ab2C1HST (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Mar 2012 03:18:19 -0400
In-Reply-To: <102582.72180.qm@web100001.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: n0diamond@yahoo.co.jp
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2012-03-28 at 13:14 +0900, Norman Diamond wrote:
> I wrote:
> > James Bottomley corrected one of the experts who corrected me yesterday:
> >>>> So, the problem is that sd_mod is turning your request for a single block into a request for several blocks.
> >> 
> >> No, it won't be this.  Everything below block does exactly what block says.  If readahead is the problem, then you need to turn it off in block:
> >> echo 0 > /sys/block/<dev>/queue/read_ahead_kb
> > 
> > Thank you.  But...
> 
> But it didn't help.  Today I put the disk internally in an old notebook, and libata made it /dev/sda.
> echo 0 >/sys/block/sda/queue/read_ahead_kb
> but sg_dd still insisted on reading an entire page, so it refused to read a good block that was too close to the bad block.

This tells me you didn't read the man page on sg_dd.

To get it to read a block at a time using SCSI commands, you need

sg_dd blk_sgio=1 bs=512 bpt=1 <rest of the arguments>

That says use SG_IO and read exactly one block per SCSI command

James


