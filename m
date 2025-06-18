Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2053085C7
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 18:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272961; cv=none; b=aWVD2Y9W7A6cui6RjNTbh308GvaZHHCW3Dqr9xyOmVWWTwhymiJ7CN1zyNvWPbCVgjFxe9GxssB/gD97LL/1FahmOi55DeIWImj80fCzmtfPfNuZQLu339rEBPK0PsuywGHyDcWvoXVLiDGfXo8bn+gr9reiyNn13Oc7hzvs/iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272961; c=relaxed/simple;
	bh=J3gehI33qaeH/ngz3ftjY0KMchuSyCHIRSp14mEm+HA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=I2f+qQMLYanJnn0fdGNYttwFNAwfewlxCRf0UIwK4/+qZNAKo+rVG2EWBZfS6Y9Tg6IC/poqmA62t9NGwIyr/CVTzXnzHsrw6Fdj0MwOVMITz/BHKzrOCZnpM19EnkEu+9DFhYhDSv9NCrjrk7YL8XoVeCr6wdMa5Ic3aK6xA4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PsgIyLlt; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PsgIyLlt"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-748e378ba4fso1694861b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2025 11:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272959; x=1750877759; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ic1FRXZs6GYY0vusWvFMjhzg5LFgOveMG15WBBRHKyc=;
        b=PsgIyLltMMW6UTFXCOP8CrZOFl8AGMnggPG5XjNoaFkgBUeuVJo8uG65D2lPuwgyqp
         jQ+m0T086YUVALaXYTAxCFN5pyVfbBKui2fi4YGPG2sS+hlft0JIg03q+u2aT5HInuHs
         aspiG3hK9vqG5d8ifQfhgKF9Itv3vSYaoVtQ0y8Jfbz3p+XcwLRmlm6qak2mwqkmVPA7
         6+BJpTo7EA9/1YWX2sEGt1CgJkk/POkR9jM8wFiedbrI0jOUnHvq+vhsmwnhw/7Shaz0
         pMro/i0rySqlvPrPfriUVhqv5Woosta5D4C2v8jpJxvLjMTl6S5mnHjMNWJg6v+Idp2f
         GXfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272959; x=1750877759;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ic1FRXZs6GYY0vusWvFMjhzg5LFgOveMG15WBBRHKyc=;
        b=lgJFl/KCQssZac9xFhX2rNQ3EjxCBQ6TpGt5Tgf7G8Oq/rpb2HzlVVxVUNEAKaqM3K
         iD+70ie4HO8WfRpSDCdQB4rfYAcOUap8idsVjdBRu1gQKEX9Qt8hVRG/pH2oen85JGj0
         0WMe8FMLwN3QWcmY76YKYjfrRH3mUfuaHA24ONY4macWR79m2/HTkJYQVXqfEyyziG+V
         DkNXniZQ2EYgsKVrCS7CjZm4TdoFco6TGzt5f00eJB+7UUuE7PwjvYdN/okYIJFylZLS
         NlQFWzQijaGzd1W3A5vuynlSUH0/ZCDLo55QnNlEKiYdgyU5HngcNGg77sbOyIdoISU7
         GCTQ==
X-Gm-Message-State: AOJu0YwHOnEENxAjD/FgEKwBaeqEfpMQqAoKDHm0SHFcXuLBCv9VWIMQ
	ZyD6z9/BIcB2uGcUqrme6GT8yfilxyuKDRmjEPR0wwbNNZiRjenabKBLPUpsmw==
X-Gm-Gg: ASbGncsLbceHQX2PWMRUY6GSKocozyD84PUMOBkxnfTZu8FgHK3tx5ESXW4GOd2adEF
	enXcaqxtLegBH9RJFc1U8j5/DEd1Q/FJcvsW8mL8oO64ByyXspqiGgF5cp8AhkzEvbNIvd7IIso
	/yFSfktmg3kNf6kjYdSlP1Gk5HDAiyXpN5RJnmZimaptaj0IxNh3WVAFAeLGYTFzk3vfeQZ23JW
	844aAHBEqnSq2Jrup/JrZRkn1TZ9beUUOab++bp3Dev0+fwPwcLU1NPUXAxbHGXdE7Ajc1EnVTM
	X1a4uv3AKC5qig1wCcW+N6WcChUcpLVpFfMzdXHSxzrKcNLNL4FNtMS2FSlRQWt+RIgPL1yg13e
	JP0EwzRDPVbGPwsnsnXTRNPwCvA5Jgo5pafSLHW/9KA75aVc=
X-Google-Smtp-Source: AGHT+IEQZqxs0hsaZivI9TbWNgVCBHtjs/nGp+3VmF5xVdVWNl3mPwc1nL7hqC3lCFwNrelSDHZ2bw==
X-Received: by 2002:a05:6a00:4fce:b0:746:31d1:f7d0 with SMTP id d2e1a72fcca58-7489cf7263bmr22224290b3a.9.1750272959419;
        Wed, 18 Jun 2025 11:55:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900b75a8sm11798834b3a.133.2025.06.18.11.55.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Jun 2025 11:55:59 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/13] Update lpfc to revision 14.4.0.10
Date: Wed, 18 Jun 2025 12:21:25 -0700
Message-Id: <20250618192138.124116-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 14.4.0.10

This patch set contains bug fixes related to diagnostic log messaging,
driver initialization and removal, updates to mailbox command handling,
and string modifications for obsolete adapter model descriptions.

The patches were cut against Martin's 6.17/scsi-queue tree.

Justin Tee (13):
  lpfc: Revise logging format for failed CT MIB requests
  lpfc: Update debugfs trace ring initialization messages
  lpfc: Check for hdwq null ptr when cleaning up lpfc_vport structure
  lpfc: Skip RSCN processing when FC_UNLOADING flag is set
  lpfc: Early return out of FDMI cmpl for locally rejected statuses
  lpfc: Simplify error handling for failed lpfc_get_sli4_parameters cmd
  lpfc: Relocate clearing initial phba flags from link up to link down
    hdlr
  lpfc: Ensure HBA_SETUP flag is used only for SLI4 in
    dev_loss_tmo_callbk
  lpfc: Move clearing of HBA_SETUP flag to before lpfc_sli4_queue_unset
  lpfc: Revise CQ_CREATE_SET mailbox bitfield definitions
  lpfc: Modify end-of-life adapters' model descriptions
  lpfc: Update lpfc version to 14.4.0.10
  lpfc: Copyright updates for 14.4.0.10 patches

 drivers/scsi/lpfc/lpfc_ct.c      | 28 +++--------
 drivers/scsi/lpfc/lpfc_debugfs.c | 20 ++++----
 drivers/scsi/lpfc/lpfc_els.c     | 11 ++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c | 11 +++--
 drivers/scsi/lpfc/lpfc_hw4.h     | 20 +++++---
 drivers/scsi/lpfc/lpfc_init.c    | 84 ++++++++++++++++----------------
 drivers/scsi/lpfc/lpfc_scsi.c    |  9 +++-
 drivers/scsi/lpfc/lpfc_sli.c     | 14 +++---
 drivers/scsi/lpfc/lpfc_sli4.h    |  4 +-
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 10 files changed, 105 insertions(+), 98 deletions(-)

-- 
2.38.0

