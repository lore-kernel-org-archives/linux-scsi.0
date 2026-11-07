Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=159.226.251.81
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794068214;
	b=GEC75r6w7uVb07syWMP4rouVNwdf1E6szQE4BTNQ0h4ALnVkxfiRql9u67N5xrQIzeBw
	 m7HdQxxLmB9cH0YPRlgqJ+YteQEJhiqdMawTXCcTaQvE++RxKc6IRisOYZb8V0iv6Vk7X
	 DsK+fiawv2yIvWF7SmFI3Pw1uat+fkRnIesuYSwltnlGor9tdsS02k6i8D5svnaxH9gjm
	 RwFWSlO9kI7xpMDmB9c/SC44Vvj5QMmp07P0M4/AWp5V28MqQYmeiJ7Ss3vIEm+sD6EWW
	 oSJaomw5Pjz6UlS9WPylSi7WehQAGeU/iWFvlC7ChxaHDLKYXf2+/zwlM9WBv9ZO/Eg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794068214;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 X-CM-TRANSID:X-Coremail-Antispam:X-Originating-IP:X-CM-SenderInfo;
	bh=Ty6UYxoOy7N07UQ8khNszbC3k3w2RTUYHeV5mF4Bnr8=;
	b=kgJjFCt9BSfjsNukRN6DyRaoBE5/47qIk6jhNlgIgi9dbzQiAJQ/MuRMsVsqBbBCsSFc
	 2qixIPPOc3QV/lVEqLVQ/buAJy3MTCJkSQwmkf2g8i0fBZ0HjDSMl/givCGbcShTdfzN0
	 uxj/VBewmLFzwnyfTQBrZvlVy19nUeH58T6rjLfIfgCUkgNzZnCjXnwkX5afbMJNnuM3F
	 o4vygItWunSnA3N7wGUXVQqFEObi71orr1wkHW2ZAbGUgFDsFKhUYMl3ZzawBcTmtlhQW
	 Z7GiMr8JFv5NIcunWq+aEpqMzqmUmtasdKq7Y1Cn/nRHfxRJ9lOQHSg/S3jN/E38dMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=iscas.ac.cn;
	spf=pass smtp.mailfrom=iscas.ac.cn;
	arc=none smtp.remote-ip=159.226.251.81
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430F0606D3C5;
	Sat,  7 Nov 2026 16:16:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 430F0606D3C5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from dfae2b116770.home.arpa (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowADn9ZbtTu9qIJ6BAA--.24761S3;
	Sun, 08 Nov 2026 00:16:45 +0800 (CST)
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
Subject: [PATCH v2 2/3] scsi: lpfc: Report bsg mailbox failures as an errno
Date: Sat,  7 Nov 2026 16:16:54 +0000
Message-Id: <20261107161655.2628796-2-vulab@iscas.ac.cn>
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
X-CM-TRANSID:rQCowADn9ZbtTu9qIJ6BAA--.24761S3
X-Coremail-Antispam: 1UD129KBjvJXoWrtr1rXF18Aw1UAF15trWkJFb_yoW8JrWUpr
	W8GanrurZrJF1Ikry7G3s8WFnIya93Ga4qyFWqka43uFW8Kry8Jr15t3WjgFWUJF1vyr90
	yr4DWryUGr47ZwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-CM-SenderInfo: pyxotu46lvutnvoduhdfq/1tbiBwIEA2rvPocYDQAAsr

lpfc_bsg_issue_mbox() hands a command to the port with MBX_NOWAIT and, if
that does not start the command, returns the raw result to
lpfc_bsg_mbox_cmd(), which stores it in the bsg reply.  bsg-lib only
reports a negative result as an error to the ioctl caller, so a positive
MBX status such as MBX_NOT_FINISHED is passed off as success, with
device_status holding the low byte of the status and no reply data.

Report -EIO instead, as the polled path in the same function already maps
its failures to -ETIME and -ENODEV.

Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
---
New in v2.

 drivers/scsi/lpfc/lpfc_bsg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 7354ae9ba8e5..00c54a8818ed 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -5106,6 +5106,11 @@ lpfc_bsg_issue_mbox(struct lpfc_hba *phba, struct bsg_job *job,
 	if ((rc == MBX_SUCCESS) || (rc == MBX_BUSY))
 		return 1; /* job started */
 
+	/* bsg-lib only reports a negative result as an error, so a status
+	 * from the MBX code space must not be passed back to it.
+	 */
+	rc = -EIO;
+
 job_done:
 	/* common exit for error or job completed inline */
 	if (pmboxq)

