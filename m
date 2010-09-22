From: David Milburn <dmilburn@redhat.com>
Subject: Re: [PATCH] mvsas: defer non-NCQ cmds when NCQ cmds are active
Date: Tue, 21 Sep 2010 19:24:46 -0500
Message-ID: <4C994CCE.3020607@redhat.com>
References: <20100921191701.GA16726@dhcp-10-15-1-70.hsv.redhat.com> <1285102274.16440.132.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26479 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0IVAY2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2010 20:24:28 -0400
In-Reply-To: <1285102274.16440.132.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, jeff@garzik.org, k.skarlatos@gmail.com

James Bottomley wrote:
> On Tue, 2010-09-21 at 14:17 -0500, David Milburn wrote:
>> Non-NCQ commands should run exclusively, ata_qc_issue warns when mixing
>> non-NCQ and NCQ commands.
>>
>> Signed-off-by: David Milburn <dmilburn@redhat.com>
>> Reported-by: Konstantinos Skarlatos <k.skarlatos@gmail.com>
>> ---
>>  drivers/scsi/libsas/sas_ata.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
>> index 042153c..ddbade7 100644
>> --- a/drivers/scsi/libsas/sas_ata.c
>> +++ b/drivers/scsi/libsas/sas_ata.c
>> @@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link *link, unsigned int sc_reg_in,
>>  static struct ata_port_operations sas_sata_ops = {
>>  	.phy_reset		= sas_ata_phy_reset,
>>  	.post_internal_cmd	= sas_ata_post_internal,
>> +	.qc_defer               = ata_std_qc_defer,
> 
> What does this do on the card that doesn't need it: the aic94xx?  That
> one takes in a pipeline of commands and takes responsibility for getting
> the issue right.  Something like this throttles the pipeline higher than
> the aic94xx is expecting.  However, as long as it's not too much of a
> performance problem, I don't mind applying it.

James,

For any driver using sas_sata_ops, it could effect performance for
those drivers whose execute_task handles both, though I can't say
I am real familiar with aic94xx.

Thanks,
David



> 
> James
> 
> 

