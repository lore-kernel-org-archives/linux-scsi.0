Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF4D3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:21:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5E5E6115B
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhEDCWd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 22:22:33 -0400
Received: from mail-pg1-f172.google.com ([209.85.215.172]:36519 "EHLO
        mail-pg1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbhEDCWd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 22:22:33 -0400
Received: by mail-pg1-f172.google.com with SMTP id c21so1129623pgg.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 19:21:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GvA35LuG7e8SsQC3ZjnnlBhjUSffC3HOMVlLErX+xTQ=;
        b=XQPViWe0t6D5gMETAyKC7HINBCPRkBbAmAyIIcqSab4mYyYF+fup+x08tvqPlo+0G7
         VNCPtnRmKLydSZNrc/GoQaUSKztxj8JwQVsYtA6b0wq4NdeVjtI4bIRIDNmmPUNo4sPm
         ZWj0XRyNjFnxQOS/Bfpt247A1tyurAI6x6w1q+Ukygfbn7UmVtvARtSyYm6MOqhx5P5t
         sX65U04PAFbTaKPqkS9s2emks7bFiEnxPHGIrM0NxL/KsaE/Y1V9pvJI1uqi5MM+DNfW
         vagcohhBmKiy+ogt1sjccLa6LzSYIpZxcLsacx3chXnDHx8q5RND9Hcxp9XJ1gHwh895
         CVwA==
X-Gm-Message-State: AOAM532N7m/cdWXWeq5GxKaiISmux0KgtTvBIaSlx/wCMnneGR/iHStp
        v0sNIs9qzrkJys3F6MwpSOcNVsdBbLY=
X-Google-Smtp-Source: ABdhPJwVaRvwkEcuBUe8oRYCSgCjHU3Pv+Z9Bw9j9zeO0G46VwFB7Vq4S68QbePXHoq++agp+2HMzg==
X-Received: by 2002:a17:90a:488a:: with SMTP id b10mr24590696pjh.2.1620094898738;
        Mon, 03 May 2021 19:21:38 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id h19sm1157757pgm.40.2021.05.03.19.21.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:21:38 -0700 (PDT)
Subject: Re: [PATCH 03/18] scsi: add scsi_{get,put}_internal_cmd() helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-4-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d9c7f79f-f0ec-a420-517c-d6ca83d99ef9@acm.org>
Date:   Mon, 3 May 2021 19:21:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-4-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> +/**
> + * scsi_get_internal_cmd - allocate an internal SCSI command
> + * @sdev: SCSI device from which to allocate the command
> + * @op: operation (REQ_OP_SCSI_IN or REQ_OP_SCSI_OUT)
> + * @flags: BLK_MQ_REQ_* flags, e.g. BLK_MQ_REQ_NOWAIT.
> + *
> + * Allocates a SCSI command for internal LLDD use.
> + */
> +struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev,
> +	unsigned int op, blk_mq_req_flags_t flags)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +
> +	WARN_ON_ONCE(((op & REQ_OP_MASK) != REQ_OP_SCSI_IN) &&
> +		     ((op & REQ_OP_MASK) != REQ_OP_SCSI_OUT));
> +	rq = blk_mq_alloc_request(sdev->request_queue, op, flags);
> +	if (IS_ERR(rq))
> +		return NULL;
> +	scmd = blk_mq_rq_to_pdu(rq);
> +	scmd->request = rq;
> +	scmd->device = sdev;
> +	return scmd;
> +}
> +EXPORT_SYMBOL_GPL(scsi_get_internal_cmd);

Multiple fields that are initialized by the regular command submission
path are not initialized by the above function, e.g. scmd->tag. Has it
been considered to call scsi_init_command() instead of adding yet
another code path that initializes scmd->request?

Thanks,

Bart.
