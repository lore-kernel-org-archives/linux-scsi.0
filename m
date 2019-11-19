Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79237C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C388222DF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 07:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfKSHGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:06:41 -0500
Received: from mx2.suse.de ([195.135.220.15]:45276 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725784AbfKSHGk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 02:06:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D2212AD4A;
        Tue, 19 Nov 2019 07:06:37 +0000 (UTC)
Subject: Re: [PATCH 8/9] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-9-hare@suse.de>
 <bcf68366-cb44-b846-1348-d646555f98ba@acm.org>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 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
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <f9f0ee84-10fd-33ac-81bb-e57b35973304@suse.de>
Date:   Tue, 19 Nov 2019 08:06:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <bcf68366-cb44-b846-1348-d646555f98ba@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/19 12:06 AM, Bart Van Assche wrote:
> On 11/18/19 1:22 AM, Hannes Reinecke wrote:
>> Use the scsi midlayer helper to traverse the number of outstanding
>> commands. This also eliminates the last usage for the cmd_list
>> functionality so we can drop it.
>>
>> Cc: Balsundar P <balsundar.p@microsemi.com>
>> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>   drivers/scsi/aacraid/linit.c | 81
>> ++++++++++++++++++++++----------------------
>>   1 file changed, 41 insertions(+), 40 deletions(-)
>>
>> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
>> index ee6bc2f9b80a..db96482c4fdc 100644
>> --- a/drivers/scsi/aacraid/linit.c
>> +++ b/drivers/scsi/aacraid/linit.c
>> @@ -622,54 +622,56 @@ static int aac_ioctl(struct scsi_device *sdev,
>> unsigned int cmd,
>>       return aac_do_ioctl(dev, cmd, arg);
>>   }
>>   -static int get_num_of_incomplete_fibs(struct aac_dev *aac)
>> +struct fib_count_data {
>> +    int mlcnt;
>> +    int llcnt;
>> +    int ehcnt;
>> +    int fwcnt;
>> +    int krlcnt;
>> +};
>> +
>> +static bool fib_count_iter(struct scsi_cmnd *scmnd, void *data, bool
>> reserved)
>>   {
>> +    struct fib_count_data *fib_count = data;
>>   -    unsigned long flags;
>> -    struct scsi_device *sdev = NULL;
>> +    switch (scmnd->SCp.phase) {
>> +    case AAC_OWNER_FIRMWARE:
>> +        fib_count->fwcnt++;
>> +        break;
>> +    case AAC_OWNER_ERROR_HANDLER:
>> +        fib_count->ehcnt++;
>> +        break;
>> +    case AAC_OWNER_LOWLEVEL:
>> +        fib_count->llcnt++;
>> +        break;
>> +    case AAC_OWNER_MIDLEVEL:
>> +        fib_count->mlcnt++;
>> +        break;
>> +    default:
>> +        fib_count->krlcnt++;
>> +        break;
>> +    }
>> +    return true;
>> +}
>> +
>> +/* Called during SCSI EH, so we don't need to block requests */
>> +static int get_num_of_incomplete_fibs(struct aac_dev *aac)
>> +{
>>       struct Scsi_Host *shost = aac->scsi_host_ptr;
>> -    struct scsi_cmnd *scmnd = NULL;
>>       struct device *ctrl_dev;
>> +    struct fib_count_data fcnt = { };
>>   -    int mlcnt  = 0;
>> -    int llcnt  = 0;
>> -    int ehcnt  = 0;
>> -    int fwcnt  = 0;
>> -    int krlcnt = 0;
>> -
>> -    __shost_for_each_device(sdev, shost) {
>> -        spin_lock_irqsave(&sdev->list_lock, flags);
>> -        list_for_each_entry(scmnd, &sdev->cmd_list, list) {
>> -            switch (scmnd->SCp.phase) {
>> -            case AAC_OWNER_FIRMWARE:
>> -                fwcnt++;
>> -                break;
>> -            case AAC_OWNER_ERROR_HANDLER:
>> -                ehcnt++;
>> -                break;
>> -            case AAC_OWNER_LOWLEVEL:
>> -                llcnt++;
>> -                break;
>> -            case AAC_OWNER_MIDLEVEL:
>> -                mlcnt++;
>> -                break;
>> -            default:
>> -                krlcnt++;
>> -                break;
>> -            }
>> -        }
>> -        spin_unlock_irqrestore(&sdev->list_lock, flags);
>> -    }
>> +    scsi_host_busy_iter(shost, fib_count_iter, &fcnt);
>>         ctrl_dev = &aac->pdev->dev;
>>   -    dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", mlcnt);
>> -    dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", llcnt);
>> -    dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", ehcnt);
>> -    dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fwcnt);
>> -    dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", krlcnt);
>> +    dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", fcnt.mlcnt);
>> +    dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", fcnt.llcnt);
>> +    dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n",
>> fcnt.ehcnt);
>> +    dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fcnt.fwcnt);
>> +    dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", fcnt.krlcnt);
>>   -    return mlcnt + llcnt + ehcnt + fwcnt;
>> +    return fcnt.mlcnt + fcnt.llcnt + fcnt.ehcnt + fcnt.fwcnt;
>>   }
>>     static int aac_eh_abort(struct scsi_cmnd* cmd)
>> @@ -1675,7 +1677,6 @@ static int aac_probe_one(struct pci_dev *pdev,
>> const struct pci_device_id *id)
>>       shost->irq = pdev->irq;
>>       shost->unique_id = unique_id;
>>       shost->max_cmd_len = 16;
>> -    shost->use_cmd_list = 1;
>>         if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
>>           aac_init_char();
> 
> Same comment here: could scsi_device_quiesce() and scsi_device_resume()
> have been used instead?
> 
We don't need to.
This function is called during SCSI EH when the host is quiesced anyway.
That's what I tried to imply with the added comment on top.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 247165 (AG München), GF: Felix Imendörffer
