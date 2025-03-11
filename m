Received: from fgw20-4.mail.saunalahti.fi (fgw20-4.mail.saunalahti.fi [62.142.5.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3914254868
	for <linux-scsi@vger.kernel.org>; Tue, 11 Mar 2025 11:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.142.5.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741692361; cv=none; b=SefJQT+AbhZpHYEIl9+i4cfc8VlmXBieyJEJzM4gsk065LGe7P9F7hC/JSUsabvNTuFjYhFBTF9G0AwpqCev95I8t479TW8o5V4Vq3jwuFz4gJpEjdLNh7MfIHQAOtPpTA3jX4AQclPUjoL82U23zDdUhbl/9erb1l2E9YK7cQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741692361; c=relaxed/simple;
	bh=FMzUnYrAUQZEeSgs2eATqMgruSAS2BlCDC2qhCuu2kw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BrigeuMgnOiVqhdKgXkevBSxmw5yxe0We56OVsDRtzO8qRBntI5MmtPESvuWAfz9CYO2uGOsR5fJkpHKwsx84PFw2DARS0VV8Wo5h/MgYt0nx0PiVrmR45g2y5EzheqPAzdYkwv/u+CXVMB4tdZvXotRlGC0V7NG5i6bP/Eph94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi; spf=pass smtp.mailfrom=kolumbus.fi; dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b=gaxm8nvR; arc=none smtp.client-ip=62.142.5.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kolumbus.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kolumbus.fi header.i=@kolumbus.fi header.b="gaxm8nvR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=kolumbus.fi; s=elisa1;
	h=content-transfer-encoding:content-type:mime-version:message-id:date:subject:
	 cc:to:from:from:to:cc:reply-to:subject:date:in-reply-to:references:
	 list-archive:list-subscribe:list-unsubscribe:content-type:
	 content-transfer-encoding:message-id;
	bh=iZACrZQ976IEl3UWhopX/+Gv0GIuRF34YkH08gpjpu8=;
	b=gaxm8nvR+4ztxm6KC367Cxc6757Wawwg0eMt3LEMjMrbas6PAxuRIzdnHE0XKPYMQYUhv6+Do09Fb
	 JoDQ8LtCJuZ81V857ty+CwxahMgiXma0r7KgMU049OH/b/C2VNJSvwk5evqejarSaUfdqWVwNZbnnh
	 xqlxgtaKJZLFsaHW4T+5v6Wqz4VwmziWJthpTlaBj3+LzGbbGMB3EA3KUDrMRkxJcjLZaaXl/v9RaO
	 Vq1EP1yvEuMc8sGMxXfaK1k5uSZU0f6W8pHJ/PVObHrJT6Ta0OR0noaxdAIy+ZYNVV3fjgtai8tUoA
	 5+6cXGISaoKQx5AAuq/g4RB1cLJso/A==
Received: from kaipn1.makisara.private (85-156-116-90.elisa-laajakaista.fi [85.156.116.90])
	by fgw22.mail.saunalahti.fi (Halon) with ESMTPSA
	id 90f3599e-fe6b-11ef-83bd-005056bdf889;
	Tue, 11 Mar 2025 13:25:42 +0200 (EET)
From: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com,
	James.Bottomley@HansenPartnership.com,
	jmeneghi@redhat.com,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Subject: [PATCH 0/3] scsi: st: Small fixes
Date: Tue, 11 Mar 2025 13:25:13 +0200
Message-ID: <20250311112516.5548-1-Kai.Makisara@kolumbus.fi>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix some small things in the st driver.

Applies to 6.15/scsi-staging

Kai Mäkisara (3):
  scsi: st: Fix array overflow in st_setup()
  scsi: st: ERASE does not change tape location
  scsi: st: Tighten the page format heuristics with MODE SELECT

 drivers/scsi/st.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

-- 
2.43.0

