From: "Ed Lin - PTU" <ed.lin@promise.com>
Subject: RE: [PATCH] stex: Add reset code for st_yel
Date: Mon, 17 Aug 2009 16:03:18 -0700
Message-ID: <85ABFDC4641C4847BA6088F2982EFD8F02A86231@nonamew.ptu.promise.com>
References: <4A8697A2.3050704@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:30008 "EHLO
	nanamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758192AbZHQXDS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Aug 2009 19:03:18 -0400
Content-class: urn:content-classes:message
In-Reply-To: <4A8697A2.3050704@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: "James.Bottomley" <James.Bottomley@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>, Promise_Linux <Promise_Linux@promise.com>



>-----Original Message-----
>From: Jeff Garzik [mailto:jeff@garzik.org] 
>Sent: 2009年8月15日 4:10
>To: Ed Lin - PTU
>Cc: James.Bottomley; linux-scsi; Promise_Linux
>Subject: Re: [PATCH] stex: Add reset code for st_yel
>
>
>Ed Lin wrote:
>> Add reset related code for st_yel.
>> 1. Set the SS_H2I_INT_RESET bit.
>> 2. Wait for the SS_MU_OPERATIONAL flag. This is also part of
>>    normal handshake process so move it to handshake routine.
>> 3. Continue handshake with the firmware.
>> 
>> Signed-off-by: Ed Lin <ed.lin@promise.com>
>> ---
>> 
>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>> index 8d2a95c..b57f92f 100644
>> --- a/drivers/scsi/stex.c
>> +++ b/drivers/scsi/stex.c
>> @@ -55,6 +55,7 @@ enum {
>>  	OIS	= 0x30,	/* MU_OUTBOUND_INTERRUPT_STATUS */
>>  	OIM	= 0x3c,	/* MU_OUTBOUND_INTERRUPT_MASK */
>>  
>> +	YIOA_STATUS				= 0x00,
>>  	YH2I_INT				= 0x20,
>>  	YINT_EN					= 0x34,
>>  	YI2H_INT				= 0x9c,
>> @@ -108,6 +109,10 @@ enum {
>>  
>>  	SS_HEAD_HANDSHAKE			= 0x80,
>>  
>> +	SS_H2I_INT_RESET			= 0x100,
>> +
>> +	SS_MU_OPERATIONAL			= 0x80000000,
>> +
>>  	STEX_CDB_LENGTH				= 16,
>>  	STATUS_VAR_LEN				= 128,
>>  
>> @@ -884,7 +889,7 @@ static void stex_ss_mu_intr(struct st_hba *hba)
>>  		tag = (u16)value;
>>  		if (unlikely(tag >= hba->host->can_queue)) {
>>  			printk(KERN_WARNING DRV_NAME
>> -					"(%s): invalid tag\n", 
>pci_name(hba->pdev));
>> +				"(%s): invalid tag\n", 
>pci_name(hba->pdev));
>>  			continue;
>>  		}
>>  
>> @@ -1040,16 +1045,28 @@ static int stex_ss_handshake(struct 
>st_hba *hba)
>>  	void __iomem *base = hba->mmio_base;
>>  	struct st_msg_header *msg_h;
>>  	struct handshake_frame *h;
>> -	__le32 *scratch = hba->scratch;
>> +	__le32 *scratch;
>>  	u32 data;
>>  	unsigned long before;
>>  	int ret = 0;
>>  
>> -	h = (struct handshake_frame *)(hba->alloc_rq(hba));
>> -	msg_h = (struct st_msg_header *)h - 1;
>> +	before = jiffies;
>> +	while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
>> +		if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
>> +			printk(KERN_ERR DRV_NAME
>> +				"(%s): firmware not operational\n",
>> +				pci_name(hba->pdev));
>> +			return -1;
>> +		}
>> +		rmb();
>> +		msleep(1);
>> +	}
>
>hmmmmm.  Is that rmb() really necessary?  It does not appear to be so.
>
>At worst, the rmb should occur immediately after the loop, no?
>
>ACK everything else.
>
>	Jeff
>
>
>

Do you mean rmb() is not needed for readl()? I checked the x86 version
of readl() and it seems to be so. If so I will come up with a new patch
removing this thing.

Thanks,
Ed Lin
