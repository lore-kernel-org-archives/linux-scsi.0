Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8C1320CCE
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532420; cv=none; b=rFPvowgZgUJLI0CT5i38QUN16L7/WZTZa6zYmScfiEhBEUjySNvZyeF8CexgQ6QV2vtH/lDQubCtfUP0LJetGdh645nj2rX5ZlCJf70H8UhHMUOZs35Sv56LkBkwJUL9vsq/G2ycHp2aRwp1jDXPt1IJC3SJpql7C7MUrHznAoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532420; c=relaxed/simple;
	bh=7/Z+SQeyyvY5/myVnjKwv5kT0jJCcxHZArP8YClRoGk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ur3/DNgFibn5cQu7pg1V8ArRe0W25m2x+eIW6BLCnAygI6pHtyY1SW+XqnGgF70a4/uUefDwlKuarowEMp91m++lRLd97EQen+FnWPWi4xCPXCt4iKlKlxAYc5JdZD3kF1AqOImhqf72NVCClNL6AYruyZICFSBWN4iMRb3QioA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NBK9QBJ+; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NBK9QBJ+"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5HLn2WCWzlgqyd;
	Mon, 18 Aug 2025 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755532415; x=1758124416; bh=O2xpc7ZMTTmLLE02LFFqQEh0
	p5nyjmFQn8TDGdEhQeA=; b=NBK9QBJ+azpnf0VmpSm2v9dFCJbVhbwTg0lhJIRD
	2TQe6p06s63r1LTpZlYY6i/hR+pzBcYtNvg1SJPngN1+Py3Z5xLgJ3l60/acE0v4
	/CYhVnU2q8IqFLAO+ReYT8Cu8+U8ON1JhxQaps7/Rjb52Ah+7/7bo7SGTN4QR8uT
	qmPgFR7uMy+qXEf0Eip+7mvmS3Zvr4KuThEgSgovQNe3j6lQbkuiMpgAZSWTofIR
	OctzabPFKNd81lT1OdeObfVgDsV0ykwyiVgnsXDf0rLjUkjpzT7ihO05LTMzLZfc
	w0wgN2UgM7SKencTf5OllMiKr/O3c9kKMcwFG/jktl8gQw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id re96urgbYWhG; Mon, 18 Aug 2025 15:53:35 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5HLd0YcGzlgqVs;
	Mon, 18 Aug 2025 15:53:28 +0000 (UTC)
Message-ID: <79cce962-b524-4624-a989-640f985669e8@acm.org>
Date: Mon, 18 Aug 2025 08:53:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "beanhuo@micron.com" <beanhuo@micron.com>,
 "cang@codeaurora.org" <cang@codeaurora.org>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "daejun7.park@samsung.com" <daejun7.park@samsung.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>
References: <20250815160049.473550-1-bvanassche@acm.org>
 <f54ba94ebb1108bfe6faf2aca7d15e69b0b4a4c4.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f54ba94ebb1108bfe6faf2aca7d15e69b0b4a4c4.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/18/25 4:56 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Should this information also be provided to
> ufshcd_print_tr for debugging purposes?
How about the patch below?

Thanks,

Bart.


---
  drivers/ufs/core/ufshcd.c | 26 ++++++++++++++++----------
  1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 714d9966431e..29a2ecb7b5b9 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -607,10 +607,12 @@ void ufshcd_print_tr(struct ufs_hba *hba, int tag,=20
bool pr_prdt)

  	lrbp =3D &hba->lrb[tag];

-	dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n",
-			tag, div_u64(lrbp->issue_time_stamp_local_clock, 1000));
-	dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n",
-			tag, div_u64(lrbp->compl_time_stamp_local_clock, 1000));
+	if (hba->monitor.enabled) {
+		dev_err(hba->dev, "UPIU[%d] - issue time %lld us\n", tag,
+			div_u64(lrbp->issue_time_stamp_local_clock, 1000));
+		dev_err(hba->dev, "UPIU[%d] - complete time %lld us\n", tag,
+			div_u64(lrbp->compl_time_stamp_local_clock, 1000));
+	}
  	dev_err(hba->dev,
  		"UPIU[%d] - Transfer Request Descriptor phys@0x%llx\n",
  		tag, (u64)lrbp->utrd_dma_addr);
@@ -2357,10 +2359,12 @@ void ufshcd_send_command(struct ufs_hba *hba,=20
unsigned int task_tag,
  	struct ufshcd_lrb *lrbp =3D &hba->lrb[task_tag];
  	unsigned long flags;

-	lrbp->issue_time_stamp =3D ktime_get();
-	lrbp->issue_time_stamp_local_clock =3D local_clock();
-	lrbp->compl_time_stamp =3D ktime_set(0, 0);
-	lrbp->compl_time_stamp_local_clock =3D 0;
+	if (hba->monitor.enabled) {
+		lrbp->issue_time_stamp =3D ktime_get();
+		lrbp->issue_time_stamp_local_clock =3D local_clock();
+		lrbp->compl_time_stamp =3D ktime_set(0, 0);
+		lrbp->compl_time_stamp_local_clock =3D 0;
+	}
  	ufshcd_add_command_trace(hba, task_tag, UFS_CMD_SEND);
  	if (lrbp->cmd)
  		ufshcd_clk_scaling_start_busy(hba);
@@ -5622,8 +5626,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba,=20
int task_tag,
  	enum utp_ocs ocs;

  	lrbp =3D &hba->lrb[task_tag];
-	lrbp->compl_time_stamp =3D ktime_get();
-	lrbp->compl_time_stamp_local_clock =3D local_clock();
+	if (hba->monitor.enabled) {
+		lrbp->compl_time_stamp =3D ktime_get();
+		lrbp->compl_time_stamp_local_clock =3D local_clock();
+	}
  	cmd =3D lrbp->cmd;
  	if (cmd) {
  		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

