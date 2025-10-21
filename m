Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C17A341655
	for <linux-scsi@vger.kernel.org>; Tue, 21 Oct 2025 15:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761058889; cv=none; b=H38qP20L5XHhFsA9SrnrnEDgs5AgY2126fv3psUImtfS8409JBdmdkTwjG5bhVndGyaJSG4Gu+GLe7E90YNijfx9xgDt9AgelWqp3mGsAGRRyuq3kC9ISXEeg+jd1cvKhgdJBrsEnoEp67ZztIKaItCHmfJyYLC/Xzut3tHFbKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761058889; c=relaxed/simple;
	bh=tDEYSndoMWfy2rdUfaONhK/wrhs6AmC9pmb4b71j6us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCwD4XaQ5FfwZxhJerh2iJw5B7Lz+4mlyemcuGnPHnyhn8MDD63gsCCDlpkesFbc6qHkYmS/a86EfbwImPlPncsPx72I2aGBTIT9/y3IbwdxcSH3WpuEN+Dubv1RMHUqrZ53hCTyiYhdZbo4Ah1N9x/InVcsomZQvFDjyC+UFQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DhJlXhzW; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DhJlXhzW"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4crb902VZ8zm0NB9;
	Tue, 21 Oct 2025 15:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761058882; x=1763650883; bh=CjcRfqb+ro1DE8jrnYnTNNMd
	qWZKS583eGp4qU3haYI=; b=DhJlXhzWypHieZc5+fGFOkyx+G7P1bt2qRNB8Es5
	LopJElMLZKfCgXEy7SFRf/Y2O5TYtXCo7q6I1GTCUdzZ5QMrHBHgixNp7D48GXhE
	wfujqw9I95/AocM/bsFpW/pVj19AX+zCgR7HApYKQcisEdxNCbNTHBsdlWeXK8HN
	Wx3iggxP1h1hu7IthWI0Bs8t42A451IbqYM/2Lq32/V6ThJrUoVmu+27RmfMAHqE
	yDrTATUd4fHzk6LpS2o3/FWRa59b+5yy+ku0SfIJ0GJl1xgUdKjVbLCALzLrlLHV
	RvBU2QguZfRW/o4O84fxaQF7GM/CXMtMvuUgBGeeaobuwQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Ce058pUmQ0vE; Tue, 21 Oct 2025 15:01:22 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4crb8k41x7zm0yt6;
	Tue, 21 Oct 2025 15:01:08 +0000 (UTC)
Message-ID: <c80b73bc-b52a-4735-ba04-c1e7f6a353e0@acm.org>
Date: Tue, 21 Oct 2025 08:01:06 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] ufs: core: Fix a race condition related to the "hid"
 attribute group
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "chullee@google.com" <chullee@google.com>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>
References: <20251014200118.3390839-1-bvanassche@acm.org>
 <20251014200118.3390839-2-bvanassche@acm.org>
 <22dd7d580444be92d0029694468cdddf1ac98f13.camel@mediatek.com>
 <569fcd05-4d77-468a-bc8d-c86d0a5dfc8c@acm.org>
 <bc0ac3e9f44bb3c6e0f06efd7372b21535ac07a9.camel@mediatek.com>
 <62ec19d2-f7ee-445d-be97-098acc1f390b@acm.org>
 <c47fcb9200d4e969b8200a8c2cb4a4af35883047.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c47fcb9200d4e969b8200a8c2cb4a4af35883047.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 10/20/25 8:04 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> On Mon, 2025-10-20 at 09:13 -0700, Bart Van Assche wrote:
> Apologies, I missed the HID patch. However, this change will
> not affect only HID; other sysfs groups, such as
> ufs_sysfs_device_descriptor_group, should also be updated?
Hi Peter,

Calling sysfs_update_group() is only necessary for sysfs groups that
define an .is_visible callback and only after the input parameters for
these callback functions have been modified. Here is an overview of the
groups in which an .is_visible callback has been defined:

$ git grep -nHw is_visible drivers/ufs/core/ufs-sysfs.c
drivers/ufs/core/ufs-sysfs.c:1955:	.is_visible =3D ufs_sysfs_hid_is_visib=
le,
drivers/ufs/core/ufs-sysfs.c:2048:	.is_visible =3D=20
ufs_unit_descriptor_is_visible,

The ufs_sysfs_hid_group is the only group for which the=20
sysfs_update_group() function ever has to be called.

 > Would it be better to ensure that ufshcd_async_scan
 > completes before invoking ufs_sysfs_add_nodes?

That would make the sysfs attributes unavailable if the LUN scan hangs.

Thanks,

Bart.
