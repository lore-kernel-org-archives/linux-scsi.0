Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09D42222C4
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 20:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908935; cv=none; b=ONyRyHC1zj8NyH0+S/uY/F6rU5VANHsOJLboyDW+n7n2bQvrXIu55oqH9ms1I3ZAfevtaqh1GHpZX1pt768gVJjFuG1MlMqcHFqhbtsdIcqoqrtv+jhUoS47fn9bPeiNruLJDl/i9VZdMY4/owXyEssAviZadq8sXfYAAN2OX1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908935; c=relaxed/simple;
	bh=A8Aw+mPrgehuW8bHrr+C5YTDn03XNzH2c2IiRR3j5WY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I5Vl5Z8WUz8JYKjheCfTynYdYZGfAwXWkofS9G8dy+4jGad/lUNDPDQL58qWFz1xPuAVGBNsVK0mQalz0SMuTUZq1+JNdhLoN/8H0w1kU/J6N6R/cpF3V2Tn4tJNSp7HqAnr48nF7QCck8kQb5Sr3ecdq4on02lZPF8wDGQO5vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com; spf=pass smtp.mailfrom=embeddedor.com; dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b=NbkHkpA7; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=embeddedor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=embeddedor.com header.i=@embeddedor.com header.b="NbkHkpA7"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id hD3xupJdP1jt6hDpkutYEk; Wed, 30 Jul 2025 20:55:32 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
	by cmsmtp with ESMTPS
	id hDpjuTG185MXOhDpkuImSf; Wed, 30 Jul 2025 20:55:32 +0000
X-Authority-Analysis: v=2.4 cv=et7fzppX c=1 sm=1 tr=0 ts=688a86c4
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=elAakMZAzsQyfqpwiXQzJA==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7T7KSl7uo7wA:10 a=20KFwNOVAAAA:8
 a=_Wotqz80AAAA:8 a=TJLAJ6qVr0XwJw5lu-gA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=buJP51TR1BpY-zbLSsyS:22 a=xYX6OU9JNrHFPr8prv8u:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=dHh2fkqoc0wYykD0z2uFJ60z/WmFdyPmF/+FyL5LJiU=; b=NbkHkpA7Qj256LuQbnPD8kq+Dr
	fxMLagQqLY/Jq9iVzuDGY5vM6L1mTpLwF2R8oP0l/GqCLdPGaz947A38rFSkBpW1M4DeXHiUyF82q
	WRzO3YIjgaLuMu20D+QIj3eeAsQV0it5yGE6NKvyt2cDoqYKunzqGO0T0u8gxy+57LrxSA92ZMOaG
	pHWe+5Xp0e7/kVcleNiiiI/SRBd3ZGQ9rapykppamVN1qji2KC6hYNBhbbHXrbKiU01+/giEg5X5K
	2TmeoZlHjc7hmuvbYg14cYs1/GIzkL9kOo+2qfukjxbZ5gMKsUTIgkEyB9J1FwetwELKAcRCQYe4F
	AB35WiVA==;
Received: from [177.238.16.239] (port=60462 helo=[192.168.0.21])
	by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <gustavo@embeddedor.com>)
	id 1uhDpi-000000018m0-3DLT;
	Wed, 30 Jul 2025 15:55:31 -0500
Message-ID: <3e1ef565-3f3b-4fd9-8ae7-2af3d2581f99@embeddedor.com>
Date: Wed, 30 Jul 2025 14:55:23 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible array
 purex_item.iocb
To: Bryan Gurney <bgurney@redhat.com>
Cc: Chris Leech <cleech@redhat.com>, linux-scsi@vger.kernel.org,
 Nilesh Javali <njavali@marvell.com>, Kees Cook <kees@kernel.org>,
 "Gustavo A . R . Silva" <gustavoars@kernel.org>,
 John Meneghini <jmeneghi@redhat.com>, linux-hardening@vger.kernel.org
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
 <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
 <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
 <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
 <f9525216-5721-4f9e-99ab-d697506e0e8f@embeddedor.com>
 <6d8f13c8-405f-4fa0-ad23-09c9e4c5cd54@embeddedor.com>
 <22825ff4-0545-4e6b-92a6-64ddfac82b55@embeddedor.com>
 <CAHhmqcSzwnz+jir+vMjH2j7k+4JtyJ5wvr0deLXJvinSiSKzCg@mail.gmail.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <CAHhmqcSzwnz+jir+vMjH2j7k+4JtyJ5wvr0deLXJvinSiSKzCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.16.239
X-Source-L: No
X-Exim-ID: 1uhDpi-000000018m0-3DLT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.16.239]:60462
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 7
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKzKvRpJJQP6JQpd9EKXOtPE+5zS3zSmLrUnT0X0KG7OlCna34xn2JE+5Ftra0mCpyjl1L8dHQBQpNLWwDg3ihRD7C4LLwUiXVsoMXZdekABvDcXtBmU
 XH4xvgDWjdhrBF2VWJ8K8hxp0P1gY2JtS7mdF2ISz4OTA3uBBgAcM83nAtBXZpzXUghIcVuGcsvUSaxmgQyaNBKorazpjtGnrypqBo47VIPB0zAUQ4yGTCQY



On 30/07/25 09:43, Bryan Gurney wrote:
> Hi Gustavo,
> 
> Yes, it passes.  When I test this on top of the NVMe FPIN link
> integrity v9 patchset, I only see the "kernel: qla2xxx... : FPIN ELS"
> event.
> 
> Tested-by: Bryan Gurney <bgurney@redhat.com>

Awesome. :)

Thanks!
-Gustavo

> 
> 
> Thanks,
> 
> Bryan
> 
> On Tue, Jul 29, 2025 at 11:45 PM Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
>>
>> Hi Bryan,
>>
>> I wonder if you could run your tests on the patch below and let me
>> know if it passes. If it does, I'll go ahead and submit it as a
>> proper patch (including your Tested-by tag) to the SCSI list.
>>
>> Thank you!
>> -Gustavo
>>
>>>
>>> The (untested) patch below avoids the use of `struct_group_tagged()`
>>> and the casts to `struct purex_item *`:
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
>>> index cb95b7b12051..4bdf8adf04ed 100644
>>> --- a/drivers/scsi/qla2xxx/qla_def.h
>>> +++ b/drivers/scsi/qla2xxx/qla_def.h
>>> @@ -4890,9 +4890,7 @@ struct purex_item {
>>>                                struct purex_item *pkt);
>>>           atomic_t in_use;
>>>           uint16_t size;
>>> -       struct {
>>> -               uint8_t iocb[64];
>>> -       } iocb;
>>> +       uint8_t iocb[] __counted_by(size);
>>>    };
>>>
>>>    #include "qla_edif.h"
>>> @@ -5101,7 +5099,6 @@ typedef struct scsi_qla_host {
>>>                   struct list_head head;
>>>                   spinlock_t lock;
>>>           } purex_list;
>>> -       struct purex_item default_item;
>>>
>>>           struct name_list_extended gnl;
>>>           /* Count of active session/fcport */
>>> @@ -5130,6 +5127,10 @@ typedef struct scsi_qla_host {
>>>    #define DPORT_DIAG_IN_PROGRESS                 BIT_0
>>>    #define DPORT_DIAG_CHIP_RESET_IN_PROGRESS      BIT_1
>>>           uint16_t dport_status;
>>> +
>>> +       TRAILING_OVERLAP(struct purex_item, default_item, iocb,
>>> +               uint8_t __default_item_iocb[QLA_DEFAULT_PAYLOAD_SIZE];
>>> +       );
>>>    } scsi_qla_host_t;
>>>
>>>    struct qla27xx_image_status {
>>> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
>>> index c4c6b5c6658c..4559b490614d 100644
>>> --- a/drivers/scsi/qla2xxx/qla_isr.c
>>> +++ b/drivers/scsi/qla2xxx/qla_isr.c
>>> @@ -1077,17 +1077,17 @@ static struct purex_item *
>>>    qla24xx_alloc_purex_item(scsi_qla_host_t *vha, uint16_t size)
>>>    {
>>>           struct purex_item *item = NULL;
>>> -       uint8_t item_hdr_size = sizeof(*item);
>>>
>>>           if (size > QLA_DEFAULT_PAYLOAD_SIZE) {
>>> -               item = kzalloc(item_hdr_size +
>>> -                   (size - QLA_DEFAULT_PAYLOAD_SIZE), GFP_ATOMIC);
>>> +               item = kzalloc(struct_size(item, iocb, size), GFP_ATOMIC);
>>>           } else {
>>>                   if (atomic_inc_return(&vha->default_item.in_use) == 1) {
>>>                           item = &vha->default_item;
>>>                           goto initialize_purex_header;
>>>                   } else {
>>> -                       item = kzalloc(item_hdr_size, GFP_ATOMIC);
>>> +                       item = kzalloc(
>>> +                               struct_size(item, iocb, QLA_DEFAULT_PAYLOAD_SIZE),
>>> +                               GFP_ATOMIC);
>>>                   }
>>>           }
>>>           if (!item) {
>>> @@ -1127,17 +1127,16 @@ qla24xx_queue_purex_item(scsi_qla_host_t *vha, struct purex_item *pkt,
>>>     * @vha: SCSI driver HA context
>>>     * @pkt: ELS packet
>>>     */
>>> -static struct purex_item
>>> -*qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>>> +static struct purex_item *
>>> +qla24xx_copy_std_pkt(struct scsi_qla_host *vha, void *pkt)
>>>    {
>>>           struct purex_item *item;
>>>
>>> -       item = qla24xx_alloc_purex_item(vha,
>>> -                                       QLA_DEFAULT_PAYLOAD_SIZE);
>>> +       item = qla24xx_alloc_purex_item(vha, QLA_DEFAULT_PAYLOAD_SIZE);
>>>           if (!item)
>>>                   return item;
>>>
>>> -       memcpy(&item->iocb, pkt, sizeof(item->iocb));
>>> +       memcpy(&item->iocb, pkt, QLA_DEFAULT_PAYLOAD_SIZE);
>>>           return item;
>>>    }
>>>
>>> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
>>> index 8ee2e337c9e1..92488890bc04 100644
>>> --- a/drivers/scsi/qla2xxx/qla_nvme.c
>>> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
>>> @@ -1308,7 +1308,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
>>>
>>>           ql_dbg(ql_dbg_unsol, vha, 0x2121,
>>>                  "PURLS OP[%01x] size %d xchg addr 0x%x portid %06x\n",
>>> -              item->iocb.iocb[3], item->size, uctx->exchange_address,
>>> +              item->iocb[3], item->size, uctx->exchange_address,
>>>                  fcport->d_id.b24);
>>>           /* +48    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
>>>            * ----- -----------------------------------------------
>>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>>> index d4b484c0fd9d..253f802605d6 100644
>>> --- a/drivers/scsi/qla2xxx/qla_os.c
>>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>>> @@ -6459,9 +6459,10 @@ void qla24xx_process_purex_rdp(struct scsi_qla_host *vha,
>>>    void
>>>    qla24xx_free_purex_item(struct purex_item *item)
>>>    {
>>> -       if (item == &item->vha->default_item)
>>> +       if (item == &item->vha->default_item) {
>>>                   memset(&item->vha->default_item, 0, sizeof(struct purex_item));
>>> -       else
>>> +               memset(&item->vha->__default_item_iocb, 0, QLA_DEFAULT_PAYLOAD_SIZE);
>>> +       } else
>>>                   kfree(item);
>>>
>>> Thanks
>>> -Gustavo
>>
> 

