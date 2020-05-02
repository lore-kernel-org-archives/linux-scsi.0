Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 788DBC3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D28921582
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 08:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgEBIp1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 04:45:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56008 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726468AbgEBIp1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 04:45:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CA5D9AC51;
        Sat,  2 May 2020 08:45:26 +0000 (UTC)
Subject: Re: [PATCH RFC v3 02/41] scsi: add scsi_{get,put}_reserved_cmd()
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-3-hare@suse.de> <20200501173946.GA23795@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d85e8384-639f-fa89-8c52-367bdb46cc8a@suse.de>
Date:   Sat, 2 May 2020 10:45:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200501173946.GA23795@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 7:39 PM, Christoph Hellwig wrote:
> On Thu, Apr 30, 2020 at 03:18:25PM +0200, Hannes Reinecke wrote:
>> Add helper functions to retrieve SCSI commands from the reserved
>> tag pool.
> 
> I'm still quite worried about the fact that we have a pretty much
> half-initialized command that now goes down the whole stack.
> 
Reserved commands just serve as a placeholder to get a valid tag from 
the block layer; the SCSI commands themselves are never ever passed 
through the whole stack, but rather allocated internally within the 
driver, and passed to the hardware by driver-specific means.
So really the SCSI specific parts of the commands are never used.
We can add a check in queuecommand to abort reserved commands if that's 
what you worried about, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
