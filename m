Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D25176FA7
	for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2024 21:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729200584; cv=none; b=SZLdPERY+HUUPnqkx3WD+YYP80pJcW20VnAPTNmKgXeeP9QWF6ZEqGHORcbNAx5iO6X7gBdJ0BmwzoHKZfutMyFEp7+Nkuj7O+HLicTS6ZieO/redlf5vKVqi71kQkVjCVbzJE/LdWo3Bh5ivxULw/OoO8D5J8S9nyUpS6eFwqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729200584; c=relaxed/simple;
	bh=gmz/aP28dVxv7+zRaaMfw76XK8CLx2XyTAsOqVd26Js=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=owRfe8aH9IlwBLrtOFvLnik8CUGyEJRazZ2CdIUQCpkEYmP2QW7kdl0jU0jn6Ki4T51xCbpxCWXS4qkMRFQ2+AbZCbPCJQnLRC3fsr9ZrD0TXd4nXjod2myNWNZNjZ+7COWEGHE/Fnsdn7kmkmUFiuolAv++9aqomUVhaCTqako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iiJtdEfk; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iiJtdEfk"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XV1FC6Y9Nz6Cnk9X;
	Thu, 17 Oct 2024 21:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729200571; x=1731792572; bh=bjrF+xf5iaqb9tO+kELn57FC
	0bR1evNWsuMysFqdbwU=; b=iiJtdEfkR6Bv3JYm6o1gkmyN1wJKs/gHZtMIqePT
	5Wgsjl+dHU5Tdt17RTGLUCjVpEb/1WMwH1LZf9lKPlhwfFxena3MB81Igg9kvkO+
	LYL5U2nDhXUJvQ3DakBx741F5zf9KlKqM0RupP1YtheKv1mdlkJCEKIvbrdEgkty
	u04RAkTwifUjd+03u3qT5+nRo0f76gevmnpOnvPOZT6WbeBueR2sKPLCjrZ2g8nw
	JRqeXbwP839yC9wyskYQpSnoZwslfD9SO+GVepYh8bruqR2PhJx/PwOzwX3+kFD5
	TpFfmZjWE/rp93+XOzteMuW0/u+AfgABbPXNc3dPEqjm2A==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 79JzmjcL3K0e; Thu, 17 Oct 2024 21:29:31 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XV1F42q8sz6ClSqG;
	Thu, 17 Oct 2024 21:29:28 +0000 (UTC)
Message-ID: <879075a8-998c-4e17-b368-6023ec960d9b@acm.org>
Date: Thu, 17 Oct 2024 14:29:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] scsi: ufs: core: Fix ufshcd_mcq_sq_cleanup()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Minwoo Im <minwoo.im@samsung.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Chanwoo Lee <cw9316.lee@samsung.com>, Rohit Ner <rohitner@google.com>,
 Stanley Jhu <chu.stanley@gmail.com>, Can Guo <quic_cang@quicinc.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-7-bvanassche@acm.org>
 <DM6PR04MB65756D0B96314EF126162948FC472@DM6PR04MB6575.namprd04.prod.outlook.com>
 <d97543f4-f394-423d-9ea0-819ddaeb7749@acm.org>
 <DM6PR04MB657523DB92B671DD8F06723EFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB657523DB92B671DD8F06723EFC472@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 11:07 AM, Avri Altman wrote:
> I was just pointing out that after your change, the extra info of RTC will no longer be available,
> And proposed a way in which we can still retain it.

Something like this change?

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 57ced1729b73..988400500560 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -572,14 +572,18 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int 
task_tag)
  	/* SQRTCy.ICU = 1 */
  	writel(SQ_ICU, opr_sqd_base + REG_SQRTC);

-	/* Poll SQRTSy.CUS = 1. Return result from SQRTSy.RTC */
+	/* Wait until SQRTSy.CUS = 1. Report SQRTSy.RTC. */
  	reg = opr_sqd_base + REG_SQRTS;
  	err = read_poll_timeout(readl, val, val & SQ_CUS, 20,
  				MCQ_POLL_US, false, reg);
  	if (err)
-		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%ld\n",
-			__func__, id, task_tag,
-			FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));
+		dev_err(hba->dev, "%s: failed. hwq=%d, tag=%d err=%d\n",
+			__func__, id, task_tag, err);
+	else
+		dev_info(hba->dev,
+			 "%s, hwq %d: cleanup return code (RTC) %ld\n",
+			 __func__, id,
+			 FIELD_GET(SQ_ICU_ERR_CODE_MASK, readl(reg)));

  	if (ufshcd_mcq_sq_start(hba, hwq))
  		err = -ETIMEDOUT;

Thanks,

Bart.
