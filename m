Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32C88C433E2
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:48:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3028221ED
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 15:48:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="MlZQBj/o"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgIKPse (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgIKPrq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Sep 2020 11:47:46 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E24CC061756
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 08:47:46 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d6so7650862pfn.9
        for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2020 08:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8qITAmpZovlk0VqFzAPSzRSUuVesfkTqqVBpZYXhTqY=;
        b=MlZQBj/oGNs5Ngu/7pa9Ux7BEhFqjU8Qn+s8DgZsKksuQZBWtIROkLODiX5yzT39WK
         nsTwEFlWNdBb5ayg83w8UfxJc8zeYbBejQz7PH8b6vRlqQcTXBGf8FmWinB0mOIZgL9O
         bZck87JGaxoY+6xHGttol2Z6+jsx1JbMj7C5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8qITAmpZovlk0VqFzAPSzRSUuVesfkTqqVBpZYXhTqY=;
        b=Bu/27IwCb/HDCqbY28dGRjmVGwFi2NmNWHAZw6+KUQwIsDZ3IY2sxOKvEbaUFnzzRm
         HdNL/243Rh0fpH2W6dXUddbb3ue6TE/smSgNSRfdVjCOdaT22luYobj/PjF/h0IFqF+Y
         lVsp2WH/JZ1pTwZB09anuGI4o5Afx19n7GwhPXHNpRvCug++B7ZHL5EQjbpMap2UDGAg
         n/RUaRWv6bMNyLbzsegR4og3SjmJifJa76wFk6nMqdOOEP+5ONnVC4RmQAA9Quh07+Jx
         csdMlHqTwfx/GrkZaukU5xq8XHt7IOgVCOY3WMErkRvdiZYVJuocGt8HohE22kLlhQos
         iIhA==
X-Gm-Message-State: AOAM531phoMFwJiQeKfXOiBEIZvtF6bkQ+jHN1ctYnImHgAnRh25ICaj
        INtPavfGSXqmtAhw9XBaQCZuLQ==
X-Google-Smtp-Source: ABdhPJzKf8v2QCyWm2BMqBtIjlUXRWYsk7umKxRnFWZCmspUm3x4I/CjB1hrRYx/6YRLx2ppBLVdAw==
X-Received: by 2002:a17:902:d909:b029:d0:cbe1:e716 with SMTP id c9-20020a170902d909b02900d0cbe1e716mr2857745plz.36.1599839265879;
        Fri, 11 Sep 2020 08:47:45 -0700 (PDT)
Received: from localhost.localdomain ([192.30.189.3])
        by smtp.gmail.com with ESMTPSA id g32sm2222561pgl.89.2020.09.11.08.47.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Sep 2020 08:47:45 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.0.3.2.26\))
Subject: Re: [PATCH 1/1] scsi: scsi_dh_alua: remove the list entry before
 assigning the pointer and sdev to NULL
From:   Brian Bunker <brian@purestorage.com>
In-Reply-To: <adbb27fcbe0a534a9f19f4ff624f05dbf2a1a193.camel@redhat.com>
Date:   Fri, 11 Sep 2020 08:47:44 -0700
Cc:     linux-scsi@vger.kernel.org, hare@suse.de
Content-Transfer-Encoding: 7bit
Message-Id: <1D8474C3-6D04-4C0F-B23C-A2924CD5436A@purestorage.com>
References: <4064EB40-C84F-42E8-82F7-3940901C09D2@purestorage.com>
 <adbb27fcbe0a534a9f19f4ff624f05dbf2a1a193.camel@redhat.com>
To:     "Ewan D. Milne" <emilne@redhat.com>
X-Mailer: Apple Mail (2.3654.0.3.2.26)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

To me just removing the h->sdev = NULL seems strange because then this
looks strange to me:

pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
rcu_assign_pointer(h->pg, NULL);

Then saying
If (pg)

Since we just assigned that pointer, h->pg to NULL.

Thanks,
Brian 

Brian Bunker
SW Eng
brian@purestorage.com



> On Sep 11, 2020, at 6:44 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> 
> On Thu, 2020-09-10 at 14:22 -0700, Brian Bunker wrote:
>> A race exists where the BUG_ON(!h->sdev) will fire if the detach
>> device handler
>> from one thread runs removing a list entry while another thread is
>> trying to
>> evaluate the target portal group state.
>> 
>> The order of the detach operation is now changed to delete the list
>> entry
>> before modifying the pointer and setting h->sdev to NULL.
>> 
>> Signed-off-by: Brian Bunker <brian@purestorage.com>
>> Acked-by: Krishna Kant <krishna.kant@purestorage.com>
>> ___
>> diff -Naur a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c
>> b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c
>> --- a/scsi/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-10
>> 12:29:03.000000000 -0700
>> +++ b/scsi/drivers/scsi/device_handler/scsi_dh_alua.c	2020-09-10
>> 12:41:34.000000000 -0700
>> @@ -1146,16 +1146,18 @@
>> 
>> 	spin_lock(&h->pg_lock);
>> 	pg = rcu_dereference_protected(h->pg, lockdep_is_held(&h-
>>> pg_lock));
>> -	rcu_assign_pointer(h->pg, NULL);
>> -	h->sdev = NULL;
>> -	spin_unlock(&h->pg_lock);
>> 	if (pg) {
>> 		spin_lock_irq(&pg->lock);
>> 		list_del_rcu(&h->node);
>> 		spin_unlock_irq(&pg->lock);
>> -		kref_put(&pg->kref, release_port_group);
>> 	}
>> +	rcu_assign_pointer(h->pg, NULL);
>> +	h->sdev = NULL;
>> +	spin_unlock(&h->pg_lock);
>> 	sdev->handler_data = NULL;
>> +	if (pg) {
>> +		kref_put(&pg->kref, release_port_group);
>> +	}
>> 	kfree(h);
>> }
>> 
> 
> Good catch.
> 
> This makes the code hold the h->pg_lock while holding the pg->lock
> though.
> 
> It seems like all that is needed is to remove the h->sdev = NULL
> assignment, since it has to remain valid until the alua_ah_data is
> removed from the pg->dh_list, and the object is going to be freed
> right afterwards anyway?
> 
> Might as well also remove the BUG_ON(!h->sdev) in 2 places since the
> kernel will crash when h is dereferenced anyway if it is NULL.
> 
> -Ewan
> 
> 

