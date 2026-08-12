Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F30B7423E85
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 10:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530858; cv=none; b=FsShTIygl3e182vCqJF+RcVc8ykpe7DyY2rQz6eoDCGRcJNnrotgxHrFIcbv+iedRoG20Hry2QPmnEBoDj1YSHIqddstWGAEg9S24t2uaQCQc5Evt7NnYCUlvgz0pPlj3WUnbdMvF1aIWLoDhAZ+q6gsxv0cQdi7iFcoPNpwbbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530858; c=relaxed/simple;
	bh=QslT1uo1hQY4U0PYOxdmrfNftOyp47nQCRupknM8Y00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+CYL/GwKreVy0seY1psHhaVJzlpbL5YncRpyHT/TLb9/V9qdWPTzAoPeRFPyxvXPu20fTmFkHgr9rDcn+9MeCbYqLMo0voODgg1BIIdbRHQP+WV6rWs11vCfQcEEAXL4GQC1sP5pwgPl8ylGEqrGJwlSm+zTJNTFAO952eLJRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NYEF77Nl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=uFmrTfXf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NYEF77Nl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="uFmrTfXf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786530856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r8qWubulphdV1XFUWAhJ9CU7Q89Wk0Bg4x3ogs9qX78=;
	b=NYEF77NlL1eAkTb7R/n8aG4GmD+4AQy2yxx9R8MSsqPbPcydoBTWaQIKI+5Q3QWS1IkAxe
	Uz2pggNVfboXgEo1waxQckJW60qhN8DOHEqGlZQmqJ17WBvAqR0ilmQbJNh0yeLUv0wbuL
	kC122rYixEfUOo9vOAYg/ZSs2LtAyJA=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639-ysep7vxNM0i-pgSkAye7cA-1; Wed, 12 Aug 2026 06:34:15 -0400
X-MC-Unique: ysep7vxNM0i-pgSkAye7cA-1
X-Mimecast-MFC-AGG-ID: ysep7vxNM0i-pgSkAye7cA_1786530854
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-c9fe4c5eb39so565334a12.1
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 03:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786530854; x=1787135654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r8qWubulphdV1XFUWAhJ9CU7Q89Wk0Bg4x3ogs9qX78=;
        b=uFmrTfXfRJ5GcMvWE+F8RVFESDBO4Qk9DhM1sCNDz02VP6sWknqhq6k3ypWSVkZ9N7
         sdVsSswEY5b/DxuXZU7v0Jrjh4xeEiis8fAzzellx8eshMmzaeQr5PptezyxWuOoKm6d
         Ujjsd2Q18IeqJD2jGJT/OKpg0B868HQTOFC30WDXX0BOZtIoLifPsAIIbdTJyPCnsg9S
         NGHGlITHOzz6afMJh6G4EemnB3CAT8EvDE7HSDOTIj+ZfYbBq1ZSYcD1cpw7vPx7EAQ+
         YldoJVXpeknv6HbQdLVNEuw4TlMRuqwPSW50sx6bJH3vYYoVwVxay60J9B5srF5XzTiN
         2lVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786530854; x=1787135654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=r8qWubulphdV1XFUWAhJ9CU7Q89Wk0Bg4x3ogs9qX78=;
        b=ITXmzNm97XEYbHQOsG0wD20Md6Uv1PmqH3YcGYabmZe7WI/8TvtY44hbnCFRstu8h4
         s7cdMdFtF1Th17dXmNcVdt4XZq1VaVmSiSRWvonPleZ1M99pdC+3fdS4CDl2HwqXovyv
         mKWRD1BhUUXMQi0p7IXzPhn1f1gyyVY84k/GOlz1aUnZjZnPreneSu47b4lB9ZEkoAV9
         Rv5OcshewM69WaG5h7u183ufZPOQftzRq38pm5YGQP804akpUHPsbzVobiiSUlIxhUv4
         knaE8i7CF9YjEYmeR2gCx0V/U/jPfZ1px7+aZWWjcaK72WXTC7c/G2I0KptUrZdqDTSL
         5fvw==
X-Gm-Message-State: AOJu0YyID/cpTS7Pym4BIPgVch7ejX7hmb1FfKVWttenm+QcD06hud+I
	3HgfLqa2jgrO8PscVg47YBRnp3OlvzJ43OAA2hd7e1if1pCwPqLsBs7EH+V2z/YcSgnJ2DeFV6w
	mtl+YRfWpT0uF/7WGuO9xTiFvwedkY/og2Ls7u3/QIaaPqTfwZjnlWdmadcAaeSxX7dtvwtMEer
	lJvNtmkcqWzUuApJ6fQn/2o6DDCeOOANmOts/amiCXu0vvIA05
X-Gm-Gg: AR+sD13RYTO/4VUVWRwFb3EkDC8zsvtx1jhQAoDo5wUz1d+Q3/WzlD1FR60fWw2osUk
	S6ZsTh6tE8yxfOAhLzsBG29tklt/GqQZWcKtSJbK7X5rSbILie+nX81Y8t2/hm5pky7dDApEBrP
	Ze7z0QClPtMog9dWiz87X2Ri3slVhqOGdFo8ZkP4QnVGKmQeakiu3sxbBvO8myXeCKcv1ZztC01
	nHIgqSKR4YsVv6WA+pj6kY8yLAfxNTz3dwo1gb3ElRWjk+7I2Pp4tYRd/Xk8JWf7Qh4SgQpUUxi
	/YJkCj6MDcVLPJ1CoNsbnktsJcTKzQWq10+hOnICZybNbgnHC5BqYIk5DtpjFwAW4mQyvHJkvrK
	hYp2j5zx/LsccifGZdwGZWyLGpWe9Iptf1v7y8eYVpilfzqxNT/1sX3hyc7C5nx4cOM7H
X-Received: by 2002:a17:90b:288b:b0:38e:f6eb:2b38 with SMTP id 98e67ed59e1d1-393014944a5mr4243091a91.17.1786530853740;
        Wed, 12 Aug 2026 03:34:13 -0700 (PDT)
X-Received: by 2002:a17:90b:288b:b0:38e:f6eb:2b38 with SMTP id 98e67ed59e1d1-393014944a5mr4242998a91.17.1786530853165;
        Wed, 12 Aug 2026 03:34:13 -0700 (PDT)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88fa:3d3d:2349:1310:a2eb:9912])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f9675e32sm1031413a91.0.2026.08.12.03.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:34:12 -0700 (PDT)
From: "Milan P. Gandhi" <mgandhi@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: "Milan P. Gandhi" <mgandhi@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] scsi: mpi3mr: Fix target device refcount leak in mpi3mr_sas_port_add()
Date: Wed, 12 Aug 2026 16:03:44 +0530
Message-ID: <20260812103344.174247-3-mgandhi@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260812103344.174247-1-mgandhi@redhat.com>
References: <20260812103344.174247-1-mgandhi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mpi3mr_get_tgtdev_by_addr() increments the target device kref when it
returns a device. If a subsequent error triggers a goto out_fail after
the tgtdev reference is acquired, the reference is never released
because the out_fail path does not call mpi3mr_tgtdev_put(). This
prevents the target device structure from ever being freed.

Add a tgtdev put in the out_fail path, guarded by a NULL check since
tgtdev is only acquired for SAS_END_DEVICE types and the same cleanup
path is shared by earlier error cases where tgtdev is still NULL.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index ea2c04384a0e..232af978d737 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1507,6 +1507,8 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	list_for_each_entry_safe(mr_sas_phy, next, &mr_sas_port->phy_list,
 	    port_siblings)
 		list_del(&mr_sas_phy->port_siblings);
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
 	kfree(mr_sas_port);
 	return NULL;
 }
-- 
2.55.0

