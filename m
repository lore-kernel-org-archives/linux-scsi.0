Received: from mta-03.yadro.com (mta-03.yadro.com [89.207.88.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834951474A7;
	Fri, 29 Nov 2024 15:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.207.88.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732894826; cv=none; b=aJPSPbo3SbgbN2PlXfV7kVUAc1P/9PQIL+JXbjw6mFaTlNE0x5+Pczm+22k8EzurOWUYtOQ7omv+dSViLVqkqiONseYwp6T5F0K5MWiU5Lt/oCzxAoXIMQAzO6BXTQUtps+XQteVddXqRuqZJifyWJHJUnpBiIAs7XWrIHG+7Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732894826; c=relaxed/simple;
	bh=4+EBCYGIqX+1YNZd4AVZV83tZLV2KUc5BpUZCxNwYK0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mV/rzrTiz3PednWSADX/z4BOGgAd+XoPx4mIk6dRoZE/kPMXRdWO0PNCyPxhx3sU2+T5/Q3jIziOyeaDI7iQ2Ge6BHjKxfFHkZTfCzuI5c49nqex1IeQjIIbgNT2tPtrPwhCceDMHxBSL4S7ix6jax1CLDN5IOP00Abm7d0X8Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com; spf=pass smtp.mailfrom=yadro.com; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=RC6MEv1F; dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b=jwIbRr32; arc=none smtp.client-ip=89.207.88.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yadro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yadro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="RC6MEv1F";
	dkim=pass (2048-bit key) header.d=yadro.com header.i=@yadro.com header.b="jwIbRr32"
DKIM-Filter: OpenDKIM Filter v2.11.0 mta-03.yadro.com 61D84E0008
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-04;
	t=1732894340; bh=e/Mj9Q3r6B3S8/acUA3r+gYznMYxkdB0/sDhGh2BI30=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=RC6MEv1FslEelE5tf4LXCGth/LC0YYnVAfSBCDrV7sRtIvSxnawWKaP74ECRssn4b
	 Br/6rP5UfxeiLkO6OzIfi5ohqsKFjyLiJiHY/Z8L++gAC19HviV7LmY1wy+KUz8vvq
	 POGa1MYBJEzmOc0943ThvFOxyWA7ZJ1meW5g0QPE5s+E/kZuJY73hScvX5M7Bkb6js
	 SiT1Y/bmGECz0v3AdzFtbAN9woqs/51CI6q1iG1c28676trnnSKnuj6WeLOmHletWh
	 IHeToDCsfs1Y/wDjIGQMOTJLJ5RMLnRJy+IfY6BVdggEhUCaf8PumTUQUHSw/h7zAf
	 IDw3UaL0sfC/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; s=mta-03;
	t=1732894340; bh=e/Mj9Q3r6B3S8/acUA3r+gYznMYxkdB0/sDhGh2BI30=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=jwIbRr32n2C9o3P8Fs68mITV/lpJAsWlSAED5YUxnDV67502M9vM1EJUNRKSX7qE7
	 xtTUjKJIkbHdjy5EY+oXwK4bH1TApzuJN3M9tQopjcUyIDMYrTE7hdLHCJbIh0OqoB
	 b2e7dZT0A75qAwwwgMQe/DR5YDLsKdZjQtXbtv1yCknp5dJXtefvcPEtbem7W93OMX
	 R+BeQ6w5jMYiNlp8YT0kT5Ut6MvC5jS90ySGEW0fOXLPrvLMsC6i9tA7oowXLPK1jD
	 xwNUeTuqr74sH/XxbD0/JHGg2JSIOueLVHgnpKF1YUEY8DnQujlxm6FBpr/d9U0nMA
	 8sZ47z81C7w2A==
From: Anastasia Kovaleva <a.kovaleva@yadro.com>
To: <martin.petersen@oracle.com>, <bootc@bootc.net>, <bostroesser@gmail.com>,
	<michael.christie@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>,
	<linux@yadro.com>
Subject: [PATCH 00/10] Improve SCSI target logs
Date: Fri, 29 Nov 2024 18:30:46 +0300
Message-ID: <20241129153056.6985-1-a.kovaleva@yadro.com>
X-Mailer: git-send-email 2.40.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-ClientProxiedBy: T-EXCH-07.corp.yadro.com (172.17.11.57) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)

This patch series address two main issues of the current logs in SCSI
target (discussed in [1]):

  1. Absence of a common prefix for the subsystem to make it possible to
     filter them out to a separate file.
  2. Absence of an I-T-L nexus in a log message to understand what is
     that log for.

Patches 2 - 6 of the series are automated. So, we also included fixes
[PATCH 04] of other style errors and warnings that checkpatch can fix.
We've been using these logs for almost an year and didn't encounter any
kind of problems.

Code style of all patches was made by git clang-format with these
additional parameters:

+AllowAllArgumentsOnNextLine: false
+ColumnLimit: 100
+PenaltyBreakOpenParenthesis: 12000
+PenaltyBreakBeforeFirstCallParameter: 12000
+PenaltyBreakString: 12000

In general, logs present in the following format:
  target <file_prefix>: General log Message
  target <file_prefix> (<iqn_initiator> -> <RTPI>): Session Log Message
  target <file_prefix> (<iqn_initiator> -> <RTPI>/<MappedLun>): Command Log Message
  target <file_prefix> <fabric_name>_tpg[<tpg_tag>](<tpg_rtpi>/<LUN>): Lun Log Message

Examples:
  target sbp: initiator already logged-in
  target core (iqn.2001-09.com.example:foobar-1 -> 1): ABORT_TASK: Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 2281488
  target core (iqn.2001-09.com.example:foobar-1 -> 1/99): Unknown PERSISTENT_RESERVE_OUT service action: 0x11
  target core iSCSI_tpg[1](1/99): Unable to extract alua_tg_pt_status

[1] - https://lore.kernel.org/target-devel/ZF0MiCRW8HWm8YYj@yadro.com/

Anastasia Kovaleva (10):
  target: core: Improve SCSI target logs
  target: Use new log wrappers
  target: Fix quoted strings splitting
  target: Fix some obvious style problems
  target: Add log prefix to all tcm files
  target: Remove old prefixes from log messages
  target: core: Extend CaW logging
  target: core: Use extended logs where possible
  target: Use __func__ in logs
  target: iscsi: Improve a log message

 drivers/target/iscsi/cxgbit/cxgbit_cm.c       | 191 +++---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c      |  19 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c     |  47 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c   | 115 ++--
 drivers/target/iscsi/iscsi_target.c           | 559 +++++++--------
 drivers/target/iscsi/iscsi_target_auth.c      | 123 ++--
 drivers/target/iscsi/iscsi_target_configfs.c  |  91 +--
 .../target/iscsi/iscsi_target_datain_values.c |  20 +-
 drivers/target/iscsi/iscsi_target_device.c    |   4 +-
 drivers/target/iscsi/iscsi_target_erl0.c      | 149 ++--
 drivers/target/iscsi/iscsi_target_erl1.c      | 158 ++---
 drivers/target/iscsi/iscsi_target_erl2.c      |  60 +-
 drivers/target/iscsi/iscsi_target_login.c     | 157 ++---
 drivers/target/iscsi/iscsi_target_nego.c      | 187 +++---
 .../target/iscsi/iscsi_target_nodeattrib.c    |  94 ++-
 .../target/iscsi/iscsi_target_parameters.c    | 354 ++++------
 .../target/iscsi/iscsi_target_seq_pdu_list.c  |  86 +--
 drivers/target/iscsi/iscsi_target_stat.c      |   2 +
 drivers/target/iscsi/iscsi_target_tmr.c       | 121 ++--
 drivers/target/iscsi/iscsi_target_tpg.c       | 172 +++--
 drivers/target/iscsi/iscsi_target_transport.c |   6 +-
 drivers/target/iscsi/iscsi_target_util.c      | 133 ++--
 drivers/target/loopback/tcm_loop.c            | 114 ++--
 drivers/target/sbp/sbp_target.c               | 156 +++--
 drivers/target/target_core_alua.c             | 192 +++---
 drivers/target/target_core_configfs.c         | 533 ++++++---------
 drivers/target/target_core_device.c           |  99 +--
 drivers/target/target_core_fabric_configfs.c  |  65 +-
 drivers/target/target_core_fabric_lib.c       |  27 +-
 drivers/target/target_core_file.c             | 126 ++--
 drivers/target/target_core_hba.c              |  15 +-
 drivers/target/target_core_iblock.c           |  96 ++-
 drivers/target/target_core_pr.c               | 635 ++++++++----------
 drivers/target/target_core_pscsi.c            | 160 ++---
 drivers/target/target_core_rd.c               |  87 ++-
 drivers/target/target_core_sbc.c              | 159 ++---
 drivers/target/target_core_spc.c              |  32 +-
 drivers/target/target_core_stat.c             |   4 +-
 drivers/target/target_core_tmr.c              |  57 +-
 drivers/target/target_core_tpg.c              |  81 +--
 drivers/target/target_core_transport.c        | 226 +++----
 drivers/target/target_core_ua.c               |  27 +-
 drivers/target/target_core_user.c             | 257 ++++---
 drivers/target/target_core_xcopy.c            | 228 +++----
 drivers/target/tcm_fc/tcm_fc.h                |   2 +-
 drivers/target/tcm_fc/tfc_cmd.c               |  47 +-
 drivers/target/tcm_fc/tfc_conf.c              |  18 +-
 drivers/target/tcm_fc/tfc_io.c                |  22 +-
 drivers/target/tcm_fc/tfc_sess.c              |   7 +-
 drivers/target/tcm_remote/tcm_remote.c        |  41 +-
 include/target/target_core_base.h             |  92 +++
 51 files changed, 2847 insertions(+), 3606 deletions(-)

-- 
2.40.3

