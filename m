From: ygardi@codeaurora.org
Subject: Re: [PATCH v1 06/17] scsi :ufs: verify hba controller hce reg value
Date: Mon, 26 Oct 2015 13:11:05 -0000
Message-ID: <64a376c625da10a5dc948535d25950b5.squirrel@www.codeaurora.org>
References: <1442155977-7686-1-git-send-email-ygardi@codeaurora.org>
    <1442155977-7686-7-git-send-email-ygardi@codeaurora.org>
    <CAC5umygqzg1vBhnF8cB3Z3ncVSTH7VWF7n2mQ2gZAubiORoM7g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umygqzg1vBhnF8cB3Z3ncVSTH7VWF7n2mQ2gZAubiORoM7g@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> 2015-09-13 23:52 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> Sometimes due to hw issues it takes some time to the
>> host controller register to update. In order to verify the register
>> has updated, a polling is done until its value is set.
>>
>> In addition the functions ufshcd_hba_stop() and
>> ufshcd_wait_for_register() was updated with an additional input
>> parameter, indicating the timeout between reads will
>> be done by sleeping or spinning the cpu.
>>
>> Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 54
>> ++++++++++++++++++++++++++++-------------------
>>  drivers/scsi/ufs/ufshcd.h | 12 +++--------
>>  2 files changed, 35 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 6171da8..e5a876c 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -267,11 +267,12 @@ static inline void ufshcd_disable_irq(struct
>> ufs_hba *hba)
>>   * @val - wait condition
>>   * @interval_us - polling interval in microsecs
>>   * @timeout_ms - timeout in millisecs
>> - *
>> + * @can_sleep - perform sleep or just spin
>>   * Returns -ETIMEDOUT on error, zero on success
>>   */
>
> We usually put a blank line between @argument description and
> return value description.
>

will be fixed in v2.
thanks
