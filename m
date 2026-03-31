Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9425A2D46CE
	for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 20:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774988582; cv=none; b=hAxX8CGBxTk8rGZZ7Yv5R21WUSr5Ps0dJurb+EJ4tU6E18cQ+rWM0AZQxVqRGyGS9m03HXdhudg9z31C2vISAXXiFRXotyAE9DJUU9kEUoBVj6F17WOezBrysO3y1uEvpf5OujNCi2sXCoAlnJQvbvuwoUgdVOFbY7KImIWdlno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774988582; c=relaxed/simple;
	bh=pEfQN+vyBMKQkdx3NF/f8oaXlAdJReOlm9urbN7rV7w=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GmJ9X836XaS4J5V9cA2UohMTJzaEiUkJuXeXjCfFfZDNaCH5UBVpWKQui9TrV6qot/RHeXi3mJjm1lMW6ALbeNI+EQ1SNRda49/gSDHGH4yrabgUmey9+51T4DzMoZmVeuUXkIy4ZXUsys/Ocf92JPDuJIYKwY+ACHxoe/cvxPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g/i1/lxI; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/i1/lxI"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50904a8f421so62367701cf.2
        for <linux-scsi@vger.kernel.org>; Tue, 31 Mar 2026 13:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774988580; x=1775593380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7KT9dTIqx0p2w7Aa0i3K/rvvJvq8SbqISxKtop6X9po=;
        b=g/i1/lxIqo+mbpbPtAYPJa73OW+KNdkYPi8AsxNKaEOrYY21lQ37DiyRdUEaOGytac
         boPfrPyiXaUIKlSp33i3iVDdg+0QBbAoQ40TPvryzaVESj7+93b/uPnT/nH1UkIpZkJO
         eG5lVpJBvEehh0+epotc6PHc2Wm1qeyuXFjoejo1ZB/VCWFyCrLwmY3ST51b0USO/GCO
         /tARvmRCpWQusDPg7zGkLmNaoEAbi8v88ckwYk+OeDh669Q3WxSsWR100s1bwXDtF8hB
         Y+U1sLE58dZKro+xkrP+eTy3XEHeLTmmYJtwNWYkjM6tsotuTAU2LyY91PXFNGkU3XCS
         MrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774988580; x=1775593380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7KT9dTIqx0p2w7Aa0i3K/rvvJvq8SbqISxKtop6X9po=;
        b=MRraFzJfd/tqn3sviszPzdSJzK6y470xaA5C5VWFmtNuHLzWhhPCsGYnWwR5CLwiKn
         hvfaD9qMy6DWh4ns2J1NkAuYH5iXWxbgh8+zspTax4GRxxVuF6zXOuTAPH7N3P+Gk6/S
         EWUhV6o7vZJCN2xqhLQxO3YChRYWy1US7xStiFQ7SrlYnrCd+TUdRrS1331sEo5v7NOR
         8j9n+NulaJpXg9+Yevvu85PBBZjaf4qpkj2bGW2f7pGF4mXVR2c1a1RXzrp8sJ1C5Nm6
         J+AOl5uxGdR5QevqKUCS2yd3sKoZ68mX8faRmV2qIxv4DAHRQ3KnTkBVLMNSKBoc49j4
         xqkw==
X-Gm-Message-State: AOJu0YzVbw92sttigF0+tS3LB9LA1cCHk50FllBu9sd0z6MduYlpUN5D
	8hmqkpHFRxOtZwuihHPl6zmIv6VBsjvI6HrFFLzNQ7ic805o4+3uesoQmtSDNA==
X-Gm-Gg: ATEYQzym7Zr75JCaNiPVajIpKCTdF+Kl2KikNWiQ9H1EUiLfj8odik/kSS/mw7GcNR4
	ys+jRtA/YcokHcUckcmPtsmIFDArs1YxX/fAco9Rn/wwkWhpCru+4mkdCFq3jAYxAouA9ThaMEF
	fwkbFSAjUepJYcNc6oZthyDb2VGUk8xMc2sRGuBd222oagDIcHVNa+MJ/+eTgQoF5fFpwNZlH0l
	1V+19m3sCjwBfPZYmzYkaHNjbsMYgxRt9b5iHp/4qC10Cs7XNsZ1gbAn+OFP/xQ3W1vjq5ZmDFX
	aCcYB1COFZHMPPf8orcBQgt2zJYh21DWWnI7qQ/JPYRFtXkgu2VBZa/WxVTkWwfGYLjhOTS994n
	rXiOSrbg3l0KQup/bwqYQwPOMzw3vPBywYit0W9arnZahUIeZXi9RVW+G34aAEUYLgyPL8lQa1g
	lNE1hWzbSvQSivipz+PSzFj/qGslgTzTUfJ91ttAtXkM1r1hXGD4wK3/+PPuoZSu1zuPx8isXAl
	Zer/OtAEp7lpw+xvxnfybXmb3s/IYvxLKtVAUR92gU=
X-Received: by 2002:a05:622a:209:b0:50b:460b:650e with SMTP id d75a77b69052e-50d3bcee065mr14121181cf.49.1774988580239;
        Tue, 31 Mar 2026 13:23:00 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89ecf865ccesm96685616d6.39.2026.03.31.13.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Mar 2026 13:23:00 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 00/10] Update lpfc to revision 15.0.0.0
Date: Tue, 31 Mar 2026 13:59:18 -0700
Message-Id: <20260331205928.119833-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Update lpfc to revision 15.0.0.0

This patch set adds support for the G8 ASIC found on the LPe42100 series
adapter models.

Updates are made to irq affinity assignment, mailbox command handling
related to initialization, SGL construction, firmware download
diagnostics, and the removal of an outdated performance feature.  We also
add 128G link speed selection and support.

The patches were cut against Martin's 7.1/scsi-queue tree.

Justin Tee (10):
  lpfc: Break out of IRQ affinity assignment when mask reaches
    nr_cpu_ids
  lpfc: Select mailbox rq_create cmd version based on sli4 if_type
  lpfc: Log mcqe contents for mbox commands with no context
  lpfc: Add REG_VFI mailbox cmd error handling
  lpfc: Remove deprecated PBDE feature
  lpfc: Update construction of SGL when XPSGL is enabled
  lpfc: Check ASIC_ID register to aid diagnostics during failed fw
    updates
  lpfc: Introduce 128G link speed selection and support
  lpfc: Add PCI ID support for LPe42100 series adapters
  lpfc: Update lpfc version to 15.0.0.0

 drivers/scsi/lpfc/lpfc.h           |   9 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  27 +++---
 drivers/scsi/lpfc/lpfc_els.c       |  18 +++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   |   4 +-
 drivers/scsi/lpfc/lpfc_hw.h        |   3 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  37 ++++----
 drivers/scsi/lpfc/lpfc_ids.h       |   4 +-
 drivers/scsi/lpfc/lpfc_init.c      |  53 ++++++++---
 drivers/scsi/lpfc/lpfc_mbox.c      |   7 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  38 ++++----
 drivers/scsi/lpfc/lpfc_nvme.c      |  56 ++++--------
 drivers/scsi/lpfc/lpfc_nvmet.c     |  37 ++------
 drivers/scsi/lpfc/lpfc_scsi.c      | 137 ++++++++++++++---------------
 drivers/scsi/lpfc/lpfc_sli.c       |  27 ++----
 drivers/scsi/lpfc/lpfc_sli4.h      |   1 +
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 16 files changed, 225 insertions(+), 235 deletions(-)

-- 
2.38.0

