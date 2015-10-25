From: ygardi@codeaurora.org
Subject: Re: [PATCH v3 03/15] scsi: ufs: verify command tag validity
Date: Sun, 25 Oct 2015 13:29:30 -0000
Message-ID: <5c991223dc8eeefa92263c27b20c59b0.squirrel@www.codeaurora.org>
References: <1441188795-4600-1-git-send-email-ygardi@codeaurora.org>
    <1441188795-4600-4-git-send-email-ygardi@codeaurora.org>
    <CAC5umyjwgKvyZpMsk7J1n5M+G+bjTh+rEUNGZcDgnSD2DZG1NQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <CAC5umyjwgKvyZpMsk7J1n5M+G+bjTh+rEUNGZcDgnSD2DZG1NQ@mail.gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, Rob Herring <robherring2@gmail.com>, Jej B <james.bottomley@hansenpartnership.com>, Paul Bolle <pebolle@tiscali.nl>, Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Santosh Y <santoshsy@gmail.com>, linux-scsi-owner@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, Gilad Broner <gbroner@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

> 2015-09-02 19:13 GMT+09:00 Yaniv Gardi <ygardi@codeaurora.org>:
>> A race condition appear to exist between request completion when
>> scsi_done() is called to end the request and set the tag back to
>> -1 (at blk_queue_end_tag() scsi_end_request), and scsi layer error
>> handling which aborts the command and reuses it to request sense
>> data. Sending the request sense is done with tag which was set to -1
>> and so it is invalid.
>> Assert command tag passed from scsi layer is valid.
>>
>> Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
>> Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>
>>
>> ---
>>  drivers/scsi/ufs/ufshcd.c | 24 ++++++++++++++++++++++--
>>  1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> index 2d3ebca..8860a57 100644
>> --- a/drivers/scsi/ufs/ufshcd.c
>> +++ b/drivers/scsi/ufs/ufshcd.c
>> @@ -190,6 +190,10 @@ static int ufshcd_config_pwr_mode(struct ufs_hba
>> *hba,
>>                 struct ufs_pa_layer_attr *desired_pwr_mode);
>>  static int ufshcd_change_power_mode(struct ufs_hba *hba,
>>                              struct ufs_pa_layer_attr *pwr_mode);
>> +static inline bool ufshcd_valid_tag(struct ufs_hba *hba, int tag)
>> +{
>> +       return tag >= 0 && tag < hba->nutrs;
>> +}
>>
>>  static inline int ufshcd_enable_irq(struct ufs_hba *hba)
>>  {
>> @@ -1310,6 +1314,12 @@ static int ufshcd_queuecommand(struct Scsi_Host
>> *host, struct scsi_cmnd *cmd)
>>         hba = shost_priv(host);
>>
>>         tag = cmd->request->tag;
>> +       if (!ufshcd_valid_tag(hba, tag)) {
>> +               dev_err(hba->dev,
>> +                       "%s: invalid command tag %d: cmd=0x%p,
>> cmd->request=0x%p",
>> +                       __func__, tag, cmd, cmd->request);
>> +               BUG();
>> +       }
>
> Is it better to avoid BUG() by WARN_ON() and return if possible?

in this specific case, i think BUG() is the way to handle this scenario.
It is very rare, and if invalid_tag is sent, the SW can not proceed, and
it indicates something very wrong happened. either in the block layer that
allocated the tag, or in the UFS that reported nutrs.
So, if we actually hit this scenario, then recovering is not an option and
i believe we need to BUG. hope it makes sense.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
