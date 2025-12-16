Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC86E3090C6;
	Tue, 16 Dec 2025 06:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765864974; cv=none; b=Nc0uLK9xNZuO68b3tFx6p/l6BsxTIVTYjmM9bc7oKd+NNWHndL4GO0bx7o5EggV/o69w5fNlpRnsXtChB9T9NC2/ngcm1HvbcFUKZaw+pTbEK+f6p1d+wMhrirysLZepqXU5K5llzIoykcNyyNL8Pz+bkzfS8UZwhRfV1b6z914=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765864974; c=relaxed/simple;
	bh=ERoOMso4AHgw3bTkDUndM9STNhE5XWAF2SLnTAqzeRU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=d9DC54BsBv3jxhG/FIfOhOx8AfDdb3bemYi+zS5A+EOh30SoidejdUa72ptnY9xhiffUD2CBdgHoxbK61SEsnEPXxHtXme1cBJ/LX5msMQdYYesr3PTR4iX+joqbIeu58M1QI91MNvPHirhDBEMThbFjF79TG8AV0w5Q1diNPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com; spf=pass smtp.mailfrom=darknavy.com; dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b=SGslDdn0; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=darknavy.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=darknavy.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=darknavy.com header.i=@darknavy.com header.b="SGslDdn0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darknavy.com;
	s=litx2311; t=1765864933;
	bh=cBfDMLiRZJFVndSNRVUc6V/e7+Nb1HHw/d6Em9QV5B8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=SGslDdn0Vn3tPJ1E5JSn1eMTaEj4pSu6h5yqEUTwuWOWv1tBU6kf+YX0FqPz2bQuJ
	 hmeWdG1uL7iJpQ02qXLT1YdYxBq2BTGNC8y2djlG3SY+7OygZ64FEyApo+aWnKHqnQ
	 VeK1yn9zdN9XrDOJsJRnV8X5XvZ37y01ptGtUiP4=
X-QQ-mid: esmtpsz20t1765864926t32a710af
X-QQ-Originating-IP: 1YmwxuQBSbLmGSkp79NXgPpBa3lWVZUdRUpfm3DUGc0=
Received: from localhost.localdomain ( [223.166.168.213])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 16 Dec 2025 14:02:00 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 8354494127150700673
EX-QQ-RecipientCnt: 10
From: Shipei Qu <qu@darknavy.com>
To: Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shipei Qu <qu@darknavy.com>,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	DARKNAVY <vr@darknavy.com>
Subject: [PATCH v2] scsi: megaraid_mbox: validate numstatus and completed[] from firmware
Date: Tue, 16 Dec 2025 14:01:54 +0800
Message-Id: <20251216060156.41320-2-qu@darknavy.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:darknavy.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NENrrmtYLi89a3g6qHiM9go14j4pckw1ZXNeqlHHOAhUVS3Wo83eOSAc
	57Pa+5IImkYr1ew3YgwKBK+yxBZ17GCHzKDAEPSdx8YkwYMY9cPfrGELZw93RMwSaVJNRLX
	Z8wJDEl2TkWkwSP428njdyQI2mXchbqyXtiLTWCwPFV3kMlSHS7abFafx6scV1eiGITx22P
	0QoaWR0i8Tdnl30PNzQriYHY9LBaHOKItWbX0LQu/SQ1kcHhGSp1uYZD2ihlWLQd/ddYsV9
	JJ7vb0wxriyRbx7rc6Q3qBKGOW0YhrpJilYDB/CosDX/XXnt4U/XkJ8sAeV9LwJQ9GxneF3
	ihTIyk3d4UuMh8anmMs29SjfolVNIUwfYBhBro3rlvNN4r49uuXv3jSbyd2KQyv7dwPDENJ
	DBVxkScaM0YdDccEJmrnzHGkZj/pAfd0z54JdWS3n6hG5PWa1wh1JI9yunjCKAAwqQYVrVr
	8h0czeqzmsY00BNuoeNOLKKON6ekx+42fWhskIfsmskpDgWn6CccnZ9HBnclKjOKo0X537d
	3oCFpJ6regrYkWk9rn0yBTUq1EtMmXO8+/Eo4dSnmOB/cMqeD2fyqxbkjwQBgZY6Z3VEtah
	TlidNYNPkrff8SO8L60vplJIkmn5lUvvUTXTqynFMt1p5DIjzGQaJhbcBVqwpUC2LaFBB+Q
	OXDOwv52AKrBoc6ac3uqGO/p/sVh05iRe7OuPLpQgK8id4IOqBgrqpMpknns4hOKZOxcA0o
	JeD8ut6p9krq2sN60xZJsQ9ZqfGsj4F4kvWQYIkaCffAVhmqZueasUig8oOf/ldx9kUCuvb
	Yw4ycTqEf+78t/hshgj+s08uRxmQN+IqpuNcc287GhkIkRNEUxR9BSeuzGkxSJtQQL8F9Id
	NE8aeHB8oy61mCMKdvFScSaauDJnLFIPHMhrFtGoQ0yOURElzpmJ8XgEinR2jE0tB+Zlz21
	s/X1SDiOcLuCMy5fVvk/CYEyAFEBTayfQqmJfQIsEKymWOiWf4VkIys7/fHDG+vTgsiEhlq
	Z1kOr69w==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
X-QQ-RECHKSPAM: 0

Hi,

resending with a properly formatted diff (the previous email had a malformed
patch header). The patch is otherwise unchanged.

The legacy megaraid_mbox driver trusts the mailbox fields numstatus and
completed[] that are written by the firmware.

In megaraid_ack_sequence():

  - numstatus is used as the loop bound when filling a fixed-size stack array
    completed[MBOX_MAX_FIRMWARE_STATUS] without checking that it is <=
    MBOX_MAX_FIRMWARE_STATUS;
  - each completed[i] is then used as an index into adapter->kscb_list[] /
    adapter->uscb_list[] without validating that it is within the combined SCB
    pool (MBOX_MAX_SCSI_CMDS + MBOX_MAX_USER_CMDS).

A misbehaving or buggy firmware can therefore cause stack and heap
out-of-bounds accesses and crashes.

In practice, this can also be triggered by a malicious PCIe or
Thunderbolt-attached device that emulates a supported controller and returns
crafted mailbox state.

This driver is still built by default in several distributions (e.g. Ubuntu),
so such firmware behaviour can affect stock installations. The same pattern is
present in current mainline kernels.

This issue was first reported via security@kernel.org. The kernel security team
considered it a normal robustness bug (controllers are assumed to be trusted
from the host's point of view) and asked us to send fixes to the relevant
development lists, so this patch follows that request. Below is a small
defensive fix.

Reported-by: DARKNAVY (@DarkNavyOrg) <vr@darknavy.com>
Signed-off-by: Shipei Qu <qu@darknavy.com>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index b610cad83..c5922c3fd 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -2073,6 +2073,13 @@ megaraid_ack_sequence(adapter_t *adapter)
 		}
 		mbox->numstatus = 0xFF;
 
+		if (nstatus > MBOX_MAX_FIRMWARE_STATUS) {
+			con_log(CL_ANN, (KERN_ERR
+				"megaraid: firmware reported %u status entries (max %d)\n",
+				nstatus, MBOX_MAX_FIRMWARE_STATUS));
+			nstatus = MBOX_MAX_FIRMWARE_STATUS;
+		}
+
 		adapter->outstanding_cmds -= nstatus;
 
 		for (i = 0; i < nstatus; i++) {
@@ -2093,6 +2100,12 @@ megaraid_ack_sequence(adapter_t *adapter)
 				continue;
 			}
 
+			if (completed[i] >= MBOX_MAX_SCSI_CMDS + MBOX_MAX_USER_CMDS) {
+				con_log(CL_ANN, (KERN_ERR
+					"megaraid: invalid command id %u\n", completed[i]));
+				continue;
+			}
+
 			// Get SCB associated with this command id
 			if (completed[i] >= MBOX_MAX_SCSI_CMDS) {
 				// a cmm command
-- 
2.45.1
