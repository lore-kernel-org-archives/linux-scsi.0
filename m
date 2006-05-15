From: "HighPoint Linux Team" <linux@highpoint-tech.com>
Subject: Re: [PATCH] hptiop: HighPoint RocketRAID 3xxx controller driver
Date: Mon, 15 May 2006 14:22:44 +0800
Message-ID: <041901c677e7$fdd9fbf0$1200a8c0@GMM>
References: <200605122209.k4CM95oW014664@mail.hypersurf.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stats.hypersurf.com ([209.237.0.12]:24839 "EHLO
	stats.hypersurf.com") by vger.kernel.org with ESMTP id S932114AbWEOGWa
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 May 2006 02:22:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "\"Arjan van de Ven\"" <arjan@infradead.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Could you give more explanation about pci posting flush? When (and why) do we need it?
In an old posting (http://lkml.org/lkml/2003/5/8/278) said pci posting flush is unnecessary - is it correct?

Thanks.

>
>> + }
>> +
>> + if (req != IOPMU_QUEUE_EMPTY) {
> +  writel(req, &iop->outbound_queue);
>
>does this need a PCI posting flush?
>
>> +
>> +static int iop_send_sync_msg(struct hptiop_hba * hba, u32 msg, u32 
>> +millisec) {
>> + u32 i;
>> +
>> + hba->msg_done = 0;
>> +
>> + writel(msg, &hba->iop->inbound_msgaddr0);
>> +
>> + for (i = 0; i < millisec; i++) {
>> +  __iop_intr(hba);
>> +  if (hba->msg_done)
>> +   break;
>> +  mdelay(1);
>> + }
>>
>>and here, but here you're very clearly missing a pci posting flush
>>
>> + else
>> +  arg->result = HPT_IOCTL_RESULT_FAILED;
>> +
>> + arg->done(arg);
>> + writel(tag, &hba->iop->outbound_queue); }
>
>this looks like it needs a posting flush again
>
>> + memcpy(req->cdb, scp->cmnd, sizeof(req->cdb));
>> +
>> + writel(IOPMU_QUEUE_ADDR_HOST_BIT | _req->req_shifted_phy,
>> +   &hba->iop->inbound_queue);
>
>this needs pci posting flush
>
>> +
>> +static int hptiop_reset_hba(struct hptiop_hba * hba) {  if 
>> +(atomic_xchg(&hba->resetting, 1) == 0) {
>> +  atomic_inc(&hba->reset_count);
>> +  writel(IOPMU_INBOUND_MSG0_RESET,
>> +    &hba->iop->outbound_msgaddr0);
>> + }
>
>this needs a pci posting flush


