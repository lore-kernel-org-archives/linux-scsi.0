Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE51C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 21:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiKPVWQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 16:22:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbiKPVWP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 16:22:15 -0500
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688895D6BB
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 13:22:14 -0800 (PST)
Received: by mail-pf1-f178.google.com with SMTP id c203so7555625pfc.11
        for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2022 13:22:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Jqu1vIvoJDBHXHOfONNUaF/5HcI7xaOYy9kZBnQu6l8=;
        b=J+9PvesD0WCb2Qn8zGdBGmVPT/7kdFfZikL9cKIPZP0Qb/sHyhYpu6rElrMeDOMDNM
         MYqs4lysWjz5F+XylMzOn2arrO6mpVlD3h8UcOtMvtWDKVUcOB9AphvMh8Ff7d/MA0Is
         tGjyT1o/UFmiZ/gGZ1SngJOtNQxnTZLIkw29yVvyl+riqPtX37dAwmQ0VwsbGqX7s3n+
         /bhlAAc36a/q/xWgRUF2qB8P3Q0Z07+pzSrYf8+8JMA4ItfscsgvQnDMuBVfjwcozSiC
         jA98TNS1Cv8FZdDCTkixRAc6b7jCpZSKjPN3ksbW9dxRt5YJlx+H+1tlN6snlRdYFyaN
         1YiA==
X-Gm-Message-State: ANoB5pm7VHcAv6e9PDdA1frNXwGHhGXSpasO+NC1BvB75+WZYxENQfjE
        7DD9jV8XQgzckZgQ0BWXa44=
X-Google-Smtp-Source: AA0mqf4yvK523X6L3GkO1qOPDeWEanpSeIW+pSov7OQbWcwjdq/I8AR7FrDcJYCEqQN9V4kVpH1yxg==
X-Received: by 2002:a05:6a00:4299:b0:56c:6f58:5937 with SMTP id bx25-20020a056a00429900b0056c6f585937mr25407552pfb.5.1668633733718;
        Wed, 16 Nov 2022 13:22:13 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:327b:52b7:c177:a972? ([2620:15c:211:201:327b:52b7:c177:a972])
        by smtp.gmail.com with ESMTPSA id 132-20020a62188a000000b00571dda13fafsm9236856pfy.163.2022.11.16.13.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Nov 2022 13:22:12 -0800 (PST)
Message-ID: <feb72aeb-cd34-4cc0-0520-30e8a808a824@acm.org>
Date:   Wed, 16 Nov 2022 13:22:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: alua: Fix alua_rtpg_queue()
To:     Martin Wilck <mwilck@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Hannes Reinecke <hare@suse.de>
References: <20221115224903.2325529-1-bvanassche@acm.org>
 <0efc9faa6dd519d1d402a08dbedd5cd7ed0de4f5.camel@suse.com>
Content-Language: en-US
In-Reply-To: <0efc9faa6dd519d1d402a08dbedd5cd7ed0de4f5.camel@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16/22 02:32, Martin Wilck wrote:
> On Tue, 2022-11-15 at 14:49 -0800, Bart Van Assche wrote:
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index 610a51538f03..905b49493e01 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -372,12 +372,13 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
>   	if (pg_updated)
>   		list_add_rcu(&h->node, &pg->dh_list);
>   	spin_unlock_irqrestore(&pg->lock, flags);
> -
> -	alua_rtpg_queue(rcu_dereference_protected(h->pg,
> -						  lockdep_is_held(&h->pg_lock)),
> -			sdev, NULL, true);
>   	spin_unlock(&h->pg_lock);
>   
> +	if (kref_get_unless_zero(&pg->kref)) {
> +		alua_rtpg_queue(pg, sdev, NULL, true);
> +		kref_put(&pg->kref, release_port_group);
> +	}
> +
>   	if (old_pg)
>   		kref_put(&old_pg->kref, release_port_group);
>   
> @@ -986,11 +987,22 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
>   		force = true;
>   	}
>   	if (pg->rtpg_sdev == NULL) {
> -		pg->interval = 0;
> -		pg->flags |= ALUA_PG_RUN_RTPG;
> -		kref_get(&pg->kref);
> -		pg->rtpg_sdev = sdev;
> -		start_queue = 1;
> +		struct alua_dh_data *h = sdev->handler_data;
> +		struct alua_port_group *sdev_pg = NULL;
> +
> +		if (h) {
> +			rcu_read_lock();
> +			sdev_pg = rcu_dereference(h->pg);
> +			rcu_read_unlock();
> +		}
> +
> +		if (pg == sdev_pg) {
> +			pg->flags |= ALUA_PG_RUN_RTPG;
> +			pg->interval = 0;
> +			kref_get(&pg->kref);
> +			pg->rtpg_sdev = sdev;
> +			start_queue = 1;
> +		}
>   	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
>   		pg->flags |= ALUA_PG_RUN_RTPG;
>   		/* Do not queue if the worker is already running */

Although I like the approach of this patch, how about the implementation below?
I think the implementation below is a little cleaner but that might be subjective ...

Thanks,

Bart.


diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index bd4ee294f5c7..d5a7d6ed5c63 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -354,6 +354,8 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
  			    "%s: port group %x rel port %x\n",
  			    ALUA_DH_NAME, group_id, rel_port);

+	kref_get(&pg->kref);
+
  	/* Check for existing port group references */
  	spin_lock(&h->pg_lock);
  	old_pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
@@ -373,11 +375,11 @@ static int alua_check_vpd(struct scsi_device *sdev, struct alua_dh_data *h,
  		list_add_rcu(&h->node, &pg->dh_list);
  	spin_unlock_irqrestore(&pg->lock, flags);

-	alua_rtpg_queue(rcu_dereference_protected(h->pg,
-						  lockdep_is_held(&h->pg_lock)),
-			sdev, NULL, true);
  	spin_unlock(&h->pg_lock);

+	alua_rtpg_queue(pg, sdev, NULL, true);
+	kref_put(&pg->kref, release_port_group);
+
  	if (old_pg)
  		kref_put(&old_pg->kref, release_port_group);

@@ -986,6 +988,9 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
  {
  	int start_queue = 0;
  	unsigned long flags;
+
+	might_sleep();
+
  	if (WARN_ON_ONCE(!pg) || scsi_device_get(sdev))
  		return false;

@@ -996,11 +1001,17 @@ static bool alua_rtpg_queue(struct alua_port_group *pg,
  		force = true;
  	}
  	if (pg->rtpg_sdev == NULL) {
-		pg->interval = 0;
-		pg->flags |= ALUA_PG_RUN_RTPG;
-		kref_get(&pg->kref);
-		pg->rtpg_sdev = sdev;
-		start_queue = 1;
+		struct alua_dh_data *h = sdev->handler_data;
+
+		rcu_read_lock();
+		if (rcu_dereference(h->pg) == pg) {
+			pg->interval = 0;
+			pg->flags |= ALUA_PG_RUN_RTPG;
+			kref_get(&pg->kref);
+			pg->rtpg_sdev = sdev;
+			start_queue = 1;
+		}
+		rcu_read_unlock();
  	} else if (!(pg->flags & ALUA_PG_RUN_RTPG) && force) {
  		pg->flags |= ALUA_PG_RUN_RTPG;
  		/* Do not queue if the worker is already running */
@@ -1246,8 +1257,8 @@ static void alua_bus_detach(struct scsi_device *sdev)
  		spin_unlock_irq(&pg->lock);
  		kref_put(&pg->kref, release_port_group);
  	}
-	sdev->handler_data = NULL;
  	synchronize_rcu();
+	sdev->handler_data = NULL;
  	kfree(h);
  }

