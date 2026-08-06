Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E2837701A;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029461; cv=none; b=MqEgw0qNG6FcmLDFNoNCYRldIhXtvVPwn4wtg9dYBSCDgKfBzR9j8R8KFIdzIUE1jIW43XOLXXiTj5Rif6+JDFZnnxEenN6Y+ps7y+Y0FRi9Y7SdFl6jM0WffzAUn3Yjjw2GREcHyAs7vJLkKV6ekEw0xe6I/ulIYavZk3cICdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029461; c=relaxed/simple;
	bh=qfxRlQT8GJBzQHkXJKoOJDBTd5fFyJUzu/bGdv+TGrs=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=WOZhvCY8uQTy5Y3CQN5ULBSgfhXcTSJnfditr9i9g4qqe7PTQTEkWZ8Gorog4U1J3H/HaDCtxvOBsvzr1RT2fRPS5bU8OR80bu5XnaywhOQaXlgzDIkLJfurclg7tKVNPxx1MMxpvasBzxTBmZZ7eDJ8KjTk0sxSLkqenezlKtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZPXwJHW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZPXwJHW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E9B4C2BCB9;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786029460;
	bh=qfxRlQT8GJBzQHkXJKoOJDBTd5fFyJUzu/bGdv+TGrs=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=nZPXwJHWiROA/g3AXZ2Ja0kYsq+EqrdyMiM09vLK81jcDHW1U3oZxxK5GGfxr0RxM
	 Lyn9QOvKY5Q1VxAa9kzNh6i6cT74n50lZ3KnTWiuWXkQaQ679PlsaGSwAHWZaBQ5ak
	 g9CW/I6L+HqHstGWdPyRcIc7oKK/LpcT2nRXpCIqiw7BQn58jTTyJQPiiQAKqGWNL8
	 TRzMr6rSXoCMHmYTSGgP9KaNlslG94BqHsNUKNJX5u2FnkUc275bDXSn+UgZHRHt57
	 2k9gMu9oglXITnY/7mIAp7NhB8dV9LnXj/E+ymDobMjWLe273WjumQIbgyo4i91u4/
	 t+1se/FuU8SIw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61A78C56208;
	Thu,  6 Aug 2026 15:17:40 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v5 0/7] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 06 Aug 2026 10:17:30 -0500
Message-Id: <20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/3XNzW7DIBAE4FeJOJdowax/csp7RD0YDM1GjW2Bj
 VJFfvdCqipVRY4jzXxzZ8F6soEddnfmbaRA05gCvu2YOffjh+U0pMwkyBoUNJz0NTrD3UwjD+s
 8T37hutPYoBnk0AuWlrO3jm4P9fT+k8OqL9YsmcqNM4Vl8l+P2yhy7/ehLT5EwYGj1FAbVSsL1
 fGTxvW2T929ma4sv0T5dOpXjkzOoIRDBU73aEpO9XQakGWnyk6HukPVGNe2JUf9cQSUHZUc66A
 SvREdSvjvbNv2DSz4/D6kAQAA
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
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786029459; l=3702;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=qfxRlQT8GJBzQHkXJKoOJDBTd5fFyJUzu/bGdv+TGrs=;
 b=n6utSnKzlItJiA9VEUkzJVYCTEM2/0UbVVzK/8W8f0IpIMK0h9XMisHAiaNXax4sFRozbw3BL
 cgHh1TOXqySAgxd1WKG4p/ZwUqQb2MnUw3Klj7fIyop1zTVYkDc7wZx
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
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 3-6)
- extended, supporting FC-LS-5 (patch 7)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 2)

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
Changes in v5:
- Incorporate changes for NVME-over-FC.
- Removed now redundant fabric login patch.
- Link to v4: https://patch.msgid.link/20260710-ibmvfc-fpin-support-v4-0-ef031ac19520@linux.ibm.com

Changes in v4:
- Refactored channel registration
- Check whether async work queue is allocated before using or freeing
- Fixed work queue allocation/destruction
- Skip basic KUnit test when there are no ibmvfc devices available
- Fix target not found condition in ibmvfc_process_async_work
- Link to v3: https://patch.msgid.link/20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com

Changes in v3:
- Fixed latent bug, exposed by VFC_NOOP, related to dataless CRQs and events
- Fixed FPIN TLV descriptor length calculations
- Use safe list walker to walk targets in ibmvfc_process_async_work
- Added write memory barriers after clearing CRQ valid field
- Use per-vhost work queue for FPIN work
- Link to v2: https://patch.msgid.link/20260608-ibmvfc-fpin-support-v2-0-d41f540fba5c@linux.ibm.com

Highlights of changes in v2:
- Refactored mostly common FPIN conversion routines and async event
  processing into single routines with wrappers for differences.
- Moved FPIN processing to a work queue to avoid conflicts with
  fc_host_fpin_rcv and memory allocation
- Set descriptor sizes correctly
- Use target WWPN for basic FPIN descriptor
- Split patch 4 into 3 patches, for definition, allocation, and use of
  the asynchronous sub-queue for events
- Link to v1: https://patch.msgid.link/20260408-ibmvfc-fpin-support-v1-0-52b06c464e03@linux.ibm.com

---
Dave Marquardt (7):
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: Add NOOP command support
      scsi: ibmvfc: define asynchronous sub-queue
      scsi: ibmvfc: allocate asynchronous sub-queue
      scsi: ibmvfc: extend async event handlers to handle async sub queue events
      scsi: ibmvfc: register and use asynchronous sub-queue for events
      scsi: ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 643 ++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  70 ++++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 240 +++++++++++++
 5 files changed, 915 insertions(+), 49 deletions(-)
---
base-commit: 9c632ff7d7fcec167659cd7060e4491412c747da
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


