Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793228904;
	b=qIUyRdK5SDol1+MlKX1kfTg3L3QqijpSYLj9qLcEi0fuKwnmgRtLJa6N/I+rNCtl4IUs
	 zElnmqUfh4i/dRzaugzqzuEDvLNqCXjacsJJwWzPRDIliAII4I/PDHAXt3BEaeR9xk97R
	 eXymtjMZJ+rwGI7V0VhpP21wpqM9iWhQG6MIvy2WgKMVF4nlo2erZNj9dzozXrAokc65x
	 sLgq+si+ZATNXPuX4JcRDFPgJeU3HkUwYUqMeOVbWXyzoVfgWaUrL4I73DpBuT8n56plR
	 UQI9rsDFFAi4r3yJCM0mFlfULXQ747hC158A9/N4E5FbdhMEQfFm0qCAKVvnzwFs9Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793228904;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
	b=NvxR3Q051W/2gjBVVSIaeg9Uhl3B6Cl65KKfldWHX6Odsljv2edO6FlzBLw0DtioE8fV
	 gPaCOZOfcSUaAupBN9SQ9tbPmQX/00xWqelyDMDtF5+7q2tA8Swnnd99KpSPO+faYqtdv
	 UkQuhQcqJIlRxP9gyMgAaSFVuXn97AJsemhnFhpG6vXmTcYgKeAQPbhQhNAPvxzkKLuZe
	 APgowFJetdUpjMWptDO4sUORffke32y5Vrdrux5NYpmFrJRowZKA3xVGnTBcp3rcadqIM
	 UdMB0wBZVuhvTbUWKCg+vtz2M6H1kyBwzJFbD6i2f90alk2ddAm/gu1ivK7w+btNGjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=J7O4RQOw;
	arc=none smtp.remote-ip=74.125.82.180
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EBA606A326
	for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 23:08:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 12EBA606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=J7O4RQOw
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3282db206d3so1648202eec.0
        for <linux-scsi@vger.kernel.org>; Wed, 28 Oct 2026 16:08:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1793228903; x=1793833703; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
        b=J7O4RQOw5TrBs8O7/aWm1PpYFTaePLS2jhIsY9DC90fqyHJyXyrXX+vvqa6zDrpytl
         pec4m2Su1RrabCHsph8rLf1ofEuA8kK27JUd9+wn9YCCYyCUj7sOSiJvaJCNI3974kYP
         d1AnsZ6sv/gIT0xohQgo9HDEpjsXf71742abQqVD7PbVLa6rGePyltiKQD9l1uMGZeZj
         MRHORF+9gKR3/l8v3copzgxvDjH4ZaOk9eZIJunEtZOCmoQfQSXIVButX9dldIftQNjI
         WHyBo3NoG5rcT692HXRpVnqWKst+nVdPs5Covd+5Eo/bqZrOvo1JWwNJWFymhnmDKRU9
         g4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793228903; x=1793833703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Mur3ShFuDmQflyAH2FyzCqcQNq7BKWZRbT1pvK+lX9o=;
        b=MsWrja+ejH99dWpmvpS6oQY5uDdbe0MM8jOOn0cfBw6cbuRVkMh6su2EdDT+JBQUEt
         6zaNorJn/airn/NrATaF+YHzHo48KGRDuvHDTBvDmEceiEQxAS1DaTYX84HDh1k1dYfg
         KfXPqTd4shij43KxcM/p1Hv/kHJtH9R9ldyiEHRBgY+vOUV28dhjrzG3pPIqnLaAZ4fs
         5zRlejgF4CeVJZXFA+90QkR8MCdynbCPqkP9HbmkETBux0TdJVWEyR7QPDKeD676aN73
         nN+NZro6sXXXDHEGj/9/5ojVsB9DacwHwRtF4NVXjAsVQMIZ3jwXwI04XejVc7QXdSaG
         db6g==
X-Gm-Message-State: AFq9FYIirMq2wH4u/GYLEhoOwAj+drKI4x5kFG0AP9ZvAeAqrCjAqpn7
	rkluC9vgfIoWxi4Dz1HWu5as8yFndbBpAihB17050x1MieL7JzDGzXZ7bxNZqowuQMddUsA8Q7q
	eN9iVUjvQYwhl3r8hS5hLuZVHpIEUN0E3mfd1ek7UTK1CWzr3zr9HciLRqDZ6cagXau/zJfe6cz
	i0BO1bV/4ni8wzJbspGuWIJyMj7x1iGjOrQ7S4IPXFXBiao1J3xQ==
X-Gm-Gg: AYBFou3dRoFW2F0pVwAE/embk35K8+GNgg65pLbmAsbJSY/RAFpvv0jZRWYHK84GBOa
	ZyiFq9EY9yGBIXxfzLPkGS2UmfzDcT3XriVdWyPX4yn7u/v7QiVMSmHbeip0cHPhPIJ6w0//r93
	yhtIIZFuiEJmz1R5q8lJXCy8XGZdJrjIY1VIXC119dgSbS/n+RnztHt8aHagj5Pm+7KoZftv7D5
	Z7VlsAVZg/cRXd9DBIb60QfI3gTGtvJEF74jBMvMN4vtDk06faKB9f3ePhpSX0R4/WGP5AAcXpv
	kEHRf3POD/JKqgKcq2okuwSFir6vYxWjfwvAtEP7oEq8q9fGGJ63FKrcaifczLLtuEKNyfl8Fqi
	cUVxhNYqGC+Gp9hyEJi8GXK9DdTIkmdh2Tqc9ZktilxOOB21gx4Ag1rFfc/PZKSrnE0Sgy2Kcpv
	PJha4YLDmRoGl322rCP1C5WA43krncCpOqruKQuLjwPOY/ZYChNjZ8HifY+yLIoJWeRnVKQwXvp
	ZSrUiukiZ30pBeH1aLuJJmN6NO6JvGtN1Bpwg+0UdP/D2EctKQxRTF9ZbubYUVa+DMR+c4AcPZ/
	XqAp8Ud6t7JHEytR1KQdZ3cH61CLCjL68VyhnAZLHPYFnEptM+Ltxjo1cTAp3pCgtym75RpQJ/A
	+qVDoWJrb9mekQM0TwBVfMKe91swGXm+oWwYqSLlhB0H7Yr78kcgA6W2BDrDDm4KAU1VzLHhzsX
	NBSMlz+EuuQkMhopiMyI5P
X-Received: by 2002:a05:7300:f894:b0:368:4c93:544e with SMTP id 5a478bee46e88-36a202bc3f0mr5622495eec.1.1793228902784;
        Wed, 28 Oct 2026 16:08:22 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a26d59f0fsm8156513eec.6.2026.10.28.16.08.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 Oct 2026 16:08:22 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Hannes Reinecke <hare@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krishna Kant <krishna.kant@purestorage.com>
Subject: [PATCH v2 3/4] scsi: scsi_dh_alua: Start a port group in the scanned access state
Date: Wed, 28 Oct 2026 16:08:06 -0700
Message-ID: <20261028230807.61578-4-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028230807.61578-1-brian@purestorage.com>
References: <20261028230807.61578-1-brian@purestorage.com>
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

