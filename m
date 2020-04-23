Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DE5C55185
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:55:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ECCE208E4
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 02:55:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oCom5rnD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgDWCz2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 22:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgDWCz1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 22:55:27 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2A8C03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:55:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id np7so1856562pjb.1
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 19:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lo2O31vNWjbbSL/IZVSrAPPp6UwzspTpBShkwZOcoLo=;
        b=oCom5rnDPaqFovpcLH116zNcEi4Jljaz8HBcUrX5jvG+nocquuN3YrpFCb3hEvJtrb
         nN1IKQp4boDB5J/lA5Z5eUZvQ8xufB3UxZbB6tXmfWs6ZGnJTL7MLsGP2wI9oSS/rMZV
         b4fLeSQlamXgIrN+AZiYFb9EQgcxcff6U9i+XzbNy5K6ADLwUaYt+cVadC9ReiL51hki
         Ab3fDV/QwELV2ZS/LZcvsNgtAgUJr45ZWuzGLbHuDWxVElbkf2xlDv/zstSL00ElyYlx
         vzgsIJZY9faeo1TwkYGxRwIzAr6kaagrPKrG9feB4QdJ0NsFXZQeZXz3WqMDOY94Vyn7
         Bh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lo2O31vNWjbbSL/IZVSrAPPp6UwzspTpBShkwZOcoLo=;
        b=GEOhE2GwUJp2RtC2+Vmrmw3/4HpGODLIpIMmnACKk8oX6KGlFhe0jsX/IInmz0zbBW
         1zYqRDErYJ+LRDmnv1txRcLevt2S8JX8aoos/yDbXyiLpieQSO8nkEzeW+vsf4Ff1Sjn
         xtKdAIWyccsfQIW89AXLofjtVflR2owMoOFoTvdNk69lqtNzupBjjFJXKIFK3VwwxsBs
         hwc9IEHApRkmy7m9jYItTrld5Tb4h79Q5R/L4fPwdLaUTCR/8F4n8ij6XoaSRx+qXhuj
         wpLRv5+p2gTEehSha1tL/dCeJq2uWsJMtIX+UqNcYlpNn2rGWp5XM8awoaH6XBLod32b
         VTbg==
X-Gm-Message-State: AGi0PuY1B3Kofly4LdHwUwXutRUal/038vZc1Af7wXjm28o68Oc6Wbl7
        T3ZNkufSHH/3tvnhIgqVIzk=
X-Google-Smtp-Source: APiQypI1WzP0u3WTDzRGbOrTdFhVFk7ykwl0QbEKK+8R1Pvqy16yxvBkQdws/6o6ye8sY6yTD/cOkQ==
X-Received: by 2002:a17:90a:23ad:: with SMTP id g42mr1806558pje.35.1587610526939;
        Wed, 22 Apr 2020 19:55:26 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b15sm957402pfd.139.2020.04.22.19.55.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 19:55:26 -0700 (PDT)
Subject: Re: [PATCH v3 14/31] elx: libefc: FC node ELS and state handling
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-15-jsmart2021@gmail.com>
 <7246f3a2-a640-4bb4-4567-b3bf2c8fd8f2@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <1df8c1b5-44e1-6588-4b41-4633465e5c61@gmail.com>
Date:   Wed, 22 Apr 2020 19:55:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <7246f3a2-a640-4bb4-4567-b3bf2c8fd8f2@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 11:47 PM, Hannes Reinecke wrote:
...
>> +    case EFC_EVT_FLOGI_RCVD: {
>> +        struct fc_frame_header *hdr = cbdata->header->dma.virt;
>> +        u32 d_id = ntoh24(hdr->fh_d_id);
>> +
>> +        /* sm: / save sparams, send FLOGI acc */
>> +        memcpy(node->sport->domain->flogi_service_params,
>> +               cbdata->payload->dma.virt,
>> +               sizeof(struct fc_els_flogi));
>> +
> 
> Is the '->domain' pointer always present at this point?
> Shouldn't we rather test for it before accessing?

Always - if there's a node ans sport.

> 
>> +        /* send FC LS_ACC response, override s_id */
>> +        efc_fabric_set_topology(node, EFC_SPORT_TOPOLOGY_P2P);
>> +        efc->tt.send_flogi_p2p_acc(efc, node,
>> +                be16_to_cpu(hdr->fh_ox_id), d_id);
>> +        if (efc_p2p_setup(node->sport)) {
>> +            node_printf(node,
>> +                    "p2p setup failed, shutting down node\n");
>> +            efc_node_post_event(node, EFC_EVT_SHUTDOWN, NULL);
>> +        } else {
>> +            efc_node_transition(node,
>> +                        __efc_p2p_wait_flogi_acc_cmpl,
>> +                        NULL);
>> +        }
>> +
>> +        break;
>> +    }
>> +
>> +    case EFC_EVT_LOGO_RCVD: {
>> +        struct fc_frame_header *hdr = cbdata->header->dma.virt;
>> +
>> +        if (!node->sport->domain->attached) {
>> +            /* most likely a frame left over from before a link
>> +             * down; drop and
>> +             * shut node down w/ "explicit logout" so pending
>> +             * frames are processed
>> +             */
> 
> Same here; I find it slightly weird to have an 'attached' field in the 
> domain structure; attached to what?
> Doesn't the existence of the ->domain pointer signal the same thing?
> If it doesn't, why don't we test for the ->domain pointer before 
> accessing it?

Attached means something different here. Not only does the structure 
exist, but there have been VFI/VPI resources registered with the 
hardware for it.


Agree with your other comments and will address them.
And the same agreement for comments on patches 3, 9 & 10.

-- james


