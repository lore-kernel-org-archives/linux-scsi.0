Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5117517BB5;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792076822; cv=none; b=Mw+H4cFWzOjF2Ylx1JIZW1CJ3H1FxKgXKw1MM3471xsacdaGls1jQtsOxP/F3Godh9v/bfuQERfxIj1KdZBThxcVZd8Y0Ce6YSXGy+YVoHLxVjzyGbKgs1iiefk/O7t3WwCVtnSPWlBOi/9hRoe24letJYEzbZNNfuz12n5tuNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792076822; c=relaxed/simple;
	bh=KON4e9twMJ4qMcz8uQIBOYQJhVJF49lcPIScZi0vLCc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oEp7Ztcru1ozIqUJvTpZdi0/7T12PD/RJ/y/9Efrnz5k+lzXMo+hJwUI96Tx+IWqNe4TBLSH7zTKBp8+8OXHY4tnn9NbXdhAVef81ea7tzpEgJQJcteVbeTfikWwf0/Yt8Kt7Apom3HL21oc9zSmNqSrwkLfwLG+hARW3E8ix2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s+0dgZSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s+0dgZSe"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F81BC2BCC7;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792076822;
	bh=KON4e9twMJ4qMcz8uQIBOYQJhVJF49lcPIScZi0vLCc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=s+0dgZSefErcVRKBQKHJ5R4+Ekv+OsFrKlvVMVsqg7Tq4qR/HJ88nvh2Ow+oNWswz
	 czFLDBHdB6cYU+4WiJWPdkvM7GBQMUQ0wpJUjs9ptwPkUub5F2D66LtnsI9+2WaMIi
	 gNGSrwkrFj6/BgxU+a9oq3FWErZISR7MO4V40gPeZhhaRTOs46NUgBQsBEV8olRtnZ
	 n/bQ6WmgZMlDWsO56ieU5WuEUYRo1et6aBRGJmpczX4PoOsReP6ElpbKpPuuwElgfP
	 30y6G83P++oYuvZ99EGBU8ooFxgsm7f47oJTKLV62QANzBehqexWQarX/uYzVuZd1U
	 vHVVjIAnCxFtA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B7ACC6B3A;
	Thu, 15 Oct 2026 15:07:02 +0000 (UTC)
From: Dave Marquardt via B4 Relay <devnull+davemarq.linux.ibm.com@kernel.org>
Subject: [PATCH v14 00/11] scsi: ibmvfc: make ibmvfc support FPIN messages
Date: Thu, 15 Oct 2026 10:06:59 -0500
Message-Id: <20261015-ibmvfc-fpin-support-v14-0-a0b063b8d825@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABPs0GoC/3XOTWrDMBAF4KsErTtm9OM46ar3KF1I8qhWiS0jy
 SYh+O6RklJoaJczzPvmXVmi6Cmx192VRVp98mEqA1cvO2YHPX0S+L4smECxx6NowZtxdRbc7Cd
 IyzyHmIHIaNXjwSjRspKcIzl/vrPvH485LeaLbK5UvXAxjJCHSPqXjkodERvFlVQIHPIl0ql/O
 /lpOTflc2PDWOODTznEy732ykX9821I/LNhOQKEVmrpnOv6rjNPaK25cvkjccTuH0kWyRz4Xhu
 nlbP2Wdq27QYki40gWAEAAA==
X-Change-ID: 20260925-ibmvfc-fpin-support-eeba4d08b425
To: Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <mkp@kernel.org>, 
 Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-kernel@vger.kernel.org, Dave Marquardt <davemarq@linux.ibm.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792076820; l=12775;
 i=davemarq@linux.ibm.com; s=20260216; h=from:subject:message-id;
 bh=KON4e9twMJ4qMcz8uQIBOYQJhVJF49lcPIScZi0vLCc=;
 b=isViRm6b44OXqKu4c6GRZJn3CZfHGtumUQ/E2n+e4npxFkq/SGEY5S+9wgZhPaEdubicCccA8
 SpZDkGmtpMlApnd2WOgkd8Rm0VPGGo1I88F5Ub+r2sCrVKKpzlAPmZ3
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
  server (VIOS) (patch 4)
- full, supporting additional FPIN information and using its own
  asynchronous sub-queue and interrupt (patches 6-10)
- extended, supporting FC-LS-5 (patch 11)

Full and extended FPIN support requires a new asynchronous sub-queue
with its own interrupt. The asynchronous sub-queue support requires
ibmvfc to also support a new IBMVFC_NOOP command, which the driver
recognizes and ignores (patch 5).

The asynchronous sub-queue work is split across five patches: patch 6
defines the necessary data structures, patches 7 and 8 add the
interrupt and drain routines for the queue, patch 9 extends channel
registration and deregistration to accommodate the new queue, and
patches 1-3 fix IRQ cleanup and error handling bugs exposed during
that work. Patch 10 wires everything together, registering the async
sub-queue during channel initialization and advertising support to
VIOS during NPIV login.

All three modes convert an incoming FPIN message from VIOS to an FC
extended link service message, in some cases using default values for
information not provided by the VIOS FPIN message but expected in the
FC ELS message. This FC ELS message is passed to fc_host_fpin_rcv for
updating statistics and sending the information upstream by netlink
multicast, where it may be read by listeners including the DM
multipath daemon "multipathd."

Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
Signed-off-by: Dave Marquardt <davemarq@linux.ibm.com>

---
Changes in v14:
- Fix double-free of sub-CRQ at the hypervisor level: guard
  H_FREE_SUB_CRQ in ibmvfc_deregister_channel() on scrq->cookie != 0
  and clear cookie to zero on success; also clear cookie in the
  ibmvfc_register_channel() irq_failed: rollback path (patch 3)
- Add SCSI_IBMVFC_KUNIT_TEST Kconfig entry, Makefile line, and
  ibmvfc_kunit.c with ibmvfc_deregister_channel_guard_test() verifying
  the cookie and msgs.handle guard paths (patch 3)
- Fix wild pointer dereference in ibmvfc_handle_scrq(): change signature
  to accept struct ibmvfc_queue *scrq and use &scrq->evt_pool for event
  validation instead of &evt->queue->evt_pool (patch 5)
- Fix NULL pointer dereference in ibmvfc_channel_setup_done() when
  mq_enabled=0: compute async->active_queues from the VIOS response
  guarded by async->scrqs != NULL; guard async->scrqs[0].cookie access
  in ibmvfc_channel_setup() with a NULL check (patch 10)
- Fix host state machine stall on ibmvfc_reg_sub_crqs() failure: clear
  vhost->mq_enabled in addition to do_enquiry so ibmvfc_npiv_login_done()
  takes the non-channel fallback path and wakes the work queue (patch 10)
- Link to v13: https://patch.msgid.link/20261007-ibmvfc-fpin-support-v13-0-b816abfa4fcc@linux.ibm.com

Changes in v13:
- Updated to 7.4/scsi-staging base
- Extend ibmvfc_common_fpin_to_desc() with a severity parameter;
  ibmvfc_ext_fpin_to_desc() now honours IBMVFC_FPIN_SEVERITY_VALID
  and propagates the severity from the VIOS rather than always
  defaulting to FPIN_CONGN_SEVERITY_WARNING (patch 11)
- Handle scsi_host_get() failure in ibmvfc_get_first_vhost() (patch 4)
- Add kernel-doc comment to ibmvfc_get_first_vhost() (patch 4)
- Use list_for_each_entry to find an online FCP/NVMe target rport in
  KUnit tests rather than taking the first list entry unconditionally
  (patches 4, 7, 11)
- Link to v12: https://patch.msgid.link/20260930-ibmvfc-fpin-support-v12-0-53a3fff7d77b@linux.ibm.com

Changes in v12:
- Wrap ibmvfc_handle_async() invocations in KUnit tests with host_lock to
  prevent races with workqueue destruction on concurrent device removal
  (patches 4, 7, 11)
- Add missing scsi_host_put() in success exit path of ibmvfc_async_fpin_test()
  (patch 4)
- Pass resolved tgt->wwpn into ibmvfc_full_fpin_to_desc() instead of subq->wwpn
  so FPIN descriptors are correctly populated when subq->wwpn is 0 (patch 7)
- Fix kernel-doc comments in ibmvfc_register_channel() and
  ibmvfc_deregister_channel() that incorrectly directed passing a negative index
  (patch 9)
- Fix double registration of scsi_scrqs in ibmvfc_reenable_crq_queue() by
  registering async_scrqs instead (patch 10)
- Link to v11: https://lore.kernel.org/linux-scsi/20260925044900.414340-1-tyreld@linux.ibm.com/

Changes in v11:
- Split the IRQ cleanup and NULL-pointer fixes out of the "register and
  use" patch into two dedicated bug-fix patches (patches 1-2 and 1-3),
  making the series 11 patches instead of 9
- Replaced the single ibmvfc_queue async_sub_crq field in ibmvfc_host with
  an ibmvfc_channels async_scrqs field, reusing the existing channel
  infrastructure for allocation, registration, and teardown (patches 6, 9, 10)
- Added IBMVFC_PROTO_ASYNC to enum ibmvfc_protocol; ibmvfc_register_channel()
  and ibmvfc_deregister_channel() now dispatch on protocol rather than a
  negative-index sentinel (patch 9)
- Added IBMVFC_ASYNC_SUB_CRQ_FMT format enum value and corresponding
  async_scrq pointer in union ibmvfc_msgs (patch 6)
- ibmvfc_alloc_channels() selects IBMVFC_ASYNC_SUB_CRQ_FMT for async
  protocol channels so queues are sized for ibmvfc_async_sub_crq entries
  (patch 10)
- Link to v10: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v10:
- Fix ibmvfc_find_target() to use logical and (&&) instead of logical or (||)
  when checking whether fc and nvme remote ports are NULL (patch 4)
- Fix build issues due to missing & operator when referencing the host lock
  during irqsave/restore calls (patch 4, patch 7, patch 8, patch 11)
- Fix kunit build issues caused by inclusion of code meant for later patches
  (patch 4, patch 7, patch 11)
- Link to v9: https://lore.kernel.org/linux-scsi/20260911021910.1038128-1-tyreld@linux.ibm.com/

Changes in v9:
- Fix ibmvfc_find_target() to check for either a valid rport or nvme_remote_port
  so nvme targets are not silently dropped (patch 4)
- Restore xxx_host_remove() ordering and destroy async work queue prior to these
  calls. Check that the host is not offline prior to enqueuing new async work
  (patch 4)
- Link to v8: https://lore.kernel.org/linux-scsi/20260909-ibmvfc-fpin-support-v8-0-b27183b055af@linux.ibm.com

Changes in v8:
- Split patch 6 into two patches: extend channel registration/deregistration
  for async subq (patch 9), and clear sub-CRQ IRQ on registration failure
  and guard teardown (patch 1)
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
- Moved ibmvfc_find_target into patch 4
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
  scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
  scsi: ibmvfc: add basic FPIN support
  scsi: ibmvfc: add NOOP command support
  scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
  scsi: ibmvfc: extend async event handlers for async sub-CRQ events
  scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
  scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
  scsi: ibmvfc: register and use asynchronous sub CRQ for events
  scsi: ibmvfc: handle extended FPIN events

Tyrel Datwyler (2):
  scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
  scsi: ibmvfc: fix potential NULL pointer dereference on failed queue
    allocation

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 720 ++++++++++++++++++++++++---
 drivers/scsi/ibmvscsi/ibmvfc.h       |  66 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 409 +++++++++++++++
 5 files changed, 1141 insertions(+), 65 deletions(-)
 create mode 100644 drivers/scsi/ibmvscsi/ibmvfc_kunit.c

--
2.55.0

---
Dave Marquardt (9):
      scsi: ibmvfc: fix IRQ leak and guard deregister on channel reg failure
      scsi: ibmvfc: add basic FPIN support
      scsi: ibmvfc: add NOOP command support
      scsi: ibmvfc: add FPIN extended flag and async sub-CRQ queue handle
      scsi: ibmvfc: extend async event handlers for async sub-CRQ events
      scsi: ibmvfc: add interrupt routine for asynchronous sub CRQ
      scsi: ibmvfc: extend channel reg/dereg helpers for async sub-CRQ
      scsi: ibmvfc: register and use asynchronous sub CRQ for events
      scsi: ibmvfc: handle extended FPIN events

Tyrel Datwyler (2):
      scsi: ibmvfc: fix potential clobbering of rc after failed irq setup
      scsi: ibmvfc: fix potential NULL pointer dereference on failed queue allocation

 drivers/scsi/Kconfig                 |  10 +
 drivers/scsi/ibmvscsi/Makefile       |   1 +
 drivers/scsi/ibmvscsi/ibmvfc-core.c  | 781 +++++++++++++++++++++++++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.h       |  68 +++
 drivers/scsi/ibmvscsi/ibmvfc_kunit.c | 529 ++++++++++++++++++++++++
 5 files changed, 1314 insertions(+), 75 deletions(-)
---
base-commit: c3cff7fac01638ab58e85fe7df41a04fa25c5bae
change-id: 20260925-ibmvfc-fpin-support-eeba4d08b425

Best regards,
--  
Dave Marquardt <davemarq@linux.ibm.com>


