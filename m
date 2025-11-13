Received: from mail-il1-f225.google.com (mail-il1-f225.google.com [209.85.166.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BC6D2F60CA
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048590; cv=none; b=mB1Z9Zsdo00kldcY3p/XsHmV+I9bCDXEEh9dzsAnGZE3Y9E+3GXoq5n7Ta8zPP1043OspBC4pM8usCG8wwgaixWVk/U7t3T1EVVbAi9gbM8f9WAWa8fI4dkRP7rPXkEEoqJthYYxCvnwC/Bvj/Yhx208XfoutsOtnFGzUMkOPPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048590; c=relaxed/simple;
	bh=t6BrZ2T0NZzoLa3K6lra9XMhp5JcWmAmoW6udElXqQo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=C7h/Xe8sh9Vzu4F8/c0ELVkNzXOGT1ftveMnu+WZdmehwjDI5tbHAiHGV//f4cZCIvBfMWZ/nY4WYjvyujuTcOmS2+8uGIavT1/Soy9mJPEg+fk3j+UxYFIovngpO7k8VDXcN4dOWcLdjNvMNnnVDvkecKV/ATp8dmcwUK+wiSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Y4evUJwW; arc=none smtp.client-ip=209.85.166.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Y4evUJwW"
Received: by mail-il1-f225.google.com with SMTP id e9e14a558f8ab-43377ee4825so5428005ab.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763048588; x=1763653388;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w3CWJatP1IbEURWFjuJMF/K/HFeh4GgCDEn+YLBRQvI=;
        b=WA5pG8jTgtNxn+u3VsumaHB4k0gwf0hFrFOwEDAplST0pDNo4URPb8umC1Od3VvWNO
         bYXyAhNEeJLbijbHGf8jvNQY0rLzlqW0GWOVcjXT0W72sN50+3JSx3IoxMUg/1tWhX5F
         iYxlgmpVkg7NGJkW7vmrvyhRvhzoSLt8BJT6zzdhlYj08a8nxI1b5EvddRZOHfBLRXy2
         DRm3Ah0N83smS2tthTH6L0cQjC6z2KdoR/O/GOeZ83emnwNJHUtpz3EsID/6Fl5NxzEa
         TGfAHhSSxPEg67nsEsTy9XyUIgA9T8inoTJuOKdDX5Jqf/3g0Sn/1HUExDTziHLPhzSq
         eWzw==
X-Gm-Message-State: AOJu0Yxln2tPzRKRC+Zz/XygXRM50Yj1gPBiUd0lVLql5QILBWcg0EoH
	JqYk5C5Mx8Hw6/3HzW0KzYN468omhgv6WTpmv8JVE+9pSXwboeqUR314y0UGghHOALpbFUvS+HE
	NIgb6kxo3c6zrkS6m7Yl2bSNjXGTOkvsQVWH5oSeRo6thabNejBm8gbKBgF7Dvf1Qs7C4ruizh3
	plj7Vdke7P8UVQjJqQByEc4fGe8ccaZDYIj1Zx8PEQN2PV+aT6zkYvcqDtw4GRl3fKyV6TfCRBW
	q1jgC/bwLfPgmBu
X-Gm-Gg: ASbGncv6UrOENo//n8aH6KYQU0/shpEln9CP3zjh0yWmCp3iRvUnHghRB869BfgbGM/
	PL7mTtvt3nXR7Ek+SwmdaQbkjw/H+et2uTT2MCCYTOFBhqEy3E+vjAGHKdlD66g/hrWUdwXv/tV
	938rbinOJqgOC1wtEYaQ2ol1hJdYrWae2xRJnuqiOndTSPFtdGgJoAJXd8HaUBVwGtPyJYZwXDW
	5ked/6eUyfVL3211mqqAONlfAYoQOvRFHNq35uqyEbnWFiGxA9Vr9luzMEwjbXMdUaVvm9NtnEO
	m+gPWPXbQpwkxv+eHpXKx04GDWlLa0Fj+M+VfhKcVA+5HaiQsyauWp4f8X96nwBXEloG9ESJavX
	4d+yryd24Z1ngmaSlOt4dViBg7yXWIKRNlCiFg1azeP1LTRuK1nAwPeqCmfDZzRdRoQPi9XQTNt
	de7bVRtcq2CyJf+sZRHelmrfZge5QlZSuqcnzY
X-Google-Smtp-Source: AGHT+IE/R8g0NQUt8jjgGD0KP9bZCUGFO6N8eINEoXQwPpnAw6BiMDhjqI1ralA1Y+AW2onrzjpjriYLMdcv
X-Received: by 2002:a05:6e02:194b:b0:433:2da7:8a44 with SMTP id e9e14a558f8ab-43473d75049mr78619015ab.20.1763048587589;
        Thu, 13 Nov 2025 07:43:07 -0800 (PST)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-101.dlp.protect.broadcom.com. [144.49.247.101])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-434833e96f6sm1804775ab.13.2025.11.13.07.43.07
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Nov 2025 07:43:07 -0800 (PST)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-297ddb3c707so9389445ad.2
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 07:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1763048586; x=1763653386; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w3CWJatP1IbEURWFjuJMF/K/HFeh4GgCDEn+YLBRQvI=;
        b=Y4evUJwWY2ayd3/68qk++POUPy/kLiLrViYlMtJlrlKBN3/fA86CLXJNoSkGTw03qs
         De4JRp9HtvaGzmq6sKs29OJiF81wFp6cgH3YdUCJWNjZkQZ3U7WfQvLqhsgVFtZviJXd
         Eqbm3UfWCJt+mkngcVyXIbI0fYiaoi2sFX2iQ=
X-Received: by 2002:a17:902:f684:b0:295:8da4:6404 with SMTP id d9443c01a7336-2984eddda7bmr92486755ad.40.1763048585634;
        Thu, 13 Nov 2025 07:43:05 -0800 (PST)
X-Received: by 2002:a17:902:f684:b0:295:8da4:6404 with SMTP id d9443c01a7336-2984eddda7bmr92486445ad.40.1763048585039;
        Thu, 13 Nov 2025 07:43:05 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2cca66sm29100085ad.99.2025.11.13.07.43.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 07:43:04 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v2 0/6] mpt3sas: Improve device readiness handling and event recovery
Date: Thu, 13 Nov 2025 21:07:04 +0530
Message-ID: <20251113153712.31850-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

This patch series enhances the mpt3sas driver’s device bring-up,
readiness detection, and event recovery mechanisms to improve
robustness in environments with slow-responding or transient
SAS/PCIe devices.

The series introduces optional control over issuing TEST UNIT READY
(TUR) commands during device unblocking, configurable retry limits,
and a mechanism to requeue firmware topology events when devices are
temporarily busy. Together, these updates reduce discovery failures
and improve recovery reliability following firmware or link events.

Change since v1:
- Fixed test robot build warnings
- Fixed W=1 compilation warnings

Ranjan Kumar (6):
  mpt3sas: Added no_turs flag to device unblock logic
  mpt3sas: Added issue_scsi_cmd_to_bringup_drive module parameter part-1
  mpt3sas: improve device discovery and readiness handling for slow
    devices part-2
  mpt3sas: Add firmware event requeue support for busy devices
  mpt3sas: Add configurable command retry limit for slow-to-respond
    devices
  mpt3sas: Fixed the W=1 compilation warning

 drivers/scsi/mpt3sas/mpt3sas_base.c  |   14 +-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |    4 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 1458 ++++++++++++++++++++++++--
 3 files changed, 1376 insertions(+), 100 deletions(-)

-- 
2.47.3

