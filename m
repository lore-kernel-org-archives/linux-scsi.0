Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C107C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 18:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54C5761100
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 18:13:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349504AbhIHSPD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 14:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349202AbhIHSPC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 14:15:02 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11681C06175F;
        Wed,  8 Sep 2021 11:13:54 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id 6so4190854oiy.8;
        Wed, 08 Sep 2021 11:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wsmP6J8DZZnWADy+5dtS5HLS6CANu/6Oi+vux+shT7c=;
        b=KnoRzCnTfLlpKXPbScowwr+IvLNjDN3+GvyC5RWSsjna4CFXQ7Q8MZZW5CeKmizPw7
         EOWkB7Brj/+p2P6sepk/5BR3Deqfim0gRGKE/whSxTuyVP1VZrfL1hZc3UZ5JgH3u1w3
         tAHQvh/J3rp182PxfdQLpcW80gQdOOtWz2umrT7gUzh0utIVtK1aMYtK3dF5dpHAF1XC
         cbP7Z799XpRDkCnlnFjRz2JT9I1dDBH4LiZqBxcO6ADUWeiofv96T5HhJmcsqG5PpjWh
         AAdMMMGmqGblQtXdiUnZu8hnchi/+BjLOG8xeaQAS690uJghTZdSRVul2azxFLsyaAE9
         DLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=wsmP6J8DZZnWADy+5dtS5HLS6CANu/6Oi+vux+shT7c=;
        b=xLvvGi6lNwzCyrzGFP3wK2AIMgS8OMCS0ZZMopNFvtEdabC6/mAFPZ8h7hPInAu5Aw
         p3iXD/JfHDlgwCgF2Y/e/BxOmIv0qvlyyhG7auR6nz9qPVF0WRNkcnkZlNUSy6pLrwNu
         AbEAVOnlp3j6uS6eAj7UvQC/2WaigFstu8S9efrRmRhFJQdwpgfsBtaGDEmKyKWIuM9/
         lmBZDT4ZZjIDPa5+EO2a4Vgm41rLWpTUhLqKbZAvEd8BNV9tasAqFr36vhcxlU9jZFCa
         gT6q/vEZnw4Af7LUQo5juqKs9DRyvqgqyg5duo/bT5X8qtPo9Ihdb9gsjc1CqEI+RzLW
         1L6A==
X-Gm-Message-State: AOAM532nP05hRstgrF160i5SGZOnUmqlLS3aZvxKlEIq9rywYjPdBTR7
        QZZo+v+boaEB2NL6JQhBW4E=
X-Google-Smtp-Source: ABdhPJwjooSA30lQLF4upBlQxdLzBeKZ0F4iImvgwV0fJRM2P8DX9ou9kF1zOZm0oElASAYj4sFgXA==
X-Received: by 2002:aca:2216:: with SMTP id b22mr3316630oic.163.1631124833369;
        Wed, 08 Sep 2021 11:13:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i19sm599763ooe.44.2021.09.08.11.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 11:13:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 8 Sep 2021 11:13:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Helge Deller <deller@gmx.de>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] scsi: ncr53c8xx: Remove unused
 retrieve_from_waiting_list() function
Message-ID: <20210908181351.GA1209328@roeck-us.net>
References: <YTfS/LH5vCN6afDW@ls3530>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YTfS/LH5vCN6afDW@ls3530>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 07, 2021 at 11:00:44PM +0200, Helge Deller wrote:
> Drop retrieve_from_waiting_list() to avoid this warning:
> drivers/scsi/ncr53c8xx.c:8000:26: warning: ‘retrieve_from_waiting_list’ defined but not used [-Wunused-function]
> 
> Fixes: 1c22e327545c ("scsi: ncr53c8xx: Remove unused code")
> Signed-off-by: Helge Deller <deller@gmx.de>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>

> 
> diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
> index 7a4f5d4dd670..2b8c6fa5e775 100644
> --- a/drivers/scsi/ncr53c8xx.c
> +++ b/drivers/scsi/ncr53c8xx.c
> @@ -1939,11 +1939,8 @@ static	void	ncr_start_next_ccb (struct ncb *np, struct lcb * lp, int maxn);
>  static	void	ncr_put_start_queue(struct ncb *np, struct ccb *cp);
> 
>  static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd);
> -static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd);
>  static void process_waiting_list(struct ncb *np, int sts);
> 
> -#define remove_from_waiting_list(np, cmd) \
> -		retrieve_from_waiting_list(1, (np), (cmd))
>  #define requeue_waiting_list(np) process_waiting_list((np), DID_OK)
>  #define reset_waiting_list(np) process_waiting_list((np), DID_RESET)
> 
> @@ -7997,26 +7994,6 @@ static void insert_into_waiting_list(struct ncb *np, struct scsi_cmnd *cmd)
>  	}
>  }
> 
> -static struct scsi_cmnd *retrieve_from_waiting_list(int to_remove, struct ncb *np, struct scsi_cmnd *cmd)
> -{
> -	struct scsi_cmnd **pcmd = &np->waiting_list;
> -
> -	while (*pcmd) {
> -		if (cmd == *pcmd) {
> -			if (to_remove) {
> -				*pcmd = (struct scsi_cmnd *) cmd->next_wcmd;
> -				cmd->next_wcmd = NULL;
> -			}
> -#ifdef DEBUG_WAITING_LIST
> -	printk("%s: cmd %lx retrieved from waiting list\n", ncr_name(np), (u_long) cmd);
> -#endif
> -			return cmd;
> -		}
> -		pcmd = (struct scsi_cmnd **) &(*pcmd)->next_wcmd;
> -	}
> -	return NULL;
> -}
> -
>  static void process_waiting_list(struct ncb *np, int sts)
>  {
>  	struct scsi_cmnd *waiting_list, *wcmd;
