Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212952;
	b=rgzdpyARntXxKOu1v8lYIm0doZOEF5nO+9M/ZQX/qikOhajqFQHmbBkfawRjjE2JDwld
	 UOaX06fKE83SljMDPj/GKHgpgK15njlJkdHERUgd+Y9Rgc0ZhLh9kh5NghP3SQ5Mq/rlO
	 UBORAxqB7zGzClbayIr4lOxKQVXABqXlQcsU0I1Qk8VWiFWmHMmKZ8/yNN1rUc894enXT
	 Jr+la4aReAIM9DiXRTli+gRSeZ05MvmN6DKWLuc4PcMVZVjScrtftTkUf+m0+EO5BmeFi
	 q78jsEKiZSidDF9XJc7ea4lHJ8bo2gI1QLQqK/Sjx5AnUuKmP/UOeEruuyo5VK5rjjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212952;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
	b=aZfEXwEvQeu323hy2ioCWeA6n5cguAIufREK9WBYXBJaEi81wIJ/Qg4+IE06HQCUfsgy
	 2Z7OvQa/FbFGiuCsR+pPgfnywybkQMo3DYoR5nDcZUbfBkP2dZsIcDtLyG5/27fBHGs7T
	 Gqs31z6FmtMHC0Nylxqdea6fA+FDdJ6DoFcTjSdYNw6dMA3EO76r3gAuruDosluc0bFo/
	 BJfWtmI4R5KSeXz9S1CDAHWt4I914mU4XMPYNsp38WJ1KKB30Z/baOwng96HYB1NZidid
	 9PK7iOGGDSUqJ5OrZhymYv6oAzCoYePro9d8xwDP8rgBHeMNR2/4EBTLMHQPs+GrhRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=gcn9Ny59;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB25606A323
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 18:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EB25606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=gcn9Ny59
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35c76e9614aso1868722eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 11:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793212950; x=1793817750; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
        b=gcn9Ny59tS3cdJR9fLgcieq+qS5EzgIEOhD8qEUqXuboIlGfyNQcY/fRief7rq7pxw
         Y3oYZej+g+S67kYTn0zA/+xoxnRT0v7YTRRHQ2jpnERLjTr0XJ1A5wem6BCI6g3S7lnu
         n990NwUymYsWN7qs7io3wt68l7PNf6/gnYy9goJWfU+z9zkeSjPZSaatEqqQORNXuDTX
         f1duvWFm3Ecig6PiiNzmoJWP71B8+I2J84sdtobZoCRxOV5K9Di61Utl8Bm1Bltr/CGm
         8AgmXBxlcisVR39gQjsSSPMBxTvg8ZmlRzVo5gzqgHI5tGndEv/2gY75HcqwkTzvoi1c
         3kPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793212950; x=1793817750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
        b=Wfbm38F7STaHXZL8wSEQ2Wc3pYKNFApNxXxr6As3o8P2jSyfhgnLWF8N8+uEnDPavb
         J/tONO9n3xjRyVCKebdZUfrag9lke605+JyyB6UbWGYVse4QQTcGdJKRwZITGEqS0UlG
         BiysnS0v2HHbhpCTMyeLRVpoLA0AfKvAONespZvTpq3QnycvZeZBalausIW8UToEDOs5
         cGA7ng5bWMbt+Znzjrfhtx8P26LmNk+eA0LBgWSgryZdwZCIFaQYF8D8wv7oGENHL1A7
         2/DrKUrbWsdK55PJGST3rAnQFdtm5t86mjy5KKhyYbXKRggKVPeFBX8w7kM9e96nn27M
         agBw==
X-Gm-Message-State: AFq9FYKS+ZFRgeOM4yQx9IaIxgDck5n5SVYnmJXXs2MUlHW8HP87xeMH
	E1w6XhUjW+tA3gm9ro0UWVd7k2t0vNW/tsDK/mzcUS/bBxpUS+BkCB8rAv6djQQbFERYzQN5q7/
	Cpuix3n8IvUlRmL8gK8kEs4F8oa4jV7f1S3mPTfmzqqHER43s+cJd5PYp7I6AMqKyOp/TvmTsyW
	Qh0Tz0JYhpwKv19CfeDVjJ9po5sWRm+vGsSDKDYom6K9DOJZgeOQ==
X-Gm-Gg: AYBFou2OwyBtEt+OouBdrAC1X8RykXsKGj8lE69FqPxz3dZFwo7X8LfYTPD1+8N9RAs
	k3PLZisr6N0lW4NHk+Dvdr6kbeGJJ0ppzLckPk1NBlVyr83BW6SMF6q4oy10wFYZxpAb72iLvAQ
	dgXetwPKYE1UBbJ6xnKBHvnc/7g1u/BdiEFCRfHnAIzcSnZqAuUKJDIz0AcbOOctQEGmrYreR2r
	e41gV3wRKsrDst/gjxEEFaIvp9+ag912uQCKTOzCBdM7HEWUvr/mC6BN1AEZfMX153Mzn+nOQyC
	s/omQKw5z4HrvnmVfUaEcenjZSkyaqjuMoxMLIxRhi9rZkVXemBMmKELOOkbtR5MJtb8WzZKlCt
	UA/JTzhGeFEfg2Jj2JdciItoZ4V94LQvHxkM7INLkDbgV2ydEtCKgJY/3WHVqLLRg4IjoOO3ymW
	AAs/3Jv7CaJSdK/+EFuCgXsV7asmMjXEEKGpZENSiurM3DtPWfzeurWxz5nrnJTgr4VGXkbW25p
	RshqSmVDaxaJCG4z+dFoDYptiixvCL2/ioVBev7tS2TyPYCwkjhs97o5JMgoYfkQ/2MtR87UaN6
	9Fdfb/GFSDycM8awv+eb+Ng+umcZTOKGwixSzNM+0a8/hCMePE9hFsIWH4Q3EQAnRIJJCmeC5Qg
	BCU0SpWvx11qkAndY+DUQKO7N0fe0I0x0Nte/m5m6lUYrjHYqdQTIJ2bCCyUDAtEcudvh2oScgM
	ynDhFeOddacYMmea6mRsIKJoxJhg==
X-Received: by 2002:a05:693c:8946:10b0:36a:1a65:ebd3 with SMTP id 5a478bee46e88-36a203f2064mr4753798eec.18.1793212950253;
        Wed, 28 Oct 2026 11:42:30 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a238da3e1sm11604066eec.8.2026.10.28.11.42.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 11:42:29 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH 3/4] scsi: scsi_dh_alua: Start a port group in the scanned access state
Date: Wed, 28 Oct 2026 11:42:15 -0700
Message-ID: <20261028184216.25453-4-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028184216.25453-1-brian@purestorage.com>
References: <20261028184216.25453-1-brian@purestorage.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new port group starts out active/optimized until the first RTPG of
the handler completes, so alua_prep_fn() lets I/O through to a path
that is actually unavailable. For a device whose driver is bound
straight away, the first I/O, typically the partition table read, then
reaches the target and fails with LOGICAL UNIT NOT ACCESSIBLE, TARGET
PORT IN UNAVAILABLE STATE, logging an I/O error.

The SCSI core now reads sdev->access_state when the device is scanned,
before the handler attaches. Start a new port group in that state. If
the core did not read one, sdev->access_state is zero, which is
active/optimized, so nothing changes for those devices.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 06eb35cc9d7c..15471e7bf19a 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -208,7 +208,14 @@ static struct alua_port_group *alua_alloc_pg(struct scsi_device *sdev,
 	}
 	pg->group_id = group_id;
 	pg->tpgs = tpgs;
-	pg->state = SCSI_ACCESS_STATE_OPTIMAL;
+	/*
+	 * Start in the access state the SCSI core read when the device was
+	 * scanned. That is active/optimized if it did not read one, as it
+	 * was before. alua_prep_fn() then already fails I/O to a path that
+	 * is unavailable before the first RTPG of the handler completes.
+	 */
+	pg->state = FIELD_GET(SCSI_ACCESS_STATE_MASK, sdev->access_state);
+	pg->pref = FIELD_GET(SCSI_ACCESS_STATE_PREFERRED, sdev->access_state);
 	pg->valid_states = TPGS_SUPPORT_ALL;
 	if (optimize_stpg)
 		pg->flags |= ALUA_OPTIMIZE_STPG;
-- 
2.56.0

