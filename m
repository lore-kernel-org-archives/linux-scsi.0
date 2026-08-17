Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5633BE16A;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786998480; cv=none; b=V7hxUOxsXcGYItKj68JV3HBzTUaFm0PAC/4VQP27ntsmCLLUVfWvSgUzeU9la8OPYqfQDd6bYFILZkApcOcu8lrY8sxpPbZWnp76faACv1oj+YKb8xSyiovPQjbpldRc2BGQIAOBwXh7DDmpFXVXXZC8wv1v0u2/yx1OxBfltuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786998480; c=relaxed/simple;
	bh=NBFG5u7pJHuTnDg+QYaDFahe8sDuzyqLxxcC0knzU5I=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=G6R8kP7/OgL+1Ztu2JulAAIUT1OXS5pReMcn95efkc+r3cF3IiNtAvwmb9rNO6Bo+4LSyllK9bvIYJNk8EMbgPENoNdBRRwLAT42rPVq+T9N36UGrBUz12hn2F9nz2YC5iqKPJh6pGbrmGYy1Wm5Z5Vdr83EeHfUFHnf3wGm8Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g049eFZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g049eFZH"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66710C2BCB3;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786998480;
	bh=NBFG5u7pJHuTnDg+QYaDFahe8sDuzyqLxxcC0knzU5I=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=g049eFZHOxTbZupbH5W9F/jodql8q+wiGpVLep9jnexHE0dNDMsmPTM7SeTpHfbtf
	 4XIIG8qPF3f5zH3/PZhesxmsyJC8U93LJ6f2IfAt97/Vj+hMgmJpmkKY6HzERAti1R
	 Je6K36Ac96Y6YtLgB/nv7scRFlO8KLw07AHToRT+uiCuHFYTcKufZkaR8FZGE/vJrz
	 gKxcC9lrQX45W54KWJyenm8J8jhQD5J0tfPBSFzqUWE59wSoW0/PUCJKqvZLXV0aRl
	 dCA28Xb85r4pc3Z3HDU4GOssvOwoD/aTwGWbQvMNlwB53ZvebaAKaWoa6VzXFa5gnx
	 Ic8kglTUQXTaQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E75C5B572;
	Mon, 17 Aug 2026 20:28:00 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v6 0/8] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Mon, 17 Aug 2026 15:27:53 -0500
Message-Id: <20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMlug2oC/3XNS2rDMBgE4KsEravw62k5q96jZKFno9LYRrJFQ
 vDdK6cUl6IuB2a+eaDsU/QZnQ4PlHyJOY5DDfLlgOxFD+8eR1czokAlcOhwNNcSLA5THHBepml
 MMza9EZ2wjjpNUF1OyYd4e6pv5++cF/Ph7bxRW+MS8zym+/O2kK3386CaD4VgwIIakJZL7oG9f
 sZhuR1r92jHK9peCt0d+Z9Dq+M4CYJDMFrYlsN2pwPadtjm9ML0gnc2KNVy+C+HQNvh1fEBGNG
 W9IJCyxG7o0C2HVEdwoKTQWkVlPnrrOv6BV8pdaDsAQAA
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786998478; l=4486;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=NBFG5u7pJHuTnDg+QYaDFahe8sDuzyqLxxcC0knzU5I=;
 b=T4tXrwcYyh46C4r5VXhVqaycsMkEpj3TTCvrBaXQw8GvELGc84zzoocKoI16kwOA2wGE5R9dR
 vslUVkZDNqpAObYxY3fKgUbJYzKBb0Z9sq13KqrPHkkkLNQFmqvpggJ
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
  asynchronous sub-queue and interrupt (patches 3-7)
- extended, supporting FC-LS-5 (patch 8)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 2).

The asynchronous sub-queue work is split across three patches: patch 3
defines the necessary data structures, patch 5 adds the interrupt and
drain routines for the queue, and patch 6 refactors channel
registration and deregistration to accommodate the new queue. Patch 7
wires everything together, registering the async sub-queue during
channel initialization and advertising support to VIOS during NPIV
login.

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
Changes in v6:
- Use alloc_workqueue rather than devm_alloc_workqueue, and add
  explicit destroy_workqueue calls
- Moved ibmvfc_find_target into patch 1
- Link to v5: https://patch.msgid.link/20260806-ibmvfc-fpin-support-v5-0-13fd6f8a8f8b@linux.ibm.com

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
- Link to v3: https://patch.msgid.link/20260702-ibmvfc-fpin-support-v3-0-d95b9747cf88@linux.ibm.com

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
Dave Marquardt (8):
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: Add NOOP command support
      scsi: ibmvfc: define asynchronous sub-queue
      scsi: ibmvfc: extend async event handlers to handle async sub queue events
      scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
      scsi: ibmvfc: extend channel registration and deregistration for async subq
      scsi: ibmvfc: register and use asynchronous sub CRQ for events
      scsi: ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 644 ++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  52 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 352 +++++++++++++++++++
 5 files changed, 1011 insertions(+), 48 deletions(-)
---
base-commit: 9c632ff7d7fcec167659cd7060e4491412c747da
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


