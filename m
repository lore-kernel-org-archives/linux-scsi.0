Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793308534;
	b=O71TzLkVf+sXiBZPWv5aEUaPXPTmRBZY5GiMB5qqqWr2Y2gFv2YOXBSH0zTTqM6wRRlj
	 Phr1hgcoyn/f0LcwMdJUlLNNhV4Nc1UEi4+zEKMiEmp3dIacukEI7GTOrNaSJOqx7dNiX
	 3Nhejoyx2+qNVKZehSu2bkKC75zXefIFttxhRclbUo2T1actfzOVfsxgBwxn6M22qiMRX
	 54r28IoQB/w4cQhUuXvLT1ee3LiKkUpcf22PZ/P5u0cR0c3cZh/BSsotYai6HsmPhO/M5
	 AjZmTs41bo+LMwvD9NIi2fpXZBwsRRLjoDpU4Rl6Wq0Aw6C+H+UirzbZXGNphRlyu3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793308534;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Scanned-By;
	bh=rbgA2NhQmBBCynjtJFMb9J9STofHj6wgPgbtpbZIb+k=;
	b=gqFC4YWCvTVTCDczmX0uh0NXXzf8Mln2X+NkLKOL2508/UvtHZwhw+VFbwplQrgPYsLh
	 M+S8nBbGTJX/RO2uCw4/MuKTVC0mdUg+zUG+2drbCmQ7bdR3/CymY1Jqo9F2ocDi0u/ZM
	 9DWWlJB2qbktmj6D97dJ1GTeUCqfwzxnYMS2d51wHraFHktc5svSfk3USumxknT00EcSe
	 8CviirklV2ZEPXzHBqN5mX/UaVX4qTwaelKQ6tHVs/MF6ExiyNrakZOn0AoZEXbtNee26
	 gogCAn8Gnlwyd05Ppi6H8K/i9zbqOpEMgqJsJ6MWmq/4dr3sjxE7QSEvXZoZac2GV8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b="ZE54/ckw";
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F28606A31F
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2026 21:15:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 97F28606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ZE54/ckw
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793308532;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rbgA2NhQmBBCynjtJFMb9J9STofHj6wgPgbtpbZIb+k=;
	b=ZE54/ckw38UE671MF7583jMqg56msuKVZIQD1PDIbZXdun7FLA2eGGui16J7sjavtNsGZ3
	PwZXnynFNbUQ+rIXxsXgc/c7uu2ItU5B0eZ7+/H5vNgI7TPTA5bKPTwNdRRzhHRGDKejqA
	U3rygX1oT440FM5BsTNLEsu1cOwFCjY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-464-dZYdjsAJNVi28d-0caQj-A-1; Thu,
 29 Oct 2026 17:15:29 -0400
X-MC-Unique: dZYdjsAJNVi28d-0caQj-A-1
X-Mimecast-MFC-AGG-ID: dZYdjsAJNVi28d-0caQj-A_1793308527
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 597B51800BEE;
	Thu, 29 Oct 2026 21:15:27 +0000 (UTC)
Received: from [100.91.223.109] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7C2821955E7D;
	Thu, 29 Oct 2026 21:15:25 +0000 (UTC)
Message-ID: <f79de58b-5a3c-4b78-81d0-0e7e50adca15@redhat.com>
Date: Thu, 29 Oct 2026 17:15:24 -0400
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: qedf: Remove unesseary function call
To: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Nilesh Javali <njavali@marvell.com>,
 Manish Rangankar <mrangankar@marvell.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Nimal Prabudoss I <nprabudo@redhat.com>,
 GR-ETH-Storage-Upstream@marvell.com, Jesse Taube <jtaubepe@redhat.com>
References: <20261029160443.904468-1-jtaubepe@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20261029160443.904468-1-jtaubepe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>

Nilesh or Manish now that you are on the MAINTAINERS list for this file, can we get an ACK from you?

I really want Martin to merge this so we can move forward with some of these bugs, and he needs your ACK.

Thanks,

/John

On 10/29/26 12:04, Jesse Taube wrote:
> The result of `skb_transport_header` was unused. Calling this function
> warned when `skb_transport_header_was_set` returned false causing a
> panic on debug kernels.
> 
> Signed-off-by: Jesse Taube <jtaubepe@redhat.com>
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

