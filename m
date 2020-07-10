Return-Path: <SRS0=WTMl=AV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A27C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 07:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA7BF2077D
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Jul 2020 07:18:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EP60IbkZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGJHSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Jul 2020 03:18:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:48749 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725851AbgGJHSI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2020 03:18:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594365487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FGoPGTEznFk5h14aCUBaJwrGf/5Nb40zpROvBbNiTpA=;
        b=EP60IbkZ8RsasnJp8wui+wFake4Ai1zn0hRUOAgQ8AoWBVjWRey9+udl3KNYIuaZGflpVd
        sokWs+goDX0EN/WnxD7+uKCZiPeaMwSgxurFaEpJ+M13IDkxWso3ZVNEvCWTIuzG420HRJ
        r1ZNjT1XTTf2CSS3KwyjOBovG3z9uCU=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-39-L61QJisANc6lMcnfO-qJNQ-1; Fri, 10 Jul 2020 03:18:02 -0400
X-MC-Unique: L61QJisANc6lMcnfO-qJNQ-1
Received: by mail-wm1-f72.google.com with SMTP id g124so5574133wmg.6
        for <linux-scsi@vger.kernel.org>; Fri, 10 Jul 2020 00:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FGoPGTEznFk5h14aCUBaJwrGf/5Nb40zpROvBbNiTpA=;
        b=XDP6wlNgz4eIxSzwdoYWGsa4V+FF4wOuBqjsf4Ay8jCP1z2w2LTUJEVp1E+HN7W6Mq
         SgPg4nBQTZkHaXAFZMD1RFua63GF20wMcNFQV4ZmM3brB4cHCDYR7wMvJb0q8ckNKPPW
         RSsh/lY+x6mdJMOZ+sPaxA4eImIDhCXXDQf58NP39RpOSnZYrkFiNj1D+Tv5qf5b1YPc
         X7XuUsmE4t/p1KaKO6onsqSQAxZFY9B9qzalzkLCeSFl8uaZTtmKKqldqYiUK2RP+duZ
         n0dGsGKDUGYwoLU3hTT2uZS6D9zb6frKvmoWyxH12rm7k2qEdMeTAPG9qeVOrRNWg3i3
         IZdw==
X-Gm-Message-State: AOAM533DvtqEhXGE7AEtGbx3GyrHnOY71MlRLdTtpNJCkiBOdyfKg7R3
        bACfkNpEB5UszmsxFVzW/iFkbXAWRmNJfw/LVquOArHgMTma8toymoF+n3PXYc8ot23Q9Lu2fDU
        vjJCV9D2peTFn241GxAPGOg==
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr27335912wrx.356.1594365481347;
        Fri, 10 Jul 2020 00:18:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8Rr8IAsbJamgn8rqldry9PUjrzvHl5OLB3NeoeT73v1oK2Um8w8bXswITBBP+sRvLWq5k6w==
X-Received: by 2002:a05:6000:12c3:: with SMTP id l3mr27335889wrx.356.1594365481075;
        Fri, 10 Jul 2020 00:18:01 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id w14sm8969677wrt.55.2020.07.10.00.18.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:18:00 -0700 (PDT)
Subject: Re: [PATCH] scsi: virtio_scsi: Remove unnecessary condition checks
To:     Markus Elfring <Markus.Elfring@web.de>,
        Xianting Tian <xianting_tian@126.com>,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
 <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
 <8eb9a827-45f1-e71c-0cbf-1c29acd8e310@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <58e3feb8-1ffb-f77f-cf3a-75222b3cd524@redhat.com>
Date:   Fri, 10 Jul 2020 09:17:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8eb9a827-45f1-e71c-0cbf-1c29acd8e310@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/07/20 08:32, Markus Elfring wrote:
>>>> +	mempool_destroy(virtscsi_cmd_pool);
>>>> +	virtscsi_cmd_pool = NULL;
>>>> +	kmem_cache_destroy(virtscsi_cmd_cache);
>>>> +	virtscsi_cmd_cache = NULL;
>>>>  	return ret;
>>>>  }
>>>
>>> How do you think about to add a jump target so that the execution
>>> of a few statements can be avoided according to a previous
>>> null pointer check?
>>
>> The point of the patch is precisely to simplify the code,
> 
> I suggest to reconsider also Linux coding style aspects
> for the implementation of the function “init”.
> https://elixir.bootlin.com/linux/v5.8-rc4/source/drivers/scsi/virtio_scsi.c#L980
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/scsi/virtio_scsi.c?id=42f82040ee66db13525dc6f14b8559890b2f4c1c#n980
> 
>  	if (!virtscsi_cmd_cache) {
>  		pr_err("kmem_cache_create() for virtscsi_cmd_cache failed\n");
> -		goto error;
> +		return -ENOMEM;
> 	}

Could be doable, but I don't see a particular benefit.  Having a single
error loop is an advantage by itself.

The coding style is a suggestion.  Note the difference between

		kfree(foo->bar);
		kfree(foo);

and

		kfree(bar);
		kfree(foo);

> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?id=42f82040ee66db13525dc6f14b8559890b2f4c1c#n461
> 
> 
>> executing a couple more instruction is not an issue.
> 
> With which update steps would like to achieve such a code variant?
> 
> destroy_pool:
> 	mempool_destroy(virtscsi_cmd_pool);
> 	virtscsi_cmd_pool = NULL;
> destroy_cache:
> 	kmem_cache_destroy(virtscsi_cmd_cache);
> 	virtscsi_cmd_cache = NULL;
> 	return ret;

... while there's no advantage in this.

Paolo

