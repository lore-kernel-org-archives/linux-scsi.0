Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8E4400DE9
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 10:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786530852; cv=none; b=qLoD5kLwGi/z5E1SnJ1mQntrNHU2cO7frmRUQNzgi1oowcPq+HKGJNugqfucD6kPuLs9JYfXI4NlsLLFmRdZk97vWUz+p/5KJDZ8Gmwrll3QfMwBEXs+NwKmS3utm3M57bpGt7tpUygUNfqFS/X0uVRpmbRhUat9VhIWGQGRDbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786530852; c=relaxed/simple;
	bh=3YARpoiLgDt9cepevBmsvmfBu/Wh49o8ppbMDUrcSQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIb9m+WI0apECaCvxWkE9Un+4QJwT3/XW+QY6gHEwc76ZubACtgv4Db5vCtkh+i0KZtxhtC/uyqApZfpRLvCy+kdRGjCBzAdB3J3od2KkGz6gKGoO756pvCFXHV0+wD+V5lrcjDyavJ002VP/f93cswI6jCN+cnFXwnZCX5ho9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IXmqKAOT; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=A2hv/IIW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IXmqKAOT";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="A2hv/IIW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786530849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fmJTzfVEll3lbdFDSvEM9OU2A91wWbCw8sY0qVk2q/g=;
	b=IXmqKAOTG8a6YQdIStI+1e1hvEQbg6xMDf1FxnrQbjseGb6k0FRUPHT5R8MEIrrn1iNSul
	NhMfrH1gfV8zZGbs0SOT7mItHMooIKbx49myjzDIudfahGBSK9jGFymR53tWP9P/lc7Lva
	/nqufHIq5BPLw7gghwtulD70uf4AVXw=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-1hLTI_vNMXOQbNQq5Rabeg-1; Wed, 12 Aug 2026 06:34:08 -0400
X-MC-Unique: 1hLTI_vNMXOQbNQq5Rabeg-1
X-Mimecast-MFC-AGG-ID: 1hLTI_vNMXOQbNQq5Rabeg_1786530847
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso915257a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786530847; x=1787135647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fmJTzfVEll3lbdFDSvEM9OU2A91wWbCw8sY0qVk2q/g=;
        b=A2hv/IIWeng4hn1+DmGshopqJwudhJyLrhzJ60iTUztmyS2XdJvQiYWnJrRSGWVnL9
         beJjiiAsKKJozQVXpRAsDpGvh+Hg/p3aDbE/vb3Vnyh8euXxHU/91ZAtms1TOSyWY7iS
         /t6R+uhbv1h2iEOivk0FlCnzLaFNtMPsCugkRE5gAtQqtbmxRX+qGwtfckhnLRq871QV
         c5YHyMT3tCCtEIFdcvOhFDW170rK6QOFwpb57hueuK+Oxv4Ng+gPleiMFCGm7qkMdqm6
         rWad5xSFNuwi2EqkD8Rm4jSy5yN2wpkXyWzSsV571lY/3lUjMVy691dI7i1DxPgO351N
         5QcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786530847; x=1787135647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fmJTzfVEll3lbdFDSvEM9OU2A91wWbCw8sY0qVk2q/g=;
        b=g65lxC6xU6hBU4hgHJJf5r3eIo4wAx7w5vuVIqCgKWC/7lqMsGgqy2juhU/MQu/SSi
         lFvXJJHlr4iAYFFBYh9koDboDhPH5hUiTsWag+/HC/GZJ2oX3i8TVG9IrW1bSXmYg+OD
         5S/dtbzvh4iD2ZKYUFTccIFLwK+2CkoAqL+UbOgXp3KfHlHG0XDZVHlJ3nbiVFUy7ajp
         +iTILSiuZdprAibeFaXAQJENNl/i+j1fTzo53EoW3poswubLd3bW/l93aL/7DwiKiom0
         emCS45Iu4RKzzGLG9lrbWqZfG/f3cygz8HKZ2TtLPdtkbnkOsCBIs95R4NH9iZarqhLa
         ctDg==
X-Gm-Message-State: AOJu0YzVW7E/HEqxtBSDdh4MkInhCMCsoH8fwTfiPqN4XM8D7bwiJsZy
	KXxgslWK4D9kjsTQixB10HNpad0c6+KDdc6pCKp9xwkpgdiuMpdi0oPV77PxKtD+JGgUzuj+SJn
	mV60ZZ0VZDjTNiqQUkWH5y7aYvs3Yt1Mmx8fkdc4Pra24jsvHTpClwRpStxWvR1pTmtKXApSVSS
	JTJRnyzJwulcJeG99CvVCV34jGnHJ3SB4ZId8XTO0twQlhRg29
X-Gm-Gg: AR+sD10GUFShLtoVE4Q9GhD+iXeSD5HFhzP1178vHsskY669+Ztgd2r+WnTaykRNMfm
	9cmw2CFTuGBEm0kURv9B8VV7GHNsyocdJezRi4gR1OXqnAouSkpwFrFH3ysAokwB02W+iOBuecX
	ETH8tMaWxCtQ1mwcSThH0V+fpNJMjGPxPBKJL0SRCHSQahmGYPgv6unvRrKnnecRn190xBLpJyu
	XRJ9YNgXmj/UWFjhd1zA+gKovV/k+GCc/oTkkuSDA0n8xAb+SSw7lQbP83gQqR5OzZk2WIfOG0f
	1B3eBhT9yS4Wd4KDwdtiB/YyzLrZDkYzbEaI3K9RQmBG58Gh+cT5+VFDIMGYqV5rQhHbn+AjKcI
	3jesDmK8lNtDu4T4yaP/YzaiY6ma2r79Emax/SllvkNEsTra8hCZjGgz9mtOoFTd+fg71
X-Received: by 2002:a17:90b:4406:b0:37f:fb1d:63fa with SMTP id 98e67ed59e1d1-39301663a8fmr3697933a91.15.1786530847191;
        Wed, 12 Aug 2026 03:34:07 -0700 (PDT)
X-Received: by 2002:a17:90b:4406:b0:37f:fb1d:63fa with SMTP id 98e67ed59e1d1-39301663a8fmr3697855a91.15.1786530846491;
        Wed, 12 Aug 2026 03:34:06 -0700 (PDT)
Received: from mgandhi-thinkpadp16vgen1.punetw6.csb ([2401:4900:88fa:3d3d:2349:1310:a2eb:9912])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-392f9675e32sm1031413a91.0.2026.08.12.03.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 03:34:05 -0700 (PDT)
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
Subject: [PATCH 1/2] scsi: mpi3mr: Fix NULL pointer dereference in mpi3mr_sas_port_add()
Date: Wed, 12 Aug 2026 16:03:43 +0530
Message-ID: <20260812103344.174247-2-mgandhi@redhat.com>
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

sas_port_alloc_num() can return NULL on memory allocation failure. The
return value is passed directly to sas_port_add() without a NULL check,
which causes a NULL pointer dereference.

Additionally, if sas_port_add() fails, the allocated port is not freed
before jumping to out_fail, leaking the sas_port structure. Call
sas_port_free() to properly release it.

Fixes: e22bae30667a ("scsi: mpi3mr: Add expander devices to STL")
Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..ea2c04384a0e 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1428,9 +1428,15 @@ static struct mpi3mr_sas_port *mpi3mr_sas_port_add(struct mpi3mr_ioc *mrioc,
 	}
 
 	port = sas_port_alloc_num(mr_sas_node->parent_dev);
+	if (!port) {
+		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
+		    __FILE__, __LINE__, __func__);
+		goto out_fail;
+	}
 	if ((sas_port_add(port))) {
 		ioc_err(mrioc, "failure at %s:%d/%s()!\n",
 		    __FILE__, __LINE__, __func__);
+		sas_port_free(port);
 		goto out_fail;
 	}
 
-- 
2.55.0

