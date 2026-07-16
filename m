Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869BB3BFE50
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209814; cv=none; b=ML0UIi9VWpThu+PAx562YD2qYpPDPcKfGPRRMBWr6DMheHeL/dXeX+0atmPDVagkLo+PPkodtfEaSH1Zfud5zdLKkT1E0UqHCqxzmTX05nLErY/5OT2P/cZ7j8KmJCCi4RudsJoIptU03zYLrw1d0Eu4E7yv8ol14DXuqAiqnhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209814; c=relaxed/simple;
	bh=LJxGu1vn90ST96aZbvIRyVL/x3H2tfmqZwYvDjzuR1c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PUGp8bqMpsii786zOCmin2lrRbMifOuelsox9s/oeFoOKlB+iREu/GQRACL39uwmI3dgOko38hrc8k8bkIfKEoW+KZTDiDDpeNpptm/PN2yo5rBz0Qy2nxHGB3S8YRsta9cP7I+ws/P6MeywnotggNvfhS/RXDKjujJjionsxjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=U6aWzhPi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="U6aWzhPi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784209810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lnu17VggMDCixOLGEi8Gq9H8XG41huN0NcOgMzjCJTA=;
	b=U6aWzhPinpvff82hCQJsZV63Dc7e8Lb1e79GpcZhzBC64OV2BY92HI9jxIR+2u+eEv7ahx
	oqoGEMDXUuvSXldrXFj1/+MaqkJcz/6E0lGJ1hdpCf4PUNOKzmdftjZ0EVXUqAWOUqAaD6
	jZBjXt7QI9W1QeM26M2MiXLmvm79xL8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-490-NqLtMDllPQmX3G8VQHXPUQ-1; Thu,
 16 Jul 2026 09:50:07 -0400
X-MC-Unique: NqLtMDllPQmX3G8VQHXPUQ-1
X-Mimecast-MFC-AGG-ID: NqLtMDllPQmX3G8VQHXPUQ_1784209805
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9BB80180074B;
	Thu, 16 Jul 2026 13:50:04 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id BD1C642D;
	Thu, 16 Jul 2026 13:50:02 +0000 (UTC)
Date: Thu, 16 Jul 2026 06:50:01 -0700
From: Chris Leech <cleech@redhat.com>
To: HyeongJun An <sammiee5311@gmail.com>
Cc: Mike Christie <michael.christie@oracle.com>, 
	Lee Duncan <lduncan@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: bound SCSI Response data segment
 to the connection buffer
Message-ID: <20260716-tinsel-detective-7953f0311400@redhat.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com>
 <20260716065848.1653431-1-sammiee5311@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260716065848.1653431-1-sammiee5311@gmail.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Thu, Jul 16, 2026 at 03:58:48PM +0900, HyeongJun An wrote:
> iscsi_tcp_hdr_dissect() receives the data segment of several PDU types
> into the fixed-size conn->data buffer, which is allocated for
> ISCSI_DEF_MAX_RECV_SEG_LEN (8192) bytes.  For the LOGIN_RSP, TEXT_RSP,
> REJECT and ASYNC_EVENT opcodes the dissect path already rejects a PDU
> whose DataSegmentLength exceeds that buffer.
> 
> The SCSI Command Response (ISCSI_OP_SCSI_CMD_RSP) path also copies its
> data segment (sense/response data) into conn->data via
> iscsi_tcp_data_recv_prep(), but it does so without the same check.  The
> only upstream bound on in.datalen is conn->max_recv_dlength, the
> initiator's advertised MaxRecvDataSegmentLength, which is commonly
> negotiated well above 8192 (open-iscsi defaults to 262144).  A target
> that returns a SCSI Response with a DataSegmentLength between 8193 and
> max_recv_dlength therefore overflows the 8192-byte conn->data buffer.
> 
> Once the same bound applies, ISCSI_OP_SCSI_CMD_RSP is handled exactly
> like those responses: bound the data segment, receive it into conn->data
> when present, and otherwise complete the PDU with no data.  Fold the
> opcode into that case group rather than duplicating the check.
> 
> Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
> Suggested-by: Chris Leech <cleech@redhat.com>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
> ---
> v2: Fold ISCSI_OP_SCSI_CMD_RSP into the LOGIN_RSP/TEXT_RSP/REJECT/
>     ASYNC_EVENT case group instead of duplicating the bounds check, as
>     suggested by Chris Leech.  The handling is identical: both bound the
>     data segment to conn->data, receive it when present, and otherwise
>     complete the PDU with no data (the latter via the LOGOUT_RSP
>     fallthrough).  No functional change from v1.
> 
> v1: https://lore.kernel.org/all/20260710050645.1194212-1-sammiee5311@gmail.com/
> 
>  drivers/scsi/libiscsi_tcp.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)

Acked-by: Chris Leech <cleech@redhat.com>

