Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EC9335540
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764786453; cv=none; b=B4flBl8JODhbgHFT431ckjO2NbPRjtF2l/odkzj2+G82+5YBC+y3gj/coMzFo0iLPl0Vvof95Ae6yjFXLX/4Cv/5lRlzId1p/NjA/D6d3dLAwOb9WOX7ganA5YdNY6562tL51pXPE0+wQnRg5RMRIpaG6xKt+FmOZjjDR3jatGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764786453; c=relaxed/simple;
	bh=bYgTqBrSMlQdR11h0rPkoWRAtrNonSQWrkka4mWeq7w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XRmNWRp69660xEFB8TvsR+DWEjlr7GK5uhN+QF0k1Qr79qsI7IYF44P0bJjK5sME8p3Tk/xVz7iaDqxawR3sXV+1LlDYvJfUm1AABPrMqal7qJ2Om20Aa8+8JCy78z4U8mZA3/HQkWYP47q9QrYdQP/BhSxx1IY6MO/F+v5zw3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jPnAu9FU; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jPnAu9FU"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dM5hz34HdzllCW4;
	Wed,  3 Dec 2025 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764786449; x=1767378450; bh=lKb1jhVD7++NH4dbKGkGN6Qb
	QA3E54/IGpOXJZFBc1I=; b=jPnAu9FU0CSIhfUzSimyiSn3W2Uu0ABCxCTLpLAr
	O+rU/dOFZx0ceTkvCQzSxbllE5zQS6fMOcOChPXqo1Xdg2fRhZJAbo5s1+qMKxln
	z2akh7zRfhpQySlLuzpRmtugSkSVWt4cCYxqm/R5xjYjBW9GOBsiIQE3hEv1wFTn
	HTbTx8K4C1SMGj+BCTayyiZ7ZendYywCUEOMKzRLv6XgN/342amlItxE+1Unr7aO
	dfas6UmOP/FqyfgVRidKweJx6nO+6WD0z9L5QgNSiotNWw230W8l0UubTMQVWuwn
	17dGImzFnslXbMoVkhT6u8WSGMERdQPZJDSXaBDJLXq7tA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id AIuECS-e8n31; Wed,  3 Dec 2025 18:27:29 +0000 (UTC)
Received: from [10.25.100.213] (syn-098-147-059-154.biz.spectrum.com [98.147.59.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dM5ht1jc6zlfgPY;
	Wed,  3 Dec 2025 18:27:25 +0000 (UTC)
Message-ID: <250c9b6d-dc2a-4ad6-b3b7-e29e9a2c4798@acm.org>
Date: Wed, 3 Dec 2025 08:27:22 -1000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Nitin Rawat <quic_nitirawa@quicinc.com>, Roger Shimizu <rosh@debian.org>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Nitin Rawat <nitin.rawat@oss.qualcomm.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
 <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
 <75cf6698-9ce9-4e6d-8b3c-64a7f9ef8cfc@acm.org>
 <in3muo5gco75eenvfjif3bcauyj2ilx3d6qgriifwnyj657fyq@eftlas3z3jiu>
 <d7579c22-40d0-4228-b539-4dfe4e25b771@acm.org>
 <nso6f36ozpad36yd3dlrqoujsxcvz4znvr6snqwgxihb3uxyya@gs6vuu76n6sx>
 <5c142a9d-7b41-422a-bbff-638fda1939dc@acm.org>
 <CAEQ9gEkz=Y1ksXL0wCumb7zbqXTREqJ6Vn29P-7FWS_e=iuuVQ@mail.gmail.com>
 <84b00b56-e775-43e6-a829-85e5da43508e@acm.org>
 <462fb80d-7614-41b5-aac6-2492845d7468@quicinc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <462fb80d-7614-41b5-aac6-2492845d7468@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/3/25 6:47 AM, Nitin Rawat wrote:
> I tested on other platforms - SM8650 and SM8750 , and the same error=20
> occurs there as well. Seems like the issue impacts all targets.
>=20
> I suspect the problem is related to the new tag implementation in the=20
> device management command.
>=20
> Below is the call stack observed each time the issue occurs:
> [=C2=A0 274.480707] task:kworker/u33:6=C2=A0=C2=A0 state:D stack:0=C2=A0=
=C2=A0=C2=A0=C2=A0 pid:94=20
> tgid:94=C2=A0=C2=A0=C2=A0 ppid:2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 task_fla=
gs:0x4208060 flags:0x00000010
> [=C2=A0 274.492127] Workqueue: devfreq_wq devfreq_monitor
> [=C2=A0 274.496964] Call trace:
> [=C2=A0 274.499481]=C2=A0 __switch_to+0xec/0x1c0 (T)
> [=C2=A0 274.503431]=C2=A0 __schedule+0x368/0xce0
> [=C2=A0 274.507025]=C2=A0 schedule+0x34/0x118
> [=C2=A0 274.510354]=C2=A0 schedule_timeout+0xd4/0x110
> [=C2=A0 274.514393]=C2=A0 io_schedule_timeout+0x48/0x68
> [=C2=A0 274.518608]=C2=A0 wait_for_completion_io+0x78/0x140
> [=C2=A0 274.523178]=C2=A0 blk_execute_rq+0xbc/0x13c
> [=C2=A0 274.527038]=C2=A0 ufshcd_exec_dev_cmd+0x1e0/0x260
> [=C2=A0 274.531431]=C2=A0 ufshcd_query_flag+0x158/0x1e0
> [=C2=A0 274.535646]=C2=A0 ufshcd_query_flag_retry+0x4c/0xa8
> [=C2=A0 274.540215]=C2=A0 ufshcd_wb_toggle+0x54/0xc0
> [=C2=A0 274.544165]=C2=A0 ufshcd_devfreq_scale+0x2c0/0x448
> [=C2=A0 274.548645]=C2=A0 ufshcd_devfreq_target+0xd4/0x24c
> [=C2=A0 274.553125]=C2=A0 devfreq_set_target+0x90/0x184
> [=C2=A0 274.557340]=C2=A0 devfreq_update_target+0xc0/0xdc
> [=C2=A0 274.561732]=C2=A0 devfreq_monitor+0x34/0xa0
> [=C2=A0 274.565591]=C2=A0 process_one_work+0x148/0x290
> [=C2=A0 274.569717]=C2=A0 worker_thread+0x2c8/0x3e4
> [=C2=A0 274.573576]=C2=A0 kthread+0x12c/0x204
> [=C2=A0 274.576895]=C2=A0 ret_from_fork+0x10/0x20
Thanks Nitin, this is very helpful. Is applying the patch below on top
of Martin's for-next branch sufficient to fix this deadlock?

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 1b3fe1d8655e..fd0b6b620b53 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1455,15 +1455,14 @@ static int ufshcd_clock_scaling_prepare(struct=20
ufs_hba *hba, u64 timeout_us)
  static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba, int err=
)
  {
  	up_write(&hba->clk_scaling_lock);
-
+	mutex_unlock(&hba->wb_mutex);
+	blk_mq_unquiesce_tagset(&hba->host->tag_set);
+	mutex_unlock(&hba->host->scan_mutex);
+=09
  	/* Enable Write Booster if current gear requires it else disable it */
  	if (ufshcd_enable_wb_if_scaling_up(hba) && !err)
  		ufshcd_wb_toggle(hba, hba->pwr_info.gear_rx >=3D=20
hba->clk_scaling.wb_gear);

-	mutex_unlock(&hba->wb_mutex);
-
-	blk_mq_unquiesce_tagset(&hba->host->tag_set);
-	mutex_unlock(&hba->host->scan_mutex);
  	ufshcd_release(hba);
  }


Thanks,

Bart.
