Return-Path: <SRS0=SrIF=DD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77E40C4727D
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 22:01:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D4692388E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Sep 2020 22:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgIZWBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 26 Sep 2020 18:01:50 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34608 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgIZWBu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 26 Sep 2020 18:01:50 -0400
Received: by mail-pf1-f194.google.com with SMTP id k13so6166176pfg.1
        for <linux-scsi@vger.kernel.org>; Sat, 26 Sep 2020 15:01:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=QhdbG+T6+ih8CBB9tvQ+05zPjxlHN9pq9IE9yFJ/8aQ=;
        b=cvTSQyYG42uxgVhQxDKJTtcX+BtBpd5GMRDCEqrduLmNxANnjJcLoh0S2NNUG26H4k
         4YxAmbKQOBU7cMOILnqwj0LtvRCcuRKOfkE/agA9DVmHaA+dfxUFPUXap1mpA+HPT0g8
         EGRP5tEAy8IFYGRxwPyrmxswTm3jWQxE+DatYmhVqSsVpiNVSyD+qgQ54VcIzeME8kNW
         1Z7m3Ur52CpzmXD3F1BIyMQoa87EHkWrZdqaPmNa/2IWmZiL4ynt29u+KQ2TTlAb4yf6
         pnINbDaX9ogVh/Uc3OFz3pSCYqgUvn+pZkngP+0Prv/LR3HYr2u9qXyMDjX2meBfVvHN
         riWw==
X-Gm-Message-State: AOAM531lpXRqdtgmNEjNxcAa/VqJMR5triuGLPzoz5jemjzZblddrmrC
        HZK+Gs6N3R1ERdtgLPxegjc=
X-Google-Smtp-Source: ABdhPJxhWkupZ0rLNGee8A5t8TzVCTNexHAgvBOIibfej2A6WlC7XY82I9vYncSWORiYilgu9uJpMw==
X-Received: by 2002:a62:7511:0:b029:142:2501:35da with SMTP id q17-20020a6275110000b0290142250135damr4918356pfc.58.1601157709084;
        Sat, 26 Sep 2020 15:01:49 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:d9b2:e338:51cb:ba62? ([2601:647:4000:d7:d9b2:e338:51cb:ba62])
        by smtp.gmail.com with ESMTPSA id h1sm2530116pji.52.2020.09.26.15.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2020 15:01:48 -0700 (PDT)
Subject: Re: [PATCH] scsi_dh_alua: avoid crash during alua_bus_detach()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        "Ewan D . Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org,
        Brian Bunker <brian@purestorage.com>
References: <20200924104559.26753-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <2175d8e0-88fa-a9eb-5d50-46f0eed402cf@acm.org>
Date:   Sat, 26 Sep 2020 15:01:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200924104559.26753-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-24 03:45, Hannes Reinecke wrote:
> alua_bus_detach() might be running concurrently with alua_rtpg_work(),
> so we might trip over h->sdev == NULL and call BUG_ON().
> The correct way of handling it would be to not set h->sdev to NULL
> in alua_bus_detach(), and call rcu_synchronize() before the final
> delete to ensure that all concurrent threads have left the critical
> section.
> Then we can get rid of the BUG_ON(), and replace it with a simple
> if condition.
> 
> Cc: Brian Bunker <brian@purestorage.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index f32da0ca529e..308bda2e9c00 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -658,8 +658,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {
> -						/* h->sdev should always be valid */
> -						BUG_ON(!h->sdev);
> +						if (!h->sdev)
> +							continue;
>  						h->sdev->access_state = desc[0];
>  					}
>  					rcu_read_unlock();
> @@ -705,7 +705,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  			pg->expiry = 0;
>  			rcu_read_lock();
>  			list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -				BUG_ON(!h->sdev);
> +				if (!h->sdev)
> +					continue;
>  				h->sdev->access_state =
>  					(pg->state & SCSI_ACCESS_STATE_MASK);
>  				if (pg->pref)
> @@ -1147,7 +1148,6 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  	spin_lock(&h->pg_lock);
>  	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>  	rcu_assign_pointer(h->pg, NULL);
> -	h->sdev = NULL;
>  	spin_unlock(&h->pg_lock);
>  	if (pg) {
>  		spin_lock_irq(&pg->lock);
> @@ -1156,6 +1156,7 @@ static void alua_bus_detach(struct scsi_device *sdev)
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  	sdev->handler_data = NULL;
> +	synchronize_rcu();
>  	kfree(h);
>  }

Hi Hannes,

Do you agree that the changes in alua_bus_detach() make the changes in
alua_rtpg() superfluous?

How about freezing command processing for 'sdev' while detaching a
device handler instead of inserting a synchronize_rcu() call in
alua_bus_detach()? I'm concerned that the alua_bus_detach() changes are
not sufficient to fix all possible races between detaching a device
handler and the following code from the SCSI error handler:

	if (sdev->handler && sdev->handler->check_sense) {
		int rc;

		rc = sdev->handler->check_sense(sdev, &sshdr);
		if (rc != SCSI_RETURN_NOT_HANDLED)
			return rc;
		/* handler does not care. Drop down to default handling */
	}

Thanks,

Bart.
