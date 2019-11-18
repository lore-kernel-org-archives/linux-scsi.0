Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC77DC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:05:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5EFB22310
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726933AbfKRXFm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 18:05:42 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33972 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726795AbfKRXFm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 18:05:42 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so10641779plr.1
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 15:05:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=swakGDG85FUXub8QK60IWyjuEYXciR7RdpjNPDjuPT8=;
        b=Zf0QUTsnrlbF3PL8sAIW8Z6OIe/soc7u5Fum6+CRCu/JnnsPJfWVLClrEgmRaQiOxd
         cvcXQOBBG78xBOD4bjHWpa8TJU/fOlzO4LpNLM1TVwGuaWUhCRAY2aGxpOVrPmi2Q9xf
         j2RCU4kioZTeOQVBHuOMWpDINBbT4EU+EmypCJcGeQ5yAT8ED9zBA6bbSzT78T5aj7kg
         DMBqPobdtZRGsVk0N3Zy7EV7Lb0BwA/EOigNUfkyA4tBm5hsG4+yX7/KJFtoVU6ueplu
         25W9TkEuqY1l/5sQSFb9jQHkUOfowQxTk94ROSjt4HTUEgr6xDZrRJVoTg+Cp3F0pfql
         U14Q==
X-Gm-Message-State: APjAAAXsco7lZn9MmNU7uPTGGTikdr2CIykSBGedvpFyehLprGQlB/bP
        sDhvFSrZtfk5MsWZkb/wWYI=
X-Google-Smtp-Source: APXvYqxC0Aqk6IadiM34+l1zOgyZZ5v1Eh/AIYzLTw8LVtOe4bWKgdsi0qCAkIgAZFdq3sThFVi3kA==
X-Received: by 2002:a17:90a:cc07:: with SMTP id b7mr1867833pju.135.1574118341428;
        Mon, 18 Nov 2019 15:05:41 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id n15sm22687454pfq.146.2019.11.18.15.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 15:05:40 -0800 (PST)
Subject: Re: [PATCH 7/9] aacraid: use scsi_host_busy_iter() in
 aac_wait_for_io_completion()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d1fa932b-0134-cd8e-3ac1-dd03ec0a8e6f@acm.org>
Date:   Mon, 18 Nov 2019 15:05:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-8-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> Use the midlayer helper function to traverse outstanding commands.
> 
> Cc: Balsundar P <balsundar.p@microsemi.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/aacraid/comminit.c | 30 +++++++++++++-----------------
>   1 file changed, 13 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
> index f75878d773cf..89c0ca339ef5 100644
> --- a/drivers/scsi/aacraid/comminit.c
> +++ b/drivers/scsi/aacraid/comminit.c
> @@ -272,29 +272,25 @@ static void aac_queue_init(struct aac_dev * dev, struct aac_queue * q, u32 *mem,
>   	q->entries = qsize;
>   }
>   
> +static bool wait_for_io_iter(struct scsi_cmnd *cmd, void *data, bool reserved)
> +{
> +	int *active = data;
> +
> +	if (cmd->SCp.phase == AAC_OWNER_FIRMWARE)
> +		*active = 1;
> +	return true;
> +}
> +
> +/* scsi_block_requests() has been called, so no new request can be issued */
>   static void aac_wait_for_io_completion(struct aac_dev *aac)
>   {
> -	unsigned long flagv = 0;
> -	int i = 0;
> +	int i;
>   
>   	for (i = 60; i; --i) {
> -		struct scsi_device *dev;
> -		struct scsi_cmnd *command;
>   		int active = 0;
>   
> -		__shost_for_each_device(dev, aac->scsi_host_ptr) {
> -			spin_lock_irqsave(&dev->list_lock, flagv);
> -			list_for_each_entry(command, &dev->cmd_list, list) {
> -				if (command->SCp.phase == AAC_OWNER_FIRMWARE) {
> -					active++;
> -					break;
> -				}
> -			}
> -			spin_unlock_irqrestore(&dev->list_lock, flagv);
> -			if (active)
> -				break;
> -
> -		}
> +		scsi_host_busy_iter(aac->scsi_host_ptr,
> +				    wait_for_io_iter, &active);
>   		/*
>   		 * We can exit If all the commands are complete
>   		 */

Would using scsi_device_quiesce() and scsi_device_resume() allow to 
eliminate the busy-waiting loop from the aacraid driver?

Thanks,

Bart.


