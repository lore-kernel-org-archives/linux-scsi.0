From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: scsi device queue depth adjustability patch
Date: Thu, 03 Oct 2002 13:00:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210031700.g93H0xF03194@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA24975
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 10:01:02 -0700
Received: from localhost.localdomain (midgard.sc.steeleye.com [172.17.6.40])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id KAA24876
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 10:01:00 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g93H0xF03194
	for <linux-scsi@vger.kernel.org>; Thu, 3 Oct 2002 13:00:59 -0400
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Thu, 03 Oct 2002 12:41:31 EDT." <20021003164131.GF30853@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

dledford@redhat.com said:
> 1)  When/How is the lldd notified that tagged queueing has been
> enabled  and the depth to which it is enabled?

A trick question. Obviously it should be in slave_attach.  However, the 53c700 
is used with a lot of quirky drives, so the way I do it is to shadow the 
commands.  The first command that comes down with tagged_supported set, I try 
a tagged command.  If that command succeeds, I then activate the TCQ and thus 
set tagged_enabled (the driver has several bits per target to support this 
state model). If the first tag fails, I clear tagged_supported.  This catches 
the annoying drives that set the  CmdQue bit in the inquiry page and then 
reject all tagged commands.  The depth for the 53c700 is just the default 
cmd_per_lun.

You can see this in the source code (tag_negotiated bitmap and 
NCR_700_DEV_BEGIN_TAG_QUEUEING flag).

> 2)  How does the lldd tell the midlayer (and hence the block layer) to
>  reduce the queue depth? 

It can't, currently.  This could be done, but only by disabling and reenabling 
the block layer TCQ support.  The block layer currently uses a static array 
for this.

However, the resources the block layer uses are tiny (one entry in this array 
per tag, plus a bitlist) so its probably just not worth freeing and 
reacquiring these.  To integrate with the blk layer, I'd propose just 
initialising the blk layer with the maximum possible number of tags (i.e. 
introduce an upper limit somewhere) and then just do the dynamic stuff in the 
mid-layer.

James


