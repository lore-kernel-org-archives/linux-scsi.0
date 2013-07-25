From: "Anand Kumar Santhanam" <AnandKumar.Santhanam@pmcs.com>
Subject: RE: [PATCH] pm80xx: fix Adaptec 71605H hang
Date: Thu, 25 Jul 2013 00:20:13 -0700
Message-ID: <E5DEE6F468524847995699AD11E8088501BED4E0@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca>
References: <51E2605D.3000301@xs4all.nl> <51E3C46E.8030600@gmail.com> <E5DEE6F468524847995699AD11E8088501BED4A5@BBY1EXM11.pmc_nt.nt.pmc-sierra.bc.ca> <51F0C9F3.7030500@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60266 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096Ab3GYHUG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 03:20:06 -0400
Content-class: urn:content-classes:message
In-Reply-To: <51F0C9F3.7030500@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jack Wang <xjtuwjp@gmail.com>, linux-scsi@vger.kernel.org, lindar_liu@usish.com, Sangeetha Gnanasekaran <Sangeetha.Gnanasekaran@pmcs.com>, jinpu.wang@profitbricks.com

Hans,

The below #defines are available in pm8001_defs.h

/* Inbound/Outbound queue size */
#define IOMB_SIZE_SPC           64
#define IOMB_SIZE_SPCV        128

You can use IOMB_SIZE_SPC in pm8001_hwi.c file and IOMB_SIZE_SPCV in
pm80xx_hwi.c 

Regards
Anand

-----Original Message-----
From: Hans Verkuil [mailto:hverkuil@xs4all.nl] 
Sent: Thursday, July 25, 2013 12:17 PM
To: Anand Kumar Santhanam
Cc: Jack Wang; linux-scsi@vger.kernel.org; lindar_liu@usish.com;
Sangeetha Gnanasekaran; jinpu.wang@profitbricks.com
Subject: Re: [PATCH] pm80xx: fix Adaptec 71605H hang

Hi Anand,

On 07/25/2013 06:44 AM, Anand Kumar Santhanam wrote:
> Hi Hans,
> 
> Are you planning to address the below comment and submit an updated 
> patch?

I think there was a misunderstanding there. It was my impression that
you would do a follow-up patch for that.

I can add the define if you want, but where do you want it? In
pm8001_defs.h with the name PM80XX_MPI_IOMB_SIZE_SPCV? Should I create a
PM8001_MPI_IOMB_SIZE_SPCV as well?

Regards,

	Hans

> 
> Regards
> Anand
> 
> -----Original Message-----
> From: Jack Wang [mailto:xjtuwjp@gmail.com]
> Sent: Monday, July 15, 2013 3:14 PM
> To: Hans Verkuil
> Cc: linux-scsi@vger.kernel.org; Anand Kumar Santhanam; 
> lindar_liu@usish.com; Sangeetha Gnanasekaran; 
> jinpu.wang@profitbricks.com
> Subject: Re: [PATCH] pm80xx: fix Adaptec 71605H hang
> 
> On 07/14/2013 10:25 AM, Hans Verkuil wrote:
>> The IO command size is 128 bytes for these new controllers as opposed

>> to 64 for the old 8001 controller.
>>
>> The Adaptec out-of-tree driver did this correctly. After comparing 
>> the
> 
>> two this turned out to be the crucial difference.
> Thanks Hans for this fix.
> We'd better use more meaningful Micro like:
> 
> #define MPI_IOMB_SIZE_SPCV 128 and replace current hard coded one.
> 
> Thanks,
> Jack
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Acked-by: AnandKumar.Santhanam@pmcs.com
>> Cc: stable@vger.kernel.org      # for v3.10 and up
>> ---
>>  drivers/scsi/pm8001/pm80xx_hwi.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c
>> b/drivers/scsi/pm8001/pm80xx_hwi.c
>> index 302514d..e1db5ca 100644
>> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
>> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
>> @@ -275,7 +275,7 @@ static void init_default_table_values(struct 
>> pm8001_hba_info *pm8001_ha)
>>  
>>  	for (i = 0; i < PM8001_MAX_SPCV_INB_NUM; i++) {
>>  		pm8001_ha->inbnd_q_tbl[i].element_pri_size_cnt	=
>> -			PM8001_MPI_QUEUE | (64 << 16) | (0x00<<30);
>> +			PM8001_MPI_QUEUE | (128 << 16) | (0x00<<30);
>>  		pm8001_ha->inbnd_q_tbl[i].upper_base_addr	=
>>  			pm8001_ha->memoryMap.region[IB +
> i].phys_addr_hi;
>>  		pm8001_ha->inbnd_q_tbl[i].lower_base_addr	=
>> @@ -301,7 +301,7 @@ static void init_default_table_values(struct
> pm8001_hba_info *pm8001_ha)
>>  	}
>>  	for (i = 0; i < PM8001_MAX_SPCV_OUTB_NUM; i++) {
>>  		pm8001_ha->outbnd_q_tbl[i].element_size_cnt	=
>> -			PM8001_MPI_QUEUE | (64 << 16) | (0x01<<30);
>> +			PM8001_MPI_QUEUE | (128 << 16) | (0x01<<30);
>>  		pm8001_ha->outbnd_q_tbl[i].upper_base_addr	=
>>  			pm8001_ha->memoryMap.region[OB +
> i].phys_addr_hi;
>>  		pm8001_ha->outbnd_q_tbl[i].lower_base_addr	=
>>
