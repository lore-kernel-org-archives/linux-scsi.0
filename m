Return-Path: <SRS0=WAUG=ZF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABC33C33CA0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 16:16:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34B4B2247C
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Nov 2019 15:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfKMPi1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Nov 2019 10:38:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:60096 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726335AbfKMPi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 Nov 2019 10:38:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BC271B49B;
        Wed, 13 Nov 2019 15:38:23 +0000 (UTC)
Subject: Re: [PATCH RFC 3/5] blk-mq: Facilitate a shared tags per tagset
To:     John Garry <john.garry@huawei.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ming.lei@redhat.com" <ming.lei@redhat.com>,
        "hare@suse.com" <hare@suse.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "chenxiang (M)" <chenxiang66@hisilicon.com>
References: <1573652209-163505-1-git-send-email-john.garry@huawei.com>
 <1573652209-163505-4-git-send-email-john.garry@huawei.com>
 <32880159-86e8-5c48-1532-181fdea0df96@suse.de>
 <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 mQINBE6KyREBEACwRN6XKClPtxPiABx5GW+Yr1snfhjzExxkTYaINHsWHlsLg13kiemsS6o7
 qrc+XP8FmhcnCOts9e2jxZxtmpB652lxRB9jZE40mcSLvYLM7S6aH0WXKn8bOqpqOGJiY2bc
 6qz6rJuqkOx3YNuUgiAxjuoYauEl8dg4bzex3KGkGRuxzRlC8APjHlwmsr+ETxOLBfUoRNuE
 b4nUtaseMPkNDwM4L9+n9cxpGbdwX0XwKFhlQMbG3rWA3YqQYWj1erKIPpgpfM64hwsdk9zZ
 QO1krgfULH4poPQFpl2+yVeEMXtsSou915jn/51rBelXeLq+cjuK5+B/JZUXPnNDoxOG3j3V
 VSZxkxLJ8RO1YamqZZbVP6jhDQ/bLcAI3EfjVbxhw9KWrh8MxTcmyJPn3QMMEp3wpVX9nSOQ
 tzG72Up/Py67VQe0x8fqmu7R4MmddSbyqgHrab/Nu+ak6g2RRn3QHXAQ7PQUq55BDtj85hd9
 W2iBiROhkZ/R+Q14cJkWhzaThN1sZ1zsfBNW0Im8OVn/J8bQUaS0a/NhpXJWv6J1ttkX3S0c
 QUratRfX4D1viAwNgoS0Joq7xIQD+CfJTax7pPn9rT////hSqJYUoMXkEz5IcO+hptCH1HF3
 qz77aA5njEBQrDRlslUBkCZ5P+QvZgJDy0C3xRGdg6ZVXEXJOQARAQABtCpIYW5uZXMgUmVp
 bmVja2UgKFN1U0UgTGFicykgPGhhcmVAc3VzZS5kZT6JAkEEEwECACsCGwMFCRLMAwAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheABQJOisquAhkBAAoJEGz4yi9OyKjPOHoQAJLeLvr6JNHx
 GPcHXaJLHQiinz2QP0/wtsT8+hE26dLzxb7hgxLafj9XlAXOG3FhGd+ySlQ5wSbbjdxNjgsq
 FIjqQ88/Lk1NfnqG5aUTPmhEF+PzkPogEV7Pm5Q17ap22VK623MPaltEba+ly6/pGOODbKBH
 ak3gqa7Gro5YCQzNU0QVtMpWyeGF7xQK76DY/atvAtuVPBJHER+RPIF7iv5J3/GFIfdrM+wS
 BubFVDOibgM7UBnpa7aohZ9RgPkzJpzECsbmbttxYaiv8+EOwark4VjvOne8dRaj50qeyJH6
 HLpBXZDJH5ZcYJPMgunghSqghgfuUsd5fHmjFr3hDb5EoqAfgiRMSDom7wLZ9TGtT6viDldv
 hfWaIOD5UhpNYxfNgH6Y102gtMmN4o2P6g3UbZK1diH13s9DA5vI2mO2krGz2c5BOBmcctE5
 iS+JWiCizOqia5Op+B/tUNye/YIXSC4oMR++Fgt30OEafB8twxydMAE3HmY+foawCpGq06yM
 vAguLzvm7f6wAPesDAO9vxRNC5y7JeN4Kytl561ciTICmBR80Pdgs/Obj2DwM6dvHquQbQrU
 Op4XtD3eGUW4qgD99DrMXqCcSXX/uay9kOG+fQBfK39jkPKZEuEV2QdpE4Pry36SUGfohSNq
 xXW+bMc6P+irTT39VWFUJMcSuQINBE6KyREBEACvEJggkGC42huFAqJcOcLqnjK83t4TVwEn
 JRisbY/VdeZIHTGtcGLqsALDzk+bEAcZapguzfp7cySzvuR6Hyq7hKEjEHAZmI/3IDc9nbdh
 EgdCiFatah0XZ/p4vp7KAelYqbv8YF/ORLylAdLh9rzLR6yHFqVaR4WL4pl4kEWwFhNSHLxe
 55G56/dxBuoj4RrFoX3ynerXfbp4dH2KArPc0NfoamqebuGNfEQmDbtnCGE5zKcR0zvmXsRp
 qU7+caufueZyLwjTU+y5p34U4PlOO2Q7/bdaPEdXfpgvSpWk1o3H36LvkPV/PGGDCLzaNn04
 BdiiiPEHwoIjCXOAcR+4+eqM4TSwVpTn6SNgbHLjAhCwCDyggK+3qEGJph+WNtNU7uFfscSP
 k4jqlxc8P+hn9IqaMWaeX9nBEaiKffR7OKjMdtFFnBRSXiW/kOKuuRdeDjL5gWJjY+IpdafP
 KhjvUFtfSwGdrDUh3SvB5knSixE3qbxbhbNxmqDVzyzMwunFANujyyVizS31DnWC6tKzANkC
 k15CyeFC6sFFu+WpRxvC6fzQTLI5CRGAB6FAxz8Hu5rpNNZHsbYs9Vfr/BJuSUfRI/12eOCL
 IvxRPpmMOlcI4WDW3EDkzqNAXn5Onx/b0rFGFpM4GmSPriEJdBb4M4pSD6fN6Y/Jrng/Bdwk
 SQARAQABiQIlBBgBAgAPBQJOiskRAhsMBQkSzAMAAAoJEGz4yi9OyKjPgEwQAIP/gy/Xqc1q
 OpzfFScswk3CEoZWSqHxn/fZasa4IzkwhTUmukuIvRew+BzwvrTxhHcz9qQ8hX7iDPTZBcUt
 ovWPxz+3XfbGqE+q0JunlIsP4N+K/I10nyoGdoFpMFMfDnAiMUiUatHRf9Wsif/nT6oRiPNJ
 T0EbbeSyIYe+ZOMFfZBVGPqBCbe8YMI+JiZeez8L9JtegxQ6O3EMQ//1eoPJ5mv5lWXLFQfx
 f4rAcKseM8DE6xs1+1AIsSIG6H+EE3tVm+GdCkBaVAZo2VMVapx9k8RMSlW7vlGEQsHtI0FT
 c1XNOCGjaP4ITYUiOpfkh+N0nUZVRTxWnJqVPGZ2Nt7xCk7eoJWTSMWmodFlsKSgfblXVfdM
 9qoNScM3u0b9iYYuw/ijZ7VtYXFuQdh0XMM/V6zFrLnnhNmg0pnK6hO1LUgZlrxHwLZk5X8F
 uD/0MCbPmsYUMHPuJd5dSLUFTlejVXIbKTSAMd0tDSP5Ms8Ds84z5eHreiy1ijatqRFWFJRp
 ZtWlhGRERnDH17PUXDglsOA08HCls0PHx8itYsjYCAyETlxlLApXWdVl9YVwbQpQ+i693t/Y
 PGu8jotn0++P19d3JwXW8t6TVvBIQ1dRZHx1IxGLMn+CkDJMOmHAUMWTAXX2rf5tUjas8/v2
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <02056612-a958-7b05-3c54-bb2fa69bc493@suse.de>
Date:   Wed, 13 Nov 2019 16:38:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <2cbf591c-8284-8499-7804-e7078cf274d2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/13/19 3:57 PM, John Garry wrote:
> On 13/11/2019 14:06, Hannes Reinecke wrote:
>> On 11/13/19 2:36 PM, John Garry wrote:
>>> Some SCSI HBAs (such as HPSA, megaraid, mpt3sas, hisi_sas_v3 ..) support
>>> multiple reply queues with single hostwide tags.
>>>
>>> In addition, these drivers want to use interrupt assignment in
>>> pci_alloc_irq_vectors(PCI_IRQ_AFFINITY). However, as discussed in [0],
>>> CPU hotplug may cause in-flight IO completion to not be serviced when an
>>> interrupt is shutdown.
>>>
>>> To solve that problem, Ming's patchset to drain hctx's should ensure no
>>> IOs are missed in-flight [1].
>>>
>>> However, to take advantage of that patchset, we need to map the HBA HW
>>> queues to blk mq hctx's; to do that, we need to expose the HBA HW
>>> queues.
>>>
>>> In making that transition, the per-SCSI command request tags are no
>>> longer unique per Scsi host - they are just unique per hctx. As such,
>>> the
>>> HBA LLDD would have to generate this tag internally, which has a certain
>>> performance overhead.
>>>
>>> However another problem is that blk mq assumes the host may accept
>>> (Scsi_host.can_queue * #hw queue) commands. In [2], we removed the Scsi
>>> host busy counter, which would stop the LLDD being sent more than
>>> .can_queue commands; however, we should still ensure that the block
>>> layer
>>> does not issue more than .can_queue commands to the Scsi host.
>>>
>>> To solve this problem, introduce a shared tags per blk_mq_tag_set, which
>>> may be requested when allocating the tagset.
>>>
>>> New flag BLK_MQ_F_TAG_HCTX_SHARED should be set when requesting the
>>> tagset.
>>>
>>> This is based on work originally from Ming Lei in [3].
>>>
>>> [0]
>>> https://lore.kernel.org/linux-block/alpine.DEB.2.21.1904051331270.1802@nanos.tec.linutronix.de/
>>>
>>> [1]
>>> https://lore.kernel.org/linux-block/20191014015043.25029-1-ming.lei@redhat.com/
>>>
>>> [2]
>>> https://lore.kernel.org/linux-scsi/20191025065855.6309-1-ming.lei@redhat.com/
>>>
>>> [3]
>>> https://lore.kernel.org/linux-block/20190531022801.10003-1-ming.lei@redhat.com/
>>>
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   block/blk-core.c       |  1 +
>>>   block/blk-flush.c      |  2 +
>>>   block/blk-mq-debugfs.c |  2 +-
>>>   block/blk-mq-tag.c     | 85 ++++++++++++++++++++++++++++++++++++++++++
>>>   block/blk-mq-tag.h     |  1 +
>>>   block/blk-mq.c         | 61 +++++++++++++++++++++++++-----
>>>   block/blk-mq.h         |  9 +++++
>>>   include/linux/blk-mq.h |  3 ++
>>>   include/linux/blkdev.h |  1 +
>>>   9 files changed, 155 insertions(+), 10 deletions(-)
>>>
>> [ .. ]
>>> @@ -396,15 +398,17 @@ static struct request
>>> *blk_mq_get_request(struct request_queue *q,
>>>           blk_mq_tag_busy(data->hctx);
>>>       }
>>>   -    tag = blk_mq_get_tag(data);
>>> -    if (tag == BLK_MQ_TAG_FAIL) {
>>> -        if (clear_ctx_on_error)
>>> -            data->ctx = NULL;
>>> -        blk_queue_exit(q);
>>> -        return NULL;
>>> +    if (data->hctx->shared_tags) {
>>> +        shared_tag = blk_mq_get_shared_tag(data);
>>> +        if (shared_tag == BLK_MQ_TAG_FAIL)
>>> +            goto err_shared_tag;
>>>       }
>>>   -    rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags,
>>> alloc_time_ns);
>>> +    tag = blk_mq_get_tag(data);
>>> +    if (tag == BLK_MQ_TAG_FAIL)
>>> +        goto err_tag;
>>> +
>>> +    rq = blk_mq_rq_ctx_init(data, tag, shared_tag, data->cmd_flags,
>>> alloc_time_ns);
>>>       if (!op_is_flush(data->cmd_flags)) {
>>>           rq->elv.icq = NULL;
>>>           if (e && e->type->ops.prepare_request) {
> 
> Hi Hannes,
> 
>> Why do you need to keep a parallel tag accounting between 'normal' and
>> 'shared' tags here?
>> Isn't is sufficient to get a shared tag only, and us that in lieo of the
>> 'real' one?
> 
> In theory, yes. Just the 'shared' tag should be adequate.
> 
> A problem I see with this approach is that we lose the identity of which
> tags are allocated for each hctx. As an example for this, consider
> blk_mq_queue_tag_busy_iter(), which iterates the bits for each hctx.
> Now, if you're just using shared tags only, that wouldn't work.
> 
> Consider blk_mq_can_queue() as another example - this tells us if a hctx
> has any bits unset, while with only using shared tags it would tell if
> any bits unset over all queues, and this change in semantics could break
> things. At a glance, function __blk_mq_tag_idle() looks problematic also.
> 
> And this is where it becomes messy to implement.
> 
Oh, my. Indeed, that's correct.

But then we don't really care _which_ shared tag is assigned; so
wouldn't be we better off by just having an atomic counter here?
Cache locality will be blown anyway ...

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
