Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D233E8334
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 17:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779904197; cv=none; b=G008JWLxdPYnUB6valaVN0IbT6AEpGXXmIXhAZn8QFBquV/CpvR2vn5uf9OHTFv3YS/Cz5stKV2YW1CpQtQw4tPyACY17Qv7j6Q1j9dsvkKH12tzjLKhBsHC2zwwm+8VbOPXBax/3Ue4tpX2z4wZg9SLFXzMoR5dwgrtet1M9Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779904197; c=relaxed/simple;
	bh=x72TnuzgLhid+oKFORst/SWEQoyLMonvtrDG9xfdGH8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=odFhtRX8LrANj3sq4LeZEprRDnD89Wdd6mRvi9W5qQztmdvxFrUkZo3Auugcwa9EY4Cg8/aCi4kkC3rkr76bslmv19+q1e7jHS24/2imOp4APVsOGlmKWii5qct1Gh/RzRwowftOn36xJRju0QY5J+TBQfTV+fDGDfBLWMEVkk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MXshjPj4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MXshjPj4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779904194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qHlUzU8QnqwNwI/35UFqfTXR9n/mfxGUoZ5D9HvNIe8=;
	b=MXshjPj4L2gk4dXRwK/+YtSpT3pUX68YBWyhHY7FqFBH5QjDoB/IHH8pxww/xbIgj0j9ip
	rJZUGaPneThaVGx6CLeVAmJaA3H2PS1YMEUJe6/qLmdzZzBdWB8+IuvWsawogGr100Dhqk
	0XfzKhVxgA7q5cLVPNer3PQPx5LKJOo=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-296-QYfd72WeP7WCsrF_vjA1QQ-1; Wed,
 27 May 2026 13:49:51 -0400
X-MC-Unique: QYfd72WeP7WCsrF_vjA1QQ-1
X-Mimecast-MFC-AGG-ID: QYfd72WeP7WCsrF_vjA1QQ_1779904190
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 04897180060F;
	Wed, 27 May 2026 17:49:48 +0000 (UTC)
Received: from [10.22.88.93] (unknown [10.22.88.93])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id F3AF730001BB;
	Wed, 27 May 2026 17:49:46 +0000 (UTC)
Message-ID: <8aae7e94-4098-483f-828d-056bbe16917d@redhat.com>
Date: Wed, 27 May 2026 13:49:46 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qedf: drop invalid skb_transport_header check to
 prevent panic
To: Nimal Prabudoss I <nprabudo@redhat.com>,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, nilesh.javali@marvell.com
References: <20260526141950.18394-1-nprabudo@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20260526141950.18394-1-nprabudo@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On 5/26/26 10:19, Nimal Prabudoss I wrote:
> During intensive FCOE Tier 1 CTC boot tests, the qedf driver triggers a
> warning assertion in include/linux/skbuff.h. This happens because the
> driver attempts to access an uninitialized transport header offset via
> skb_transport_header() under a CONFIG_DEBUG_NET environment.
> 
> Remove the invalid helper call within qedf_recv_frame() to eliminate the
> warning assertion and prevent the subsequent system panic.
> 
> Link: https://issues.redhat.com/browse/RHEL-177545

Hi Nimal. This is a private link to a Red Hat Jira issue report.  Please remove this
from you commit message.


> Signed-off-by: Nimal Prabudoss I <nprabudo@redhat.com>

Please also attribute this patch to Jesse with a `From: Jesse Taube <jtaubepe@redhat.com>`.

Not really important for this, but bnx2fc looks to have the same code and issue.

/John

> ---
>   drivers/scsi/qedf/qedf_main.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
> index da429b3a4283..f2bc0ac684e0 100644
> --- a/drivers/scsi/qedf/qedf_main.c
> +++ b/drivers/scsi/qedf/qedf_main.c
> @@ -2496,7 +2496,6 @@ static void qedf_recv_frame(struct qedf_ctx *qedf,
>   
>   	/* Pull the header */
>   	hp = (struct fcoe_hdr *)skb->data;
> -	fh = (struct fc_frame_header *) skb_transport_header(skb);
>   	skb_pull(skb, sizeof(struct fcoe_hdr));
>   	fr_len = skb->len - sizeof(struct fcoe_crc_eof);
>   

