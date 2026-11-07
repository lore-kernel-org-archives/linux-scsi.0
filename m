Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068214;
	b=c8c5R3oLFgbTM2aRtNmhZWcbsdLAVQCc7EBldyq236kmWsyWoiOrwGmTsWVBj1NqLbz0
	 TdCI78F7VkvfqsH1pnbd2JZ5yx9QW/P6Lw8ELv6Fo9H5igKfVmxlPxGkcCSuZJZlyG6c0
	 GPUglLGb4wy5tefHeBL9hzhORjpAN2CDgp5TVdQ6x5cZ9aKJzp8k0x484JbYZDlE11j7c
	 gNcNSnvj251d7HhiAxs5Zoe1TPV1D54wj5ZO6w73gBLVvLubhJ1Msps/vMgVkkfhek4+y
	 j4NAXn95aF2OFIUcgGmuEf599oTNrvUM0JnzJeJVnkoVcDoLEmudR8isUdQAk64Fviw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068214;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=1D29vSEBuUU2JgTcH1WSvo2+maUUgg84+/02JYGyg9E=;
	b=XmL9fgeASrStt1XI3gBFrf2NresKyFgm7oKh6xwhCXGcVaPYkS2jdDJVLm53sleFlXcM
	 WLBBhcNn2oJzNAzr2qqo0UmyT6NrbE8aHBSgeRh7hm4NT9N4GDbNxrkqvG+aVoqB/7Wk1
	 79nvV3TxhMMs/y+RHJFtKh3nPFvNJPIIm81osJrhfibfmp1vVXyF5qopkg0aocM+PpF6r
	 1xJ4VpVPUtRDfe4tiufmJR/41LrJgP3wGVCQk0P6cIW4y8nJQHVadosIQ2cUMOr2dqmFQ
	 0D4fH6BtvX7KWlz1kmgRHfYXo6HV4MX7sOiiZ6N9RDIdHOW3fGVzEXzCAGUk71+B8bw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73BE606AC08;
	Sat,  7 Nov 2026 16:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E73BE606AC08
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn9ZbtTu9qIJ6BAA--.24761S4;
	Sun, 08 Nov 2026 00:16:46 +0800 (CST)
From: Wentao Liang <vulab@iscas.ac.cn>
To: Justin Tee <justin.tee@broadcom.com>,
	Paul Ely <paul.ely@broadcom.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
	James Smart <james.smart@broadcom.com>,
	"Martin K . Petersen" <mkp@kernel.org>,
	Nigel Kirkland <nigel.kirkland@broadcom.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH v2 3/3] scsi: lpfc: Return MBX status when a non-polled mbox cannot be issued
Date: Sat,  7 Nov 2026 16:16:55 +0000
Message-Id: <20261107161655.2628796-3-vulab@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261107161655.2628796-1-vulab@iscas.ac.cn>
References: <CAEQnVQn7fpgpm5zY=8ne0G5M_KXWg4qjecMK6smk-q+_0j1PEw@mail.gmail.com>
 <20261107161655.2628796-1-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowADn9ZbtTu9qIJ6BAA--.24761S4
X-Coremail-Antispam: 1UD129KBjvJXoW7CrWktFW3Zw4DJw4UtFW7twb_yoW8JFy3pr
	WxKFnFyrWDJ3W2kF12ywn8WFnIya93XrZFkFsrK34UuFykGFy5Jr4aqw12q34UJF1Ut3yr
	Aw4vga4DW3WUArUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvq1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
	w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
	IY67AKxVW8JVW5JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwA2z4x0Y4vEx4A2
	jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8JVW8Jr1le2I262IYc4CY6c
	8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jw0_
	WrylYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwI
	xGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij
	64vIr41l42xK82IY6x8ErcxFaVAv8VW8GFyrJr1UJwCFx2IqxVCFs4IE7xkEbVWUJVW8Jw
	C20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAF
	wI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjx
	v20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2
	jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0x
	ZFpf9x0JUDOz3UUUUU=
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBgIEA2rvPb4YoAABs8

lpfc_sli_issue_mbox_s4() reports a failure to hand a command to the port
with an MBX status code in every path except one: when interrupts are not
enabled and the caller asked for MBX_NOWAIT, it returns -EIO.  A negative
errno does not belong in that code space, and a caller has no MBX value to
test for this outcome.

Return MBXERR_ERROR, as lpfc_sli4_post_sync_mbox() already does for a
command it cannot post.  lpfc_issue_lip() maps MBXERR_ERROR to -EIO, and
the bsg mailbox path now converts a failure of its own, so no positive
status is handed to a caller that expects an errno.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
New in v2, at Paul's request.

 drivers/scsi/lpfc/lpfc_sli.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 715b328d3d18..05a76b00702a 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10121,7 +10121,7 @@ lpfc_sli_issue_mbox_s4(struct lpfc_hba *phba, LPFC_MBOXQ_t *mboxq,
 		if (flag == MBX_POLL)
 			rc = lpfc_sli4_post_sync_mbox(phba, mboxq);
 		else
-			rc = -EIO;
+			rc = MBXERR_ERROR;
 		if (rc != MBX_SUCCESS)
 			lpfc_printf_log(phba, KERN_WARNING, LOG_MBOX | LOG_SLI,
 					"(%d):2541 Mailbox command x%x "

