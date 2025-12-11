Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BDE29405
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 23:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765410295; cv=none; b=IDJaXEBRns9s+fhBJoIIjQVO+tUIhlDYvPxl1rCxxho7y3GujoF01j5oFLPXT13S8Md7pb2Sx7vlmUoKPIfROL3CDSYSmuFDNIB3FWh7sNm/o8P2wsORiBCN9JDVpY0ZUVslUJblqIcQLp0o5rVinO//GOAzlWHF4EHZmzdr/Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765410295; c=relaxed/simple;
	bh=MonqC4Ketg5PztW7qLijc8w1NAN8BhjCJou7VAU3tEM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=g/O4TF2GBpr82Tk5zo/oLhsVLMWcn/g5BVUisM/2UNAtp1FFBnXeWoCyr5r/9YYFSjdHTARbYerQrfS3or7+KgZfr7fS4/SJKAYPvG6sXLhpop0mtCvxan0SEAIRCUQYDJNxDY6aEb0iqiHpKFUwwDNHWGU+8sROFFnhyy5Xw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BQbNevIl; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BQbNevIl"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8804f1bd6a7so3632726d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 15:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765410292; x=1766015092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m669SiV3q6jDGRM50pmUv0i5ywu+L0ZoAGIq696AC5g=;
        b=BQbNevIl/v0C320+Huq9IM/MKzj+LObhXCPmOe3dzBb5grhHzhDT/tNKzkuxkBO3t2
         CZy17U/lh/1xAEXLMVjpze2c0PBjSWBJb56Y7/HxTAig1mt0eSE7Scr2XjErnvsNv/Iz
         IJr10mnCD/IBcWlhFwQ54lGrFR9RJCHKM1fYf8NnOdqvt9uGWRDKrV6itsSq2ms/fVZA
         kL88G8Q1y1f1UZkz2LCBQVlj+5RRw4q9ZcpGJRgTsyVT4XHVXSYpiVgn9GR6BJWpCuud
         /l5szCM+RM9SiWzurmV7gD5DKWDPhJ7kijL6bH7508xyYHn2Qev6L8jGaP5PVQ9dcYl8
         2tFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765410292; x=1766015092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m669SiV3q6jDGRM50pmUv0i5ywu+L0ZoAGIq696AC5g=;
        b=F1cA8PuyX/h71OMbgEEeqy0LAwOmSt5EWPD8U/1VQDrDDKEuCmCDvl3QA9ubl991tt
         fC+G2VX0fPuxbRmfurrcIMJKxrI5Q8X3B7RAvT8fhbceGSie8Q0xns9mmMiZsm0WIg7V
         itXoJ6y6YtIJmA5GhMjGLF9/gqTFo6lRRGOQMUbyitqhj9zg+m7VQJ52w0nOwa08FgKR
         YLc+lCkHUv4Tfr0D9BzcpqVQx/MK77i27LKU2nFgi/jd/3jT4/F4WH7QgiWX/77JnRHk
         d1FtPuKYIY8DhZ4c5DDT72kHuvXpStf43iBOMejzDmPGCq6KNxy4yIDIqG5srHxq8vnM
         d41g==
X-Gm-Message-State: AOJu0Yz59uYL/ZHTRK4L7Ecz71S1aiMmM9X8qXQ/Df14evfdmMbOYSib
	S2E/dP+eRWFD7it8FaA6qC+qI1HxeHUTAT+zmVRLswrJnNp3aaZO+z1inDCTY+4Q
X-Gm-Gg: ASbGncsIMrgjEVtsO09+MBI3vvVIJyeTeFyeAe+B3vP0KeDfdCTOodol+ZxlAKUICj9
	BsJuH4+qIDKEnym6LO5s12i/VL8h4db826bD9mwS4MRReUQHIURc/oSSQszGZXNzN8CLjPvueyI
	eGB3jdJj86wNZJ19GyW0K3+pKv35gsrHUobgZCVl+ybTd6JViZ4I+RzZVS9+J056a94fLJC2W5H
	PfZZDQHhfVnTTROs/p51Zh6DHs793NbxX+9MpCXnhS1skdlKzvD/GaPzwuFLkQOBMjlhUIyTDqh
	kSGPK6P5M4M8XfBXIrPUaTQO5uqMjRqHVQMsVg0+kMVXByJo6XsO6RX25a6o7r+QG+HRugOuMX2
	YQABNzFvkyGsgNWnUAXXwLpbHpxJeLyxvo5yiaDuau8DFcyNVgyLZG7enI8qL26MGuQiyfzS4rj
	Qh4OtH+WS5jzoLtLv+PAozcrkQj6rACsbx1YKAcoGCjNfn+H5u2tm1D0oWqSQPSXJLrI+7shk=
X-Google-Smtp-Source: AGHT+IExDR7035JRyAX37lj6G3O8ph3XCvQde/djvRWQoeJJJiCykwb4wccIagkXjsHaoMnD/uJCtQ==
X-Received: by 2002:ac8:6903:0:b0:4ee:2721:9ebe with SMTP id d75a77b69052e-4f1b1a99b38mr63522801cf.53.1765410292120;
        Wed, 10 Dec 2025 15:44:52 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4f1bd6b502asm5869051cf.16.2025.12.10.15.44.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Dec 2025 15:44:51 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com
Subject: [PATCH 0/3] Update lpfc to revision 14.4.0.13
Date: Wed, 10 Dec 2025 16:16:56 -0800
Message-Id: <20251211001659.138635-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

Update lpfc to revision 14.4.0.13

This patch set introduces reporting encryption information for fibre
channel HBAs.

First, the scsi_transport_fc layer is updated to include a new
fc_encryption_info attribute that is added to struct fc_rport.  Supporting
sysfs and LLDD templates are provided.

Then, the lpfc driver is updated to utilize the new templates for reporting
encrypted fibre channel connections to upper layer.

The patches were cut against Martin's 6.19/scsi-queue tree.

Justin Tee (1):
  lpfc: Update lpfc version to 14.4.0.13

Sarah Catania (2):
  scsi_transport_fc: Introduce encryption group in fc_rport attribute
  lpfc: Add support for reporting encryption events

 drivers/base/transport_class.c   |  8 +++++
 drivers/scsi/lpfc/lpfc_attr.c    | 40 ++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_debugfs.c |  7 ++++
 drivers/scsi/lpfc/lpfc_disc.h    |  7 ++++
 drivers/scsi/lpfc/lpfc_els.c     | 57 ++++++++++++++++++++++++++++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_hw4.h     | 11 +++++-
 drivers/scsi/lpfc/lpfc_init.c    |  5 +++
 drivers/scsi/lpfc/lpfc_logmsg.h  |  3 +-
 drivers/scsi/lpfc/lpfc_sli4.h    |  4 +++
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 drivers/scsi/scsi_transport_fc.c | 42 +++++++++++++++++++++++
 include/linux/transport_class.h  |  1 +
 include/scsi/scsi_transport_fc.h | 12 +++++++
 14 files changed, 197 insertions(+), 3 deletions(-)

-- 
2.38.0

