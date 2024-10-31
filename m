Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34C6B1487E1
	for <linux-scsi@vger.kernel.org>; Thu, 31 Oct 2024 21:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730409334; cv=none; b=NvOEBBO1ZoY7aPQTD9jXfWcBqWw1xUzbKsqRPET8D/eFGuFKPQc+ZbeLzcV+R3pU/XZuYOvAf8qitU0Xsl3enCkBo4efLrmPN2lrSEsigs/qfy5WWHcH8bpjqAEcJBGlyDfosm/FtniYZgZ9nlvevJcqwzXBNA9k+M9p27ghdF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730409334; c=relaxed/simple;
	bh=DN64ARs/8PxlNndpi/Ttx88SHCT0s0tyyTtal9IwXwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sWFDt7sgoj3I+C08gsm6cSdx20iqn6qpKruPV5E+EPxLw0nPB66AZywaadkMpnWa3UH0wWpzGoPjx+xbRgQjOQ7D32/3u4TyKt9zs9nW/4m7PKIjiOkUwpD/UJdi5AjxAbJ8ORhSWus8ER3jpg8CU/ikfGFAw2y1aDORVdGp/UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=4lY+LPYL; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="4lY+LPYL"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XfcGR40rjzlgMVQ;
	Thu, 31 Oct 2024 21:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730409325; x=1733001326; bh=/wPtIKpzevbMaO7jnwHAYrXc
	PVvjgFpH77laAUFVpuA=; b=4lY+LPYL7LvQ0yln6SkLcURjYy8XV14qBaDenqFi
	m97LAqoPqYNEM1/K6TtyeTCy7pdYrBqEVyaZdIffNpVVPhkcfmCRJwiHboT7lJja
	PZ9iycoozGN1jSSOJ1M3MZOpWTo2p8A7k8qnCAzFfFGJFy4OSd9dHzwe5v5LjLJc
	EVFILdacrEipu9Unkuwbn0WIj0nNHi+p4g1Ka4qnDz9I/Jrcj96eUCXwbmoYlhGD
	vgGdfyJjPFs77aa3MQDf3QKrUEeEYKBVtYLJl+3CEY3OCtympQlkhe8g+BlzNsJa
	VvkRo+4C5zoysYIsOehkjL+LvPvl3JQ5S/rHxmpLlwcVNA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9KpWWuIA6MsP; Thu, 31 Oct 2024 21:15:25 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XfcGM67zCzlgTWK;
	Thu, 31 Oct 2024 21:15:23 +0000 (UTC)
Message-ID: <6b20595d-c7f6-42aa-922e-3671abd7917c@acm.org>
Date: Thu, 31 Oct 2024 14:15:20 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/11] scsi: ufs: core: Move code out of an
 if-statement
To: Neil Armstrong <neil.armstrong@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>
References: <20241016201249.2256266-1-bvanassche@acm.org>
 <20241016201249.2256266-12-bvanassche@acm.org>
 <0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org>
 <afaca557-6b7f-4f48-a38a-19eca725282f@acm.org>
 <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <19b75e1d-bc36-494d-a33a-d36a1646bcc7@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 10/31/24 12:55 PM, Neil Armstrong wrote:
> Le 31/10/2024 =C3=A0 18:51, Bart Van Assche a =C3=A9crit=C2=A0:
>> Is the patch below sufficient to fix both issues?
>=20
> Yes it does!

Thank you for having tested this patch quickly. Would it be possible
to test whether the patch below also fixes the reported boot failure?
I think the patch below is a better fix.

Thanks,

Bart.


diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index a5a0646bb80a..3b592492e152 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -874,7 +874,8 @@ static void ufs_qcom_advertise_quirks(struct ufs_hba=20
*hba)
  	if (host->hw_ver.major > 0x3)
  		hba->quirks |=3D UFSHCD_QUIRK_REINIT_AFTER_MAX_GEAR_SWITCH;

-	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc"))
+	if (of_device_is_compatible(hba->dev->of_node, "qcom,sm8550-ufshc") ||
+	    of_device_is_compatible(hba->dev->of_node, "qcom,sm8650-ufshc"))
  		hba->quirks |=3D UFSHCD_QUIRK_BROKEN_LSDBS_CAP;
  }


