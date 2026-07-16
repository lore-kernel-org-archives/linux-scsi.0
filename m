Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0604233D4E4
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 06:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183503; cv=none; b=Vv1IzaXQDaknjzSJBJMPtxKt6xWPtl3eZONecttqbInvR/RqRdqmj9pWHC1WKUo2WkPM/sVf98RXYlaaWBFuUfcnDT37s+wDNp7c4/fisNsFn5fa3+t5ofta+eFyGl21I+jURq7+IcN4rr+H8LmtlidGaCVfhc//pabCsNyvrIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183503; c=relaxed/simple;
	bh=DouacLqS15oVpiKLyNz8MkSbt2J0vaL3eq1ADhfa9Y4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EYE60laOpGXe+OQBr5upR8oSOZMQVhUuB0l4zoybzQzswWKg5bI6EciF9h0O8FjWvlA5BGbQ1UG66gnh7IeOa+KbGGysJPF95REpyxprdl5SxyX2gwy/RPo1l1knjnhD7HcSmQpzxwDQSoUEPAMwubXuOjXPuCV0jSBx1eBMNwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VCF03Lpv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VCF03Lpv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784183501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gr1Zj1GOLdHVq5h/PHbq2Xek4XFLwqItAYQhWzGS2v4=;
	b=VCF03LpvD2WV+4LpX2iRAkMjrbGYG/QCTJCrS8ek88sc6nDmKxaKg1gN4hjfqq66c5EqDv
	DCU2QJtNOo210WriJWOYpVHL1m9fm1yJzgo7aLZ6vdA80777FanMs+55EpyW91jp+iNLvV
	egjgpX73/kRBr7ApjAP4bsT4sgKIaZs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-425--Q2cu9uzNZKnQaVfSYvRWw-1; Thu,
 16 Jul 2026 02:31:34 -0400
X-MC-Unique: -Q2cu9uzNZKnQaVfSYvRWw-1
X-Mimecast-MFC-AGG-ID: -Q2cu9uzNZKnQaVfSYvRWw_1784183492
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E0631800598;
	Thu, 16 Jul 2026 06:31:32 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 256313003EFD;
	Thu, 16 Jul 2026 06:31:29 +0000 (UTC)
Date: Wed, 15 Jul 2026 23:31:29 -0700
From: Chris Leech <cleech@redhat.com>
To: HyeongJun An <sammiee5311@gmail.com>
Cc: Mike Christie <michael.christie@oracle.com>, 
	Lee Duncan <lduncan@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Sashiko AI <sashiko-bot@kernel.org>
Subject: Re: [PATCH] scsi: libiscsi: fix stale-data leak into the SCSI sense
 buffer
Message-ID: <20260715-wieldable-expire-2ee53282aed8@redhat.com>
References: <20260714104934.1404423-1-sammiee5311@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714104934.1404423-1-sammiee5311@gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Tue, Jul 14, 2026 at 07:49:34PM +0900, HyeongJun An wrote:
> iscsi_scsi_cmd_rsp() copies the sense data of a SCSI Response from the
> target-supplied data segment.  The segment carries a 2-byte sense length
> followed by the sense bytes, so it must hold 2 + senselen bytes, but the
> bounds check only requires datalen >= senselen:
> 
> 	senselen = get_unaligned_be16(data);
> 	if (datalen < senselen)
> 		goto invalid_datalen;
> 	memcpy(sc->sense_buffer, data + 2,
> 	       min_t(uint16_t, senselen, SCSI_SENSE_BUFFERSIZE));
> 
> A target that returns a SCSI Response whose datalen equals senselen (with
> senselen <= SCSI_SENSE_BUFFERSIZE) makes the memcpy() from data + 2 read
> up to two bytes past the received data.  Those bytes are stale conn->data
> contents and end up in the command's sense buffer, which is returned to
> userspace.
> 
> Account for the 2-byte sense length prefix in the check.
> 
> Fixes: 7996a778ff8c ("[SCSI] iscsi: add libiscsi")
> Suggested-by: Sashiko AI <sashiko-bot@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
> ---

This looks like a good fix to me.

Acked-by: Chris Leech <cleech@redhat.com>

>  drivers/scsi/libiscsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 160f02f2f51d..5cbc51899de0 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -918,7 +918,7 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
>  		}
>  
>  		senselen = get_unaligned_be16(data);
> -		if (datalen < senselen)
> +		if (datalen < senselen + 2)
>  			goto invalid_datalen;
>  
>  		memcpy(sc->sense_buffer, data + 2,
> -- 
> 2.43.0
> 

