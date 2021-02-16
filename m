Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FB97C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 18:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21B46614A7
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Feb 2021 18:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbhBPSQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Feb 2021 13:16:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:32818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229889AbhBPSQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Feb 2021 13:16:28 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 18EB2AB4C;
        Tue, 16 Feb 2021 18:15:46 +0000 (UTC)
Subject: Re: [RFC/RFT PATCH] scsi: pm8001: Expose HW queues for pm80xx hw
To:     Viswas.G@microchip.com, john.garry@huawei.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, akshatzen@google.com,
        Ruksar.devadi@microchip.com, radha@google.com,
        bjashnani@google.com, vishakhavc@google.com,
        jinpu.wang@cloud.ionos.com, Ashokkumar.N@microchip.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kashyap.desai@broadcom.com, ming.lei@redhat.com
References: <1609845423-110410-1-git-send-email-john.garry@huawei.com>
 <SN6PR11MB34882CBBF9CF1C6EA2C50EB29DB79@SN6PR11MB3488.namprd11.prod.outlook.com>
 <0a20dc79-a462-f3fb-14af-db151b688e5a@huawei.com>
 <SN6PR11MB34882607FCD824C9C790AEFC9DB69@SN6PR11MB3488.namprd11.prod.outlook.com>
 <1b491d44-996c-2131-2eb6-5348460f9b5b@huawei.com>
 <SN6PR11MB3488932892D5F34FEE6984499D889@SN6PR11MB3488.namprd11.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <23f6201d-130a-5bf3-c828-c06f0e0acfbe@suse.de>
Date:   Tue, 16 Feb 2021 19:15:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB3488932892D5F34FEE6984499D889@SN6PR11MB3488.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/15/21 6:31 PM, Viswas.G@microchip.com wrote:
> Hi John,
> 
> We could test this patch and it works fine. Regarding the usage of request->tag, We have some challenges there.
> Pm80xx driver need tag for internal command as well. Tag is controller wide and we need to assign unique tag
> for internal command as well. If we use request->tag, how can we get tag for internal commands ? If driver
> allocate that, how can we make sure it will not conflict with the request->tag ?
> 
I have posted a patchset for internal tags some time ago; at the time it 
was blocked by the missing shared tagset functionality.
But seeing that we're having it now I guess I'll need to repost; that 
addresses precisely the issue you've described.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
