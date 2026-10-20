Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.133.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792467517;
	b=gUs5m5eE+KRVEj3vTy1cvDckez1JQ/Ykng4TOhKrgW1tD5pbKRL3YR//DO9xN83gSieL
	 alfcdZFUy7cljo7howE1FFG0StzyvgsfA1XRCRwedz5Av2cEQ6H2BahhZookrOi/Tjo+0
	 oEq0Uud/25wAsOGp0XKlqRGM95DdWlqCGPzeE7h+jTHYzIAVi1rpXqE+YOcIgX774Nz9w
	 vIE5p+E+rCEKeFQ98cQUYDsLjDNLO8DqSPlHR6Gu+k9JAliS9MPpxIBFEyulTOm1XwfPk
	 Hl4vKtxuwfe8WLQ+DbK5eRcMPrjBH3w0jBDnxKmOM3DAIcVKLVQlO8x9J9lfpyoBIFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792467517;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=LyqF35HBbNaPNhpu9vnIOGXj1BnAm17RWcd5cz7Cexs=;
	b=QSJGTNaMghfX/UUksTlOSEcxYSYmlXBnsFtKYKPB4lJ6tqpKaHRqLYCvG7dtQlogc+er
	 g/wVWa0zIHbDgNnUL74DIHAPX6wysYfqH3rmMFxQ0VPlaOYKkl6AWWJDSPXGxb9kz8P7U
	 xHBzgEnKGsH0//7KEtk4LeFeNZyDgVEGdoMEiPTxyOGngcwP7Y/0Ba2ChQ++UzEJ8IIH+
	 3sDFbE3GBsUM1ic11LnX/8WCjEZBRpUxIuBxMm8/k2Pq/l1TuzfXWvZyDd1jNDEB2/77B
	 hN3shCzU1iLyJr3+2xLO7FVsmnho05uD9aevDv2W8kfRk7xAXMWpE/c6Eu1OF8ruA6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c+UIW8ar;
	arc=none smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657C9606A319
	for <linux-scsi@vger.kernel.org>; Tue, 20 Oct 2026 03:38:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 657C9606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=c+UIW8ar
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792467515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LyqF35HBbNaPNhpu9vnIOGXj1BnAm17RWcd5cz7Cexs=;
	b=c+UIW8aroxd/4C59G0YD46dcW03+WKFRNy4rIGU1OtsOrcIWSbCEiVrSfbYhaVS27KPE9i
	iYntoQ43IGH/ekLX6szWyUClsXcCwX+t6de2B9inVJHnWKbbr56oFE6y8NJxGJeIfsIkkt
	xF0nsG/vl7s3tfPCuxxFdODZnmcemBc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-650-cwd6YC4LNKmXMtTHq6aIhQ-1; Tue,
 20 Oct 2026 03:38:31 +0000
X-MC-Unique: cwd6YC4LNKmXMtTHq6aIhQ-1
X-Mimecast-MFC-AGG-ID: cwd6YC4LNKmXMtTHq6aIhQ_1792467510
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1195F1955DE9;
	Tue, 20 Oct 2026 03:38:30 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 7D67E18001CA;
	Tue, 20 Oct 2026 03:38:28 +0000 (UTC)
Date: Mon, 19 Oct 2026 20:38:27 -0700
From: Chris Leech <cleech@redhat.com>
To: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, 
	"lduncan@suse.com" <lduncan@suse.com>, "michael.christie@oracle.com" <michael.christie@oracle.com>, 
	James Bottomley <james.bottomley@hansenpartnership.com>, "mkp@kernel.org" <mkp@kernel.org>
Subject: Re: [PATCH] scsi: libiscsi_tcp: prevent R2T range check overflow
Message-ID: <20261019-purging-charm-a883db232701@redhat.com>
References: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB5PR08MB100629CD3750FBF71475B5224FD982@DB5PR08MB10062.eurprd08.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Oct 19, 2026 at 09:30:33PM +0000, Ratnaker Gautam wrote:
> An iSCSI target controls the R2T data offset and length as 32-bit
> values. Adding them before comparing the result with the SCSI data
> buffer length can wrap. An R2T with offset 1 and length U32_MAX then
> passes the check for a 4096-byte write.
> 
> The transmit path treats the wrapped range as valid, exhausts the
> command scatterlist, and dereferences the NULL next entry in
> iscsi_tcp_segment_done().
> 
> Check the offset first, then compare the length with the remaining
> bytes in the data buffer.
> 
> Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ratnaker Gautam <ratnaker.gautam@kuleuven.be>
> ---
>  drivers/scsi/libiscsi_tcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index d35f93451ee9b..3c9e736d45e7e 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -601,7 +601,8 @@ static int iscsi_tcp_r2t_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  			      data_length, session->max_burst);
>  
>  	data_offset = be32_to_cpu(rhdr->data_offset);
> -	if (data_offset + data_length > task->sc->sdb.length) {
> +	if (data_offset > task->sc->sdb.length ||
> +	    data_length > task->sc->sdb.length - data_offset) {
>  		iscsi_conn_printk(KERN_ERR, conn,
>  				  "invalid R2T with data len %u at offset %u "
>  				  "and total length %d\n", data_length,
> -- 

Acked-by: Chris Leech <cleech@redhat.com>

