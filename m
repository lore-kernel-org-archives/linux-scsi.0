Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 282AC14A8E;
	Tue, 19 Aug 2025 02:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755570655; cv=none; b=XmrKl8C6VSNXgr8TOtlsItT+fCnb0J0jOvAm6EcaZ9waUFIbh2DlfN5zmVZpGcIRb3xp5JxsjJuXohx8zGdisTNp1iq+NKJRZP5GAKhSKJ72pV+cvI56liVEazhAEes5QFFvbasQG/JeUyudL69F2e6Ov7QIR1PgJ1ngEJbbmJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755570655; c=relaxed/simple;
	bh=b1qUQAM60cMYPl7V0ScUvR9LA9K1JoHvN22P5gTDwR0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LhrsB9D9b1/7UAfo2Dz5SKLJX9XQ+Ink5g4SLNvfFzw3Kuv3DnGp5ACiH6MRuU4kh0k6jjsZjTF7GVk+1DLLzC1lwb2i2EweEN5NDW1uu7t4IqV5hm6KmJLzpmIIREi7I3F24lS3LX3QJjHVU5U6ytPpDRFueq47fPkr1wq02KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=bkY5koch; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="bkY5koch"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Ev
	Tdpk/C0SrAV2N3VjzKTmAB7DE/+/AoiCYzOgohIRY=; b=bkY5kochVE6qKnJjFZ
	sndwQzM+WuDz7hbU03R0xWXzj9xZBUYLVlfAamQ94qBK5dp/jWbb5NtxMat57KCS
	ZhCXKRmmBiMSPBPWNxzkAZozrPlwg3Qa6jSWSibtGKu1OtzmisuRPfN0jLhs/5bS
	q0onklo+mNvkxL3DfqZf+Zcwg=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wD3d0Ow4aNo6PDgCw--.2226S2;
	Tue, 19 Aug 2025 10:30:09 +0800 (CST)
From: liuqiangneo@163.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] scsi: aic94xx: remove self-assigned redundant code
Date: Tue, 19 Aug 2025 10:30:06 +0800
Message-ID: <20250819023006.15216-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3d0Ow4aNo6PDgCw--.2226S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtryxGF4xtw4UCF48Ww4xtFb_yoWfGrc_Wr
	Wjvan7WryUJrs7Kw15Aa45Jr9Yva1xW3y8u3s0vr93A3WSvFW5Zw1DAF9rAw4kG3yYyFy7
	JrW8WF1Fkr1ktjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU11lkDUUUUU==
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbBNROuYWij31JG5QAAsM

From: Qiang Liu <liuqiang@kylinos.cn>

Assigning ssp_task.retry_count to itself has no effect

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 drivers/scsi/aic94xx/aic94xx_task.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index 4bfd03724ad6..b26a468ddc98 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -488,7 +488,6 @@ static int asd_build_ssp_ascb(struct asd_ascb *ascb, struct sas_task *task,
 	scb->ssp_task.conn_handle = cpu_to_le16(
 		(u16)(unsigned long)dev->lldd_dev);
 	scb->ssp_task.data_dir = data_dir_flags[task->data_dir];
-	scb->ssp_task.retry_count = scb->ssp_task.retry_count;
 
 	ascb->tasklet_complete = asd_task_tasklet_complete;
 
-- 
2.43.0

