Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A79D32ED3A;
	Wed,  8 Apr 2026 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775668069; cv=none; b=n0ER5eILMyO6WfxKbIt+GzdOwVyAv6OpNvVi66NlyyZOLr0UVt+OZP4WGxCMcax1DvV4U4SwNu3nyCxScNpu/Lfw/cQ1QdU+zPMjYIh1DN+GDkkU6BWWUHDwcEzkgzART3rectRJZv0+liM1h19Qjva7QJ8ICbuh48k/uI3H9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775668069; c=relaxed/simple;
	bh=/V2YOh5dun+k/7gXehbcIbYcHTsZqq3ru5OdAAq4JmM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=UmaxntJ5lYaK0wV00aTg6oNcvofMFKGIUYtjDbbtnRq+d6hQZDWUypM/GVx5cqas7yN2OUAQqZ6tayRDw6GExPyRvzo7xKDYgqgH3H84Y+snEZHvLFIl3rKjrnAlBLxT3PAqB+jDTwqZ/UllBUw6KMYmmcvLqriMd0ZEV8iHFHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ju7yLbI5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ju7yLbI5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2F438C19421;
	Wed,  8 Apr 2026 17:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775668069;
	bh=/V2YOh5dun+k/7gXehbcIbYcHTsZqq3ru5OdAAq4JmM=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=Ju7yLbI5yeQ/hhmR7cx/t5N99/R8XvSyfYmVQb4Pj1VDyXwi8l1IdDzyhVmW8Wf/g
	 fV0Pu1mhKtWWtnIdgi7iyKHdycmyHgd1+iIvPsfu8FMrYWs0oTZDV5FEzF4YBmPvRe
	 WGjy9RxiUYllEQzjWlhursZcyopsYJNqbfmzvrknhTw+MZh1zmMplw8fi2+9Lhmvgv
	 BB51I0E56b03esTviAiUwutNSxu63s23k3HTY/tw2CgTHnfKJ+txDlg1mrRJRVnVwj
	 0RELnJHM02PVuq157FSgDArjqZrekWSYHVscNppe14YiR7TWmMgxvZEbWkGPVdHJf1
	 Ks5GNa6Lk+rvQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C4FE10F995E;
	Wed,  8 Apr 2026 17:07:49 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH 0/5] ibmvfc: make ibmvfc support FPIN messages
Date: Wed, 08 Apr 2026 12:07:41 -0500
Message-Id: <20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMTQqDMBBA4avIrB2IQSv1KuIiP5N2Co0hoyKId
 ze1y2/x3gFCmUlgqA7ItLHwHAuaugL3NvFFyL4YtNIP1aoe2X634DAkjihrSnNe0D5t13fOa28
 aKGXKFHi/r+P0t6z2Q275reA8L2blqjx3AAAA
X-Change-ID: 20260407-ibmvfc-fpin-support-b9b575cd2da1
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775668068; l=2115;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=/V2YOh5dun+k/7gXehbcIbYcHTsZqq3ru5OdAAq4JmM=;
 b=Mr24O9zSJQyULVQH6pUlEtKtf3Ixdd5fISCF3k9bRs8Nd14sBiYHWx9RAd7MDndQVe75RHmY2
 O98bO8dMcP+DgCdPydXjIZMA/eTM13TMjvoBlFd7t4Hk/Vc0mtxQKa+
X-Developer-Key: i=davemarq@linux.ibm.com; a=ed25519;
 pk=vy0/nfobrje6EqZxuyw6a3ZstytG8WK2vf5Y3xtGrEg=
X-Endpoint-Received: by B4 Relay for davemarq@linux.ibm.com/20260216 with
 auth_id=689
X-Original-From: Dave Marquardt <davemarq@linux.ibm.com>
Reply-To: davemarq@linux.ibm.com

This patch series adds FPIN (fabric performance impact notification)
support to the ibmvfc (IBM Virtual Fibre Channel) driver. This comes
in three flavors:

- basic, to recognize existing FPIN messages from the virtual I/O
  server (VIOS) (patch 1)
- full, supporting additional information and using its own
  asynchronous sub-queue and interrupt (patches 2-4)
- extended, supporting FC-LS-5 (patch 5)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support

- a new VFC_NOOP command, which the driver recognizes and
  ignores (patch 2)
- fabric login, to login separately to the fabric through messages
  exchanged with VIOS rather than doing fabric login through the
  existing NPIV login (patch 3)

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, with basic and full FPIN support using
default values for information not provided by the VIOS FPIN message
but expected in the FC ELS message. This FC ELS message is passed to
fc_host_rcv_fpin for updating statistics and sending the information
upstream by netlink multicast, where it may be caught by listeners
including the DM multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
Dave Marquardt (5):
      ibmvfc: add basic FPIN support
      ibmvfc: Add NOOP command support
      ibmvfc: make ibmvfc login to fabric
      ibmvfc: use async sub-queue for FPIN messages
      ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc.c       | 668 +++++++++++++++++++++++++++++++++--
 drivers/scsi/ibmvscsi/ibmvfc.h       | 102 +++++-
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 219 ++++++++++++
 5 files changed, 961 insertions(+), 39 deletions(-)
---
base-commit: 927722dcfe0a5294433bb087387cc52a46cbf675
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


