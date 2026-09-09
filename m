Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5869F3446C0;
	Wed,  9 Sep 2026 19:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980880; cv=none; b=ncc/luUX8c8Yty4K8exTrmLTX+nVZYvLj3xDQVHw8g7453sGN59fKQY8pov3l3+0UicpltACZ8NnhR8+YvW9yTVLn4ZpIOWzJ+IYp78dj1VZ+56KDp0ntC2TEaykkoK3oTpb8jjEuUvc1vZJvJhq10zSbhIuBCEXSxxefgzKboI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980880; c=relaxed/simple;
	bh=ODVDkRikTRl7YV9kYyCFbawq4cb+ZDsV64YiMkH9bVg=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ThWVDGdkBB2FU+pLo2cD/x6tM9JBI1vhu8Py99D+mMcn8f+3hs3MIrMF70ZRZHh6nG/pJSez3MA6hjGRAhYWSgwhahHeNcJ3YHGWi/2WizTUo05zmEDHPXxQ073aKPeSSBirzceiJiuFEDIjLtrdkuKyKJ13XWzMd27OVGIrPyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CnCSXF4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CnCSXF4x"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCA3EC2BCF4;
	Wed,  9 Sep 2026 19:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788980879;
	bh=ODVDkRikTRl7YV9kYyCFbawq4cb+ZDsV64YiMkH9bVg=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=CnCSXF4xTaOwvkn5HA7ZmOLn4HGpjjgBJLJ+LwJSz1pcn4DX3xG03pCiK/bEz+EI3
	 MBL7rrFwxM+0lHcGtiqV3TNH/5GiIj8ZKzw1D2AIiDoPzEK10Ackeo0L9xDjt/ttnE
	 707nTMT3vLyZVgNwRedoq+sOF9aJWz9oWKI92Ja19a1ZBewlUr3KuvHZIac/kVlHZw
	 RTF+l+ac7oHgiD8AKTUKNVICp/QYzZPnC2gkxTVJHug4JyDtCmkznZ3JqqC/78y5nD
	 FLiLINOi+H1ojIhys9FL3gCf4RfDFy7HgRaIiZa8OsPfJyb9uCYNeehYuXV+AyOWGI
	 OgXw0D8Ft4Lfw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F0BC79FB9;
	Wed,  9 Sep 2026 19:07:59 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v8 0/9] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Wed, 09 Sep 2026 14:07:55 -0500
Message-Id: <20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAIuuoWoC/3XRy0rEMBgF4FcZsjbDn3vqyvcQF7k6EactTRtGh
 r676Yi0SFweOPnOD7mjHKYUMno+3dEUSspp6GvQTyfkLqZ/Dzj5mhEFKoGDwsleS3Q4jqnHeRn
 HYZqx7axQwnnqDUH15TiFmG4P9fXtJ+fFfgQ3b9TWuKQ8D9PXY7aQrfe7oJsLhWDAglqQjkseg
 L18pn65nWv37IYr2lYK3R35n0Or4zmJgkO0RriWw3ZHAW07bHM6YTvBlYtatxx+cAi0HV6dEIE
 R40gnKLQcsTsaZNsR1SEsehm10VHbliMPDmn/ZJHVkdRQL6gICnzLUQeHkbajqqOUB9tp6OrZf
 511Xb8BBC8WsHwCAAA=
X-Change-ID: 20260407-ibmvfc-fpin-support-b9b575cd2da1
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, Brian King <brking@linux.ibm.com>, 
 Greg Joyce <gjoyce@linux.ibm.com>, Kyle Mahlkuch <kmahlkuc@linux.ibm.com>, 
 Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788980878; l=6581;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=ODVDkRikTRl7YV9kYyCFbawq4cb+ZDsV64YiMkH9bVg=;
 b=+8rr6zZCbI8uQsKIxeAsIBJbV9G2NVuO9mShB4P3fazaEwHMBGJ+Mc5fn6wodx5OlErIpXnWA
 /aowKahPy9DCvtxroH1dQqHD7TPio1+zpyPs2TOLRIUf4BKNx2oVhMC
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
  asynchronous sub-queue and interrupt (patches 3-8)
- extended, supporting FC-LS-5 (patch 9)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 2).

The asynchronous sub-queue work is split across four patches: patch 3
defines the necessary data structures, patch 5 adds the interrupt and
drain routines for the queue, patch 6 extends channel registration and
deregistration to accommodate the new queue, and patch 7 fixes IRQ
cleanup on registration failure. Patch 8 wires everything together,
registering the async sub-queue during channel initialization and
advertising support to VIOS during NPIV login.

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_rcv_fpin for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>
---
Changes in v8:
- Split patch 6 into two patches: extend channel registration/deregistration
  for async subq (patch 6), and clear sub-CRQ IRQ on registration failure
  and guard teardown (patch 7)
- Fixed NULL dereference in ibmvfc_deregister_channel() when called on
  an unallocated queue: guard memset() behind scrq->msgs.handle check
- Fixed variable-shadowing bug in ibmvfc_register_channel() error path
  where H_FREE_SUB_CRQ hcall result clobbered the return code
- Deregister and re-register async sub-CRQ in ibmvfc_reenable_crq_queue()
  and ibmvfc_reset_crq() alongside SCSI channel queues
- Link to v7: https://patch.msgid.link/20260831-ibmvfc-fpin-support-v7-0-77d0b9809080@linux.ibm.com

Changes in v7:
- Removed CRQ valid bit clearing to callers of ibmvfc_handle_async in
  all cases
- Added validity checks that IBMVFC_ASYNC_ID_IS_ASSOC_ID is clear
  before using node_name
- Fixed error path cleanup in ibmvfc_init_sub_crqs
- Deregister and reregister async sub-CRQ in CRQ reset and reenable
  code.
- Moved work queue destruction after sub CRQs teardown in ibmvfc_remove
- Modified async event handling code to use a tagged union rather than
  void *.
- Use WQ_UNBOUND rather than WQ_PERCPU for fpin workqueue, as FPIN
  events should be rare. Hold q_lock only in
  ibmvfc_drain_async_subq(), like ibmvfc_drain_sub_crq().
- Hardened KUnit tests to use host_lock and kref.
- Link to v6: https://patch.msgid.link/20260817-ibmvfc-fpin-support-v6-0-62a2d525e70d@linux.ibm.com

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

To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <mkp@kernel.org>
To: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>
To: Nicholas Piggin <npiggin@gmail.com>
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
To: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
Cc: linuxppc-dev@lists.ozlabs.org

---
Dave Marquardt (9):
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: add NOOP command support
      scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
      scsi: ibmvfc: extend async event handlers for async sub-CRQ events
      scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
      scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
      scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
      scsi: ibmvfc: register and use asynchronous sub CRQ for events
      scsi: ibmvfc: handle extended FPIN events

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 726 ++++++++++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  63 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 408 ++++++++++++++++++++
 5 files changed, 1144 insertions(+), 64 deletions(-)
---
base-commit: 12e67eb89eb2b9516685c744d3f7de0a2d1bd701
change-id: 20260407-ibmvfc-fpin-support-b9b575cd2da1

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


