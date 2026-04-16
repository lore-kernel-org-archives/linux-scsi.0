Received: from mail-qk1-f228.google.com (mail-qk1-f228.google.com [209.85.222.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA891C6FF5
	for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2026 00:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776298971; cv=none; b=KVqd8YUmCcRkwCXjqrgDAhpYLUqEeQNaD43jMKd3vo+dDDpPGbURVKOSsExA/37woI7uKHhlDrA8os5fLnh+0TN44aONrCv+XMiea+H5ew9kbmI7yL+aUZlDOPiXvMdlc7fiUeKxr9zvkyEZeklcabK0xD1A0/QqcxyiY2JUImM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776298971; c=relaxed/simple;
	bh=FVwKbgioBZ+VO2vvdiCyvzfplqZuonuE42jMiRh7ulc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ikIc9mKWlboKLBhbdIJqwqdjehWkB2GiCj+sdUrXaG8bBbZZxQyVR3FrLyuBM+HjOJ2CF/TxC7TSD13h77pHDzyzJbrMLaHUfO/kqkcIVItadFa6QBh/uL5+7ng9fQl8nGwcdALg8GyMn6NL0KCQwlNSp8eotgqOiiO1MbGyGkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=A/n/Ah/B; arc=none smtp.client-ip=209.85.222.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="A/n/Ah/B"
Received: by mail-qk1-f228.google.com with SMTP id af79cd13be357-8d5e1ca50ddso142643385a.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Apr 2026 17:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1776298968; x=1776903768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qTb4WYVL+QtfOgfKxr2rwJdF5OfB66I75dlU3VTdI6c=;
        b=A/n/Ah/BZ7Zj8v9yQwgw9Cu4aQ6WfKwC+hRGVwA4AHyKZa2Nbs9i+ELQuUPwQlnuTZ
         eyCuB3IlKTQXCmeRPe/c6C3rqeKkEHAmm1QLyjMu8s26OXW6ASdD+bj6Z/uansAf6sKX
         wOGV+Xh+ZJzHBxISK95ydcIkN+kof+IybXgBtRAXXUlZIh7+mRLpzQvAGewvkQkOFqQu
         tciz32ruqZAecMZi6npaY2c1Rh3DgOsk2cJ2sZow/FfkRJwRhcHnRgrBo4FYqekGg/ef
         WtHzecD5pENS5wkST1IwrjYpg/dUTsClHvSGFq+4nFPFEgbu3DFxqhw0wdzrJp+6k9zR
         Ac7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776298968; x=1776903768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qTb4WYVL+QtfOgfKxr2rwJdF5OfB66I75dlU3VTdI6c=;
        b=qB/S5Ka36Ay6V1iMfvm+UgoxEtDMVJw4V+IT9R0f0EHKYGQ9ldMx4MGclvDwTo8Hsa
         1RzvumtYils45S1+dR7n+5RKlZQn/j7xu4ePV5EP0y/5/OA6EeRCXjCsJD7sWmLpdiPt
         PYidbFMFPEBx7kZ446gJEnv5srVoK3JwLIPlZQ6sxhOQDhIXsUR02HrFz6t4ra+G09VT
         w5DBwNrnK1Eo1yVW3/1kqCyNYRK7rRz5fgzY7Rt9OYHqPo0dkjSDFKu2vqo/YzH+k05M
         kIpg0tlvASEDPL8RwzMvn1k7SUkKDNxnS+Erzab+H35cmpb7CbvKjxZOBTVrhOTZmdSB
         Av0g==
X-Forwarded-Encrypted: i=1; AFNElJ9oEzJrTE9sq6AfWQZMMWsyPp9setQP5dMVa0eXRue9Wbml8dTgrf9SPajFt3qc0PCPn4ivXwRqljdH@vger.kernel.org
X-Gm-Message-State: AOJu0YyJHEuCUJU/h+9+bBG7QcaS0Dfp+/iGqD8/f5Dk7zaqkfX1Z3Nr
	uHVOcIptxg/PjhWe/WwatE2xpzr9URm10kg/p8/Lj5oMrIB++h8taRxcbr4IPkac8UU+9Kz16sz
	HTO/CTluGoJszuwoqfA6yWSJWOH5L4LSuk6u4
X-Gm-Gg: AeBDieuXw64CLP0hI9KJe6KWK09uvqt5tY55XrE5Wj4N41C+4pyb6cAFfnN4np067GH
	T0jxzHRVwthOmMGMkwd6drVlgCrGawFa62imMmo8BJYhXsL1HkERvVMeupreeCqQ+qZmiY8Rb5Q
	gsiN1vubN+EZnI9JEpTyWPR1e/RN5uKvL5CWeFwVdEoTRBCsZ8EjAg5Tq0u4YnYR/XmYe6LvxmW
	QjQ/m1RtCr0LDUBEePXtDbMu60uVz44OTEJ5BSsMS9ybX7R1zhr0SIxIx1V+0v24TxARXJhDqn1
	5gBUJOv3O1EC9HTI3W9xZhq6j7qiSRJpK2vAr52XpGSjdFaIdvqs/gtWrKpJawWtDnieAo4JbsK
	/HzEX8ib966BBxRS+ZqPGPWlgeKCo95jWMdSa9PoSTysEilCbqrOnrfb520F6rEeH
X-Received: by 2002:a05:620a:4614:b0:8d2:394a:d3f3 with SMTP id af79cd13be357-8e6321e7da5mr60618285a.2.1776298968296;
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id 6a1803df08f44-8ae6c93d2b9sm2589456d6.4.2026.04.15.17.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2026 17:22:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.112.29.101])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 07F4F3422D5;
	Wed, 15 Apr 2026 18:22:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id F1B94E41B93; Wed, 15 Apr 2026 18:22:46 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v2 4/6] bio-integrity-fs: use integrity interval instead of sector as seed
Date: Wed, 15 Apr 2026 18:22:12 -0600
Message-ID: <20260416002214.2048150-5-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260416002214.2048150-1-csander@purestorage.com>
References: <20260416002214.2048150-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

bip_iter.bi_sector is meant to be in units of integrity intervals rather
than 512-byte sectors. bio_integrity_verify() doesn't actually use it
currently (it uses the passed in struct bvec_iter's bi_sector instead).
But let's set it to the expected value for consistency.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/bio-integrity-fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bio-integrity-fs.c b/block/bio-integrity-fs.c
index 389372803b38..5d1b0e33fc5f 100644
--- a/block/bio-integrity-fs.c
+++ b/block/bio-integrity-fs.c
@@ -62,11 +62,11 @@ int fs_bio_integrity_verify(struct bio *bio, sector_t sector, unsigned int size)
 	 *
 	 * This is for use in the submitter after the driver is done with the
 	 * bio.  Requires the submitter to remember the sector and the size.
 	 */
 	memset(&bip->bip_iter, 0, sizeof(bip->bip_iter));
-	bip->bip_iter.bi_sector = sector;
+	bip->bip_iter.bi_sector = bio_integrity_intervals(bi, sector);
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, size >> SECTOR_SHIFT);
 	return blk_status_to_errno(bio_integrity_verify(bio, &data_iter));
 }
 
 static int __init fs_bio_integrity_init(void)
-- 
2.45.2

