From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [PATCH] scsi: aacraid: rcode is unsigned, so can never be less
 than zero
Date: Tue, 7 Feb 2017 11:37:43 +0000
Message-ID: <ebdf99a4-667a-8d83-f927-2a0dabf273ca@canonical.com>
References: <20170207112738.18486-1-colin.king@canonical.com>
 <20170207113717.GB11154@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170207113717.GB11154@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 07/02/17 11:37, Dan Carpenter wrote:
> On Tue, Feb 07, 2017 at 11:27:38AM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The check on rcode >= 0 is always true because rcode is unsigned
>> and can never be less than zero.  Remove the redundant check.
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/scsi/aacraid/aachba.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
>> index 3b5ddf4..ddfd726 100644
>> --- a/drivers/scsi/aacraid/aachba.c
>> +++ b/drivers/scsi/aacraid/aachba.c
>> @@ -1848,7 +1848,7 @@ int aac_report_phys_luns(struct aac_dev *dev, struct fib *fibptr, int rescan)
>>  			FsaNormal, 1, 1, NULL, NULL);
>>  
>>  	/* analyse data */
>> -	if (rcode >= 0 && phys_luns->resp_flag == 2) {
> 
> The original code is buggy.  rcode should be an int.

Thanks for spotting that. Oops.

> 
> regards,
> dan carpenter
> 
