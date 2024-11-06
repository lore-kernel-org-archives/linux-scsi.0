Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81ED51D5CD3
	for <linux-scsi@vger.kernel.org>; Wed,  6 Nov 2024 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730903685; cv=none; b=EkBzznNzCYgDc5ZytIzwVfUP0/B8Tm9J+tkNrWSQiWh6aZVm01dRLwDzlvQ2nhFR5+G0jtHY65yXQ8CT870ojeBlVxJq3kCQSblkMTNBDZTUkkDf+SR2D+k8ycT1CtnamYlCZJRh4ZGpcmTcM1R2LwgG1AgoOAYkrYqSIADJ5hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730903685; c=relaxed/simple;
	bh=LqAITwUYo4n/xzHTAhLyVk+/VGxS8C4gNITrgwWX0vo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BeiDDD0e6Q1vgOnNngrgUe6U8tlwdRlC5ClDO7uG5CXwMxwbbY8kxkI87wlPZCJn9kG3X7zxZmfIuleeb+bUHoN6VDosidn05ilNvq2cc7sUpJ7zgK+Pb6ZskKStbV6TlyOzHrHo2uFOV2pu7ZFn2JgEW9Np35D+Cfp+bOBeKJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OkBNBAdg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OkBNBAdg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730903682;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c7bzXvSXOb2wPhJ2iqyu0t4v5icx5XrB1K23egfe8hg=;
	b=OkBNBAdg6B3wtaQBasOi/wH9qHYAil1T3DBK7dM2zIXdq4J+mJRmjY+5Y+JAhpbesmZvxg
	8rvxw7bdyKq6qPP9/n/zHwNYZ6FNo3UVASFv5aLWcwrTAPgFRqsQyh83r5aoYcaZISVO/G
	ih9TFzAzfat+q8y5Nlfp/GIBG/jO7+Y=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-l3ev-BxpPyOujL5xejCubA-1; Wed,
 06 Nov 2024 09:34:39 -0500
X-MC-Unique: l3ev-BxpPyOujL5xejCubA-1
X-Mimecast-MFC-AGG-ID: l3ev-BxpPyOujL5xejCubA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53A13190C4CA;
	Wed,  6 Nov 2024 14:34:31 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id BF2931955BC7;
	Wed,  6 Nov 2024 14:34:29 +0000 (UTC)
Message-ID: <6ffe0589-d721-41d0-a523-60408747854e@redhat.com>
Date: Wed, 6 Nov 2024 09:34:28 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] scsi: st: New session only when Unit Attention for
 new tape
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241106095723.63254-4-Kai.Makisara@kolumbus.fi>
 <20241106102316.63462-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241106102316.63462-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 11/6/24 05:23, Kai Mäkisara wrote:
> Currently the code starts new tape session when any Unit Attention
> (UA) is seen when opening the device. This leads to incorrectly
> clearing pos_unknown when the UA is for reset. Set new session only
> when the UA is for a new tape.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index c9038284bc89..e8ef27d7ef61 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -991,7 +991,10 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
>   			scode = cmdstatp->sense_hdr.sense_key;
>   
>   			if (scode == UNIT_ATTENTION) { /* New media? */
> -				new_session = 1;
> +				if (cmdstatp->sense_hdr.asc == 0x28) { /* New media */
> +					new_session = 1;
> +					DEBC_printk(STp, "New tape session.");
> +				}
>   				if (attentions < MAX_ATTENTIONS) {
>   					attentions++;
>   					continue;

