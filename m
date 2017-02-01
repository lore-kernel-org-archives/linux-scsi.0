From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sg: remove unreachable code in SET_FORCE_LOW_DMA
Date: Wed, 1 Feb 2017 14:05:07 +0100
Message-ID: <9ce5c116-47da-32c1-dece-a3470aafcf2e@suse.de>
References: <1485948399-83339-1-git-send-email-hare@suse.de>
 <20170201130048.GA5125@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40151 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750863AbdBANF2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 08:05:28 -0500
In-Reply-To: <20170201130048.GA5125@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/01/2017 02:00 PM, Christoph Hellwig wrote:
> On Wed, Feb 01, 2017 at 12:26:39PM +0100, Hannes Reinecke wrote:
>> The low_dma value is always '1' in that branch, so the remaining
>> 'if' statement can never be reached.
>>
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>>  drivers/scsi/sg.c | 9 ++-------
>>  1 file changed, 2 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
>> index dbe5b4b..652b934 100644
>> --- a/drivers/scsi/sg.c
>> +++ b/drivers/scsi/sg.c
>> @@ -890,14 +890,9 @@ static int max_sectors_bytes(struct request_queue *q)
>>  		result = get_user(val, ip);
>>  		if (result)
>>  			return result;
>> -		if (val) {
>> +		if (val)
>>  			sfp->low_dma = 1;
>> -			if ((0 == sfp->low_dma) && (0 == sg_res_in_use(sfp))) {
>> -				val = (int) sfp->reserve.bufflen;
>> -				sg_remove_scat(sfp, &sfp->reserve);
>> -				sg_build_reserve(sfp, val);
>> -			}
>> -		} else {
>> +		else {
> 
> I think the proper fix is to check sfp->low_dma for 0 before updating
> it, at least that seems to be the intent here.
> 
May. Or may not.

But this code path has _never_ been taken for the last ten years; this
particular code predates the initial git check-in from Linus.
Where would be the point of enabling it now?
(Especially given all the issues we're having with the sg driver ...)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
