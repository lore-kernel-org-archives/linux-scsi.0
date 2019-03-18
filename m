From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH] scsi: lpfc_nvme: Fix wrong sizeof argument
Date: Mon, 18 Mar 2019 14:58:03 -0700
Message-ID: <872b6dcf-929c-9e2c-3c71-0b2943191c9f@broadcom.com>
References: <20190318171505.GA8748@embeddedor>
 <1552931093.3203.25.camel@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552931093.3203.25.camel@linux.ibm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <jejb@linux.ibm.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Dick Kennedy <dick.kennedy@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 3/18/2019 10:44 AM, James Bottomley wrote:
> On Mon, 2019-03-18 at 12:15 -0500, Gustavo A. R. Silva wrote:
>> sizeof() is currently using the wrong argument when used in a call to
>> memset().  Notice that wqe is a pointer to union lpfc_wqe128, not to
>> union lpfc_wqe.
>>
>> Fix this by using union lpfc_wqe128 instead of lpfc_wqe as argument
>> of sizeof().
>>
>> Addresses-Coverity-ID: 1443938 ("Wrong sizeof argument")
>> Fixes: 5fd1108517d9 ("scsi: lpfc: Streamline NVME Initiator WQE
>> setup")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/scsi/lpfc/lpfc_nvme.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/lpfc/lpfc_nvme.c
>> b/drivers/scsi/lpfc/lpfc_nvme.c
>> index d16ca413110d..3dc0c85c7d50 100644
>> --- a/drivers/scsi/lpfc/lpfc_nvme.c
>> +++ b/drivers/scsi/lpfc/lpfc_nvme.c
>> @@ -1981,7 +1981,7 @@ lpfc_get_nvme_buf(struct lpfc_hba *phba, struct
>> lpfc_nodelist *ndlp,
>>   		/* Fill in word 3 / sgl_len during cmd submission */
>>   
>>   		/* Initialize WQE */
>> -		memset(wqe, 0, sizeof(union lpfc_wqe));
>> +		memset(wqe, 0, sizeof(union lpfc_wqe128));
> Actually the correct way to avoid potential problems like this is
>
> 	memset(wqe, 0, sizeof(*wqe));
>
> James
>

Agree with James on style.   This one reference was a little 
interesting. It purposely was something smaller than the whole structure 
as the latter end of the structure ends up getting set later.  But not a 
big deal to correct as indicated.

--james
