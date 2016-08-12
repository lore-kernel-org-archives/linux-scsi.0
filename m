From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] sd: dynamically adjust SD_MAX_WS16_BLOCKS as per the actual logical block size
Date: Thu, 11 Aug 2016 23:10:37 -0400
Message-ID: <yq1bn0yptqq.fsf@sermon.lab.mkp.net>
References: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51199 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbcHLDLr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2016 23:11:47 -0400
In-Reply-To: <b7f44789e0e68fa57d2e3cd059ac3a5bc6d53495.1470954520.git.tom.ty89@gmail.com>
	(tom's message of "Fri, 12 Aug 2016 06:29:43 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com
Cc: martin.petersen@oracle.com, shaun@tancheff.com, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, shaun.tancheff@seagate.com

>>>>> "Tom" == tom ty89 <tom.ty89@gmail.com> writes:

Tom,

Tom> However, SD_MAX_WS16_BLOCKS is used to check values that are, for
Tom> example, orignated from Maximum Write Same Length field on the
Tom> Block Limit VPD. Such field expresses the number of blocks in terms
Tom> of the actual logical sector size of the specific drive instead of
Tom> the block size that the block layer is based on (512).

I agree the SD_MAX_WS16_BLOCKS is ugly. I think it started out as a
limit expressly set in block layer sector units and then when the
discard code got expanded it got re-purposed into being something
else. So let's get that cleaned up.

However, the CDB transfer length limit is really not the main issue
here, it's bi_size that we need to enforce.

After contemplating a bit I think it would be cleanest to add
BLK_MAX_BIO_SECTORS and clamp on that in blk_queue_max_foobar() like we
do with some of the other queue limits. Move the enforcement to block
where the actual limit originates rather than code around it in sd.

Also, please use ilog2() instead of division for things like this.

-- 
Martin K. Petersen	Oracle Linux Engineering
