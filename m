Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793104128;
	b=t5HCQeXkGb2Z2N77aRaUi0aTXv1x1uwHrFt5eKDNgXYuwHlA0kS4jmkIaKmbdONp/pfN
	 AuffgVoLN0DKZy4Ppf/QQKNrOxttIocB50SpLD3Bn6TAkrO1Nvn40tpcoSVvpeRhSukQU
	 s47ra2QBD/e0NjysXG7+OlGUmBrcStn1JU4TtBZQrrLGzGxl1FGUU/WI0vTacNjCXF8rK
	 YAZ8qSDFjxc/2BNxRoy9eD/H9piL0vg+N9msYivvzC6CPaJjinpYvldUsmdYIxryPJBH3
	 Rrh5puqE75DzxfE928aAjm1M5dtzQPBMtLiU1bKqaIB0xFPjlGE0nFqc2FSM+JWqhmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793104128;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=PcQlm6rnKPPM1vE8CglOYEspv7Td6rAHC6OMdoMm9/g=;
	b=BZ/wntvVSE0LjunOHvT3WWeBHu8ioIEjucQuRl94YGNcAUSpIzw0k5dw5PSudbiptxqj
	 RL1Jn85zX/5T8O7BZKVrvo0WpmINRLf/qneSNKXnY/sOa8+VsvOcA4f5Et3YdIy3eNQIC
	 IlNMoPyOaqEBuXiCSQOrCJfU8Pp3P2elGO72VKhf8YFhNtQEQHO0lwtxRrvxx/9pfXAdN
	 ZWgrHcJQsl01LBuaNZjiWXWEbxmLr6gyNH7Id3u6WIuWWJH59b92WhXg0y5R3Fr7TG5D3
	 15qELqv+1jMm6kBLML+VmFi3g2FAp6/S+bkawTV6LCZlzrWY0Npc5vQZwhBNtowQ4IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I9V3U7F5;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F67606A320
	for <linux-scsi@vger.kernel.org>; Tue, 27 Oct 2026 12:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 59F67606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=I9V3U7F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793104127;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PcQlm6rnKPPM1vE8CglOYEspv7Td6rAHC6OMdoMm9/g=;
	b=I9V3U7F5ff72rIMcU4RbvsJFAFEdRKo6zs0q3FhHNXVGygIIxZToz553VTPVR/dY42E73X
	80PglLBHszhritWP7l7/rR3YNU3NV0uFyUPwFAx4QGwton7xzn/R5PjTU4SBtduSJkOUVg
	RPDhODaa+Fiq76NXgFsXEL2KpEG3wjY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-141-faybnkduPCCOQANGaS7VXQ-1; Tue,
 27 Oct 2026 08:28:43 -0400
X-MC-Unique: faybnkduPCCOQANGaS7VXQ-1
X-Mimecast-MFC-AGG-ID: faybnkduPCCOQANGaS7VXQ_1793104122
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6CBD6180132C;
	Tue, 27 Oct 2026 12:28:42 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2A6A4300019F;
	Tue, 27 Oct 2026 12:28:40 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 0/4] scsi: target: fix LUN_RESET hang on aborted iSCSI WRITEs
Date: Tue, 27 Oct 2026 08:28:33 -0400
Message-ID: <20261027122837.2148074-1-loberman@redhat.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

These four patches fix a LUN_RESET hang on iSCSI targets, and two
pre-existing bugs that fixing it exposes.

I had LLM help in generating and reviewing these and suggestions to 
change them, as well as multiple sashiko reviews.
While the initial 2 patches were fully tested at a customer to fix the
hangs, they needed changes posted now here to be accepted.

A WRITE command that is still in TRANSPORT_WRITE_PENDING has never been
passed to the backend, so when a TMR aborts it the fabric is the one that
has to complete it. Patch 4 completes it at the one site where nothing
does today. Patches 1 to 3 make that safe, and all three fix problems that are
reachable without patch 4.

 - Patch 1 stops compare_and_write_post() re-enabling interrupts in a
   caller that had them disabled. target_complete_cmd() may be called
   from interrupt context, and for an aborted command it reaches that
   callback, which used spin_lock_irq()/spin_unlock_irq().

 - Patch 2 stops COMPARE AND WRITE releasing dev->caw_sem when it never
   took it. The callback is installed in sbc_parse_cdb() and the semaphore
   is taken much later in sbc_compare_and_write(), so a command aborted in
   between releases a semaphore it does not hold, which lets two COMPARE
   AND WRITE commands run against a device at once.

 - Patch 3 makes target_abort_work be queued at most once per command, at
   both sites in target_core_transport.c that queue it. Without it a
   second call re-queues an se_cmd->work that is already queued.

 - Patch 4 is the hang this work started from. A WRITE that arrives with
   immediate data, aborted after that data has been received but before
   the first R2T is built, is never completed by anything: no R2T has been
   sent so the initiator cannot send more data, and no DataOut timer is
   armed so the ERL=0 timeout cannot fire either. core_tmr_lun_reset()
   then blocks for as long as the connection stays up.

Changes since v5, all from Bart Van Assche's review and the Sashiko
review of v5:
 - New patch 1 converts compare_and_write_post() to
   spin_lock_irqsave(). Pre-existing, but patch 2 modifies that function
   and leaving spin_lock_irq() a few lines above a new
   spin_lock_irqsave() would be confusing. compare_and_write_callback()
   has the same pattern on its success path, which is only reached from
   target_complete_ok_work() in process context, so it is left alone.
 - New patch 2 for caw_sem, as Bart proposed: track whether the semaphore
   is held rather than inferring it. This also covers the case the two
   options I had offered did not -- a release of a semaphore that was
   never taken -- and it makes the one side effect of running the
   completion callback twice idempotent, so no separate guard for the
   callback is needed. COMPARE AND WRITE's is the only
   transport_complete_callback in the tree.
 - Patch 3 now covers transport_generic_request_failure() as well. v5
   guarded only target_cmd_interrupted() and left the file's other
   target_abort_work queueing site untouched, so the claim did not
   actually hold. The Sashiko review of v5 caught it.
 - Patch 3 keeps a lockless test of CMD_T_ABORTED and CMD_T_STOP before
   taking t_state_lock, since it runs for every completion.
 - Patch 3 has Cc: stable, since patch 4 depends on it.
 - __target_claim_abort() and sbc_caw_sem_release() carry __must_hold()
   and __must_not_hold(). drivers/target is not opted in to context
   analysis (no CONTEXT_ANALYSIS := y in its Makefile), so these are
   documentation for now rather than checked; turning the opt-in on for
   the whole subsystem is not something this series should carry.
 - Patch 4 no longer calls iscsit_stop_dataout_timer(), which contradicted
   its own comment. The timer is armed only in
   iscsit_set_unsolicited_dataout() and iscsit_send_r2t(), and this branch
   is reached before either, so there was nothing to stop.
 - Patch 4 explains why the other two early returns for aborted commands
   in iscsit_execute_cmd() cannot hang: both TMR paths iterate
   dev->queues[].state_list, a command only reaches that list via
   transport_generic_new_cmd(), and for those two returns
   iscsit_execute_cmd() has run before it. Only the immediate-data path
   reaches the list first, which is why it is the one that strands a TMR.
 - Patch 3's subject is "Queue the abort of a command at most once" rather
   than "Complete ... at most once", which is what it guarantees.

v5: https://lore.kernel.org/linux-scsi/20261026192835.1431767-1-loberman@redhat.com/
v4: https://lore.kernel.org/linux-scsi/20261026150722.823941-1-loberman@redhat.com/
v3: https://lore.kernel.org/linux-scsi/20261026124344.745124-1-loberman@redhat.com/
v2: https://lore.kernel.org/linux-scsi/20261016175351.126373-1-loberman@redhat.com/
v1: https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat.com/

Patches 1 to 3 carry no Fixes: tag. For patches 1 and 2 the behaviour is
as old as COMPARE AND WRITE itself; for patch 3, the commit
that made ABORT and LUN RESET synchronous added the same abort-queueing
pattern to both functions, but the double queueing is not what it set out
to do. All are marked for stable regardless, since patch 4 depends on patch 3
and patch 3's reasoning depends on patch 2. Please say which
commits you would like named and I will add them.

How this was found:

The hang was reported against an Oracle RAC cluster on two-session iSCSI
LIO targets, where one node's LUN_RESET aborts WRITEs belonging to the
other node's session. It was not reproducible in a lab, so the diagnosis
came from instrumented kernels in the reporter's environment, logging
every site that completes or waits on an aborted command.

Across two hosts every stall had the identical signature given in patch 4,
and the stall only ever ended when the initiator gave up and dropped the
connection. 217 of 222 LUN_RESET drains completed in under a second; the
rest took 46 to 54 seconds, which is where the hung-task panics came from.
One 53.7 second stall recovered on its own and the host ran for a further
19 hours.

An earlier attempt at this fix completed the command from
core_tmr_drain_state_list() instead. That is not safe: at that point the
initiator may still be sending DataOut for the command, and the result was
a double completion -- re-queued se_cmd->work, list_del corruption and a
refcount underflow. That is the failure patch 3 now prevents outright.

What is and is not tested:

Patch 4's change has run 300 LUN_RESET cycles with no hang, in two
independent runs on a 5.14-based distro kernel, one instrumented and one
with the tracing removed. The same reproducer previously failed at 95 and
196 cycles. In those kernels the double queueing was prevented by an
iSCSI-private claim that earlier versions of this series carried, rather
than by patch 2, so the hang fix is validated but patches 1 and 2 are not.
Neither of their bugs was observed in the field; both were found by
inspection while reviewing this series. I would rather say that plainly
than imply coverage they do not have.

The reporter's environment is a production cluster and the only place this
has ever reproduced, so I cannot offer an upstream -rc run from there. A
build of this series is going to them and I will report the result.

Two things found while reviewing v6 locally are not addressed here.

Completing the command in iscsit_execute_cmd() means
iscsit_get_immediate_data() can read cmd->sense_reason and
cmd->unsolicited_data after target_abort_work has freed the command. The
caller defect is pre-existing: iscsit_handle_immediate_data() sets
ICF_GOT_LAST_DATAOUT when all of a WRITE's data arrives as immediate data,
and the branch directly above the one patch 4 changes then calls
target_execute_cmd(), which queues the same target_abort_work for an
aborted command and returns 0 to the same caller, which goes on to
dereference it. What patch 4 changes is which commands reach that: today
an all-immediate-data abort, after the patch also one whose length exceeds
FirstBurstLength.

Given how you wanted the caw_sem bug handled, I would rather ask than
guess: should the caller be fixed first in this series, or as a follow-up?
The two shapes I can see are holding a reference across
iscsit_sequence_cmd(), or giving iscsit_execute_cmd() a return value that
means "command consumed, do not touch it". The second changes the contract
for every caller of iscsit_sequence_cmd(), so it is not something I want
to decide on my own.

Second: a COMPARE AND WRITE that fails target_check_reservation() reaches
compare_and_write_callback() with success == false, its SG lists
allocated, and neither CMD_T_ABORTED nor CMD_T_STOP set, which fires the
WARN_ON() there. That is pre-existing and none of these patches change
whether it is reached. Working out whether the WARN_ON or the path is
wrong is a separate question and I did not want to guess at it here.

Laurence Oberman (4):
  scsi: target: Do not re-enable interrupts in compare_and_write_post()
  scsi: target: Only release caw_sem if this command took it
  scsi: target: Queue the abort of a command at most once
  scsi: target: iscsi: Complete an aborted WRITE stuck before the first
    R2T

 drivers/target/iscsi/iscsi_target_erl1.c | 12 +++-
 drivers/target/target_core_sbc.c         | 54 +++++++++++------
 drivers/target/target_core_transport.c   | 77 +++++++++++++++++++++---
 include/target/target_core_base.h        |  2 +
 4 files changed, 117 insertions(+), 28 deletions(-)

-- 
2.43.0

