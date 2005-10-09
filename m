From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 0/3] libata: scsi error handling, encore
Date: Sun, 09 Oct 2005 13:30:44 -0400
Message-ID: <434953C4.4000201@adaptec.com>
References: <43490BC8.9060504@torque.net> <434919E4.1080601@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37272 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932161AbVJIRa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2005 13:30:59 -0400
In-Reply-To: <434919E4.1080601@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: dougg@torque.net, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, htejun@gmail.com, russb@emc.com

On 10/09/05 09:23, Jeff Garzik wrote:
> 4) I excised the following chunk from patch #2, before applying:
> 
> 
>>@@ -1572,7 +1628,7 @@
>> 		 * time).  We need to issue REQUEST SENSE some other
>> 		 * way, to avoid completing the command twice.
>> 		 */
>>-		cmd->result = SAM_STAT_CHECK_CONDITION;
>>+		cmd->result = (DRIVER_SENSE << 24) | SAM_STAT_CHECK_CONDITION;
>> 
>> 		qc->scsidone(cmd);
> 
> 
> We don't yet have sense at this point; the code above largely serves as 
> a trigger to a SCSI EH kthread, which will wake up and issue REQUEST 
> SENSE for us.  Its a bit of a weird setup, and I'm also working in this 
> area, so I simply removed the above quoted change from your patch, which 
> was applied otherwise unaltered.

If libata-scsi aspires to become SATL*, it needs to implement
autosense (which has been the norm since 2002 and everyone has
already forgotten this word, since it is the norm).

E.g. If you look at the SAS Code, you have more than enough
information to generate it (see sas_task.h::struct ata_task_resp).

	Luben
* libata-scsi would need a _lot_ of changes to become SATL.  Would
it be more efficient to start from a clean slate (drivers/scsi/satl/satl.c)
or change libata-scsi beyond recognition?  What is the political stance
on this?

-- 
http://linux.adaptec.com/sas/
Disclaimer: Opinions stated in this email are my own, not of my employer.
For inquiries write to: luben_tuikov@adaptec.com or ltuikov@yahoo.com.
