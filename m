From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/14] block: Replace bi_integrity with bi_special
Date: Wed, 11 Jun 2014 20:18:19 -0400
Message-ID: <yq1vbs7q8tw.fsf@sermon.lab.mkp.net>
References: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
	<1401334128-15499-3-git-send-email-martin.petersen@oracle.com>
	<20140611163257.GB28815@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaFLASx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jun 2014 20:18:53 -0400
In-Reply-To: <20140611163257.GB28815@infradead.org> (Christoph Hellwig's
	message of "Wed, 11 Jun 2014 09:32:57 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:

Christoph> Instead of having a union of pointer just make it a void
Christoph> pointer. I also think special is a terribly generic name, but
Christoph> I don't really have a better idea at hand.

I needed something that could encompass additional information to be
passed for integrity, copy offload and discard requests.

Another option is that we forgo the union name:

        union {
#if defined(CONFIG_BLK_DEV_INTEGRITY)
                struct bio_integrity_payload *bi_integrity;
#endif
                struct bio_copy *bi_copy;
        };

That's the way Jens has done it in struct request. I think I like that
better and it doesn't send the same up-for-grabs signal that a void
pointer might.

Jens: Any preference?

-- 
Martin K. Petersen	Oracle Linux Engineering
