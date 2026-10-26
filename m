Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793018635;
	b=mpmq25+SZnBIZSfOpVyLfawbCusw1mf9OQwAC3eQThX7sLlUy8nUk/Qg+DKCV2xTvt5j
	 nQOor1+YU8nABRnpZySDq9B98NosLu1cz5eH2ZQBDnzsOWxn+O8186xsTFkIO3747QmJc
	 MZAgn1/H51h2OCDwwd71sh7U5u4aANPHfoRtu9eytyz5v2xxUW+iZktFXq6AU8WJmIjyp
	 9fDseERfQk1+eGJovO+UDd1gb47jBjNfmrJYl7LAH890Za/7Iyyo24l20/1cgjaGArV68
	 VuqHQPbZ8odDI9o9T9e6O/IgY0ySeSFigyqIQiVqYGoeZAYErzjpMLD9AcpMxnbsKXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793018635;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=mzy07ucNeXfFwJeLxVmpRnJ2m6GWAM0gZOL1HyveZDw=;
	b=HVMFRrFhVdiCjD9P9vcEWZX5YNU0yGzpX/rFmSmoxMMBkBvABwJcpY7e88CjnXLfE8w3
	 DFNOvNX3qUKz5sVTLtuEFFDF5rBjA1U7xZuRBCexsnKOd4kDP9kGXhOSAL4Wxw1St+Avo
	 aCvol4VoT9XTykZgvbVhli/GxYzog13/rTW5zJLleEDG96StrkDruWQ9jA3ZOMSTFqoCc
	 kHJqXsTw3QvApcGzy7DlEjuBxqyTekTZFumUJKJMKDyMqrcm5wJpIfy2KkT2SeaD33k4B
	 GI3Dw4CXerOaxX9F35M/jf+Vl6bBk9uayw/bklsqlrU4J1oYvKu7uWhIPU7e/enN1Iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UJeGnZyH;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D72606A326
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 12:43:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47D72606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=UJeGnZyH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793018634;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=mzy07ucNeXfFwJeLxVmpRnJ2m6GWAM0gZOL1HyveZDw=;
	b=UJeGnZyHMtvxudvh+jSDdBjU1Qk5f8MNeWRm7hFK4L6v2IMSUOHtjIQr7b8w3jHLxKPXDW
	B6mdc7FbZ79HmZzs/UGR8FjYWnLvxdKPCq8z8WKjT+zalZbACwugLU2Ss3yYrLleftXvwE
	DHWjqTujXg/8YqHMLGgFQpPzCheJdgY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-ppTONbovOsGiHyiq-zSmQQ-1; Mon,
 26 Oct 2026 08:43:50 -0400
X-MC-Unique: ppTONbovOsGiHyiq-zSmQQ-1
X-Mimecast-MFC-AGG-ID: ppTONbovOsGiHyiq-zSmQQ_1793018629
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9F5AB1802573;
	Mon, 26 Oct 2026 12:43:49 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8062A1956088;
	Mon, 26 Oct 2026 12:43:48 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	bvanassche@acm.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] scsi: target: iscsi: fix stalled and doubly completed aborted WRITEs
Date: Mon, 26 Oct 2026 08:43:40 -0400
Message-ID: <20261026124344.745124-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

These four patches apply on top of commit d5869dae5080 ("scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands").

A WRITE command that is still in TRANSPORT_WRITE_PENDING has never been
passed to the backend, so when a TMR aborts it the iSCSI fabric is the one
that has to complete it. That commit fixed the case where the final
DataOut PDU for an already-issued R2T arrives after the abort. Three more
paths can leave such a command with nothing to complete it, or let it be
completed twice:

 - Patch 1 is the hang this work started from. A WRITE that arrives with
   immediate data, aborted after that data has been received but before
   the first R2T is built, is never completed by anything: no R2T has been
   sent so the initiator cannot send more data, and no DataOut timer is
   armed so the ERL=0 timeout cannot fire either. core_tmr_lun_reset()
   then blocks for as long as the connection stays up.

 - Patch 2 closes the equivalent window where a new R2T would have been
   sent for an already-aborted command.

 - Patches 3 and 4 fix two existing sites that complete an aborted
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

Changes since v2:
 - New patch 3 routes the completion added by that commit through the
   claim, with Fixes: and Cc: stable. Raised in the review of v2, and by
   the Sashiko bot against both v1 and v2.
 - New patch 4 does the same for the DATAOUT_SEND_TO_TRANSPORT path into
   target_execute_cmd(), which has the same shape and is older.
 - Patch 1: reworded the completion_claimed comment. It said the flag is
   set once target_complete_cmd() has been called; it is set before the
   call, by whichever site takes the claim.
 - Patch 2: moved the "never observed in the field" paragraph below the
   --- line. Code unchanged.
 - Patches 1 and 2 are otherwise identical to v2.

v2: https://lore.kernel.org/linux-scsi/20261016175351.126373-1-loberman@redhat.com/
v1: https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat.com/

Two corrections to things I said during the v2 review:

I wrote that if the outstanding_r2ts read in patch 2 is stale low, "the
later completion in __iscsit_check_dataout_hdr() becomes a no-op". That
was wrong. In v2 that site calls target_complete_cmd() directly and never
looks at the claim, so the claim cannot make it a no-op. What actually
prevents a second completion there is that outstanding_r2ts is a u32, so
--cmd->outstanding_r2ts on a counter already at zero wraps to 0xffffffff
and fails the < 1 test. That is an accident of the existing code rather
than a guarantee, and it leaves the counter corrupted. Patch 3 removes
the need to rely on it. I have not tried to fix the underflow itself
here; say the word if you would like a patch for it.

I also said the pre-existing sites were best left to a follow-up. For the
record on the other half of that exchange, that commit is not confined
to 7.3/scsi-staging: it is in mainline, it carries CVE-2026-97951, and it
has been backported to 5.10.y, 5.15.y, 6.1.y, 6.6.y, 6.12.y, 6.18.y and
7.2.y. That is the reason patch 3 has Cc: stable -- and also a reason it
may be better taken as a standalone fix for those branches than as part
of this series, since none of them carry patch 1's helper. I will send
whichever form you prefer.

On fixing this in target core instead:

The root cause is that target_cmd_interrupted() queues target_abort_work
and records nothing under t_state_lock, so a test-and-set there would
cover every fabric rather than iSCSI alone, and would make the
completion_claimed field in this series unnecessary. I think that is the
better end state and I am willing to do it. I did not do it here for two
reasons. It changes the path that every fabric completes through, and I
have no way to test iSER, FC or SRP. And the field evidence behind this
series is evidence for an iSCSI-local change, not for a core one. I would
rather land the narrow fix for a hang that is being hit in production and
then propose the core cleanup on its own merits, in front of the people
who own that code.

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

Patches 1 and 2, backported to a 5.14-based distro kernel, have run 300
LUN_RESET cycles with no hang, in two independent runs: one instrumented
and one with the tracing removed. The same reproducer previously failed at
95 and 196 cycles.

Only patch 1's window was ever observed. The instrumented kernels recorded
no completions at patch 2's site in either run, and patches 3 and 4 are
closed by inspection. The reporter's environment is a production cluster
and is the only place this has ever reproduced, so I cannot offer an
upstream -rc run or a MaxOutstandingR2T > 1 run from there. If that is a
blocker for patches 2 to 4, I would rather you took patch 1 on its own
than held the series.

Laurence Oberman (4):
  scsi: target: iscsi: Complete an aborted WRITE stuck before the first
    R2T
  scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be
    sent
  scsi: target: iscsi: Claim the completion in
    __iscsit_check_dataout_hdr()
  scsi: target: iscsi: Claim the completion on the DataOut submit path

 drivers/target/iscsi/iscsi_target.c      | 44 +++++++++++++++++++----
 drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
 drivers/target/iscsi/iscsi_target_util.c | 46 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h |  2 ++
 include/target/iscsi/iscsi_target_core.h |  6 ++++
 5 files changed, 101 insertions(+), 7 deletions(-)

-- 
2.43.0

