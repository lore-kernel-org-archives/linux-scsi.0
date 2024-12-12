Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E803454723
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2024 20:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734036744; cv=none; b=cOICVrwKEDLNAEMExBMJjCFpdiILFSyyag7mjyaQwJWkqNf806YaiOvo6NgY7dEliZZ3F/+TkgIESoVwtMgJpH8yaIrG7l+BiNZmaIuuXai08LiVb9/5SPTKXtXITbDwcvlZFtTnqbzJJlDKokjZCE8k/ohKHBVA/7S6UcROdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734036744; c=relaxed/simple;
	bh=yiwPWrbTjp8ma6fSG7gvV+COqBeqs/rHgFw/+Zg3k2o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AWOL00wKkyefC0Af2ZBR1avlOxLAC/OTS6r2p6LySJK+AEZC4FKIdmSTwjF23hSdCHkANqq38bCvFxBstl5oIJko43bEj3tP44hkT1tPr1rpUOCwCMNlhMWliCrh9I8WvLt1zL1ZYzIGE8O+p6qfP635lnpesPWsf0i584xlizg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WO9yZiXL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WO9yZiXL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4g6GVR9APuTC1HVYC7Knnc7cK4KtpsIO+vvNRaQk9O8=; b=WO9yZiXLFpk7hVguhl+5gFWEUP
	Uq5Q21Gh4A662nXQsdrsge7zFHaa8UIjwN05W3BSWqOLM89hc0MZ7FCpEDYhq5Ew3lYdvKOq4adto
	NgSVZOH0MIdBR3s/84PVh8JXzao5hDraV+NYNYFyhqM3vYP2p9zBlVZbibOMjGtfDOSwA/lp5CI2X
	w7cJnSRMFT/5ESUwt8MFQF2+V/0VK5i6PZSJEvG35MvjMDZ180pBfBkUva4RTM1j6IRxcREYzvDKG
	vzWEyi2ZoniMoEnFt1//jccnLRzLmZC624u5jmCjyia8qIPBM1f1ucf8cVOFJf2zF0IzAykYlseUj
	yrAFqE7w==;
Received: from [50.53.2.24] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLqAX-00000001rO5-1XKl;
	Thu, 12 Dec 2024 20:52:21 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-scsi@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/5] scsi: fix kernel-doc for exported functions
Date: Thu, 12 Dec 2024 12:52:12 -0800
Message-ID: <20241212205217.597844-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add or fix kernel-doc for exported functions so that they can
be part of the SCSI driver-api docbook.


 [PATCH 1/5] scsi: scsi_error: add kernel-doc for exported functions
 [PATCH 2/5] scsi: scsi_ioctl: add kernel-doc for exported functions
 [PATCH 3/5] scsi: scsi_lib: add kernel-doc for exported functions
 [PATCH 4/5] scsi: scsi_scan: add kernel-doc for exported function
 [PATCH 5/5] scsi: transports: fix kernel-doc for exported functions

 drivers/scsi/scsi_error.c         |   26 ++++++++++----------
 drivers/scsi/scsi_ioctl.c         |   35 ++++++++++++++++++++++++----
 drivers/scsi/scsi_lib.c           |   21 ++++++++++++++--
 drivers/scsi/scsi_scan.c          |   20 ++++++++++++++++
 drivers/scsi/scsi_transport_sas.c |   10 ++++----
 drivers/scsi/scsi_transport_spi.c |    3 +-
 6 files changed, 89 insertions(+), 26 deletions(-)

CC: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>
