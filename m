Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C2F2DA759
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 06:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784183225; cv=none; b=Ci0mCuc7FFYISZKfgxP6OmzkDe7MlZh6zXiBClenMLvOrBiqaqD7swlq4KhLOmYAJCuqlBKLDuLa2/kSatcTSJ3FQ+LJQMbm8A+EaveYTreXlQ0TRWdW+BxqniS0tEQodOt2bUx17ujVCxrHuwd0JZ6CztWIbSH+gI0TB5hur+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784183225; c=relaxed/simple;
	bh=eKDGip+WNj2ar2dm/ZI/9tiVGyq8BT9s7vCpVo7Boc8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GfXur1G5KlY/cV5+ZVY0bHFbca9lveJ6FQijRzilkNqTwrDpjdd6hacvQIRpQS+lQoLZiyIi9jpWIW4HQT8cjoh9tIat+vhInAlsjPSbXvYQAP7Yu24Hit9R+LgrN+PeQXY1hcZAX5zNwNbqUELF1HZUJGDc72i9c7db1K5L+Po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VglBhOTf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VglBhOTf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784183221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zQUbND+mr6KS6FD06A0sSeBeL/Z+rfDO5L9Fq0+jZEU=;
	b=VglBhOTfsrwpWIlbaa690uEgeHf3g1LY96IOivkPacsbtTQEojdfNvboWquOzdGN2PLk73
	OgsnUuNS35H2i3e9EUS50TnZk/mbKGs8pSIjVbnigef2StH6ceMZ+K2hbcgdvhOqvEqWho
	WoGCSjEt3t0y5sHwvfdBuhZm+8KcgiA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-376-0kXcAtE1PHCGqUXI2fP2_w-1; Thu,
 16 Jul 2026 02:26:55 -0400
X-MC-Unique: 0kXcAtE1PHCGqUXI2fP2_w-1
X-Mimecast-MFC-AGG-ID: 0kXcAtE1PHCGqUXI2fP2_w_1784183213
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5FFAC180025C;
	Thu, 16 Jul 2026 06:26:53 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 70753195604D;
	Thu, 16 Jul 2026 06:26:51 +0000 (UTC)
Date: Wed, 15 Jul 2026 23:26:50 -0700
From: Chris Leech <cleech@redhat.com>
To: HyeongJun An <sammiee5311@gmail.com>
Cc: Mike Christie <michael.christie@oracle.com>, 
	Lee Duncan <lduncan@suse.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi_tcp: bound SCSI Response data segment to
 the connection buffer
Message-ID: <20260715-hunk-chute-465725c7e841@redhat.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710050645.1194212-1-sammiee5311@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Fri, Jul 10, 2026 at 02:06:45PM +0900, HyeongJun An wrote:
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
> Apply the same bound used by the sibling opcodes before handing the
> data segment to conn->data.
> 
> Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
> ---

Thanks, this looks correct to me.

However, with this applying the same bounds check the SCSI_CMD_RSP
handling is now identical to the LOGIN_RSP, TEXT_RSP, REJECT and
ASYNC_EVENT cases. I think it would be better to simply combine them
instead of duplicating.

I've run some iSCSI regression testing with this change, without issue.

- Chris Leech

>  drivers/scsi/libiscsi_tcp.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
> index e90805ba868f..790d11ec00bc 100644
> --- a/drivers/scsi/libiscsi_tcp.c
> +++ b/drivers/scsi/libiscsi_tcp.c
> @@ -753,6 +753,18 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
>  		spin_unlock(&conn->session->back_lock);
>  		break;
>  	case ISCSI_OP_SCSI_CMD_RSP:
> +		/*
> +		 * Sense/response data is received into conn->data, so bound
> +		 * it to that buffer like the responses handled below.
> +		 */
> +		if (tcp_conn->in.datalen > ISCSI_DEF_MAX_RECV_SEG_LEN) {
> +			iscsi_conn_printk(KERN_ERR, conn,
> +					  "iscsi_tcp: received buffer of len %u but conn buffer is only %u (opcode %0x)\n",
> +					  tcp_conn->in.datalen,
> +					  ISCSI_DEF_MAX_RECV_SEG_LEN, opcode);
> +			rc = ISCSI_ERR_PROTO;
> +			break;
> +		}
>  		if (tcp_conn->in.datalen) {
>  			iscsi_tcp_data_recv_prep(tcp_conn);
>  			return 0;
> -- 
> 2.43.0
> 

