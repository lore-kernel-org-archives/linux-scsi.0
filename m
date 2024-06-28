Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D4D1CD15
	for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 17:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594359; cv=none; b=hpTarv/GmEul+gWQB1YgFwk4wRcz0RFoxV4ItgWcNXa2NXKmG0/glRy1XDTnDtbzXxCnLFXo3Wpc7tlBgMEE5BcxBgBMiFcapRx9VA4b0pQrf8TZERZ5oTpSYBiR4gfjpsLEl88smBybKvD8IO/477SPHpWkBrU22w0FOgbex2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594359; c=relaxed/simple;
	bh=R2CFWGAGGZ/HX0tVx2GM3jFttu1wMuzoNRsMGl1+tKQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=LzGkOHfBVtRke6SGNdw6K1CCA17r0BXp2YXg7cF+IWSuyxuZFXtIz9r0O5UzgM0lp4HRgmB/O7WxH8xfUdB5i7QFqqcpXyw2xmj0UWw6k0169yzIrAAeUAmtyPcD7SzmLOudW01l9wNo6Iks2zqUxJWWskSybP3KTjnAWITishw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SEbnoxRH; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SEbnoxRH"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-375dea76edaso495865ab.2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Jun 2024 10:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719594357; x=1720199157; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gxzpXMyMRpTIQCCz6PEn52c9RQhAzTHN2jlYw0yTTHY=;
        b=SEbnoxRHHyTS8X01F5XGgQgekn4OBrApVNQBHl9SAYw0A/2YLXiomVhR5TJ5d5k+wX
         ymeQbpjXpNhDvALFgiHa8twGxjakISqJbVzEXzqXmnj51q8+CJ1gfA6qRWlNlx5MZmvT
         tnldfV7VVlwqApJhI1hnmsMw+parBKxsmycU2Cx6jQB3lZZGpLAh41xYWn7A1zzk6qzB
         xd7g+nOjRiODrj0Lq85JrijngCpDKJQw9uwWk3OpjdsfKpl33cuwXXuuMApaZm/gMWSR
         0xwyDZmVXiJN9ZtQY1CGZ7EOWdBtayqyKlfe3JlTGDtuSxMfuWlnoz3NSoTynB8iptny
         6HcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719594357; x=1720199157;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gxzpXMyMRpTIQCCz6PEn52c9RQhAzTHN2jlYw0yTTHY=;
        b=L44eZbKrAeGIh67njkWlbdAbI2QMekhfB4EUyXFkyvIdQ7LhLN3lvPUzuOu58NM48O
         56/L2WiM/XJXKNQ3c1pgCgzzspxkgATpB16VbIxZgmEgS6y9Uik1h5xBerjZYroP7cy8
         5Wd1SAlCCDs0UeJMbI6UYZi/vC8WtYa8rZ5u1pyqR+BXsuof04CquEizW6QqQvdgeh1k
         Li+3TevxRSrBIWd6xQEvLsmrZCp5flf5GMfqUouOaDUfrrc5/vBzPuBZhVjbOdJWzTzF
         zyfzsDzciTDM0O9kWGeK/akveS+jglojpAZmAWWOup3KuGPsWM3pev8WCAkwI+E5YW5m
         JMdg==
X-Gm-Message-State: AOJu0YwbyMmtkeRZvu+CzDXqwOuG+Akflxak09r9CdmxxtvAfWZj37nn
	+REsdxYQyCHzQin7uKYM0SLSzvV2udvjF8CPGWoah5sTMIgYaEl3gnhSbg==
X-Google-Smtp-Source: AGHT+IES8tTYvUTQnUPS+pF69GqOBDiLsjdWseDs/Nce/v7g3DdVmbbfhcFW50ZtM2Gwm/kNOngD7Q==
X-Received: by 2002:a92:c981:0:b0:375:bdfe:287a with SMTP id e9e14a558f8ab-3763807c15emr182792935ab.0.1719594356891;
        Fri, 28 Jun 2024 10:05:56 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-72c6afb8ef1sm1524623a12.40.2024.06.28.10.05.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2024 10:05:56 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 0/8] Update lpfc to revision 14.4.0.3
Date: Fri, 28 Jun 2024 10:20:03 -0700
Message-Id: <20240628172011.25921-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.3

This patch set contains bug fixes related to discovery, submission of
mailbox commands, and proper endianness conversions.

The patches were cut against Martin's 6.11/scsi-queue tree.

Justin Tee (8):
  lpfc: Cancel ELS WQE instead of issuing abort when SLI port is
    inactive
  lpfc: Allow DEVICE_RECOVERY mode after RSCN receipt if in PRLI_ISSUE
    state
  lpfc: Relax PRLI issue conditions after GID_FT response
  lpfc: Fix handling of fully recovered fabric node in dev_loss callbk
  lpfc: Handle mailbox timeouts in lpfc_get_sfp_info
  lpfc: Fix incorrect request len mbox field when setting trunking via
    sysfs
  lpfc: Revise lpfc_prep_embed_io routine with proper endian macro
    usages
  lpfc: Update lpfc version to 14.4.0.3

 drivers/scsi/lpfc/lpfc_attr.c    |  5 +++-
 drivers/scsi/lpfc/lpfc_ct.c      | 16 +++---------
 drivers/scsi/lpfc/lpfc_els.c     | 19 ++++++++------
 drivers/scsi/lpfc/lpfc_hbadisc.c | 10 +++++++-
 drivers/scsi/lpfc/lpfc_sli.c     | 43 ++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 6 files changed, 51 insertions(+), 44 deletions(-)

-- 
2.38.0

