Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3DF1E1A33
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761659862; cv=none; b=LmJVPFoqZj9ddaHrgXoRut/Z7KpdGWYj3cF1OOFmMvnknu1+YpxA6EhyyVuoTl2meOqlk3U9ZBWqP+S7D1Ls3T5moAdVk6WQnYXivBpvonJW+BW7ldaey5NhxZvh9eT/1qW+HLLqkkloA/zT+h1XNEaPS1MtQ9WBTNusP5ybr2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761659862; c=relaxed/simple;
	bh=z+x2ilWcRDkEggKoqQ2T8rbYh0i/fzEC2GHAREkDqjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XyLLJhAvBV6zDJiInSAjOPUiJG9Ztdthk3eRhT3nGLW2ZNfLxfu94qvOBAcX6C585cS+vqFSu+WpUDHihbg/iYMvU6MVTKU9RFFcCi9DX8AhrW1WLP9MTIvwlZFJMgMKx5TMv8sgy02nIUj4zUkOBZ/u/36uYtvryLssbIY3Eic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QP2/9d2x; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QP2/9d2x"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cwsQC1mxrzlgqTr;
	Tue, 28 Oct 2025 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761659855; x=1764251856; bh=bQoOwoaZacn/4uM3rvKBecq0
	q2rHuMZBwqULheEU+40=; b=QP2/9d2xNrWnXsh6NIWcUgO+AlvMi0+oPZQQxuHI
	LSllXuot5xGbyf0FsX91I+N/SjtHIenhqJuIBA7885Ecy+TTmvDToClO/cv34DfR
	+XjMAS5S9uMoufqEeAaB58Y+EUr2+evmjYVqwduwmOQl2FvnaXVdFtmxHH7w4JgV
	9fwFHNu/6Zy/rCCHW8szuLjOsi1weTtX0c4QJg1f4yK5q6KmRRRm6zHKlYaIRycB
	xNfq76EdRy1XcDIlmJSAP13WZGBqP2EHg4yc8Vk/mEqvKVr6/4Rw2giNztr5zJKU
	D1wGGtWDC18s5ZOJ424UflqavXA5bmmzJ9/jSIBCszD/JA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lGCy6S5QJSVY; Tue, 28 Oct 2025 13:57:35 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cwsPg06VdzlgqW0;
	Tue, 28 Oct 2025 13:57:09 +0000 (UTC)
Message-ID: <6acc1879-ebb9-4e51-bbe9-3824f8f1711f@acm.org>
Date: Tue, 28 Oct 2025 06:57:07 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid"
 attribute group
To: Bjorn Andersson <andersson@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Daniel Lee <chullee@google.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Huan Tang <tanghuan@vivo.com>, Avri Altman <avri.altman@wdc.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Gwendal Grignou <gwendal@chromium.org>, Liu Song <liu.song13@zte.com.cn>,
 Bean Huo <huobean@gmail.com>, Manivannan Sadhasivam <mani@kernel.org>,
 Adrian Hunter <adrian.hunter@intel.com>, Can Guo <quic_cang@quicinc.com>,
 Eric Biggers <ebiggers@kernel.org>, Nitin Rawat <quic_nitirawa@quicinc.com>,
 Neil Armstrong <neil.armstrong@linaro.org>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
 <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/27/25 8:03 PM, Bjorn Andersson wrote:
> So, unless I'm missing something with regards to the error handler that
> you refer to, I think you should solve this problem in ufshcd_init(), by
> making sure that syfs attributes are created before the
> ufshcd_device_params_init() call.

Something like this? (needs more work to make sure all state information 
that can be modified through sysfs has been initialized before the sysfs 
attributes are added)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 5d6297aa5c28..3ad258922036 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10800,6 +10800,8 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
          */
         ufshcd_readl(hba, REG_INTERRUPT_ENABLE);

+       ufs_sysfs_add_nodes(hba->dev);
+
         /* IRQ registration */
         err = devm_request_threaded_irq(dev, irq, ufshcd_intr, 
ufshcd_threaded_intr,
                                         IRQF_ONESHOT | IRQF_SHARED, 
UFSHCD, hba);
@@ -10887,7 +10889,6 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
         if (err)
                 goto out_disable;

-       ufs_sysfs_add_nodes(hba->dev);
         async_schedule(ufshcd_async_scan, hba);

         device_enable_async_suspend(dev);

> PS. How come these are attributes on the host device and not on the SCSI
> host device (i.e. ufshcd_driver_template::shost_groups)? It seems like
> more structured place to have such properties, and would avoid having to
> dynamically create/destroy them from the ufshcd driver itself.

This choice was made before I started contributing to the UFSHCI driver.
I'm not sure why this choice has been made. If we would start over from
scratch, I think the UFSHCI attributes should be added to the UFSHCI
device instance and the UFS attributes should be added to the SCSI host.
Today the sysfs attributes created by the UFSHCI driver are a mix of
UFSHCI and UFS attributes.

This is a change we can't make today because it would break user space.

Thanks,

Bart.
