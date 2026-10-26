Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793042933;
	b=nzvDWRBTncE28BZMckTJC6NpD/zVdpdgz1WTOcitRICW7o8TUzYnD6oqwMuqu8Awgt/v
	 HCKJNYYYf2I5pvP4QJ96CcL2ahDb85lCT8N5yklQhzkkxwEWDGrd2zREEt6F6UGz6a3pH
	 zaJIk1k4pB/MN8mCz3sOY8mC4CtiSh/o4bvzFnFgWQcbIHKsqFHhmKmsb0v9Bly4CMFs5
	 ZeZhpmTPOMM5X/wfZrdFd0EvAtz4byX64pUwaG1I7Lsm3FQcZQjBz8TTb5I2BjgTT7NpD
	 3t6+6tNhDMmXIYxaMxTN72uFu8lTPORwiv618mJX9mowHpI9qtrdh1MOvgZ0Ayf+sNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793042933;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:From:To:Cc:Subject:Date:
	 Message-ID:MIME-Version:Content-Transfer-Encoding:X-Scanned-By;
	bh=F92PyrcrMhVyeeMFv1DzawMVg8zdrpoLUWb74RJSV7g=;
	b=uZhrcQq1a3cOPySS0H1zljpBp/5k/OoeRycfKWTzZ5oMZgHTt2FGVr2cC1V141zZQmgG
	 /vHwetSJIXgpo75O0F9hxDgLBExNg+jYTLMTrZqgzSwNbKBk7qupxyShVt4vmkekq3/0e
	 hsq+tNZCLAy/EmlCAS+9b53dlolljUxKl23j3IJMZwFAwHsZwlhcUp8YNqNlLhrqARS9B
	 jsZZ3w71YLgtczdJKlTSVdH5hr8oTHOdq2nVbvEF4s9NAPX/EaQrOsphzRkMiwYfRsBLv
	 MX2LyOlV5TE/RFi6lDoN4DZwcvgH/o7KHoQvaTW2s603eHqdsZdlUpLYw0eDIYGpNvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="GMKqwDQ/";
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE91606A31A
	for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2026 19:28:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CE91606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=GMKqwDQ/
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793042931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=F92PyrcrMhVyeeMFv1DzawMVg8zdrpoLUWb74RJSV7g=;
	b=GMKqwDQ/4bkXgAgM3I3rjWzLDGGJy4ETgWV5myWJArCocRAgcjimjabPAeX3JI/jmra0PO
	D8O4jgAi2LSRV0HxayjVTwUt6ylPIr3/WzzFb0Uw6unWOw6WFHWC03cz1HOuh7Np4a++8C
	WplGav0Sy+hmyl8WrkHyv8erVQWxMfA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-47-0jccAgxdPGC0taZ9-vtAxQ-1; Mon,
 26 Oct 2026 15:28:48 -0400
X-MC-Unique: 0jccAgxdPGC0taZ9-vtAxQ-1
X-Mimecast-MFC-AGG-ID: 0jccAgxdPGC0taZ9-vtAxQ_1793042926
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 904081800BCD;
	Mon, 26 Oct 2026 19:28:46 +0000 (UTC)
Received: from loberman-thinkpadp16gen3.redhat.corp (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 55150433;
	Mon, 26 Oct 2026 19:28:45 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	bvanassche@acm.org,
	michael.christie@oracle.com,
	mlombard@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v5 0/2] scsi: target: fix LUN_RESET hang on aborted iSCSI WRITEs
Date: Mon, 26 Oct 2026 15:28:33 -0400
Message-ID: <20261026192835.1431767-1-loberman@redhat.com>
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
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

These two patches fix a LUN_RESET hang on iSCSI targets, and the double
completion that fixing it exposes.

A WRITE command that is still in TRANSPORT_WRITE_PENDING has never been
passed to the backend, so when a TMR aborts it the fabric is the one that
has to complete it. Patch 2 completes it at the one site where nothing
does today. Patch 1 makes a second completion of an already-aborted
command a no-op, which is what makes that safe -- and which also fixes a
pre-existing double completion that is not specific to iSCSI.

 - Patch 1 guards the CMD_T_ABORTED branch of target_cmd_interrupted()
   with a one-shot flag taken under t_state_lock. Without it, a second
   target_complete_cmd() on an aborted command re-queues an se_cmd->work
   that is already queued and re-runs transport_complete_callback(), which
   for COMPARE AND WRITE releases dev->caw_sem a second time.

 - Patch 2 is the hang this work started from. A WRITE that arrives with
   immediate data, aborted after that data has been received but before
   the first R2T is built, is never completed by anything: no R2T has been
   sent so the initiator cannot send more data, and no DataOut timer is
   armed so the ERL=0 timeout cannot fire either. core_tmr_lun_reset()
   then blocks for as long as the connection stays up.

Changes since v4:
 - Moved the one-shot guard from iSCSI into target_cmd_interrupted(), as
   Bart Van Assche asked for in review of v4, and to the design he
   proposed there. This replaces the iSCSI-private completion_claimed
   member and the two helpers, which are gone, and it covers sites the
   iSCSI version could not: it closes the window where CMD_T_ABORTED is
   set between a fabric check and target_cmd_interrupted(), it covers the
   deferred ICF_OOO_CMDSN path into target_execute_cmd(), and it applies
   to every fabric rather than iSCSI alone.
 - The guard is limited to the CMD_T_ABORTED branch. complete_all() on the
   CMD_T_STOP branch is idempotent, and a shared guard would suppress the
   queueing of target_abort_work if CMD_T_ABORTED were set after a first
   call took the CMD_T_STOP branch.
 - Dropped v4 patches 2 and 3, which claimed the completion at two further
   iSCSI sites. Patch 1 makes both unnecessary.
 - Patch 2's Fixes: tag now names commit 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
   rather than the TAS commit it cited in v4. The TAS commit left the site
   with nothing to complete the command; making the abort path wait on a
   fabric completion is what turned that into a hang. Both are in v5.0, so
   the stable range is unchanged, and the patch body describes both.
 - Patch 2 is otherwise the same change as v4 patch 1, without the claim.

v4: https://lore.kernel.org/linux-scsi/20261026150722.823941-1-loberman@redhat.com/
v3: https://lore.kernel.org/linux-scsi/20261026124344.745124-1-loberman@redhat.com/
v2: https://lore.kernel.org/linux-scsi/20261016175351.126373-1-loberman@redhat.com/
v1: https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat.com/

How this was found:

The hang was reported against an Oracle RAC cluster on two-session iSCSI
LIO targets, where one node's LUN_RESET aborts WRITEs belonging to the
other node's session. It was not reproducible in a lab, so the diagnosis
came from instrumented kernels in the reporter's environment, logging
every site that completes or waits on an aborted command.

Across two hosts every stall had the identical signature given in patch 2,
and the stall only ever ended when the initiator gave up and dropped the
connection. 217 of 222 LUN_RESET drains completed in under a second; the
rest took 46 to 54 seconds, which is where the hung-task panics came from.
One 53.7 second stall recovered on its own and the host ran for a further
19 hours.

An earlier attempt at this fix completed the command from
core_tmr_drain_state_list() instead. That is not safe: at that point the
initiator may still be sending DataOut for the command, and the result was
a double completion -- re-queued se_cmd->work, list_del corruption and a
refcount underflow. That is the failure patch 1 now prevents outright, and
it is worth knowing that the same symptoms are reachable without any of
this series.

What is and is not tested:

Patch 2's change has run 300 LUN_RESET cycles with no hang, in two
independent runs on a 5.14-based distro kernel, one instrumented and one
with the tracing removed. The same reproducer previously failed at 95 and
196 cycles. In those kernels the double completion was prevented by the
iSCSI-private claim that v4 carried rather than by patch 1, so the hang
fix is validated but patch 1 is not: it is new code, and its design is
Bart's rather than mine. I would rather say that plainly than imply field
coverage it does not have.

The reporter's environment is a production cluster and the only place this
has ever reproduced, so I cannot offer an upstream -rc run from there. A
build of this series is going to them and I will report the result.

Laurence Oberman (2):
  scsi: target: Complete an aborted command at most once
  scsi: target: iscsi: Complete an aborted WRITE stuck before the first
    R2T

 drivers/target/iscsi/iscsi_target_erl1.c | 13 ++++++++-
 drivers/target/target_core_transport.c   | 37 +++++++++++++++++++-----
 include/target/target_core_base.h        |  1 +
 3 files changed, 42 insertions(+), 9 deletions(-)

-- 
2.43.0

