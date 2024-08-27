Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6679146590
	for <linux-scsi@vger.kernel.org>; Tue, 27 Aug 2024 18:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724784929; cv=none; b=YLNp2zwc+SQ2uweF5B9bqDJWFTEm9UViV+3ct7hv9T6i85KfmlXDSx5xwhvDWoxYvkebofgWsEY0DJp++yaX8W/xCBAcVqL8p3lfclGZnproTZ9QyfPJWd6ZH2Xfvde0/YFxcEeb1cxV4eUvgEVwZFk2ABQKHh3k9JEWcw9lbMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724784929; c=relaxed/simple;
	bh=rSQaHMO8f61xEzuYKf3U3E4m/6/+gudnCtIr4lvgRfw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qj7wDR4wb49fb99zvhMI645V9dWKre9oYmbpYa10jfnzKezMwf5WN739ri+4dyR3GIasdJBONqW2xWE6BSKENdERBOoP92uRO/e+E0UwLmwLHsz4vO/yeHMwAkMUWfn2w0PnBuBflggO9aWztMROBO1/D5ow3381of8Fw3CTmms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=fVMZC4Yq; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="fVMZC4Yq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1724784927; x=1756320927;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rSQaHMO8f61xEzuYKf3U3E4m/6/+gudnCtIr4lvgRfw=;
  b=fVMZC4Yq9pZmisth9GAiQFAxyZH7BwAb/FxSarD73AfWRc9yWeGaHSQp
   qdDn5cx/imU+2m/jUL7N9xJ1HGkZfxvu/tshW2Lxdsuh0zA5l/sfVy2Or
   oheuuMY6y+klldzbBUba+1UbQwrBldODHtAIwPE0erEmpN0DcRbKcwhZD
   cK+xSTI43PGjAj3TPsqQO6Ki5bpQZv4hcZsbisDOhBQg3Te5WJYW6xig6
   jDjphO0fHU3APRZy4OkDVXYbhgSISvXRY+Us7msxtEzGb4BcRlhhQEuqz
   usHxXUkhM4F3ySOpWyK/3p7l+pnCKvvi/hsAxnwNYkAJdKxRY8jVi64EM
   g==;
X-CSE-ConnectionGUID: HXogS4E1Q5emAr2ic36fkw==
X-CSE-MsgGUID: 8ln2jVHoSh21ZId82zBAlA==
X-IronPort-AV: E=Sophos;i="6.10,181,1719903600"; 
   d="scan'208";a="198399610"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 27 Aug 2024 11:55:26 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 27 Aug 2024 11:54:56 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Tue, 27 Aug 2024 11:55:01 -0700
From: Don Brace <don.brace@microchip.com>
To: <don.brace@microchip.com>, <scott.teel@microchip.com>,
	<Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
	<gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
	<mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
	<kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
	<david.strahan@microchip.com>, <hch@infradead.org>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Martin Petersen
	<martin.petersen@oracle.com>, <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC: <linux-scsi@vger.kernel.org>
Subject: [PATCH 0/7] smartpqi updates
Date: Tue, 27 Aug 2024 13:54:54 -0500
Message-ID: <20240827185501.692804-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.46.0.421.g159f2d50e7
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Microchip Technology Inc.
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

These patches are based on Martin Petersen's 6.12/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.12/scsi-queue

There are two functional changes:
    smartpqi-add-fw-log-to-kdump
    smartpqi-add-counter-for-parity-write-stream-requests

There are three minor bug fixes:
    smartpqi-fix-stream-detection
    smartpqi-fix-rare-system-hang-during-LUN-reset
    smartpqi-fix-volume-size-updates

The other two patches add PCI-IDs for new controllers and change the
driver version.

This set of changes consists of:
* smartpqi-add-fw-log-to-kdump

  During a kdump, the driver tells the controller to copy its logging information to some
  pre-allocated buffers that can be analyzed later.

  This is a "feature" driven capability and is backward compatible with existing controller FW.

  This patch renames some prefixes for OFA (Online-Firmware Activation ofa_*) buffers
  to host_memory_*. So, not a lot of actual functional changes to smartpqi_init.c,
  mainly determining the memory size allocation.

  We added a function to notify the controller to copy debug data into host memory before
  continuing kdump.

  Most of the functional changes are in smartpqi_sis.c where the actual handshaking is done.

* smartpqi-fix-stream-detection

  Correct some false write-stream detections. The data structure used to check for write-streams
  was not initialized to all 0's causing some false write stream detections. The driver sends
  down streamed requests to the raid engine instead of using AIO bypass for some extra performance.
  (Potential full-stripe write verses Read Modify Write).

  False detections have not caused any data corruption.
  Found by internal testing. No known externally reported bugs.

* smartpqi-add-counter-for-parity-write-stream-requests

  Adding some counters for raid_bypass and write streams. These two counters are related
  because write stream detection is only checked if an I/O request is eligible for bypass (AIO).

  The bypass counter (raid_bypass_cnt) was moved into a common structure (pqi_raid_io_stats) and
  changed to type __percpu. The write stream counter is (write_stream_cnt) has been added to
  this same structure.

  These counters are __percpu counters for performance. We added a sysfs entry to show the
  write stream count. The raid bypass counter sysfs entry already exists.

  Useful for checking streaming writes. The change in the sysfs entry write_stream_cnt can be
  checked during AIO eligible write operations.

* smartpqi-add-new-controller-PCI-IDs

  Adding support for new controller HW.
  No functional changes.

* smartpqi-fix-rare-system-hang-during-LUN-reset

  We found a rare race condition that can occur during a LUN reset. We were not emptying
  our internal queue completely.

  There have been some rare conditions where our internal request queue has requests for
  multiple LUNs and a reset comes in for one of the LUNs. The driver waits for this internal
  queue to empty. We were only clearing out the requests for the LUN being reset so the
  request queue was never empty causing a hang.

  The Fix:
     For all requests in our internal request queue:
        Complete requests with DID_RESET for queued requests for the device undergoing a reset.
        Complete requests with DID_REQUEUE for all other queued requests.

  Found by internal testing. No known externally reported bugs.

* smartpqi-fix-volume-size-updates

  The current code only checks for a size change if there is also a queue depth change.
  We are separating the check for queue depth and the size changes.

  Found by internal testing. No known bugs were filed.

* smartpqi-update-version-to-2.1.30-031
  No functional changes.

---

David Strahan (1):
  smartpqi: add new controller PCI IDs

Don Brace (2):
  smartpqi: fix volume size updates
  smartpqi: update driver version to 2.1.30-031

Mahesh Rajashekhara (2):
  smartpqi: correct stream detection
  smartpqi: add counter for parity write stream requests

Murthy Bhat (2):
  smartpqi: Add fw log to kdump
  smartpqi: fix rare system hang during LUN reset

 drivers/scsi/smartpqi/smartpqi.h      |  39 ++-
 drivers/scsi/smartpqi/smartpqi_init.c | 352 +++++++++++++++++---------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  60 +++++
 drivers/scsi/smartpqi/smartpqi_sis.h  |   3 +
 4 files changed, 322 insertions(+), 132 deletions(-)

-- 
2.46.0.421.g159f2d50e7

