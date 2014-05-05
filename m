From: =?UTF-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Subject: Re: [PATCH v1.0 14/16] arcmsr: fix sparse checking error
Date: Mon, 5 May 2014 12:10:39 +0800
Message-ID: <CAKiknE-cJZpkpjMEPiX_cP4iC3e_b5huk2WJBvK2FpkKHecJoQ@mail.gmail.com>
References: <1398857906.6930.59.camel@localhost>
	<20140502091315.GG4963@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140502091315.GG4963@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: James Bottomley <jbottomley@parallels.com>, Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Dan,

In this patch, there are several replace of call readl() or writel()
by direct access to memory.
Because in main memory, we allocated a block of memory for
post_qbuffer and done_qbuffer.
These memory are access by both of CPU and IOP, they are not hardware registers.
This change will not introduce a bug. I have verified it.

Thanks for your comment.

Regards,
Ching


2014-05-02 17:13 GMT+08:00 Dan Carpenter <dan.carpenter@oracle.com>:
> On Wed, Apr 30, 2014 at 07:38:26PM +0800, ching wrote:
>> From: Ching<ching2048@areca.com.tw>
>>
>> Fix sparse utility checking errors.
>>
>
> I was expecting that this patch would add __iomem annotations throughout
> but in several places it actually removes calls to readl() and writel()
> as well.
>
>>       case ACB_ADAPTER_TYPE_C:{
>> -             struct MessageUnit_C *reg = (struct MessageUnit_C *)acb->pmuC;
>> +             struct MessageUnit_C __iomem *reg = acb->pmuC;
>>               /* disable all outbound interrupt */
>>               orig_mask = readl(&reg->host_int_mask); /* disable outbound message0 int */
>>               writel(orig_mask|ARCMSR_HBCMU_ALL_INTMASKENABLE, &reg->host_int_mask);v
>> @@ -1085,8 +1085,9 @@ static void arcmsr_done4abort_postqueue(
>>               /*clear all outbound posted Q*/
>>               writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell); /* clear doorbell interrupt */
>>               for (i = 0; i < ARCMSR_MAX_HBB_POSTQUEUE; i++) {
>> -                     if ((flag_ccb = readl(&reg->done_qbuffer[i])) != 0) {
>> -                             writel(0, &reg->done_qbuffer[i]);
>> +                     flag_ccb = reg->done_qbuffer[i];
>> +                     if (flag_ccb != 0) {
>> +                             reg->done_qbuffer[i] = 0;
>>                               pARCMSR_CDB = (struct ARCMSR_CDB *)(acb->vir2phy_offset+(flag_ccb << 5));/*frame must be 32 bytes aligned*/
>>                               pCCB = container_of(pARCMSR_CDB, struct CommandControlBlock, arcmsr_cdb);
>>                               error = (flag_ccb & ARCMSR_CCBREPLY_FLAG_ERROR_MODE0) ? true : false;
>
> I don't know the hardware, but it doesn't even seem to make sense to me.
> if "reg" is an __iomem pointer surely an offset into reg is an iomem
> pointer as well.
>
> I am worried that this introduces a bug.
>
> regards,
> dan carpenter
