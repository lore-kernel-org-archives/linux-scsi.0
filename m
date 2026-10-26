Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793027244;
	b=ZuUseOP6Hm0QdYhyS5kb2v+eTQZxvhezThYhpvf36yIadkoglZZYn+7nblpxSF5L7kJF
	 eriJrg45iea7qFs2hs6vCgOTHP0LN8+oVg2Gdrk+paFxHRe3Ab7AMO+l+8w6iv9UVchrY
	 zkC2OEAEnCgMzAb5p5AMJPSA4bAMxt0LeSnU7z+Ey8ZoWZetS8ppH5gxk/+szkAfLIh2l
	 Ufsu+f6RuXN7SzX+dawSLQeDb+zDjrEXSXUqxoYrDe0v4hgNRFkr4alGKCXkEc2XoCALz
	 E61YbrzrkS0vaLwjYhZYdBzEfpwzh0nERtyIt8IVRyD6+sJVEcEQdcmlu59Hmzq5H4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793027244;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=ErBXZ3qkp9rEhypSgiIPkrPyS3IBvbxgicF7GVZZyVE=;
	b=zc9lWkxX0ILTIOfV/ih2lAKYQ6Haj5agshvpwRJ3rVxesjfXm5XWXIv8i1NkOAuepdX7
	 EDfwmNQQ2tuX1UhOHxmsmzHCrFMvKvcoCM+B2UC/utIixpxn2WOetg4lAK1csvivcu32E
	 WxjoTc/nMUyRqRMKMJs6ovL1tvNquLiIdNssUYUlx+mKOTEwlNBSsx2J9A9mWSNQcq4Lt
	 I3o9FmgPYJr85ZLm65qBFZMvIhIGToaRo49N4j617b2/+RuAoWhb5QISQGbKZAu9OSBot
	 4jsMgksNXRH5F2HzmdDtVqsBEtN2MoJxkBjnsQSKZHKbgMYeu2NCBoyHU51AFZKz7dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LaR3N+ma;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D8606A32D
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 15:07:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 021D8606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LaR3N+ma
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793027242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ErBXZ3qkp9rEhypSgiIPkrPyS3IBvbxgicF7GVZZyVE=;
	b=LaR3N+majJ6gG8kAXy3PTMZ0Td09Y4her8zqiP73zPD2cQiD1MWEISGonsQlKeszy7x1V1
	ZeSr4PW7txLDfgFzHJS8kC8byyjw6DL7+akn/S5xTcEkofzTr5tT8IenDqHXmIE8ojeZY5
	62BTH2hZgKq06IzObbE2wjaqigo8s+w=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-125-MLbv_7tYPS-1zBVVyJ9h5Q-1; Mon,
 26 Oct 2026 11:07:16 -0400
X-MC-Unique: MLbv_7tYPS-1zBVVyJ9h5Q-1
X-Mimecast-MFC-AGG-ID: MLbv_7tYPS-1zBVVyJ9h5Q_1793027235
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 63A7818007FD;
	Mon, 26 Oct 2026 15:07:15 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 31DD530000E3;
	Mon, 26 Oct 2026 15:07:14 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/3] scsi: target: iscsi: fix stalled and doubly completed aborted WRITEs
Date: Mon, 26 Oct 2026 11:07:07 -0400
Message-ID: <20261026150710.1063511-1-loberman@redhat.com>
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

These three patches apply on top of commit d5869dae5080 ("scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands").

A WRITE command that is still in TRANSPORT_WRITE_PENDING has never been
passed to the backend, so when a TMR aborts it the iSCSI fabric is the one
that has to complete it. That commit fixed the case where the final
DataOut PDU for an already-issued R2T arrives after the abort. Two more
paths can leave such a command with nothing to complete it, or let it be
completed twice:

 - Patch 1 is the hang this work started from. A WRITE that arrives with
   immediate data, aborted after that data has been received but before
   the first R2T is built, is never completed by anything: no R2T has been
   sent so the initiator cannot send more data, and no DataOut timer is
   armed so the ERL=0 timeout cannot fire either. core_tmr_lun_reset()
   then blocks for as long as the connection stays up.

 - Patches 2 and 3 fix two existing sites that complete an aborted
   WRITE_PENDING command without recording that they have done so, and
   which connection teardown can therefore complete a second time.

Patch 1 also adds a one-shot completion claim. target_complete_cmd() on a
command that already has CMD_T_ABORTED set goes into
target_cmd_interrupted(), which queues target_abort_work and returns
without setting CMD_T_COMPLETE and without changing t_state, so target
core records nothing that would stop a second completion. The command
stays in TRANSPORT_WRITE_PENDING and on conn_cmd_list until
target_abort_work reaches iscsit_aborted_task(), and
iscsit_release_commands_from_conn() completes anything it finds in
TRANSPORT_WRITE_PENDING. The claim is what makes exactly one site
complete the command.

Changes since v3:
 - Dropped the patch that completed an aborted WRITE in the
   DATAOUT_SEND_R2T branch of iscsit_check_dataout_payload(). The review
   of v3 pointed out that the adjacent DATAOUT_SEND_TO_TRANSPORT branch
   deliberately checks ICF_OOO_CMDSN and defers, and the dropped patch did
   not: it could complete and free a command still reachable by raw
   pointer from sess_ooo_cmdsn_list, which iscsit_execute_ooo_cmdsns()
   dereferences later. Simply mirroring the neighbour is not enough
   either, because a command with ICF_NON_IMMEDIATE_UNSOLICITED_DATA set
   falls through iscsit_execute_cmd() without being completed when the
   CmdSN gap is filled. That window needs more thought than this series
   should carry, and it was never observed in the field, so it will come
   back on its own.
 - Patches 1 to 3 are unchanged from v3 patches 1, 3 and 4 respectively.

v3: https://lore.kernel.org/linux-scsi/20261026124344.745124-1-loberman@redhat.com/
v2: https://lore.kernel.org/linux-scsi/20261016175351.126373-1-loberman@redhat.com/
v1: https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat.com/

Two other findings against v3 are pre-existing rather than introduced
here, and I am reporting them separately rather than widening this series
again:

iscsit_get_immediate_data() reads cmd->sense_reason and
cmd->unsolicited_data after iscsit_sequence_cmd() returns, holding no
reference, and target_handle_abort() drops the final reference for an
aborted command. Patch 1 adds a path where that can happen, but so does
the branch directly above it: iscsit_handle_immediate_data() sets
ICF_GOT_LAST_DATAOUT when all of the command's data arrives as immediate
data, and iscsit_execute_cmd() then calls target_execute_cmd() from the
same caller with the same abort states. Patch 1 adds a third path with a
property two existing paths already have.

In patch 3, CMD_T_ABORTED can be set between the check and
target_cmd_interrupted() inside target_execute_cmd(), leaving the
completion unclaimed. That is also what happens today for every aborted
command on that path; the patch narrows the window rather than closing it.

A correction to something I said during the v2 review, in case it is
relied on: I wrote that if the outstanding_r2ts read in the dropped patch
was stale low, "the later completion in __iscsit_check_dataout_hdr()
becomes a no-op". That was wrong -- before patch 2 of this series that
site called target_complete_cmd() directly and never consulted the claim.

On moving the one-shot guard into target core:

This will be explored later on but is not in scope for this series; it
changes the path every fabric completes through and I have no way to test
easily in iSER, FC or SRP right now.

How this was found and tested:

The hang was reported against an Oracle RAC cluster on two-session iSCSI
LIO targets, where one node's LUN_RESET aborts WRITEs belonging to the
other node's session. It was not reproducible in a lab, so the diagnosis
came from instrumented kernels in the reporter's environment, logging
every site that completes or waits on an aborted command.

Across two hosts every stall had the identical signature given in patch 1,
and the stall only ever ended when the initiator gave up and dropped the
connection. 217 of 222 LUN_RESET drains completed in under a second; the
rest took 46 to 54 seconds, which is where the hung-task panics came from.
One 53.7 second stall recovered on its own and the host ran for a further
19 hours.

An earlier attempt at this fix completed the command from
core_tmr_drain_state_list() instead. That is not safe: at that point the
initiator may still be sending DataOut for the command, and the result was
a double completion -- re-queued se_cmd->work, list_del corruption and a
refcount underflow. Mentioning it in case the same idea comes up in
review.

What is and is not tested:

Patch 1, backported to a 5.14-based distro kernel, has run 300 LUN_RESET
cycles with no hang, in two independent runs: one instrumented and one
with the tracing removed. The same reproducer previously failed at 95 and
196 cycles. The instrumented kernels also carried the dropped
DATAOUT_SEND_R2T patch, and recorded that its site fired zero times in
either run, so removing it does not change anything those runs exercised.

Patches 2 and 3 are closed by inspection. Patch 2's site did run during
those tests, but by way of the unclaimed target_complete_cmd() it
replaces; when the claim succeeds the two are the same two calls in the
same order, so the tested behaviour is preserved. Patch 3 leaves the
non-aborted path through target_execute_cmd() untouched.

The reporter's environment is a production cluster and is the only place
this has ever reproduced, so I cannot offer an upstream -rc run from
there. A build of this series is going to them for a further 300-cycle run
and I will report back. If that is a blocker for patches 2 and 3, I would
rather you took patch 1 on its own than held the series.

Laurence Oberman (3):
  scsi: target: iscsi: Complete an aborted WRITE stuck before the first
    R2T
  scsi: target: iscsi: Claim the completion in
    __iscsit_check_dataout_hdr()
  scsi: target: iscsi: Claim the completion on the DataOut submit path

 drivers/target/iscsi/iscsi_target.c      | 28 +++++++++++----
 drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
 drivers/target/iscsi/iscsi_target_util.c | 46 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h |  2 ++
 include/target/iscsi/iscsi_target_core.h |  6 ++++
 5 files changed, 85 insertions(+), 7 deletions(-)

-- 
2.43.0

