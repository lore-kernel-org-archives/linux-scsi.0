From: Jens Axboe <axboe@suse.de>
Subject: Re: sense visible despite ide-floppy in 2.6 maybe
Date: Wed, 9 Jun 2004 10:00:13 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040609080013.GS13836@suse.de>
References: <1086710016.3647.4.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:30643 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S265685AbUFIIA1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2004 04:00:27 -0400
Content-Disposition: inline
In-Reply-To: <1086710016.3647.4.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org

On Tue, Jun 08 2004, Pat LaVarre wrote:
> Doug G:
> 
> Did I do something wrong, or does "everyone know" already,
> 
> SCSI pass thru in 2.6 omits ide-floppy, except if we do resort to the
> ide-scsi deprecated there?
> 
> Or more specifically,
> 
> Can ioctl SG_IO fetch the offset 7 Additional Length field of op x03
> "REQUEST SENSE" data?
> 
> Naively I thought yes of course, I know that works with /dev/scd$n.
> 
> But then I tried a /dev/hd$v ide-floppy.  No joy.  perror tells me ioctl
> SG_IO fails via "Invalid argument", dmesg has no comment.  sg_scan you
> know.  ~/bin/sgio source is the trivial exercise quoted in source far
> below, specifically with an O_NONBLOCK|O_RDWR open as you can see.

Hmm fudge. There are two problems - first you need to pass through SG_IO
ioctl from the ide layer, ide-cd gets it through cdrom.c currently.
That's the easy part, attached.

Secondly, you need to map struct request to a idefloppy_pc_t packet
command. Currently it just passes through START_STOP, it could in fact
handle any request that doesn't carry data though:

idefloppy_blockpc_cmd()
{
	if (rq->data_len)
		return 1;
	if (rq->cmd_len > sizeof(pc->c))
		return 1;

	idefloppy_init_pc(pc);
	memcpy(pc->c, rq->cmd, sizeof(pc->c));
	return 0;
}

For data transfer, it's more tricky. Well actually, if you restrict
yourself to non-bio backed request, then it becomes pretty trivial!
ide-floppy expects a contig buffer, a bio is scattered by nature.

-- 
Jens Axboe

