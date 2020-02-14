Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FFF9C3B1A6
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 17:39:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 184312168B
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 17:39:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbgBNRjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:39:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:45534 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389941AbgBNQEa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3B00FABEA;
        Fri, 14 Feb 2020 16:04:28 +0000 (UTC)
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
To:     Keith Busch <kbusch@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tim Walker <tim.t.walker@seagate.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
 <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com> <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
Date:   Fri, 14 Feb 2020 17:04:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/14/20 3:40 PM, Keith Busch wrote:
> On Fri, Feb 14, 2020 at 08:32:57AM +0100, Hannes Reinecke wrote:
>> On 2/13/20 5:17 AM, Martin K. Petersen wrote:
>>> People often artificially lower the queue depth to avoid timeouts. The
>>> default timeout is 30 seconds from an I/O is queued. However, many
>>> enterprise applications set the timeout to 3-5 seconds. Which means that
>>> with deep queues you'll quickly start seeing timeouts if a drive
>>> temporarily is having issues keeping up (media errors, excessive spare
>>> track seeks, etc.).
>>>
>>> Well-behaved devices will return QF/TSF if they have transient resource
>>> starvation or exceed internal QoS limits. QF will cause the SCSI stack
>>> to reduce the number of I/Os in flight. This allows the drive to recover
>>> from its congested state and reduces the potential of application and
>>> filesystem timeouts.
>>>
>> This may even be a chance to revisit QoS / queue busy handling.
>> NVMe has this SQ head pointer mechanism which was supposed to handle
>> this kind of situations, but to my knowledge no-one has been
>> implementing it.
>> Might be worthwhile revisiting it; guess NVMe HDDs would profit from that.
> 
> We don't need that because we don't allocate enough tags to potentially
> wrap the tail past the head. If you can allocate a tag, the queue is not
> full. And convesely, no tag == queue full.
> 
It's not a problem on our side.
It's a problem on the target/controller side.
The target/controller might have a need to throttle I/O (due to QoS 
settings or competing resources from other hosts), but currently no 
means of signalling that to the host.
Which, incidentally, is the underlying reason for the DNR handling 
discussion we had; NetApp tried to model QoS by sending "Namespace not 
ready" without the DNR bit set, which of course is a totally different 
use-case as the typical 'Namespace not ready' response we get (with the 
DNR bit set) when a namespace was unmapped.

And that is where SQ head pointer updates comes in; it would allow the 
controller to signal back to the host that it should hold off sending 
I/O for a bit.
So this could / might be used for NVMe HDDs, too, which also might have 
a need to signal back to the host that I/Os should be throttled...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
