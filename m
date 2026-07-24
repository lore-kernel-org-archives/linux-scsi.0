Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CE741F5EA
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784889181; cv=none; b=t2MPgXug0cPj7qHo7hnaMARWI8xHZ6ihUDY+/NATrUR2ketggjJ7DblSjyRgLz0Ky1KQgaRmX6Sar0GwJN1AJm9AUj6lPdebAX36ox04Iojh2B/BqXwzNxO7gcP/J4LuvoWuAuh7ZTi2vp7IUhSUetA/3DnMjVHGVyzVPj6Ub5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784889181; c=relaxed/simple;
	bh=OG8ia/aKi4S1bUjrapGHG3wPOdqfQrCTK70T8hhlbd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJlJvtd20WtDLSIGgeS9v589jXhEQ6m9By1MJTraEj7vRe5SiPdA8JZaZufhwTz7e050sQqwiQNn+eGQG6u2aUIeTtvVIAt/IoRMFJhIcAG+BwwhfbjmT7pCzoBboDKkuqcMDIXzntZWRp1lkazWP0CV2hCNwT5vIaQ0VmvqYNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=CVRFi4LY; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="CVRFi4LY"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-6626b5ace23so1242260d50.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784889178; x=1785493978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Gv5WsJX/AagDmyo5EhhXWRr3KoL7MQqXxlQTbJ7iwcA=;
        b=IK14VUz6KgwrNwiTCQEVINxH4q44mUsxlCuU2VQtQFjeW3Mv99YeC2AgKMn81UasRJ
         WoPucjkmJ2qtSPjvX/E8vWWEWRtTT3t1xfuiHhncXsK9JbVI/O5hc3idYHBiWzTXjm78
         mzQZW5J4C0aYfZHWik8qNLpJiTi7saqNhKDma5+vAeRomfDDuhvWm7soqRe9MWufDYWZ
         uvZYbthZJ0SOMBhA46TKG2UcVluKLAtlSVf+No6vRSMHTwYp5xmvC9kpOYAgVACIoPGb
         +rDIIhT5VoMNLngdoRR4RAUqR9+VHVQWaA+zk0ojeAE+DOq0+vL2YuLmqxwCdjyUaOMh
         kU2Q==
X-Gm-Message-State: AOJu0Yyjzhy+213CMXudC3R/SotqsMBgR3npBCTR3f1P2hXhaLNu1He5
	QQeHEieZYoPdAEI2R9t8wkoLfDbnc1xgxqeCH3KZZkKmUd3jSaC+89Sy2je9o5i2JValEUvCMRt
	oysXMw4kv2uKksCkUq5NGwSogWy8MLdcMNlXfbTB3SfJvvDRr3fhTUPXen3ZWTLRTAUyp9Mbpy/
	2dqwvz0l1wBZa+0d6mCRnBX6H+V3rbVGFWVrbTAWydxsihAOhJQCcvx7hUOGzk0cmnhLyZpRhvP
	lINYS/LcmmqdoK1
X-Gm-Gg: AR+sD12W1vZgeP5sYO8LVcI7DFEFIY+Omaf97OoXRgoxQecTbgvKenyr+FekfPrqT8D
	G5Ry8XSW+G3Y6PM0HSlGeEnZ9DbXlzzCgbRxCoQ6LfYVW5l7hr2MUdtDI3XIe4La+pPJwNLoudy
	pPE0hjZzh99fK+vb+QHKJ6lsJM1neJlHLpvSjAtZqB22PUlypJsSnYoYjcDeZftsn4vqCyAextU
	Ntn8Lu30ryHjqAW6H20bjNfhvWmeDDRpxvgczlt1ly7Mxld7eErgN9P87BYSo1y8qT0vfKcv51o
	MKKBr0JfwuKkTg8V1CkOzVuiPvMKQnJAI0Zf3cCyhkJ8nK2I6ozBL5TGqXGsJa0lfyLsrvhFUDg
	j6RTptMfW/5687JmgObIlruuxaMUZ0dIU0pJFT+ZXkRMYMKPM1MixAQNkDwmdVq+W1vbyIApjCL
	z2RmtdwnEPcFawVgTA7oHAw0UyLr3qFyLbIto=
X-Received: by 2002:a05:690e:144a:b0:668:b12d:7e2 with SMTP id 956f58d0204a3-668b12d275fmr1063462d50.42.1784889178069;
        Fri, 24 Jul 2026 03:32:58 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-73.dlp.protect.broadcom.com. [144.49.247.73])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-66890527726sm526767d50.4.2026.07.24.03.32.57
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Jul 2026 03:32:58 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84c4cd31b51so1685686b3a.0
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 03:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1784889177; x=1785493977; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gv5WsJX/AagDmyo5EhhXWRr3KoL7MQqXxlQTbJ7iwcA=;
        b=CVRFi4LYcZLTMnJj/cT6Mh8XjW9a8qpairHRTwLVL1uazefYyrAmWP4m9vi4TW9c9y
         IYC997S7SeH0j+VY9HEFrrwiP/rUmddlTGDoZfyilh8R7SR70v8dPxtJL4eLJA+TyvEu
         yDEXyAPcmO7AglgvpuPPSox7WLT2E527KBPbc=
X-Received: by 2002:a05:6a20:6a26:b0:3c4:2f75:719 with SMTP id adf61e73a8af0-3c44cd1de09mr7243753637.37.1784889176808;
        Fri, 24 Jul 2026 03:32:56 -0700 (PDT)
X-Received: by 2002:a05:6a20:6a26:b0:3c4:2f75:719 with SMTP id adf61e73a8af0-3c44cd1de09mr7243725637.37.1784889176135;
        Fri, 24 Jul 2026 03:32:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147e1cf8fasm30233211eec.31.2026.07.24.03.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 03:32:55 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	chandrakanth.patil@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 08/10] mpi3mr: Fix SAS port allocation and registration error handling
Date: Fri, 24 Jul 2026 15:55:03 +0530
Message-ID: <20260724102505.115136-9-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
References: <20260724102505.115136-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

During SAS port creation, the driver does not verify successful port
allocation before attempting registration, which can lead to a NULL
pointer dereference. Additionally, if registration fails, the allocated
port is not freed, resulting in a memory leak.

Fix this by adding a NULL check after allocation and freeing the port
when registration fails.

Additional fixes in the error handling path include:

1. Fixing similar missing NULL checks for rphy allocations.
2. Ensuring the target device reference is released in the error path
   to prevent resource leaks.
3. Fixing a double-free vulnerability in the sas_rphy_add() error path.
   Calling sas_port_delete() automatically cleans up the attached rphy,
   so explicitly calling sas_rphy_free() immediately afterward resulted
   in a double-free. Remove the redundant sas_rphy_free() call.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260626114109.43685-1-ranjan.kumar@broadcom.com?part=8
Closes: https://sashiko.dev/#/patchset/20260708183305.244485-1-ranjan.kumar@broadcom.com?part=8
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..00f115ef3a47 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s() (sas_port_alloc)!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
@@ -1450,10 +1456,22 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	mr_sas_port->port = port;
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		rphy = sas_end_device_alloc(port);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_end_device_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 		tgtdev->dev_spec.sas_sata_inf.rphy = rphy;
 	} else {
 		rphy = sas_expander_alloc(port,
 		    mr_sas_port->remote_identify.device_type);
+		if (!rphy) {
+			ioc_err(mrioc, "failure at %s:%d/%s() (sas_expander_alloc)!\n",
+			    __FILE__, __LINE__, __func__);
+			sas_port_delete(port);
+			goto out_fail;
+		}
 	}
 	rphy->identify = mr_sas_port->remote_identify;
 
@@ -1463,6 +1481,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	if ((sas_rphy_add(rphy))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_delete(port);
+		goto out_fail;
 	}
 	if (mr_sas_port->remote_identify.device_type == SAS_END_DEVICE) {
 		tgtdev->dev_spec.sas_sata_inf.pend_sas_rphy_add = 0;
@@ -1498,6 +1518,9 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	return mr_sas_port;
 
  out_fail:
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
-- 
2.47.3

