Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202542139D7
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 20:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730837560; cv=none; b=Wyhb7BOTBmK0gvDyBkgPtviM7YGVKlWA40e1olFHvehOIXtsBsDQFRJNfb58lIM3t6qdARen47lalndDDRUvRTW1Y+GdiXqukXb6fD4wPfmKdQcOS9xqw8SEEnOUeQakn5o0PX4oCUyGpBNagKe6oKnIbsVhAxybYrCJTby8qqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730837560; c=relaxed/simple;
	bh=p8wvM01vUcS8eLbJurBAj6CZlnUHDVlRWzR/dbKFtbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O61ERGe8zcmCa48vviQyJLLUnzUQwmyH0+5eu4aVUmmv0R1cD2KyK4SSTtf1Bqgw3aPIoLVJxwdY00W57F3d2TtKfMT06KZP/NDlciyAZ8whzFvEAKdZrSt0a8JPgHg/Nd5izv/g0vgoWbilI3iiz5Jk/O1U0C3fl2q5liVblig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWOrYud9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWOrYud9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730837556;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD3vc6YsMQ8TXorzyAQ5XwmEIOoEc4kewLOJwmYpdu8=;
	b=PWOrYud9mxbTg5Etxwx6xrzI30M2z5q+0FJX4Mpi6UAPfZ/DLZB4U2JoObzHppx6Y9ZpsI
	2ciy/rZ3h1Efdx4+14Hbu43stRo47N4rnRlf5VixmCH0V7li6xvRgqArmPI/RoDnsS8+kH
	bTTLm3WXnjE6jbX6vYQtiXOpLSoDZkk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-PQ5NUtePMnCFa0IRo848dQ-1; Tue,
 05 Nov 2024 15:12:33 -0500
X-MC-Unique: PQ5NUtePMnCFa0IRo848dQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5B93A195608B;
	Tue,  5 Nov 2024 20:12:32 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D9A7E300018D;
	Tue,  5 Nov 2024 20:12:30 +0000 (UTC)
Message-ID: <185a0286-200f-426c-905a-7b9b715f9691@redhat.com>
Date: Tue, 5 Nov 2024 15:12:29 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: st: Don't modify unknown block number in
 MTIOCGET
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
 <20241104112623.2675-2-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241104112623.2675-2-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Looks great, please merge.

On 11/4/24 06:26, Kai Mäkisara wrote:
> Struct mtget field mt_blkno -1 means it is unknown. Don't add anything to
> it.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index beb88f25dbb9..8d27e6caf027 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3756,7 +3756,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   		    ((STp->density << MT_ST_DENSITY_SHIFT) & MT_ST_DENSITY_MASK);
>   		mt_status.mt_blkno = STps->drv_block;
>   		mt_status.mt_fileno = STps->drv_file;
> -		if (STp->block_size != 0) {
> +		if (STp->block_size != 0 && mt_status.mt_blkno >= 0) {
>   			if (STps->rw == ST_WRITING)
>   				mt_status.mt_blkno +=
>   				    (STp->buffer)->buffer_bytes / STp->block_size;

