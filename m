From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/5] aacraid: simplify non-dasd support
Date: Thu, 1 Dec 2005 13:32:24 -0500
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01E9A871@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43171 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932404AbVLAScZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 13:32:25 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Christoph Hellwig [mailto:hch@infradead.org] sez:
> Just checking for channel 0 is fine with me, although a 
> 
> #define AAC_RAID_CHANNEL	0

The 'documentation' of this used to be embedded in a Macro that was
recently removed to prepare for SAS. I'll keep this in mind, I am
starting to build up a few 'cleanup' items, held back because we still
have some meaty patches coming up.

> Similar issue is the tagged_supported check, it's totally magic to me
and at 
> least needs a very good comment.

Should not be magic, if the device has tagging turned/forced/quirked
off, then we must ensure that scsi_adjust_queue_depth(sdev,0,1) be the
only value submitted; certainly not setting a larger queuedepth.

Sincerely -- Mark Salyzyn
