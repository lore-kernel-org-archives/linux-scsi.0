Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79B2DC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 19:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 42B7922304
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 19:28:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="URIWUO3m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfKRT2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 14:28:19 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36738 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfKRT2S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 14:28:18 -0500
Received: by mail-wr1-f68.google.com with SMTP id r10so20926901wrx.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 11:28:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=V0yRlyYBQtG08cX3hvk3wjYY4jgawcc6Rz/u68Je5RU=;
        b=URIWUO3mIJGc+oLmeq0FLkIRqY+U7cNM7lAceZX//Tf7jATc59iK7K9lSToOn7ePTw
         Qv83tV4KJwW8kyzpcMcTz2ZbNZoJotXDVMbla5PmQiFZe35VX38/cDvQvfc+oHKSKyOr
         pDWINfa2tRuEWZpcNCqtSlr2zcXg/ySqyMtwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=V0yRlyYBQtG08cX3hvk3wjYY4jgawcc6Rz/u68Je5RU=;
        b=TN+mYUeM5434kzkNMy6xCOAW6+2gCzY8AVKEnCO8bLc2lDmgA3+f6bm5dzAkDANzOG
         4W/mdk7A3XSjE/DE/Po7SphQX46STTGIwJ3MCY8o261zW7eclJ8DhYyGlWMMOzFK48uG
         NeIJyF6lCFsh3Z+whRqwxoDZpVAE2RisEeBvSBQw8CrI9UlUfe1zeP++ay3oiv2CxJCe
         EdLt7oyvPxQmmkKpocqcI22tHP1iSlmQJfgMBgDkXv/O1M/e8dONMpoWI8ITp3+Re2A9
         9oLmqYq6w0fGkLIsCY/UaKaB9Iyk961TiV82aZgn3H3IIN8qyMn9xgY5NggUDneWLmKU
         n2OA==
X-Gm-Message-State: APjAAAVnszT8b+NHrNUo0r5qaMlWIjKNa8Z34Z2Wr5yDGpp9rtwsrTOH
        QaFw6GfW9eDwv/G1pf6UZYwHBenA78fSrQHB0acZ40znpg1XMu6+xInGeaILBvFn/GD54J1TJsz
        NZYf0hkbfqMjcOS0f8MZUzTaCIjsPfV7SgETiEcgyD726q6HGuJ8VJ6RySDNWCOHakbLnh0JUrK
        4R
X-Google-Smtp-Source: APXvYqw854Jpj7YYV7V2L+QPhqZsbH51wq0Q5tPykSJYZSQHqjLWBXxHTfTJ2XPDguuUT/O9b+TPUg==
X-Received: by 2002:a05:6000:150:: with SMTP id r16mr31417398wrx.313.1574105296234;
        Mon, 18 Nov 2019 11:28:16 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b66sm369717wmh.39.2019.11.18.11.28.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 11:28:15 -0800 (PST)
Subject: Re: [PATCH] lpfc: fixup out-of-bounds access during CPU hotplug
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Daniel Wagner <daniel.wagner@suse.com>,
        linux-scsi@vger.kernel.org
References: <20191118123012.99664-1-hare@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <5c61c1ce-d4fc-23b8-621a-897febb89b67@broadcom.com>
Date:   Mon, 18 Nov 2019 11:28:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191118123012.99664-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/2019 4:30 AM, Hannes Reinecke wrote:
> The lpfc driver allocates a cpu_map based on the number of possible
> cpus during startup. If a CPU hotplug occurs the number of CPUs
> might change, causing an out-of-bounds access when trying to lookup
> the hardware index for a given CPU.
>
> Suggested-by: Daniel Wagner <daniel.wagner@suse.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index ba26df90a36a..2380452a8efd 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -642,7 +642,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp,
>   	int tag;
>   	struct fcp_cmd_rsp_buf *tmp = NULL;
>   
> -	cpu = raw_smp_processor_id();
> +	cpu = min_t(u32, raw_smp_processor_id(),
> +		    phba->sli4_hba.num_possible_cpu);
>   	if (cmnd && phba->cfg_fcp_io_sched == LPFC_FCP_SCHED_BY_HDWQ) {
>   		tag = blk_mq_unique_tag(cmnd->request);
>   		idx = blk_mq_unique_tag_to_hwq(tag);

This should be unnecessary with the lpfc 12.6.0.1 and 12.6.0.2 patches 
that tie into cpu onling/offlining and cpu hot add.

I am curious, how if a cpu is hot removed - how num_possible dynamically 
changes (to a lower value ?) such that a thread can be running on a cpu 
that returns a higher cpu number than num_possible ?

-- james

