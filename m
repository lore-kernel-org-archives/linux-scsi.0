Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1153204097;
	Mon, 16 Dec 2024 11:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734348558; cv=none; b=Cw7Z8B+T32pEucX1OWU7h002jibsFiHiw7xi89eLajr1q+vwvANy+qW4bArnMWTQnwsFNIoRbaqH6ysq6n642RWt0NRFTNGSpby/5kn2e1UWIbmmEWPbCzBgNj1dxSKnTzzGwq4f1B8Cv2cW/U6YwbvUZLx6kzyBqF1BliuVL0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734348558; c=relaxed/simple;
	bh=gtDmXeE2W0EUiQ4h0tC3GHJtLGn7JD/9aETwqdeMNXQ=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=bNlfjCIhjDzhemZIshZU5F+4xPICH8rlT5jrLH7jcg/JdfAJHDq6mQ1GOByYMMQei6NFEbZbHF0pRUPFf1GLNBFXFL9W7CjWRqViYjEF6vajt4ppaTxTS/XElIdQZRVlfdS8QP6IZgOY9BaKzYv0wSkWZjf8uLYrC9XKA8phOVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=g9IGOFRM; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="g9IGOFRM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1734348552;
	bh=gtDmXeE2W0EUiQ4h0tC3GHJtLGn7JD/9aETwqdeMNXQ=;
	h=From:Subject:Date:To:Cc:From;
	b=g9IGOFRMVXLay8/Tak0jU63vFmPGwWtuBziJZBqBkK0uwb3ywiM1zVd9voFYl9FM4
	 N+8yP0zX3dXu/v1K/NRIwSGE7p/Xcuo4l0o8EoBEhwHXhekOZOu5/YHFJudj/i6YYD
	 QXJ3y9RC/MVcMcm2ZEjMlxnwqEWgYDrmBtXspfRw=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 00/11] scsi: Constify 'struct bin_attribute'
Date: Mon, 16 Dec 2024 12:29:07 +0100
Message-Id: <20241216-sysfs-const-bin_attr-scsi-v1-0-f0a5e54b3437@weissschuh.net>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAMPYGcC/x3MQQqDMBBG4avIrDtgokXaq5QiJp3R2cSSP0hFv
 Luhy2/x3kGQbAJ6Ngdl2Qy2pgp3ayguU5qF7VNNvvW98+7O2KHguCYUDpbGqZTMiDAO2ncSvA7
 6EKr9N4va7/9+vc/zAg0NRjxrAAAA
X-Change-ID: 20241215-sysfs-const-bin_attr-scsi-bf43eb2f7f9e
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>, 
 Adam Radford <aradford@gmail.com>, 
 Bradley Grove <linuxdrivers@attotech.com>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Naveen N Rao <naveen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 James Smart <james.smart@broadcom.com>, 
 Dick Kennedy <dick.kennedy@broadcom.com>, Brian King <brking@us.ibm.com>, 
 Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
 GR-QLogic-Storage-Upstream@marvell.com, Nilesh Javali <njavali@marvell.com>, 
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1734348551; l=1753;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=gtDmXeE2W0EUiQ4h0tC3GHJtLGn7JD/9aETwqdeMNXQ=;
 b=ywvoFzn+Ww14FCugG9gA5NVdk3LfOJew6DUaHBTWbNMVm7gd/vkQEQAEq9Pq2Ku75KqfixXwI
 UKTwUxs2UglA4bsNZEih9ZLwE55zuxPqeIb90sn5Grbcm8kAHLHyXt3
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=

The sysfs core now allows instances of 'struct bin_attribute' to be
moved into read-only memory. Make use of that to protect them against
accidental or malicious modifications.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Thomas Weißschuh (11):
      scsi: core: Constify 'struct bin_attribute'
      scsi: 3w-sas: Constify 'struct bin_attribute'
      scsi: arcmsr: Constify 'struct bin_attribute'
      scsi: esas2r: Constify 'struct bin_attribute'
      scsi: ibmvfc: Constify 'struct bin_attribute'
      scsi: lpfc: Constify 'struct bin_attribute'
      scsi: ipr: Constify 'struct bin_attribute'
      scsi: qedf: Constify 'struct bin_attribute'
      scsi: qedi: Constify 'struct bin_attribute'
      scsi: qla2xxx: Constify 'struct bin_attribute'
      scsi: qla4xxx: Constify 'struct bin_attribute'

 drivers/scsi/3w-sas.c             | 12 +++---
 drivers/scsi/arcmsr/arcmsr_attr.c | 12 +++---
 drivers/scsi/esas2r/esas2r.h      | 12 +++---
 drivers/scsi/esas2r/esas2r_main.c | 32 ++++++++--------
 drivers/scsi/ibmvscsi/ibmvfc.c    |  6 +--
 drivers/scsi/ipr.c                | 26 ++++++-------
 drivers/scsi/lpfc/lpfc_attr.c     | 20 +++++-----
 drivers/scsi/qedf/qedf_attr.c     | 10 ++---
 drivers/scsi/qedf/qedf_dbg.h      |  2 +-
 drivers/scsi/qedi/qedi_dbg.h      |  2 +-
 drivers/scsi/qla2xxx/qla_attr.c   | 80 +++++++++++++++++++--------------------
 drivers/scsi/qla4xxx/ql4_attr.c   | 12 +++---
 drivers/scsi/scsi_sysfs.c         | 16 ++++----
 13 files changed, 121 insertions(+), 121 deletions(-)
---
base-commit: 2d8308bf5b67dff50262d8a9260a50113b3628c6
change-id: 20241215-sysfs-const-bin_attr-scsi-bf43eb2f7f9e

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>

