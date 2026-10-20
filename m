Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792505145;
	b=o3yYfIJdrn5WT/0xnJx1GLjtQKSegNKDgdXFEItvgOyptWIwWaZogETzqcycahqpOv38
	 ErAHKjxzlRIUsMcKl8iRR778AwhyBHlKd9E7X7gxANFltBHf4ENlP1/e3H5BG38GKbTBe
	 CqtMrLWzsSj7oKutoOvqUwlhwtabUmmR5Kn+80zf9HLIo2pP8x3AXu8ZEKVyOGJ/N/3fV
	 CpWviMWuwJQ35GEFDHqE1Bt1Qd/msSk1GK+MCTmn4iKYQamKeLl3GC/sHwT0svCyGJQPW
	 1uZy6GJphXXI9mZXeS/uz1JudS42759CHWits1avv8JAsfpHDVqQQRgP6r0CyhFCbkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792505145;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:
	 Organization:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Scanned-By;
	bh=EzcGp7Kbzt9VVE/SSNZUi1NWltKbEoOVGaAFY0/5BdM=;
	b=Y7F4QwAS+lYP+Irh7RAtXID5bJqkR16wCV528rmegh/gVrEohBIazK5kudMnuEwyP/O8
	 DUPG7AqMhZsxo0mCHehX18y4F1fhBYOkRbjWdUb7NsQQThDLoL8OImbCnO1h+hQuk+WbZ
	 KmD5PSsj3syjykNuqeAWlBVxVK0DJ+AsGVms94rhNQKOqwDdrrQ/wkB63YchZ769hmBae
	 iTLNkfBeI6jXvUteoUdIdJ3bWk9wUm0ZZAeDcjR4dnBz1dmAO1ANmACyP/ANjrchiKgzF
	 aWBw+22hNGP665E6recNCeA9TF6G9b42sXYEi3qohWmlpwKhBj4y3Ls0dp2RdzK4EnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=R9if0G+C;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454C6606A31B
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 14:05:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 454C6606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=R9if0G+C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792505144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EzcGp7Kbzt9VVE/SSNZUi1NWltKbEoOVGaAFY0/5BdM=;
	b=R9if0G+CAdc3aobb+OUJxjfo0kFxlNzwvYnK67ZQz9t9sxz5W9cgMz7+XEsb4EoR8pxB2V
	DUHs9mJrAoNaQ/tk3qTsy8vwAYbn/y2x8ZtQ4BZEEVFifk7wgFQWw41OJU0F0QYco5T8jS
	N7+VCC8mwpsd59fejmcwg/szESIF9RA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-295-2nBZkvSWOgSZDfRCLEJOog-1; Tue,
 20 Oct 2026 14:05:42 +0000
X-MC-Unique: 2nBZkvSWOgSZDfRCLEJOog-1
X-Mimecast-MFC-AGG-ID: 2nBZkvSWOgSZDfRCLEJOog_1792505141
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 46B5C180AB0A;
	Tue, 20 Oct 2026 14:05:41 +0000 (UTC)
Received: from [100.91.223.109] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 056D530000E3;
	Tue, 20 Oct 2026 14:05:39 +0000 (UTC)
Message-ID: <0c57f850-9891-4476-ab79-ff9baedde743@redhat.com>
Date: Tue, 20 Oct 2026 10:05:39 -0400
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
Subject: Re: [PATCH] MAINTAINERS: add Laurence Oberman and John Meneghini as
 SCSI tape driver maintainers
To: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-kernel@vger.kernel.org
References: <20261020125059.1797559-1-loberman@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20261020125059.1797559-1-loberman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

I agree with this change.

Signed-off-by: John Meneghini <jmeneghi@redhat.com>

John A. Meneghini
Senior Principal Platform Storage Engineer
RHEL SST - Platform Storage Group
jmeneghi@redhat.com

On 10/20/26 08:50, Laurence Oberman wrote:
> The SCSI tape driver (st) is currently marked as orphaned. Add
> Laurence Oberman and John Meneghini as co-maintainers and change the
> status to Maintained.
> 
> Also add a link to the tape_tests repository, which contains the test
> suite used to validate the st driver.
> 
> Kai Mäkisara, the previous maintainer, has agreed to this change.
> 
> Cc: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
> ---
>   MAINTAINERS | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4ad924aeaf16..10bde5d86026 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -24576,8 +24576,11 @@ F:	include/uapi/scsi/
>   F:	include/ufs/
>   
>   SCSI TAPE DRIVER
> +M:	Laurence Oberman <loberman@redhat.com>
> +M:	John Meneghini <jmeneghi@redhat.com>
>   L:	linux-scsi@vger.kernel.org
> -S:	Orphan
> +S:	Maintained
> +W:	https://github.com/johnmeneghini/tape_tests
>   F:	Documentation/scsi/st.rst
>   F:	drivers/scsi/st.*
>   F:	drivers/scsi/st_*.h

