Received: from cstnet.cn (smtp25.cstnet.cn [159.226.251.25])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D51623C8AE;
	Wed, 22 Jul 2026 04:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784693588; cv=none; b=dl+/a8joc7jZsrnEoZqeHYkaipStz9dTvYpX0bsUye5k496/fc6Tz2JidHmvckGEK1SfkZB4yPelI63qkt4Ivzes92RefcdEdN+nnZonNWBlaVHCw8J2PD13hCTvEXp0aStQ7zIruBTHqu8Bd87zzoNf5aciIcLTgaH4wI/2Ea4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784693588; c=relaxed/simple;
	bh=2SKuNksGOFjzc1qi5KsEgeNx83BAXbgrTys3kqAHnYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LPmqN5uW4dpp1IIzRq8Q28okTVUeiyNX1kLy5J5HavKw0mPgvpIRFG/37nnZU4DJlhiDEQSRJG999M9ZRHP+tNLDfSoztTYeFdra84Y429UvJwS34eUJouGVvfVDzY58RxIWdLFw1qyMMgvLtljhEWE/NSwfhqWNp8rTg03GuXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-05 (Coremail) with SMTP id zQCowAAHOEJJQ2BqJh+7AA--.33878S2;
	Wed, 22 Jul 2026 12:12:58 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [PATCH] scsi: mpt3sas: validate variable event array spans
Date: Wed, 22 Jul 2026 12:12:57 +0800
Message-ID: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:zQCowAAHOEJJQ2BqJh+7AA--.33878S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCry5JF47Jw15GF43Ar1UZFb_yoWrury5pr
	W8Ga4YkrZxtFyIvw43G3s8Cr4ag395GryDKFy5tanxZry7GryxJa1xtrn0q3WYyF45Zr4x
	tw4YqrZI9FZ8tFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E
	8cxan2IY04v7MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r
	4UMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j
	6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYx
	BIdaVFxhVjvjDU0xZFpf9x0JUL0edUUUUU=
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/

SAS topology, PCIe topology and IR configuration events contain flexible
arrays whose element counts are supplied by firmware. Their interrupt-time
handlers use NumEntries or NumElements without first checking that the
corresponding array fits in EventData.

Validate only these three variable-array event types before dispatch. Check
that MsgLength is within the allocated reply frame, that EventDataLength is
within MsgLength, and that the counted array fits in EventData.

Malformed events still follow the existing ACK path before they are
dropped, so validation does not leave an acknowledged event pending in
firmware. Other event types retain their existing behavior.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 71 +++++++++++++++++++++++++++++++++++--
 1 file changed, 69 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..2a9ea81d1e2b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1333,6 +1333,65 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
 	ioc_info(ioc, "%s\n", desc);
 }
 
+static bool
+_base_variable_event_data_valid(struct MPT3SAS_ADAPTER *ioc,
+				Mpi2EventNotificationReply_t *mpi_reply)
+{
+	const size_t event_offset = offsetof(Mpi2EventNotificationReply_t,
+					     EventData);
+	const void *event_data = mpi_reply->EventData;
+	size_t event_data_len;
+	size_t reply_len;
+	u16 event;
+
+	event = le16_to_cpu(mpi_reply->Event);
+	switch (event) {
+	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST:
+	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
+	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST:
+		break;
+	default:
+		return true;
+	}
+
+	reply_len = mpi_reply->MsgLength * 4;
+	if (reply_len < event_offset || reply_len > ioc->reply_sz)
+		return false;
+
+	event_data_len = le16_to_cpu(mpi_reply->EventDataLength) * 4;
+	if (event_data_len > reply_len - event_offset)
+		return false;
+
+	switch (event) {
+	case MPI2_EVENT_SAS_TOPOLOGY_CHANGE_LIST: {
+		const Mpi2EventDataSasTopologyChangeList_t *data = event_data;
+		size_t fixed_len = offsetof(Mpi2EventDataSasTopologyChangeList_t,
+					    PHY);
+
+		return event_data_len >= fixed_len &&
+		       struct_size(data, PHY, data->NumEntries) <= event_data_len;
+	}
+	case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST: {
+		const Mpi26EventDataPCIeTopologyChangeList_t *data = event_data;
+		size_t fixed_len = offsetof(Mpi26EventDataPCIeTopologyChangeList_t,
+					    PortEntry);
+
+		return event_data_len >= fixed_len &&
+		       struct_size(data, PortEntry, data->NumEntries) <= event_data_len;
+	}
+	case MPI2_EVENT_IR_CONFIGURATION_CHANGE_LIST: {
+		const Mpi2EventDataIrConfigChangeList_t *data = event_data;
+		size_t fixed_len = offsetof(Mpi2EventDataIrConfigChangeList_t,
+					    ConfigElement);
+
+		return event_data_len >= fixed_len &&
+		       struct_size(data, ConfigElement, data->NumElements) <= event_data_len;
+	}
+	default:
+		return true;
+	}
+}
+
 /**
  * _base_sas_log_info - verbose translation of firmware log info
  * @ioc: per adapter object
@@ -1482,8 +1541,9 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 {
 	Mpi2EventNotificationReply_t *mpi_reply;
 	Mpi2EventAckRequest_t *ack_request;
-	u16 smid;
 	struct _event_ack_list *delayed_event_ack;
+	bool event_data_valid;
+	u16 smid;
 
 	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
 	if (!mpi_reply)
@@ -1491,7 +1551,12 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	if (mpi_reply->Function != MPI2_FUNCTION_EVENT_NOTIFICATION)
 		return 1;
 
-	_base_display_event_data(ioc, mpi_reply);
+	event_data_valid = _base_variable_event_data_valid(ioc, mpi_reply);
+	if (event_data_valid)
+		_base_display_event_data(ioc, mpi_reply);
+	else
+		ioc_warn(ioc, "dropping malformed event 0x%04x\n",
+			 le16_to_cpu(mpi_reply->Event));
 
 	if (!(mpi_reply->AckRequired & MPI2_EVENT_NOTIFICATION_ACK_REQUIRED))
 		goto out;
@@ -1521,6 +1586,8 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
 	ioc->put_smid_default(ioc, smid);
 
  out:
+	if (!event_data_valid)
+		return 1;
 
 	/* scsih callback handler */
 	mpt3sas_scsih_event_callback(ioc, msix_index, reply);
-- 
2.50.1 (Apple Git-155)

