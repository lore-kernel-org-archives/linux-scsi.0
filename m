Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28A8C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 01:01:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjERBBB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 21:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjERBA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 21:00:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51BA40EF
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 18:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684371616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XnBVVpiuWHG14mH4rqkcPgBlj7wbBKhYrXpz+mzrwZY=;
        b=ctr9mJCWf2q3aaFOd6sEwYWuM0HMHowOZrjD6cjTcTl0SXcJ5XdDXZ7/YRajhrUf9jdfmP
        vZxSxzy+uxCSiKIcsTU0lhDRtvJoSG77IXS7yUaMHEt9v4CXFpPuaeNikMPGiR26g1N++y
        Q7aR2lIrGwvEgukarJeiyAzMYvBq5VQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-516-zLtw0IVvMHawBv8Z3_3X9w-1; Wed, 17 May 2023 21:00:11 -0400
X-MC-Unique: zLtw0IVvMHawBv8Z3_3X9w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1972F85A5B1;
        Thu, 18 May 2023 01:00:11 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1E44363F7E;
        Thu, 18 May 2023 01:00:05 +0000 (UTC)
Date:   Thu, 18 May 2023 09:00:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH v3 2/4] scsi: core: Trace SCSI sense data
Message-ID: <ZGV4kTms/igv9s0O@ovpn-8-16.pek2.redhat.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230517230927.1091124-3-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 04:09:25PM -0700, Bart Van Assche wrote:
> If a command fails, SCSI sense data is essential to determine why it
> failed. Hence make the sense key, ASC and ASCQ codes available in the
> ftrace output.
> 
> Reviewed-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.g.garry@oracle.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/trace/events/scsi.h | 21 +++++++++++++++++++--
>  1 file changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/include/trace/events/scsi.h b/include/trace/events/scsi.h
> index a2c7befd451a..512792317577 100644
> --- a/include/trace/events/scsi.h
> +++ b/include/trace/events/scsi.h
> @@ -269,9 +269,14 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__field( unsigned int,	prot_sglen )
>  		__field( unsigned char,	prot_op )
>  		__dynamic_array(unsigned char,	cmnd, cmd->cmd_len)
> +		__field( u8, sense_key )
> +		__field( u8, asc )
> +		__field( u8, ascq )
>  	),
>  
>  	TP_fast_assign(
> +		struct scsi_sense_hdr sshdr;
> +
>  		__entry->host_no	= cmd->device->host->host_no;
>  		__entry->channel	= cmd->device->channel;
>  		__entry->id		= cmd->device->id;
> @@ -285,11 +290,22 @@ DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>  		__entry->prot_sglen	= scsi_prot_sg_count(cmd);
>  		__entry->prot_op	= scsi_get_prot_op(cmd);
>  		memcpy(__get_dynamic_array(cmnd), cmd->cmnd, cmd->cmd_len);
> +		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
> +		    scsi_command_normalize_sense(cmd, &sshdr)) {
> +			__entry->sense_key = sshdr.sense_key;
> +			__entry->asc = sshdr.asc;
> +			__entry->ascq = sshdr.ascq;
> +		} else {
> +			__entry->sense_key = 0;
> +			__entry->asc = 0;
> +			__entry->ascq = 0;
> +		}
>  	),
>  
>  	TP_printk("host_no=%u channel=%u id=%u lun=%u data_sgl=%u prot_sgl=%u " \
>  		  "prot_op=%s driver_tag=%d scheduler_tag=%d cmnd=(%s %s raw=%s) " \
> -		  "result=(driver=%s host=%s message=%s status=%s)",
> +		  "result=(driver=%s host=%s message=%s status=%s "
> +		  "sense_key=%#x asc=%#x ascq=%#x)",

This way probably breaks userspace script or utility, maybe you can
just append "sense(sense_key=%#x asc=%#x ascq=%#x)" only.


thanks,
Ming

