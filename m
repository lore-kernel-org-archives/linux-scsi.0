Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA0EC388F2
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 17:19:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A04922265
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 17:19:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MCk5HfDF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKBRTy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 12:19:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727334AbgKBRTy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 12:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604337592;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IlFEvEjMSrm8s5qHZz+GEuVEXkuh6HpBQEzj3Z7NPMM=;
        b=MCk5HfDF6Ze3K5uNpuuJwbDPwdVms1JV+5gdPtmaJQzCdMflosdabiZx5sOx4zy2PgKtGU
        dDkuoE/MUd1oxvVzPQq93x+xmxF6jVwUVdQbrq9IaPpjA6T7IGWg9l5nD5fTBem0HAXbUg
        NehR97zlYA7UwLSrp/SrM8OV9pTJoNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-201-4qigXCibNpu611g5sVQsqg-1; Mon, 02 Nov 2020 12:19:50 -0500
X-MC-Unique: 4qigXCibNpu611g5sVQsqg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 734291099F60;
        Mon,  2 Nov 2020 17:19:49 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.149])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 590B35B4D3;
        Mon,  2 Nov 2020 17:19:48 +0000 (UTC)
Subject: Re: [PATCH] mpt3sas: Fix timeouts observed while reenabling IRQ
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, sathya.prakash@broadcom.com,
        suganath-prabu.subramani@broadcom.com
References: <20201102072746.27410-1-sreekanth.reddy@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <12d0a321-235d-49f0-3e14-da6b40ddaa34@redhat.com>
Date:   Mon, 2 Nov 2020 18:19:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201102072746.27410-1-sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/20 8:27 AM, Sreekanth Reddy wrote:
> While reenabling the IRQ after irq poll there may be small time
> window where HBA firmware has posted some replies and raise the
> interrupts but driver has not received the interrupts. So we may
> observe IO timeouts as the driver has not processed the replies
> as interrupts got missed while reenabling the IRQ.
> 
> So, to fix this issue, the driver has to go for one more
> round of processing the reply descriptors from reply descriptor
> post queue after enabling the IRQ.
> 
> Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
> Reported-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index b096917..a0ab44d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -1740,6 +1740,13 @@ _base_irqpoll(struct irq_poll *irqpoll, int budget)
>  		reply_q->irq_poll_scheduled = false;
>  		reply_q->irq_line_enable = true;
>  		enable_irq(reply_q->os_irq);
> +		/*
> +		 * Go for one more round of processing the
> +		 * reply descriptor post queue incase if HBA
> +		 * Firmware has posted some reply descriptors
> +		 * while reenabling the IRQ.
> +		 */
> +		_base_process_reply_queue(reply_q);
>  	}
>  
>  	return num_entries;
> 

I've tested the fix and the system now works.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

