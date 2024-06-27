Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF9145BE4;
	Thu, 27 Jun 2024 20:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719519220; cv=none; b=Lc8PpXLwEsEZ2hALBFV6h4Ckvd1DC+5VJ4ielDOc8EGdKshXNygvf4IDrvtc7Yy2U3fPtRs0qUD0M7/U8WudPXKtsBdHJqQq39vMYBrngVQ7lVtEO+EMoZkGq7RrpQ1vAoyjYzuTI4qlu6gYoW5H3aSsdPbLa1Ss1Jl0sy3B42w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719519220; c=relaxed/simple;
	bh=Ng97Q+I0pBXI53ofakv3q76+W7USXRIAadE2uWbklVA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bsjELE8UdGSbKCg0QP6T6MEN5RFf+LCQ6ONSfFxSyEGy/fV9VqEv10tNiGJhLNJn4p29cVqsKjcDwawE5UNy6kGMFKZKLLUbP75p2xXyEFG4+QO0UAiU5+es6pFBieG0LwZJ+AEDPnokzv7UH2SwB8RzuQahJUfnhY0si2a/2QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=KVcWNFoV; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="KVcWNFoV"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W98sG10gQzll9bp;
	Thu, 27 Jun 2024 20:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719519210; x=1722111211; bh=mqZoJqzWOVqvKJTvVoqplSMR
	xZgZJeY21a7owxjLVCQ=; b=KVcWNFoVDLJpmL/62VRSuBGg380beoeeuBPkTGNH
	MAXXNIjk/et8UWPS3rgK+XuvrslNyXfy6ZuW3ReuMo4ZGVJTPtEwS8xb+nTVYvca
	bnIRmPTKcRiWVPtOKbqvV+eBsWsup6xZ72sEv2nBEUMORzNnPIokS4KWgG1MNsjL
	J2Qhp6pRTgIvnHri5vTjkSKNtr7Y1uKmS7Gwj4lJdGNu8iXfA9ZVFzgIRimqA8ZB
	QsTU0tTIPrX5uuhVuQd/7rMu2XjPZqehPKC67LLb5JJSGBf/+/fG38dUYc3a8u0/
	DTmhDCEaH0XUW0xeQQ2HkiPZF2+m94R2LWgt5vcTkFAocQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nPRA6YbUERSR; Thu, 27 Jun 2024 20:13:30 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W98s0515XzllBch;
	Thu, 27 Jun 2024 20:13:24 +0000 (UTC)
Message-ID: <a34bcb63-6cad-4b77-bd07-afcc2c75b2f2@acm.org>
Date: Thu, 27 Jun 2024 13:13:22 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: fix ufshcd_abort_all racing issue
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
 "haowenchao22@gmail.com" <haowenchao22@gmail.com>
Cc: "linux-mediatek@lists.infradead.org"
 <linux-mediatek@lists.infradead.org>,
 =?UTF-8?B?SmlhamllIEhhbyAo6YOd5Yqg6IqCKQ==?= <jiajie.hao@mediatek.com>,
 =?UTF-8?B?Q0MgQ2hvdSAo5ZGo5b+X5p2wKQ==?= <cc.chou@mediatek.com>,
 =?UTF-8?B?RWRkaWUgSHVhbmcgKOm7g+aZuuWCkSk=?= <eddie.huang@mediatek.com>,
 =?UTF-8?B?QWxpY2UgQ2hhbyAo6LaZ54+u5Z2HKQ==?= <Alice.Chao@mediatek.com>,
 wsd_upstream <wsd_upstream@mediatek.com>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 =?UTF-8?B?TGluIEd1aSAo5qGC5p6XKQ==?= <Lin.Gui@mediatek.com>,
 =?UTF-8?B?Q2h1bi1IdW5nIFd1ICjlt6vpp7/lro8p?= <Chun-hung.Wu@mediatek.com>,
 =?UTF-8?B?VHVuLXl1IFl1ICjmuLjmlabogb8p?= <Tun-yu.Yu@mediatek.com>,
 "chu.stanley@gmail.com" <chu.stanley@gmail.com>,
 =?UTF-8?B?Q2hhb3RpYW4gSmluZyAo5LqV5pyd5aSpKQ==?=
 <Chaotian.Jing@mediatek.com>, =?UTF-8?B?UG93ZW4gS2FvICjpq5jkvK/mlocp?=
 <Powen.Kao@mediatek.com>, =?UTF-8?B?TmFvbWkgQ2h1ICjmnLHoqaDnlLAp?=
 <Naomi.Chu@mediatek.com>, =?UTF-8?B?UWlsaW4gVGFuICjosK3pupLpup8p?=
 <Qilin.Tan@mediatek.com>
References: <20240624121158.21354-1-peter.wang@mediatek.com>
 <eec48c95-aa1c-4f07-a1f3-fdc3e124f30e@acm.org>
 <4c4d10aae216e0b6925445b0317e55a3dd0ce629.camel@mediatek.com>
 <795a89bb-12eb-4ac8-93df-6ec5173fb679@acm.org>
 <0e1e0c0a4303f53a50a95aa0672311015ddeaee2.camel@mediatek.com>
 <b5ee63bb-4db9-47fc-9b09-1fde0447f6f8@acm.org>
 <54f5df88-ca0a-40dd-92ef-3f64c170ba55@gmail.com>
 <9284fe608d6a2c35e1db50b0f7dc69d8951be5fe.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9284fe608d6a2c35e1db50b0f7dc69d8951be5fe.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 6/27/24 3:59 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> This is a chicken-and-egg problem. We need to acquire a lock to know=20
> which hwq it is, but we need to know which hwq it is to acquire the
> lock. Therefore, to resolve this dilemma, perhaps we should just take
> all the hwq locks indiscriminately?
How about the (untested) patch below?

Thanks,

Bart.

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index aa119746ee92..c5d327ba253f 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -105,16 +105,15 @@ EXPORT_SYMBOL_GPL(ufshcd_mcq_config_mac);
   * @hba: per adapter instance
   * @req: pointer to the request to be issued
   *
- * Return: the hardware queue instance on which the request would
- * be queued.
+ * Return: the hardware queue instance on which the request will be or=20
has been
+ * queued. %NULL if the request has already been freed.
   */
  struct ufs_hw_queue *ufshcd_mcq_req_to_hwq(struct ufs_hba *hba,
  					 struct request *req)
  {
-	u32 utag =3D blk_mq_unique_tag(req);
-	u32 hwq =3D blk_mq_unique_tag_to_hwq(utag);
+	struct blk_mq_hw_ctx *hctx =3D READ_ONCE(rq->mq_hctx);

-	return &hba->uhq[hwq];
+	return hctx ? &hba->uhq[hctx->queue_num] : NULL;
  }

  /**
@@ -547,6 +546,8 @@ int ufshcd_mcq_sq_cleanup(struct ufs_hba *hba, int=20
task_tag)
  		if (!cmd)
  			return -EINVAL;
  		hwq =3D ufshcd_mcq_req_to_hwq(hba, scsi_cmd_to_rq(cmd));
+		if (!hwq)
+			return -EINVAL;
  	} else {
  		hwq =3D hba->dev_cmd_queue;
  	}

