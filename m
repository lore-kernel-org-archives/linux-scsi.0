Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09386C433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 22:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB4CA60233
	for <linux-scsi@archiver.kernel.org>; Sat, 20 Feb 2021 22:57:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBTW5O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 20 Feb 2021 17:57:14 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:45939 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhBTW5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 Feb 2021 17:57:11 -0500
Received: by mail-pf1-f170.google.com with SMTP id j12so4255971pfj.12;
        Sat, 20 Feb 2021 14:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KioCzgeVnMPMKWiyJ0+0mRWV/9IcxBVrTZwjFRyX89c=;
        b=sLpFLDFek84d7TeTq+c7695b0V6I0C4ZWN6CGjCGJMlqJzn8gm35p2MTxDzHvMBRHe
         7buCINetLE+QoPgDmZV5oOL27z0ftWsLKvBySaMzTkw8SEr2YkBqsjeiPVbxtIGCJolp
         gCH1L+TbFvcvYcHw9WmQX2nAm5uj4vBqKlwc+x6OveF4gSx2fcwzkDfoMnMSsHPxJbVa
         A5+0BA+jMLw+n58qCWVJPJISwS6W1UI+2zfFCiFvO0sfYYFsYwOBfzidhnKVx3E1CeV+
         xC7Ag9R6VW0uAERfne6/jQwd7sqQUsAuVZH+mM5SzkYALcxMAD1f2QwITknNi4WxPBnr
         F0jg==
X-Gm-Message-State: AOAM533cFgggWUmQ5unoQYn9gxZpx+2GkZHqk2j5e7KtygnlvIlvVZMO
        FkI1KPkd1OiiO5ARQFhRJhVGR0dTaSs=
X-Google-Smtp-Source: ABdhPJwC5OskOsWLBsBMqDUGbzsHtodTQ1hk4DIrKCKeSFSNcUI3SHXxafkKD9bSf/AgdnWsXnpRaQ==
X-Received: by 2002:a63:e747:: with SMTP id j7mr14021256pgk.235.1613861790854;
        Sat, 20 Feb 2021 14:56:30 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:a813:9a51:fed9:102b? ([2601:647:4000:d7:a813:9a51:fed9:102b])
        by smtp.gmail.com with ESMTPSA id y7sm6107685pfc.162.2021.02.20.14.56.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Feb 2021 14:56:30 -0800 (PST)
Subject: Re: [RFC PATCH 24/24] target: mark __rcu to avoid warning
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, jejb@linux.ibm.com,
        mlombard@redhat.com, michael.christie@oracle.com,
        houpu@bytedance.com
References: <20210220214112.7469-1-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <1bd73abb-2c02-8aa5-b583-f711fcae2c0c@acm.org>
Date:   Sat, 20 Feb 2021 14:56:28 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210220214112.7469-1-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/21 1:41 PM, Chaitanya Kulkarni wrote:
> Mark struct fc_lport member prov with __rcu that fixes following
> warning :-
> 
> drivers/target/tcm_fc/tfc_sess.c:47:17: error: incompatible types in comparison expression (different address spaces):
> drivers/target/tcm_fc/tfc_sess.c:47:17:    void [noderef] __rcu *
> drivers/target/tcm_fc/tfc_sess.c:47:17:    void *
> drivers/target/tcm_fc/tfc_sess.c:72:9: error: incompatible types in comparison expression (different address spaces):
> drivers/target/tcm_fc/tfc_sess.c:72:9:    void [noderef] __rcu *
> drivers/target/tcm_fc/tfc_sess.c:72:9:    void *
> 
> Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> ---
>  include/scsi/libfc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/scsi/libfc.h b/include/scsi/libfc.h
> index 9b87e1a1c646..0446513e46d8 100644
> --- a/include/scsi/libfc.h
> +++ b/include/scsi/libfc.h
> @@ -746,7 +746,7 @@ struct fc_lport {
>  	struct mutex		       lp_mutex;
>  	struct list_head	       list;
>  	struct delayed_work	       retry_work;
> -	void			       *prov[FC_FC4_PROV_SIZE];
> +	void			       __rcu *prov[FC_FC4_PROV_SIZE];
>  	struct list_head	       lport_list;
>  };

This patch looks suspicious to me. Although the tcm_fc driver uses RCU
to modify 'prov', this is a choice that has been made in the tcm_fc
driver and not something that other libfc users are required to do. In
other words, I think this should be fixed in the tcm_fc driver instead
of in the libfc header.

Bart.
