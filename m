Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E82D25B2F4
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929727; cv=none; b=llS7uNt4ucBxpJRwPim9vp1BDcnkNNQEkajm39612Lys3z3Tjbekl/xyFx2DFGmqIExB3Za4d8ciORVbnb3YSxX+pUdIO+K0BxGscjkv+hkaw4StyS5Q8UZ3cCWy3tS4h+g3ikdtSeQ/DkdmZT44L0w9rk5hfs9uhoa8ZLxkFAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929727; c=relaxed/simple;
	bh=+mzQt7j2BM5/VerHVXPbrHdlDHb9KEhVGib0KQnrVa4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=QQGBHCzGgfrdjKdVTd0ZeWJA16kh1SZHs+a0tlZWdDfc/r9PaFgF/wVv+fQAahPEZFtuRx3sPijuMh3RE8y45kcMIgjgj2kk03NuzeZSTSc2X4X2ipxQld86UZ1oxFAkXi7LYXjgC0YmwckCxtDU5PP/2kXNTq/Ex7hXd1PRCrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i7UrSutb; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i7UrSutb"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8947ddce09fso3324976d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929725; x=1771534525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3dobwkICLXBBNJH1jlqQxJ3Quo0Y6oLzvMafZOOZ1zk=;
        b=i7UrSutb5QpJH6B9/2dAugfSuCuuELab8sojW0WY++Z1MIkNfhak5FowEWEv/+pVv3
         RF8jqf5Z02d9dMJNEH0bhY58lfHaC1iZxpQIBJ2ZbCiAuuc45hkBQ/bsIPxP3PIRdlhI
         AOcBDVhSSbE5ZR1P4IMRvdFC6NnIeOBJgBwqkeL/Bt1rFeJfqU75bPu3GM/El4eSh2jj
         HvfEQPfNkudhiAL2tQuP8LiHSRq4hVa+Imvq7cuUvEGIJzy4rzrngmqJepBXSWMQ7dhr
         VtLMUPIIiiziBP32GeYoekBcVStYDDlziqIMcNytOPoLhLqvohoPkvgyY5cvJB+EhulS
         q7pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929725; x=1771534525;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dobwkICLXBBNJH1jlqQxJ3Quo0Y6oLzvMafZOOZ1zk=;
        b=vZGuzBos+oca44ULtIYj5gF4/vJBpsACXBygw79jhFLGP3WgjiYnl5QGG5Q6CRxl6Q
         +kjshSj0IIkSFwh8h0I6kQL/JfgjEvH6XCgzGm8Qmm8B5P1S+6YzTDOjdEvZ4r012gFW
         rxzL2/mCVdqU3prri9iJxWtK75HZA2hYSUuOnAaUgip5di6CT5Ln4s9VEhEAJTFqV67M
         1fLTV7Hmn/OGG/1zU5m90TxBsUd4FK1MdEkEWysTJd5py0MSz/e3drysOAGI+k/AIaDI
         t3fNtY3s8TR+WtoOyRzyA6B6OFAjDfmI338DWvWP0TYAik+84NcwsP0N/qrgTWWddTZD
         Gelw==
X-Gm-Message-State: AOJu0YweEdi1iQqG/GEy3UOzgwOLjPhUjUuGR1Qbr3n2wttugAU9aznt
	cam5iAu0Lx2JADI2iKGG2iKUCRb7fnKuHaEXMDNstjvv6Ndd+JtlKGWPeevKNUV6
X-Gm-Gg: AZuq6aL03vRzsG2CCkd/5Ibgqj5gdTTxzgk2ID8vLKR9QYHg56KkEff5UjoF40b/WPT
	wW8UjKxPxcN7Mg/YEWTibHCUhCgoLgQL4HdpTuYrZfEuntX2UdDwHvG+oeEeZ0O73pObF4GS/Va
	lQsSL5wekwHgrBay9TWPaA6+clMWZfLoQ5bmZZtkHSa7f7PlOoUAdwHS8GXMmESrI5l3y8pJ91d
	NzjDY7IqjWoQmydNl2v6gSaN6mn4ihOK4CFlA1dY3JSlreCazCPGEO0AI1WCa9M5nvckmmQd//Q
	ZV1qDcJTwp6ib1pXvq4p1KDzxq3ygUg8D7fmaFCAmMDCm5L9/NjHePzcoo3s84Xy6aN36VxMKN8
	7bf/hUqCTu4jeJ6KAdcRa+upDJ3x85C1ZNgysx6e6oV6nQb8sIdalZUDD28FjKCUMQm5JJqp6//
	1fdVrqHIOl8VprAqKhDrQLrn92RI4qBhaDCxDP9amg81eSt24sDO1gxk1ghaCJCdpWuxyRmMEVb
	gr83ZU+ylY=
X-Received: by 2002:a05:6214:2a4d:b0:88a:2500:7d45 with SMTP id 6a1803df08f44-897347c2e6bmr6322416d6.46.1770929725019;
        Thu, 12 Feb 2026 12:55:25 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:24 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/13] Update lpfc to revision 14.4.0.14
Date: Thu, 12 Feb 2026 13:29:55 -0800
Message-Id: <20260212213008.149873-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.14

This patch set contains updates to log messaging, trivial typecast and
pointer changes, bug fixes related to kref accounting and cleanup handling,
an update to a WQE submission bitfield, and restriction of first burst to
specific HBAs only.

The patches were cut against Martin's 6.20/scsi-queue tree.

Justin Tee (13):
  lpfc: Update log message when ndlp kref get is unsuccessful
  lpfc: Log discarded and insufficient RQE buffer events
  lpfc: Add log messages to fabric login error labels
  lpfc: Use min_t() instead of min() in lpfc_sli4_driver_resource_setup
  lpfc: Reduce pointer chasing when accessing vmid_flag
  lpfc: Remove unnecessary ndlp kref get in lpfc_check_nlp_post_devloss
  lpfc: Cleanup error exit paths in lpfc_fdmi_cmd and associated
    messages
  lpfc: Fix incorrect txcmplq_cnt during cleanup in lpfc_sli_abort_ring
  lpfc: Add clean up of aborted NVMe commands during PCI fcn reset
  lpfc: Update class of service bit field to 3 bits for WQE submissions
  lpfc: Restrict first burst to non-FCoE and SLI4 adapters only
  lpfc: Update copyright year string for 2026
  lpfc: Update lpfc version to 14.4.0.14

 drivers/scsi/lpfc/lpfc_crtn.h    |  3 +-
 drivers/scsi/lpfc/lpfc_ct.c      | 13 ++---
 drivers/scsi/lpfc/lpfc_disc.h    |  5 +-
 drivers/scsi/lpfc/lpfc_els.c     | 30 ++++++++----
 drivers/scsi/lpfc/lpfc_hbadisc.c | 29 ++++++-----
 drivers/scsi/lpfc/lpfc_init.c    |  6 +--
 drivers/scsi/lpfc/lpfc_nvme.c    | 50 ++++++++++++++++++-
 drivers/scsi/lpfc/lpfc_scsi.c    | 10 ++--
 drivers/scsi/lpfc/lpfc_sli.c     | 83 +++++++++++++++-----------------
 drivers/scsi/lpfc/lpfc_sli4.h    |  5 +-
 drivers/scsi/lpfc/lpfc_version.h |  6 +--
 11 files changed, 150 insertions(+), 90 deletions(-)

-- 
2.38.0

