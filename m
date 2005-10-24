From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH RFC] use struct scsi_lun in generic code
Date: Mon, 24 Oct 2005 10:55:36 -0400
Message-ID: <435CF5E8.5020702@adaptec.com>
References: <20051023043301.GA22615@havoc.gtf.org> <435B1E0E.8060409@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:13256 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751053AbVJXOzn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 10:55:43 -0400
In-Reply-To: <435B1E0E.8060409@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On 10/23/05 01:22, Douglas Gilbert wrote:
>>A further experiment:  once dev_printk() has been used to eliminate
>>direct references to HCIL address (see previous patch), we can see what
>>happens when we update the core to use struct scsi_lun.
>>
>>DO NOT APPLY.
>>
>>Depends on previous "kill scsi_device::{channel,id} in generic code"
>>patch.
>>
>>Changes:
>>
>>* replace 'unsigned int lun' with 'struct scsi_lun lun' in struct scsi_device
>>
>>* change various function args to receive 'const struct scsi_lun *'
>>  rather than unsigned int.
>>
>>* export scsilun_to_int()
>>
>>* create scsilun_to_str() helper
>>
>>* create scsilun_eq() helper
>>
>>* update all references to scsi_device::lun, as caught by the compiler.
>>
>>  Again, generic code was 100% converted, driver code 0% converted.
>>
>>* int_to_scsilun() is used to convert SCSI-2 luns, and luns passed
>>  from userspace as integers, to struct scsi_lun.
>>
>>* shost->max_lun check moved into scsi_scan_host_selected() callers
> 
> 
> Jeff,
> With 8 byte luns, max_lun is legacy. I found it a nuisance

I agree.

Furthermore, a LUN is just u8[8] and I don't think there's a reason
to wrap that in a struct.  (Incidentally a logical unit number is
not a number but a structure.)

Other than application clients and device servers, I don't think
that the kernel should in anyway interpret the LUN structure.
It is just u8[8] and this is what the kernel should pass around.

Cf. drivers/scsi/sas/sas_discover.c and include/scsi/sas/sas_task.h.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
