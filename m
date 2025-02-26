Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA77E21C19E;
	Wed, 26 Feb 2025 18:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740594528; cv=none; b=lH1JGskk06AcbqXilsRFuJkoToCKeccD7Yk7zb3l/x+u4rFE732OtjcVsHb1Y19vo04PKpJGXlNOPUqXi8W+apcJOUeTdBkZiyZWierEWLoEH1QtmathsPfF0QTVxjI6lugUOx9pFHgHEda6RIrknRye0M5RD/3OybJMFJFdxKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740594528; c=relaxed/simple;
	bh=xgLlMELhRjjgX4wSWhoOtD6ZOngS4uqiYbGhlQQhuy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t70J9t4m+ry06AuSkN05pFdW3D1vcyhZJ44UryZ1J6TVt7bIERtIVZ7TcdOAly7b/qSbXpmb6tzuAtGSBkOk+BHLaK9nx8FfqA2fzLPLVS9Do4ZKH+EQAIOVcJ/wFMP53cVvY769h8u8pUAZhHdO3hCtr2wUjWYvr9RBYDDEgNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=FbMWb8kA; arc=none smtp.client-ip=199.89.3.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="FbMWb8kA"
Received: from localhost (localhost [127.0.0.1])
	by 002.mia.mailroute.net (Postfix) with ESMTP id 4Z32zc6Vf6zmB6xx;
	Wed, 26 Feb 2025 18:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740594523; x=1743186524; bh=KyPmYbL6zItehixQFi6Llkvh
	GEJE3rfZhaDk8EUQkxc=; b=FbMWb8kAwfE3DveSTfkaX0bTjbcAPF6jJwaG2vqa
	o96YiC65ASo2GWw08BDKdO1ZG5Yk2vzbMp/AbhTCu6BwAJ32RucT98AiqNS+ZpfL
	CGcheOl5wUWIjium7kPq0OlvPcpGazTZgbzk30zwpX6/f2chNlG6lNXHx3v5wteM
	WGip9CAXkDU/5V0gfNZBljZY5AAvp9YfCPJmZETqNhXAKuTX3onRADo2FgdyRtrp
	avS+1CKwiv1Few0k5AJqxpRowSZ7u8ZoAVk27Kv5Okv2J/nhyE4EaR7AWs2xsZno
	jcWeF33yfqBZ1VON0y0oKMS+q59V5AoehkCLdGmM/vXnCQ==
X-Virus-Scanned: by MailRoute
Received: from 002.mia.mailroute.net ([127.0.0.1])
 by localhost (002.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wp3WPZv53FQq; Wed, 26 Feb 2025 18:28:43 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 002.mia.mailroute.net (Postfix) with ESMTPSA id 4Z32zZ5Pf2znSXxj;
	Wed, 26 Feb 2025 18:28:42 +0000 (UTC)
Message-ID: <125e3b04-a614-4d9d-aba4-8e08684374a8@acm.org>
Date: Wed, 26 Feb 2025 10:28:41 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: stop judging after finding a VPD page expected to
 be processed.
To: Chaohai Chen <wdhh6@aliyun.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250226065802.234144-1-wdhh6@aliyun.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250226065802.234144-1-wdhh6@aliyun.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/25/25 10:58 PM, Chaohai Chen wrote:
> When the vpd_buf->data[i] is expected to be processed, stop other
> judgments.
> 
> Signed-off-by: Chaohai Chen <wdhh6@aliyun.com>
> ---
>   drivers/scsi/scsi.c | 28 ++++++++++++++++++++--------
>   1 file changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index a77e0499b738..53daf923ad8e 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -510,22 +510,34 @@ void scsi_attach_vpd(struct scsi_device *sdev)
>   		return;
>   
>   	for (i = 4; i < vpd_buf->len; i++) {
> -		if (vpd_buf->data[i] == 0x0)
> +		switch (vpd_buf->data[i]) {
> +		case 0x0:
>   			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
> -		if (vpd_buf->data[i] == 0x80)
> +			break;
> +		case 0x80:
>   			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
> -		if (vpd_buf->data[i] == 0x83)
> +			break;
> +		case 0x83:
>   			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
> -		if (vpd_buf->data[i] == 0x89)
> +			break;
> +		case 0x89:
>   			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
> -		if (vpd_buf->data[i] == 0xb0)
> +			break;
> +		case 0xb0:
>   			scsi_update_vpd_page(sdev, 0xb0, &sdev->vpd_pgb0);
> -		if (vpd_buf->data[i] == 0xb1)
> +			break;
> +		case 0xb1:
>   			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
> -		if (vpd_buf->data[i] == 0xb2)
> +			break;
> +		case 0xb2:
>   			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
> -		if (vpd_buf->data[i] == 0xb7)
> +			break;
> +		case 0xb7:
>   			scsi_update_vpd_page(sdev, 0xb7, &sdev->vpd_pgb7);
> +			break;
> +		default:
> +			break;
> +		}
>   	}
>   	kfree(vpd_buf);
>   }

Instead of preserving the code duplication, please change this function
such that no code is duplicated. This will make it easier to cache more
VPD pages in the future. Here is an example of how this could be done
(entirely untested):

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index a77e0499b738..1365168941ed 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -487,6 +487,19 @@ static void scsi_update_vpd_page(struct scsi_device 
*sdev, u8 page,
  		kfree_rcu(vpd_buf, rcu);
  }

+struct vpd_page_info {
+	u8 page_code;
+	u16 offset; /* offset in struct scsi_device of vpd_pg... member */
+};
+
+#define SCSI_BUILD_BUG_ON(cond) (sizeof(char[1 - 2 * !!(cond)]) - 
sizeof(char))
+
+#define VPD_PAGE_INFO(vpd_page)						\
+	{ 0x##vpd_page, offsetof(struct scsi_device, vpd_pg##vpd_page) +\
+		SCSI_BUILD_BUG_ON(					\
+		!__same_type(&((struct scsi_device *)NULL)->vpd_pg##vpd_page, \
+			     struct scsi_vpd __rcu **))}
+
  /**
   * scsi_attach_vpd - Attach Vital Product Data to a SCSI device structure
   * @sdev: The device to ask
@@ -498,7 +511,17 @@ static void scsi_update_vpd_page(struct scsi_device 
*sdev, u8 page,
   */
  void scsi_attach_vpd(struct scsi_device *sdev)
  {
-	int i;
+	static const struct vpd_page_info cached_page[] = {
+		VPD_PAGE_INFO(0),
+		VPD_PAGE_INFO(80),
+		VPD_PAGE_INFO(83),
+		VPD_PAGE_INFO(89),
+		VPD_PAGE_INFO(b0),
+		VPD_PAGE_INFO(b1),
+		VPD_PAGE_INFO(b2),
+		VPD_PAGE_INFO(b7),
+	};
+	int i, j;
  	struct scsi_vpd *vpd_buf;

  	if (!scsi_device_supports_vpd(sdev))
@@ -510,22 +533,17 @@ void scsi_attach_vpd(struct scsi_device *sdev)
  		return;

  	for (i = 4; i < vpd_buf->len; i++) {
-		if (vpd_buf->data[i] == 0x0)
-			scsi_update_vpd_page(sdev, 0x0, &sdev->vpd_pg0);
-		if (vpd_buf->data[i] == 0x80)
-			scsi_update_vpd_page(sdev, 0x80, &sdev->vpd_pg80);
-		if (vpd_buf->data[i] == 0x83)
-			scsi_update_vpd_page(sdev, 0x83, &sdev->vpd_pg83);
-		if (vpd_buf->data[i] == 0x89)
-			scsi_update_vpd_page(sdev, 0x89, &sdev->vpd_pg89);
-		if (vpd_buf->data[i] == 0xb0)
-			scsi_update_vpd_page(sdev, 0xb0, &sdev->vpd_pgb0);
-		if (vpd_buf->data[i] == 0xb1)
-			scsi_update_vpd_page(sdev, 0xb1, &sdev->vpd_pgb1);
-		if (vpd_buf->data[i] == 0xb2)
-			scsi_update_vpd_page(sdev, 0xb2, &sdev->vpd_pgb2);
-		if (vpd_buf->data[i] == 0xb7)
-			scsi_update_vpd_page(sdev, 0xb7, &sdev->vpd_pgb7);
+		for (j = 0; j < ARRAY_SIZE(cached_page); j++) {
+			const u8 page_code = cached_page[j].page_code;
+			const u16 offset = cached_page[j].offset;
+			struct scsi_vpd __rcu **vpd_data =
+				(void *)&sdev + offset;
+
+			if (vpd_buf->data[i] == page_code) {
+				scsi_update_vpd_page(sdev, page_code, vpd_data);
+				break;
+			}
+		}
  	}
  	kfree(vpd_buf);
  }

