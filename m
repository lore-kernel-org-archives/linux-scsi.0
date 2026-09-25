Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E5DD4AB1C5
	for <linux-scsi@vger.kernel.org>; Fri, 25 Sep 2026 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790346586; cv=none; b=iUZTuDgb2l5gkS9rvF/wacKS1Ynwbc2q2+qbVfx/4Q1Oq9E9rGk7t2gnVECMDioVCMB781w+pNYGgT5C+scoP4S9pgsPEC1/BX9sRPRIlrcZrk++Xr0HwlXJl43bq2HP2zRX21JNpgz6TT02K6XyQtBIyARkBKP3HZA/5eZqWAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790346586; c=relaxed/simple;
	bh=PWZvnkYk4j5lxDWm8Nz3civdTN+Qjc+xt8P1Jw8bG4s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hcCuODMDgNMMlleKv0UosyM4Bn3zzGd9Va/h4jBo8OEljlzgLsDNof+hRnyM6la2nbLxuHa6bP6uMo7MGld6cWBbrMcppAoa+KmEp2/67Ho6ZISEw6Qfn8is2A2vquXkoQkHgFf/k7NvMcT5r5Y63GcP6gygzcCcTodR047I9f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ib1Zley9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ib1Zley9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790346584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=p0801dME+Nec+aIbveYMnaYOUO+rYxmuXL3X0xbe0kQ=;
	b=ib1Zley91EYDNI3QSxdBt9maWuQJdA8cO2mZw5T6faeOnIjQJfTTZy/gasf20IswC0yM8E
	cKIKtNB5Ys1narsjQ9AoZb3XS41y+wqNij3ulmD/P1WBQCMipB4VIkfUpgvZOtI9ytlw/r
	78q2OtywPHcT1X2/gMqTdFhfDSwJsfo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-694-ATmn_pKBPUKIv2Xa5K1VnA-1; Fri,
 25 Sep 2026 10:29:43 -0400
X-MC-Unique: ATmn_pKBPUKIv2Xa5K1VnA-1
X-Mimecast-MFC-AGG-ID: ATmn_pKBPUKIv2Xa5K1VnA_1790346581
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 974CD1953979;
	Fri, 25 Sep 2026 14:29:41 +0000 (UTC)
Received: from jtaubepe-thinkpadx1carbongen12.ibmlowe.csb (unknown [10.22.88.172])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3B371418;
	Fri, 25 Sep 2026 14:29:39 +0000 (UTC)
From: Jesse Taube <jtaubepe@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Meneghini <jmeneghi@redhat.com>,
	Chris Leech <cleech@redhat.com>,
	Saurav Kashyap <skashyap@marvell.com>,
	Javed Hasan <jhasan@marvell.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	Nimal Prabudoss I <nprabudo@redhat.com>,
	Jesse Taube <jtaubepe@redhat.com>
Subject: [PATCH] scsi: bnx2fc: Drop unesseary call to skb_transport_header
Date: Fri, 25 Sep 2026 10:29:37 -0400
Message-ID: <20260925142937.2051868-1-jtaubepe@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

The result of `skb_transport_header` was unused, previously it had no
side effects.
commit 66e4c8d95008 ("net: warn if transport header was not set")
Added a check to prevent accesses to an uninitialized transport header
under a CONFIG_DEBUG_NET environment. Sence `skb_transport_header` was
called with an uninitialized transport header, it triggered a warning
case and a subsequent system panic.

Remove the unesseary call to `skb_transport_header` eliminating the
warning assertion and prevent the subsequent system panic.

Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index c95b084cad69..3bff781d0531 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -533,7 +533,6 @@ static void bnx2fc_recv_frame(struct sk_buff *skb)
 
 	/* Pull the header */
 	hp = (struct fcoe_hdr *) skb_network_header(skb);
-	fh = (struct fc_frame_header *) skb_transport_header(skb);
 	skb_pull(skb, sizeof(struct fcoe_hdr));
 	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
 
-- 
2.55.0

