Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792448070;
	b=ZhS7gMW8dF2xpz36t0meyp6mXfTO3MHFBMf0BkXz6ZoHlR6l8fq1wL2fQdTb6MTPDscn
	 2ykTB5pzfbG5IH8T5XvCZwgFMJ0XbnOVfhxvpyyVFUX46RB3v5k1MbzH+9L0ror0BSWlU
	 DCskT6ewbNcnTAJNmfsEjxjCtkI+eBGzUbhnu7OAYBQL6xaMsHp/R9Pfs82Q56I8Ttt5Q
	 LoR6RsUVmAODN3+isW97ugItz3Tx7rK2/5hkmFG5pbI8f3YYvGTxx7ARTP3osjtrLDsTx
	 CPWVShP5MWcNVDudZ4C3TzMcs3XSXDZYg+qVKYR18EJXV6Ma+FDwsFFaURwA+5ij9+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792448070;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=lZhdWSnfDKgW5o3GXJHt9J2xBtWTDX7lwKsBGbzGcUw=;
	b=jUy3RSAelDTjVbvoQUSfULZHFKn1KXA0jjTRjJdpiguQZCvBlSZqMCLjF1xeTsJwdwz/
	 s1BJ9/gEncHyf5DJcIXn4qgg5UXX1ITqMh8SzWCtXyzSyTtZeruh/8F+0+p3wSwgdhE6v
	 Kh/LzhujIInwLEoVi7jEIDwqGDGbaOkDbkS4Bv7eD7C2tWmzyJhb/0LXbIWbVfPtQRQnT
	 RkWHKCajeXgxk3e8kMulgO24Pfndk84nCalcx8nLyyETPZI3xumoHqYHgVKLM1WEM2wwp
	 lfoC7O9e7GbLH9ZHXbYi2nifJ6O9TH3VSQj+dy+pb2ODAjs8aISDNBaAG+6oRXlJ+rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=purestorage.com;
	spf=pass smtp.mailfrom=purestorage.com;
	dkim=pass header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IOkH6TO7;
	arc=none smtp.remote-ip=74.125.82.48
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49F7606A31F
	for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 22:14:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E49F7606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=purestorage.com header.i=@purestorage.com header.a=rsa-sha256 header.s=google2022 header.b=IOkH6TO7
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-16079d54c17so5572708c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 19 Oct 2026 15:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1792448069; x=1793052869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lZhdWSnfDKgW5o3GXJHt9J2xBtWTDX7lwKsBGbzGcUw=;
        b=IOkH6TO7PLSwXhOxOw0H4E6dMTEItip+jhna0aiL+Vj6LZHDyongl5K+SsOAEAO8Qu
         MKQYNNrrYGgLMvMPseQ57anEveEhcIV7MoY1L3jdghL253l7rMXzIE93bqvGJkDfr1aD
         1rJhsSRwl5plRyMEPucYarpP/IT6ugS0qlG8sLe5BoBaXqXf/g/TF+H5esdJx2UbQjuX
         X56m1L5RgsWjbylPnHRHkKiWLL//g2pgag+ccD7ISJpyt7PFnUZmN2UED7BXP9j+b2lV
         JxC8J7/jdTcY9K0RX4SIZAP8QgDW2akYZ9JqTN+6Nqq6Iuhm8CT8WFssoZ/wSZt9ISZc
         BDlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792448069; x=1793052869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lZhdWSnfDKgW5o3GXJHt9J2xBtWTDX7lwKsBGbzGcUw=;
        b=QlcZIDZ7W5dPabljOZ1+l6eMvq3osK7L0s8wYnHj/aqszGO4mbWoMElMTUgjWIzVR7
         3ugEzOPN+F8/09wMpzQUAH7KlGfEO55Da6QvV3u6JMnzYY3A4qitbafAivkC4mpEIlj/
         qU/DE7/+4z6WiEdYrNsOh3Pym2Gv55x3Y3nEcXjPlwnSTBxqddO7dtiwBwF3CBRG0Ckl
         B4oQWYL89DwN7tzgfxw4lakD7+SDoke3IXA0leh3rEAe/NnhxCX7m+274o2TXutqLh+p
         2HDyq/40C41v1H9uV8146guLA/YnbTHIUeZaj1Y4I0qeAcVS+oPsw+J9nlYAbr1+SVR7
         M8+A==
X-Gm-Message-State: AFq9FYIiivJ8qmX96epyr0CWtPJj35KEgGJRPaI3DTXFeOHBucbdx7PQ
	f0q+b1EKGLt4tgDvTMtmCj5B42zSwGq7CUVDjvoreKgaJKHXR2yCQsHmgH07R9MBuF0aFbMtrbl
	3J/wIRiQpDmN9IpNVFQs+bK/OV7BWRX6C6zafZSX3wTpopnTMEPLkEfpy0pXXwmc0EisDPoVLda
	8x+FYX2TCots7jEWUQx/0DJ2ZkUHQ81yFFiVb2r/TXAYN6SolF3g==
X-Gm-Gg: AYBFou2Sl6bN/jpoYTo/4V54ZNEJ2ewgo4ZkpxXVu17YEWt19su6gYzj+Zj5TYsO21T
	CU0etL0NhIJg8Vcl431vdRH60wNmExqFDBlQcq1SYlfU02GcWf47u8Z76b2otT6e4cMNSnqwIjC
	nq0G4efftFuPQ3xgEsiO0X5Q8lolIQGsG4Tus5173Iu7NgFZoDtmDWgzl+aUCkDtXgRYIxYZQn/
	VXXR9l4Je6Y+2I4HkWB+V+X6P3tgEyUc9tkbnsrnn7jm91ZcHCjFtE1qxXlP0ypZ4+o3p+b07bN
	sxWwTIxR2UPUyJtvpSDYKnreWEBfJQUo3MoMl0tfLJM5EKZsaLW5C7HqIXcgAtTqf0iWyqqXmw5
	tarq0xtDC7iJP9LLHS0VrgHFbxlh02re8680p3jfzn/lZ6uoqmREpCZl4We5pTC7Bx+Fc9xlQOH
	yH2q1vxPc0ncJUMa2PkNhNibC8GBKa/bZLpNHC33H6J6FkY+QurCozq8IiG/LLD2gJb/57WhEnI
	/39XHWrNmJSjfidVzGg7VcN64mdcphyKpemU5iVFDpc11rokyMIx2Z8pcLaEqQ85IkYBVWsbbHJ
	4IOKrJO0S2qPZJNOAK3wcrKXegUyObFUiSDEuF7dhgkDnUaK3X/lBCJCyzv6ECLoIgql1BQ=
X-Received: by 2002:a05:701b:424d:10b0:166:af48:a2ba with SMTP id a92af1059eb24-18507af57eemr13916396c88.0.1792448068539;
        Mon, 19 Oct 2026 15:14:28 -0700 (PDT)
Received: from brian--MacBookPro18.purestorage.com ([170.85.204.106])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-18319d3b880sm29429839c88.10.2026.10.19.15.14.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 19 Oct 2026 15:14:28 -0700 (PDT)
From: Brian Bunker <brian@purestorage.com>
To: linux-scsi@vger.kernel.org
Cc: "Martin K . Petersen" <mkp@kernel.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	James.Bottomley@HansenPartnership.com,
	Hannes Reinecke <hare@suse.de>,
	Bart Van Assche <bvanassche@acm.org>,
	krishna.kant@purestorage.com,
	Brian Bunker <brian@purestorage.com>
Subject: [PATCH v8 5/5] scsi: core: Handle reprobe for existing devices during SCSI scan
Date: Mon, 19 Oct 2026 15:14:04 -0700
Message-ID: <20261019221405.40614-6-brian@purestorage.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019221405.40614-1-brian@purestorage.com>
References: <20261019221405.40614-1-brian@purestorage.com>
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

Complement scsi_rescan_device() reprobe by handling the scan path.
When a manual or transport-initiated scan finds a LUN that already has
a fully set up scsi_device, call scsi_rescan_device() for it so that
changes to the standard INQUIRY data are picked up and the device is
reprobed if its peripheral qualifier or device type changed.

The device lock is taken inside scsi_rescan_device() while the host's
scan_mutex is held; that lock order is already used by
scsi_remove_device(). Pseudo devices and devices that are still being
set up by another scan are left alone.

Co-developed-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Krishna Kant <krishna.kant@purestorage.com>
Signed-off-by: Brian Bunker <brian@purestorage.com>
---
 drivers/scsi/scsi_scan.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 87fd3ba5c3cc..c6424773c3f1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1156,6 +1156,16 @@ static int scsi_probe_and_add_lun(struct Scsi_Host *shost,
 			SCSI_LOG_SCAN_BUS(3, sdev_printk(KERN_INFO, sdev,
 				"scsi scan: device exists on %s\n",
 				dev_name(&sdev->sdev_gendev)));
+			/*
+			 * Rescanning a device that has been fully set up:
+			 * refresh its INQUIRY data so that peripheral
+			 * qualifier or device type changes (e.g. ALUA state
+			 * transitions) are picked up.
+			 */
+			if (rescan != SCSI_SCAN_INITIAL &&
+			    !scsi_device_created(sdev) &&
+			    !scsi_device_is_pseudo_dev(sdev))
+				scsi_rescan_device(sdev);
 			if (sdevp)
 				*sdevp = sdev;
 			else
-- 
2.56.0

