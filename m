Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAE32D78D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2023 12:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="DJg+qQWt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=MIME-Version:Message-Id:Date:Subject:From:
	Content-Type; bh=VD/OMLE3I4BlsdQN2NqB6n37Ylfblb/KYFbkJkAW3Q8=; b=DJg+qQWtrQhS
	ZqXmTM3fRihyQkTfSsT9ghKFYAdkI0jk1Zrs7LWmugGTIDKXf2s250tUOhOFmQw8pUO5Ol/1+dLpm
	nJDdiK/wWdhHWB7xLvL/Pwf18vQa+VbBnTMZLdSL5xvowI3r8tl/jEFpbQdZ9mJfy2QREG/VpQgQR
	zfMLTmjdgrPHWSx5FTLws7NyEIgsOfDmuu83NFp1bHe4RcVMlY8gwuNKLqo+lenJB3PTQjk2CGjus
	+ckca94q4bHNhIzTSsG+ilVlt1KkcXWN9M4QXzQsfADg/DF4ay8itaHw2XrXlT1nX4Y341xZq8u2v
	Ip8hr20XQEBUwFxGPIhd8Q==;
Received: from [130.117.225.1] (helo=dev011.ch-qa.vzint.dev)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <alexander.atanasov@virtuozzo.com>)
	id 1rE6zT-001QIU-0k;
	Fri, 15 Dec 2023 13:10:24 +0100
From: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
To: "James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.com>
Cc: kernel@openvz.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2 RESEND] scsi: code: always send batch on reset or error handling command
Date: Fri, 15 Dec 2023 14:10:08 +0200
Message-Id: <20231215121008.2881653-1-alexander.atanasov@virtuozzo.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In commit 8930a6c20791 ("scsi: core: add support for request batching")
blk-mq last flags was mapped to SCMD_LAST and used as an indicator to
send the batch for the drivers that implement it but the error handling
code was not updated.

scsi_send_eh_cmnd(...) is used to send error handling commands and
request sense. The problem is that request sense comes as a single
command that gets into the batch queue and times out.  As result
device goes offline after several failed resets. This was observed
on virtio_scsi device resize operation.

[  496.316946] sd 0:0:4:0: [sdd] tag#117 scsi_eh_0: requesting sense
[  506.786356] sd 0:0:4:0: [sdd] tag#117 scsi_send_eh_cmnd timeleft: 0
[  506.787981] sd 0:0:4:0: [sdd] tag#117 abort

To fix this always set SCMD_LAST flag in scsi_send_eh_cmnd and
scsi_reset_ioctl(...).

Fixes: 8930a6c20791 ("scsi: core: add support for request batching")
Signed-off-by: Alexander Atanasov <alexander.atanasov@virtuozzo.com>
---
 drivers/scsi/scsi_error.c | 2 ++
 1 file changed, 2 insertions(+)

v1->v2: fix it globally not only for virtio_scsi, as suggested by
Paolo Bonzini, to avoid reintroducing the same bug.


RESEND -> add linux-scsi, remove stable

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index c67cdcdc3ba8..1223d34c04da 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1152,6 +1152,7 @@ static enum scsi_disposition scsi_send_eh_cmnd(struct scsi_cmnd *scmd,
 
 	scsi_log_send(scmd);
 	scmd->submitter = SUBMITTED_BY_SCSI_ERROR_HANDLER;
+	scmd->flags |= SCMD_LAST;
 
 	/*
 	 * Lock sdev->state_mutex to avoid that scsi_device_quiesce() can
@@ -2459,6 +2460,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	scsi_init_command(dev, scmd);
 
 	scmd->submitter = SUBMITTED_BY_SCSI_RESET_IOCTL;
+	scmd->flags |= SCMD_LAST;
 	memset(&scmd->sdb, 0, sizeof(scmd->sdb));
 
 	scmd->cmd_len			= 0;
-- 
2.39.3

