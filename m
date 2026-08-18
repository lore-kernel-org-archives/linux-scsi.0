Received: from mail-qk1-f226.google.com (mail-qk1-f226.google.com [209.85.222.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F524854E7
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787075875; cv=none; b=LtFuO/f+/JSSlklpaSx9lqu/MdiY538aEGpF3MY7kAdsStOo2sCrCQKHtM0wMcY/+W/vngIXPLTU5z1B+XgTdSfvSKRWi47OqkyygAfterBt1/M2jxDu6ruk9DnJgwIIiHlSvW7sTJZQZ2CsINPrczlRoiu4xYbMS/GW2BbGJHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787075875; c=relaxed/simple;
	bh=LbNiQrV97/ZlGhmmZ0SscMRXanKkBYXzvlxvduRyL5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi81UE0+EMDmUMyZWXgb0niceuWGqn3VoS6pAw558ql+7J2j/6XdUkp58EcfkktuX5wbhvuDDnDIDoc4J3mFw0And6r9bScsbs1FFdj+GJTWwpRMgZm14smYR7MIOdpMLcwm3PNoEFY3oGEJBZG7voGYNfwMxOSFjz5+qHZmlqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=GF6IH8DX; arc=none smtp.client-ip=209.85.222.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GF6IH8DX"
Received: by mail-qk1-f226.google.com with SMTP id af79cd13be357-9349ad9c857so17289185a.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787075873; x=1787680673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n0PYYIebdBZMCJqIoCZEN5uEI+FLAVx+vfzVspEEKCk=;
        b=sEldte0CBmXbFgwVVMRTqY1yRoird6XDE+L/8e4Bzzh2wQHKQWkFdqEQLebBd/mGH5
         QN8zEm71+e/plJV/D9qYKo7SQ3kvDJzaUcoEAWXYEW7GkqIx4+Zf0XAhoYjU2MzRVn+L
         aX9kkRMkVgKWTvJW1NGmmnchXnjQ0JrMHSPU1skAUWflNeZuXaH8ig8yJpS0aiVA071s
         Vyo9MAAecX1nWYe2Ot0BMkYPsVZqZ/TfM6uGXwmgID6O3oFFSzS3vJFy4XdN0fDdIRCx
         pdOUvZyX9RelZRFEX4UwNz/dWPlvcWE6nHIOjRH9wqR3pa/esaRA3bJt3hDRLpcgsp1g
         ocvw==
X-Gm-Message-State: AOJu0YwxSwTggqRos6pvq0j2n9uDU73DBTuXvv53WxA0sIuXXlYaQsTV
	6hL9wXpfSl4xE5eyTBQcmwKmrlpMeuw7CDMxpqIGZvn/hVIphun275rLiEFkEg/1CYvKTHKX53a
	ONEsYYmHpspaWmDl+a11oerZNrsnYNUbXOHTtSfKlvz6hZG65o/MQ0Hegju4LFFpaTyzGl27lRJ
	Q7UdmA7EcEYUhHOSh7MAQjFO3R8b83taFiyQcCB9k+7OQPdhhDNSxh9vkqWi6/OOriBTrqFL2OB
	dC1U9WE6Q6WoXd5uDpZjIJR
X-Gm-Gg: AR+sD11ZiS0jT4/ocmcHUdhoGeYYUlVx/Cn90bUpuBW6wUrrSWlrx5ofL0zJUPgUXyi
	MOhN0BqUrgw13sHT/fSx4YPtFJsYX0gfVlpHGCv+h3IyLuIxe2EUqQnVLf8cRFl6PbNhVKSRUOO
	xjA629TvGIv6ndL1nqV2VUKNRET8pLhz37doxcqAbkh6PeDUBj6wbKo9F9tl3xp0of1K0lPNIxo
	dmEZ+PsRrIIwtRopfz8DI5pggLIL1OmFcVkA19AG4wuLFFZ/9HtjAC/SG89gKUmE9CtVUAeD+kH
	EEiu4gYgnHVLral4SZ1ejexPIj6YynPIM2GlR4mM3d8LhFSmmkWwSVTegwskgPinC58CQ/+B+tu
	8Q3uiJW4DTgd4WLbim3khfBJ/6sBi/IpBXyUo3YHfV7pQP0Tf86FeBuqW48JSVaUA0hxPwEgEVv
	Ymy0HlSCj8Y8fXua+zzPbLCMdEFxJc2IUzHcqWuD7vpiQ=
X-Received: by 2002:a05:620a:6f8d:10b0:92a:3679:7978 with SMTP id af79cd13be357-936d212c70amr2672597285a.18.1787075872852;
        Tue, 18 Aug 2026 10:57:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id af79cd13be357-93701310443sm162343185a.3.2026.08.18.10.57.51
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2026 10:57:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38e4758ab46so286182a91.0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2026 10:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787075871; x=1787680671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=n0PYYIebdBZMCJqIoCZEN5uEI+FLAVx+vfzVspEEKCk=;
        b=GF6IH8DXocfxZ+JklYi50gCn0B68MnNCVN5amJsJ+0Z2hRzfBx+xC6DmdjelL4HeEs
         MfGvEf/iRIkTdYFRV03Uo6hY28vM6y00NxDlptauHZ/p8m49yQWPye3AE8q424V6JxaK
         h+Ya9zzX+ZoIqlfzywZe1MviwyGis9GxzKf0I=
X-Received: by 2002:a17:90b:37c6:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-3933b8f3573mr40446879a91.14.1787075870812;
        Tue, 18 Aug 2026 10:57:50 -0700 (PDT)
X-Received: by 2002:a17:90b:37c6:b0:38e:2e86:ed02 with SMTP id 98e67ed59e1d1-3933b8f3573mr40446810a91.14.1787075870168;
        Tue, 18 Aug 2026 10:57:50 -0700 (PDT)
Received: from dhcp-10-123-98-253.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14153187de4sm16741958c88.15.2026.08.18.10.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 10:57:49 -0700 (PDT)
From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	ranjan.kumar@broadcom.com,
	sweeti.vandure@broadcom.com,
	vishakhavc@google.com,
	ipylypiv@google.com,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 12/17] mpi3mr: Fix out-of-bounds phy array access on link change
Date: Wed, 19 Aug 2026 04:44:21 +0530
Message-ID: <20260818231426.58105-13-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
References: <20260818231426.58105-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

The phy number that comes with a link change is used to index the
node's phy array without being compared against the number of phys
allocated for that node.

Check it first.

Fixes: 42fc9fee116f ("scsi: mpi3mr: Add helper functions to manage device's port")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
---
 drivers/scsi/mpi3mr/mpi3mr_transport.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_transport.c b/drivers/scsi/mpi3mr/mpi3mr_transport.c
index 240f67a8e2e3..2afff1a002ed 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_transport.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_transport.c
@@ -1090,6 +1090,13 @@ void mpi3mr_update_links(struct mpi3mr_ioc *mrioc,
 		return;
 	}
 
+	if (phy_number >= mr_sas_node->num_phys) {
+		spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
+		ioc_err(mrioc, "%s: phy_number(%d) >= num_phys(%d)\n",
+			__func__, phy_number, mr_sas_node->num_phys);
+		return;
+	}
+
 	mr_sas_phy = &mr_sas_node->phy[phy_number];
 	mr_sas_phy->attached_handle = handle;
 	spin_unlock_irqrestore(&mrioc->sas_node_lock, flags);
