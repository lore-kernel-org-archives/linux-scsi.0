Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5237C282DD
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 22:28:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C7E22082E
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 22:28:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728157AbgAIW2H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 17:28:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:46053 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbgAIW2G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jan 2020 17:28:06 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so79153pfg.12
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jan 2020 14:28:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Go2xwyrEU7iaQotZttlbl4moxnyE8y5ltV1FI5MZzXQ=;
        b=ROVKaFxqhyIVQt96LRgm8bm81BTEieeOeim3vZR2tNt/PFotkDM1mNqAfrjEJx7sp9
         fnhDzJrYJ3VFfwANs5nPYdgjpLfn5fb4figiBrFYqgwt5tV7BUWkicyPrHwctJQnfOE6
         GpzNr5BlGZ+GJz4VwzAq7GWOIyDAfjovQLpKPK2wUnExfhfRZLkWx95attAYxEyjegwj
         byK4VN/x/lfmp/aT6RhtTnzWfTh0RtUxW9JjcWc6G0t1XV23b92Uwm7nK1JeHssblGC3
         YO/xMN6fnW38z49uCumvQY6NupwhEJqcDgnlTu7VzEzCCBCVdN+v0TKw7WFYIbxVpIrQ
         qLow==
X-Gm-Message-State: APjAAAUVXRIqPJxWh+6DLJTmpQMhX5x/TI7l0KqjVPp7Ym8XefEmiyT4
        kXRK/GJG4pj8htHFZuOQ6yhkUdc/
X-Google-Smtp-Source: APXvYqzv/SBdsfmAQg3hjT8l2A7xXZdzwirR+GbkWrAZGcEn67C0hwT8v3EU02KRySen8gd/CkxfbQ==
X-Received: by 2002:a63:1c13:: with SMTP id c19mr296673pgc.450.1578608886163;
        Thu, 09 Jan 2020 14:28:06 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l66sm8119013pga.30.2020.01.09.14.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2020 14:28:05 -0800 (PST)
Subject: Re: [PATCH 4/4] ufs: Let the SCSI core allocate per-command UFS data
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Can Guo <cang@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Alim Akhtar <alim.akhtar@samsung.com>
References: <20200107192531.73802-1-bvanassche@acm.org>
 <20200107192531.73802-5-bvanassche@acm.org>
 <MN2PR04MB69913704982A01708C36374FFC390@MN2PR04MB6991.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <45cb376d-42b8-5bc9-70e1-a93935d02287@acm.org>
Date:   Thu, 9 Jan 2020 14:28:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <MN2PR04MB69913704982A01708C36374FFC390@MN2PR04MB6991.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/9/20 1:48 AM, Avri Altman wrote:
> Bart Van Assche wrote:
>> +       /* See also ufshcd_is_scsi() */
>> +       switch (req_op(cmd->request)) {
>> +       case REQ_OP_DRV_IN:
>> +       case REQ_OP_DRV_OUT:
>> +               WARN_ON_ONCE(true);
 >
> Maybe just WARN_ON_ONCE(!ufshcd_is_scsi(cmd->request))

Good idea. Will do.

>> +static int ufshcd_init_cmd_priv(struct Scsi_Host *shost, struct
>> +scsi_cmnd *cmd) {
>> +       struct ufs_hba *hba = shost_priv(shost);
>> +
>> +       ufshcd_init_lrb(hba, scsi_cmd_priv(cmd), cmd->tag);
 >
> So ufshcd_init_lrb() is called now for every new request?

ufshcd_init_lrb() is only called from inside scsi_add_host(), namely as 
follows:

scsi_add_host()
-> scsi_add_host_with_dma()
   -> scsi_mq_setup_tags()
     -> blk_mq_alloc_tag_set()
       -> blk_mq_alloc_rq_maps()
         -> __blk_mq_alloc_rq_maps()
           -> __blk_mq_alloc_rq_map()
             -> blk_mq_alloc_rqs()
               -> blk_mq_init_request()
                 -> scsi_mq_init_request()
                   -> ufshcd_init_cmd_priv()

>> @@ -6074,7 +6132,8 @@ static int ufshcd_eh_device_reset_handler(struct
>> scsi_cmnd *cmd)
>>
>>          /* clear the commands that were pending for corresponding LUN */
>>          for_each_set_bit(pos, &hba->outstanding_reqs, hba->nutrs) {
>> -               if (hba->lrb[pos].lun == lrbp->lun) {
>> +               lrbp2 = ufshcd_tag_to_lrb(hba, pos);
 >
> Can lrpb2 be null here?

lrpb2 can only be NULL if the 'pos' argument passed to 
ufshcd_tag_to_lrb() is not a valid tag. for_each_set_bit() however 
guarantees that 0 <= pos < hba->nutrs and hence guarantees that 'pos' is 
a valid tag.

Thanks,

Bart.
