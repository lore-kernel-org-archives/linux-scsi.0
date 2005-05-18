From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: [PATCH 2.6.12-rc4-mm1 4/4] megaraid_sas: updating the driver
Date: Tue, 17 May 2005 22:59:13 -0400
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57060CCE9A@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:24234 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262066AbVERDP2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2005 23:15:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, "'Matt_Domsch@Dell.com'" <Matt_Domsch@Dell.com>, Andrew Morton <akpm@osdl.org>, 'James Bottomley' <James.Bottomley@SteelEye.com>

>> +#define RD_OB_MSG_0(regs)	readl((void*)(&(regs)->outbound_msg_0))
>> +#define WR_IN_MSG_0(v, regs)	
>writel((v),(void*)(&(regs)->inbound_msg_0))
>> +#define WR_IN_DOORBELL(v, regs)
>> writel((v),(void*)(&(regs)->inbound_doorbell))
>> +#define WR_IN_QPORT(v, regs)
>> writel((v),(void*)(&(regs)->inbound_queue_port))
>> +
>> +#define RD_OB_INTR_STATUS(regs)
>> readl((void*)(&(regs)->outbound_intr_status))
>> +#define WR_OB_INTR_STATUS(v, regs)
>> writel((v),(&(regs)->outbound_intr_status))
>
>The void * casats are not okay.  Please make sure all your variable
>holding the I/O address are of type void __iomem * and use 
>sparse to check
>it.  I would have sent you sparse output if your mailer didn't mangle
>the patch so it couldn't be applied..
>

I will remove these macros. What is sparse output?

>> +#define SCP2HOST(scp)		(scp)->device->host	
>// to host
>> +#define SCP2HOSTDATA(scp)	SCP2HOST(scp)->hostdata	// to soft state
>> +#define SCP2CHANNEL(scp)	(scp)->device->channel	// to channel
>> +#define SCP2TARGET(scp)		(scp)->device->id	
>// to target
>> +#define SCP2LUN(scp)		(scp)->device->lun	
>// to LUN
>
>Please remove all these macros.

Christoph, I use these macros to have commonality between 2.4 and 2.6
kernels. Please consider retaining them. 

>
>Also I can't find any endianess handling.  You should probably declare
>all hardware structures __le* and use proper le*_to_cpu/cpu_to_le* when
>accessing them.  sparse -Wbitwise helps finding errors in 
>endianess handling
>

I will do that.

Thanks,
Sreenivas
