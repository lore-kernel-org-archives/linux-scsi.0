Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111192DC338
	for <linux-scsi@vger.kernel.org>; Fri, 14 Nov 2025 18:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763145596; cv=none; b=E8PHRGFguBpy1nEWec3QQG5R02uA3UthqxSoRnqkDYLQAO6PWI6A+hCluN0Snqt5muPKnnpAXh7QCZFuafd2Dna/pc+X5KZy4oFDsZNhbuQn/Ep7auA/LXFwTMxMI7rHxWKjZMnK/2zWA8f8Iab0YkXs+KcwiAYPGik//elu0+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763145596; c=relaxed/simple;
	bh=+/yWdu0RLp3xen/mn5+sfukUFvJZfDI453D2XxwluNc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQ/VCOyqotAPozB/pqEA3JUyG3Ct3YRqxr1NCJkz1CI7L12HBUFbDzIHzCik8hUG/BdIYVRMavZlabsVuzu4xZU4EyQN4beGmTeKjaCpi+gNy6uZRa312kLoLXvPByeLpS/Rhz4VczxGlRq2vxGOIjw44CeUu/DbI+1ZfTrgcFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=cRtt4evX; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="cRtt4evX"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4d7Qsv2Tn6zltH9b;
	Fri, 14 Nov 2025 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1763145585; x=1765737586; bh=QIqA3mceH8ZWf0XNtMiyBMs8
	CQdAshGm4qxM6wUXLWs=; b=cRtt4evXzR1B9bhbuCbaGg6IqEUN0SWvTUs9J+Dw
	zy3gg2Yc7yBdGqHhS6TjFx6FO7x8zSJjbTWSGXwcWzZ6IYnVje4mJZE+jZZmKjzt
	fXne+4GUp8BMh5JTGhuqKbOEIRDotDoxkEAA6Krwwm0KHp8513oZsgHEdB1DUbh2
	EyXYkTURWvbK2V8vdh31dA1KFu+DHk64Al+7lRAd3X+g238A2pWfGlykaxbDW7rm
	pbpWB/weHrXbMASfmd8CzEji0kDtjm4ugQ5yQnPy6puBUDmY9iB1lTX/PET1NNYK
	FxxbkUuv3hZpLE/4WIO2qvmlBB5vq/S1kyqt+0Oqjhd1kg==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id RTBKebGtu96h; Fri, 14 Nov 2025 18:39:45 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4d7Qsk5Y9vzlv61m;
	Fri, 14 Nov 2025 18:39:37 +0000 (UTC)
Message-ID: <2a2aef4e-288f-4dec-8ab1-fbc95bc1f880@acm.org>
Date: Fri, 14 Nov 2025 10:39:36 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Marek Szyprowski <m.szyprowski@samsung.com>,
 =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <CGME20251114101226eucas1p162ea659808485e0f18dc0a482143d8f5@eucas1p1.samsung.com>
 <c988a6dd-588d-4dbc-ab83-bbee17f2a686@samsung.com>
 <83ffbceb9e66b2a3b6096231551d969034ed8a74.camel@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <83ffbceb9e66b2a3b6096231551d969034ed8a74.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 11/14/25 9:32 AM, Andr=C3=A9 Draszik wrote:
> The commit that makes it crash is:
>=20
>    08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
>=20
> the ones leading to it just fail probe.
Marek and Andr=C3=A9, thanks for having reported this issue.

The series is not bisectable, which is unfortunate.

Please help with testing the patch below on top of the entire patch
series, e.g. on top of linux-next:

diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-pri=
v.h
index 681426fde603..f385d85d3f95 100644
--- a/drivers/ufs/core/ufshcd-priv.h
+++ b/drivers/ufs/core/ufshcd-priv.h
@@ -380,7 +380,12 @@ static inline bool=20
ufs_is_valid_unit_desc_lun(struct ufs_dev_info *dev_info, u8
   */
  static inline struct scsi_cmnd *ufshcd_tag_to_cmd(struct ufs_hba *hba,=20
u32 tag)
  {
-	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags;
+	/*
+	 * Host-wide tags are enabled in MCQ mode only. See also the
+	 * host->host_tagset assignment in ufs-mcq.c.
+	 */
+	struct blk_mq_tags *tags =3D hba->host->tag_set.shared_tags ? :
+		hba->host->tag_set.tags[0];
  	struct request *rq =3D blk_mq_tag_to_rq(tags, tag);

  	if (WARN_ON_ONCE(!rq))

Thanks,

Bart.
