Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DCE599A3A
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 17:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792173242; cv=none; b=o+8/NuEgxxbgbHUp04VfHVnbVoRQkuxvuIMxG6qgCBRonGl7AUN43TtZ3nd2uyBGP249uqfssSu/QgtJehTD36dzUFVc/YkNqjtbYkM96BTboyE6cahSejmShScPgyuB8zUuBcA8KY8SDa+J46yb9kPx8D/cAn50TByqcWj2RoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792173242; c=relaxed/simple;
	bh=mH+G3GeQjMYjazQQ0EC+XN16zVT20SSwFEexqZSBX2k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aEqqEWMJkf1L6EWm94fDyNvgKe3y8IdCMD8GzTs4PeynTv8i9kve+BIBh0/+ry5DDerBv0e87926JRfYD2GNgdRR6+WMbpTo9G20VuHICtvxi/Kjj9Gb3EI1hDIskTmlMi3/pEkTX4kFdUksucgzoTgZqii8++1zUDL1Ut5vheQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fy7ipuTI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fy7ipuTI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792173240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=0lVz5yl9h0lbQ17g+1LFurqrxe53j0c8VBAcjKV7S+c=;
	b=fy7ipuTITD7FhH8ONbfBe+tuGJwz7Q0HmgdyaiK0ddzkASLZKd3TCQXx88U4BRBauaeT1l
	ZIBx5rRzRHzDmf5hpLo7uyc91iDqwQp4m+S2DY2aO0CChTVsUunUNOH1bgMWA85rupXLMC
	hvYH6xMYjkVio8bXPpYXi5dITXVtXKc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-495-aahu8lnmMiGskNMuW9X9-g-1; Fri,
 16 Oct 2026 17:53:57 +0000
X-MC-Unique: aahu8lnmMiGskNMuW9X9-g-1
X-Mimecast-MFC-AGG-ID: aahu8lnmMiGskNMuW9X9-g_1792173235
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B0CF41954B16;
	Fri, 16 Oct 2026 17:53:55 +0000 (UTC)
Received: from loberman-thinkpadp1gen5.redhat.corp (headnet05.pony-001.prod.iad2.dc.redhat.com [10.2.32.117])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 879501800257;
	Fri, 16 Oct 2026 17:53:54 +0000 (UTC)
From: Laurence Oberman <loberman@redhat.com>
To: mkp@kernel.org
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	mlombard@redhat.com,
	michael.christie@oracle.com,
	linux-kernel@vger.kernel.org,
	Laurence Oberman <loberman@redhat.com>
Subject: [PATCH v2 0/2] scsi: target: iscsi: fix stalled aborted WRITE commands 
Date: Fri, 16 Oct 2026 13:53:33 -0400
Message-ID: <20261016175351.126373-1-loberman@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

These two patches apply on top of 
commit d5869dae5080 ("scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands").

A WRITE command that is still in TRANSPORT_WRITE_PENDING has never been
passed to the backend, so when a TMR aborts it the iSCSI fabric is the one
that has to complete it. That commit fixed the case where the final
DataOut PDU for an already-issued R2T arrives after the abort. Two more
paths can leave such a command with nothing to complete it:

 - Patch 1 is the hang this work started from. A WRITE that arrives with
   immediate data, aborted after that data has been received but before
   the first R2T is built, is never completed by anything: no R2T has been
   sent so the initiator cannot send more data, and no DataOut timer is
   armed so the ERL=0 timeout cannot fire either. core_tmr_lun_reset()
   then blocks for as long as the connection stays up.

 - Patch 2 closes the equivalent window where a new R2T would have been
   sent for an already-aborted command.

Patch 1 also adds a one-shot completion claim. Completing the command in
iscsit_execute_cmd() introduces a second site which
iscsit_release_commands_from_conn() would also complete during connection
teardown, because t_state is still TRANSPORT_WRITE_PENDING there and
target_complete_cmd() on an aborted command records nothing that would say
otherwise. The claim makes sure only one of them does it.

Changes since v1:
 - Patch 2: route the DATAOUT_SEND_R2T completion through
   iscsit_complete_aborted_cmd() rather than calling target_complete_cmd()
   directly, so the completion is claimed and cannot be repeated by
   iscsit_release_commands_from_conn() during connection teardown.
 - Patch 1 unchanged.

v1: https://lore.kernel.org/linux-scsi/20261014143932.39453-1-loberman@redhat.com/

How this was found and tested:

The hang was reported against an Oracle RAC cluster on two-session iSCSI
LIO targets, where one node's LUN_RESET aborts WRITEs belonging to the
other node's session. It was not reproducible in a lab, so the diagnosis
came from instrumented kernels in the reporter's environment, logging every
site that completes or waits on an aborted command.

Across two hosts every stall had the identical signature given in patch 1,
and the stall only ever ended when the initiator gave up and dropped the
connection. 217 of 222 LUN_RESET drains completed in under a second; the
rest took 46 to 54 seconds, which is where the hung-task panics came from.
One 53.7 second stall recovered on its own and the host ran for a further
19 hours.

Both patches, backported to a 5.14-based distro kernel, have since run 300
reset cycles with no hang, in two independent runs: one instrumented and
one with the tracing removed. The same reproducer previously failed at 95
and 196 cycles. The code here is equivalent to what was tested; only
comments differ.

One thing to flag for review: patch 2's window was never observed. The
instrumented kernels recorded no completions at that site in either run,
and the reproducer never reached it. It is included because the same
reasoning applies there, but it has no field evidence behind it, and I am
happy to drop it or send it separately if you would prefer.

An earlier attempt at this fix completed the command from
core_tmr_drain_state_list() instead. That is not safe: at that point the
initiator may still be sending DataOut for the command, and the result was
a double completion -- re-queued se_cmd->work, list_del corruption and a
refcount underflow. Mentioning it in case the same idea comes up in review.

Laurence Oberman (2):
  scsi: target: iscsi: Complete an aborted WRITE stuck before the first
    R2T
  scsi: target: iscsi: Complete an aborted WRITE when a new R2T would be
    sent

 drivers/target/iscsi/iscsi_target.c      | 28 +++++++++++++--
 drivers/target/iscsi/iscsi_target_erl1.c | 10 +++++-
 drivers/target/iscsi/iscsi_target_util.c | 46 ++++++++++++++++++++++++
 drivers/target/iscsi/iscsi_target_util.h |  2 ++
 include/target/iscsi/iscsi_target_core.h |  5 +++
 5 files changed, 88 insertions(+), 3 deletions(-)

-- 
2.52.0

