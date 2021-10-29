Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C24C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 05:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 998F46113B
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 05:51:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhJ2Fxe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 01:53:34 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:37766 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJ2Fxe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 01:53:34 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id DAEDD218E0;
        Fri, 29 Oct 2021 05:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635486664; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkHtVMt92gUgbsYTtS4S1lP2SDGldWukUMlY/TrnM0E=;
        b=E1iGctEvkOk8C1MZU+wzQNeMxIna9MZ50SbzoCyuQXXja+p1KvdqzzB/po54k0GnY0qfy2
        Yy9q1uXRrOWK68qh0/Rg60z4DVDWRMmTSnYjxMSdsx/TYbRGMTByrxIiLGAnOsZEkiH3gf
        NiyWzDnswqu/MbihUotjCokAleF92fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635486664;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkHtVMt92gUgbsYTtS4S1lP2SDGldWukUMlY/TrnM0E=;
        b=K8drR/+tVTdMf9IuYydU4OQxbBlXc+WpgVdm6e41TjOCS4FgIAT3Om/h6mDVY9xwoLziWH
        KxhhiWo4soKjIEDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 19BF713AF5;
        Fri, 29 Oct 2021 05:51:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JCVQA8iLe2GSVAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 29 Oct 2021 05:51:04 +0000
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        =?UTF-8?Q?Javier_Gonz=c3=a1lez?= <javier@javigon.com>
Cc:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "msnitzer@redhat.com" <msnitzer@redhat.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "roland@purestorage.com" <roland@purestorage.com>,
        "mpatocka@redhat.com" <mpatocka@redhat.com>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "Frederick.Knight@netapp.com" <Frederick.Knight@netapp.com>,
        "zach.brown@ni.com" <zach.brown@ni.com>,
        "osandov@fb.com" <osandov@fb.com>,
        Adam Manzanares <a.manzanares@samsung.com>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        Vincent Fu <vincent.fu@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
References: <BYAPR04MB49652C4B75E38F3716F3C06386539@BYAPR04MB4965.namprd04.prod.outlook.com>
 <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
Date:   Fri, 29 Oct 2021 07:51:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/29/21 2:21 AM, Chaitanya Kulkarni wrote:
> On 10/7/21 11:49 PM, Javier González wrote:
>> External email: Use caution opening links or attachments
>>
>>
>> On 06.10.2021 10:33, Bart Van Assche wrote:
>>> On 10/6/21 3:05 AM, Javier González wrote:
>>>> I agree that the topic is complex. However, we have not been able to
>>>> find a clear path forward in the mailing list.
>>>
>>> Hmm ... really? At least Martin Petersen and I consider device mapper
>>> support essential. How about starting from Mikulas' patch series that
>>> supports the device mapper? See also
>>> https://lore.kernel.org/all/alpine.LRH.2.02.2108171630120.30363@file01.intranet.prod.int.rdu2.redhat.com/
>>>
> 
> When we add a new REQ_OP_XXX we need to make sure it will work with
> device mapper, so I agree with Bart and Martin.
> 
> Starting with Mikulas patches is a right direction as of now..
> 
>>
>> Thanks for the pointers. We are looking into Mikulas' patch - I agree
>> that it is a good start.
>>
>>>> What do you think about joining the call to talk very specific next
>>>> steps to get a patchset that we can start reviewing in detail.
>>>
>>> I can do that.
>>
>> Thanks. I will wait until Chaitanya's reply on his questions. We will
>> start suggesting some dates then.
>>
> 
> I think at this point we need to at least decide on having a first call
> focused on how to proceed forward with Mikulas approach  ...
> 
> Javier, can you please organize a call with people you listed in this
> thread earlier ?
> 
Also Keith presented his work on a simple zone-based remapping block 
device, which included an in-kernel copy offload facility.
Idea is to lift that as a standalone patch such that we can use it a 
fallback (ie software) implementation if no other copy offload mechanism 
is available.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
