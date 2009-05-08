From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 4/4] mvsas: Fine-tuned tags array for alignment
Date: Fri, 08 May 2009 12:22:58 -0400
Message-ID: <4A045C62.50404@garzik.org>
References: <20090508061852.GA1893@jason.marvell.com> <1241795999.3327.38.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:52781 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbZEHQXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 May 2009 12:23:00 -0400
In-Reply-To: <1241795999.3327.38.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ying Chu <jasonchu@marvell.com>, linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2009-05-08 at 14:18 +0800, Ying Chu wrote:
>> >From 2269b0ff3c2573f76cb0569eb5da99e9f12711d1 Mon Sep 17 00:00:00 2001
>> From: ayan <ayan@marvell.com>
>> Date: Fri, 8 May 2009 19:59:39 +0800
>> Subject: [PATCH 4/4] bug fix: alignment 
>>
>> Fine-tuned tags array with u32 for alignment. 
>>
>> Signed-off-by: Ying Chu <jasonchu@marvell.com>
>> Signed-off-by: Andy Yan <ayan@marvell.com>
>> Signed-off-by: Ke Wei <kewei@marvell.com>
>> ---
>>  drivers/scsi/mvsas/mv_sas.h |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
>> index 75b9748..04f27bf 100644
>> --- a/drivers/scsi/mvsas/mv_sas.h
>> +++ b/drivers/scsi/mvsas/mv_sas.h
>> @@ -313,7 +313,7 @@ struct mvs_info {
>>  	const struct mvs_chip_info *chip;
>>  
>>  	int tags_num;
>> -	u8 tags[MVS_SLOTS >> 3];
>> +	u32 tags[MVS_SLOTS >> 5];
> 
> Why not just do 
> 
> DECLARE_BITMAP(tags, MVS_SLOTS);
> 
> here? ... that way you're using the correctly defined type for the
> bitmap operations and you can lose the spurious (void *) cast in your
> bitmap wrapper operations.

Agreed.  Type 'u32' is incorrect for bitmap operations...  it needs to 
be 'unsigned long', which is what DECLARE_BITMAP gives you.

	Jeff




