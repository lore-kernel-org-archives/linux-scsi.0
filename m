From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH v3 05/15] scsi: ufs: increase fDeviceInit query response timeout
Date: Mon, 26 Oct 2015 21:59:41 +0900
Message-ID: <CAC5umyh14g5vki6UdpdbwdfmVr+nqrvK=610ubS7o1DFQqmA_g@mail.gmail.com>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
	<1441188795-4600-6-git-send-email-ygardi@codeaurora.org>
	<CAC5umyh6dvnDBm0Udw2pWY3GgJL0AdYw7F-f_JpJtuHurDvEFw@mail.gmail.com>
	<34946dd94ecbe771a307c1470e63985e.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <34946dd94ecbe771a307c1470e63985e.squirrel@www.codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Yaniv Gardi <ygardi@codeaurora.org>
Cc: Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

2015-10-25 22:38 GMT+09:00  <ygardi@codeaurora.org>:
>> 2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>>> fDeviceInit query response time for some devices is too long that
>>> default
>>> query request timeout of 100ms may not be enough. Experiments show that
>>> fDeviceInit response sometimes takes 500ms so to be on safer side this
>>> change sets the timeout to 600ms. Without this change, we might
>>> unnecessarily have to retry fDeviceInit query requests multiple times
>>> and
>>> each query request timeout prints one error message.
>>>
>>> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
>>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>>
>>> ---
>>>  drivers/scsi/ufs/ufshcd.c | 12 +++++++++++-
>>>  1 file changed, 11 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>>> index e0b8755..573a8cb 100644
>>> --- a/drivers/scsi/ufs/ufshcd.c
>>> +++ b/drivers/scsi/ufs/ufshcd.c
>>> @@ -58,6 +58,12 @@
>>>  #define QUERY_REQ_RETRIES 10
>>>  /* Query request timeout */
>>>  #define QUERY_REQ_TIMEOUT 30 /* msec */
>>> +/*
>>> + * Query request timeout for fDeviceInit flag
>>> + * fDeviceInit query response time for some devices is too large that
>>> default
>>> + * QUERY_REQ_TIMEOUT may not be enough for such devices.
>>> + */
>>> +#define QUERY_FDEVICEINIT_REQ_TIMEOUT 600 /* msec */
>>
>> How about just increasing QUERY_REQ_TIMEOUT from 30ms to 600ms
>> instead of conditionally setting timeout depending on ufs flag?
>
> Your suggestion obviously could work (increasing the QUERY_REQ_TIMEOUT to
> 600ms), but in that case we bring extra delay of 570ms to error handling
> of query timeout, and in such a case, instead of handling the error after
> 30ms we handle it after 600ms, which make the SW hang.
> does it make sense ?

Compared to default scsi disk timeout (30s), 600ms does not look very
long.  I was just worried that the code gets complicated if we need to
add yet another QUERY_XYZ_REQ_TIMEOUT macros when it turns out that
30ms timeout is not enough for other query requests under specific
conditions.  But I don't too much care about it for now.

>>
>>>
>>>  /* Task management command timeout */
>>>  #define TM_CMD_TIMEOUT 100 /* msecs */
>>> @@ -1651,6 +1657,7 @@ static int ufshcd_query_flag(struct ufs_hba *hba,
>>> enum query_opcode opcode,
>>>         struct ufs_query_req *request = NULL;
>>>         struct ufs_query_res *response = NULL;
>>>         int err, index = 0, selector = 0;
>>> +       int timeout = QUERY_REQ_TIMEOUT;
>>>
>>>         BUG_ON(!hba);
>>>
>>> @@ -1683,7 +1690,10 @@ static int ufshcd_query_flag(struct ufs_hba *hba,
>>> enum query_opcode opcode,
>>>                 goto out_unlock;
>>>         }
>>>
>>> -       err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY,
>>> QUERY_REQ_TIMEOUT);
>>> +       if (idn == QUERY_FLAG_IDN_FDEVICEINIT)
>>> +               timeout = QUERY_FDEVICEINIT_REQ_TIMEOUT;
>>> +
>>> +       err = ufshcd_exec_dev_cmd(hba, DEV_CMD_TYPE_QUERY, timeout);
>>>
>>>         if (err) {
>>>                 dev_err(hba->dev,
>>> --
>>> 1.8.5.2
>>>
>>> --
>>> QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a
>>> member of Code Aurora Forum, hosted by The Linux Foundation
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
