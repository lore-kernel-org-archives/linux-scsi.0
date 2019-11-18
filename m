Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A72BCC432C0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81EA7222D1
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 23:07:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfKRXHC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 18:07:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44753 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfKRXHC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 18:07:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id e6so2372546pgi.11
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 15:07:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdJRjVTIEgjRGDbKnTp9N631gRx0TJwTYE+dOpuI2MY=;
        b=YkrK/w6jdIjFKGbgskAj+Gz7Ea1Dndselhh4jB0JuIWiRSk2V9Os1UpcLtj+03/V6P
         4cTT4N070ow7a9Ea8hZykcfn2vxWcFn3Iq+y7mPpMrTH2mTVuwE7GrqgpRJd0BwuVdWu
         DBhgZVXwMhmX8A2Cq37NARrKrljNL9pNbKY2QcJXnFFwylkLjEAiUOMU77Rzr9oeH1Ip
         TKJM6UsFK4JqgtbhS2anpFMLJCbVMgcARXS4nZ/ovmMbeYJrFQdDkKG5yL56ExXHIMqP
         nScZi1qZprNoOoBFB39CFccwoPyBxXBf+2wA47KXLWpjj4ogU7ZZBQL4DsxtjiQpQoHx
         jOqw==
X-Gm-Message-State: APjAAAUSRc6OFIqYYwMDmmkSnr3kdJ4OMdeDqx6Rp/yRg2QCG5uocxQL
        nz9raigifVMuZylepOxD4wc=
X-Google-Smtp-Source: APXvYqy8AGFm99ioq1kVamlkg+CHXvPX4+E8L5rzXdLV/5Q2XKEdDXYryxcVT2QyT0jsmFAZtjwkig==
X-Received: by 2002:a63:ec50:: with SMTP id r16mr1953091pgj.284.1574118419759;
        Mon, 18 Nov 2019 15:06:59 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s26sm21539463pfh.66.2019.11.18.15.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 15:06:59 -0800 (PST)
Subject: Re: [PATCH 8/9] aacraid: use scsi_host_busy_iter() in
 get_num_of_incomplete_fibs()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        Balsundar P <balsundar.p@microsemi.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>
References: <20191118092208.54521-1-hare@suse.de>
 <20191118092208.54521-9-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bcf68366-cb44-b846-1348-d646555f98ba@acm.org>
Date:   Mon, 18 Nov 2019 15:06:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191118092208.54521-9-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/18/19 1:22 AM, Hannes Reinecke wrote:
> Use the scsi midlayer helper to traverse the number of outstanding
> commands. This also eliminates the last usage for the cmd_list
> functionality so we can drop it.
> 
> Cc: Balsundar P <balsundar.p@microsemi.com>
> Cc: Adaptec OEM Raid Solutions <aacraid@microsemi.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/aacraid/linit.c | 81 ++++++++++++++++++++++----------------------
>   1 file changed, 41 insertions(+), 40 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index ee6bc2f9b80a..db96482c4fdc 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -622,54 +622,56 @@ static int aac_ioctl(struct scsi_device *sdev, unsigned int cmd,
>   	return aac_do_ioctl(dev, cmd, arg);
>   }
>   
> -static int get_num_of_incomplete_fibs(struct aac_dev *aac)
> +struct fib_count_data {
> +	int mlcnt;
> +	int llcnt;
> +	int ehcnt;
> +	int fwcnt;
> +	int krlcnt;
> +};
> +
> +static bool fib_count_iter(struct scsi_cmnd *scmnd, void *data, bool reserved)
>   {
> +	struct fib_count_data *fib_count = data;
>   
> -	unsigned long flags;
> -	struct scsi_device *sdev = NULL;
> +	switch (scmnd->SCp.phase) {
> +	case AAC_OWNER_FIRMWARE:
> +		fib_count->fwcnt++;
> +		break;
> +	case AAC_OWNER_ERROR_HANDLER:
> +		fib_count->ehcnt++;
> +		break;
> +	case AAC_OWNER_LOWLEVEL:
> +		fib_count->llcnt++;
> +		break;
> +	case AAC_OWNER_MIDLEVEL:
> +		fib_count->mlcnt++;
> +		break;
> +	default:
> +		fib_count->krlcnt++;
> +		break;
> +	}
> +	return true;
> +}
> +
> +/* Called during SCSI EH, so we don't need to block requests */
> +static int get_num_of_incomplete_fibs(struct aac_dev *aac)
> +{
>   	struct Scsi_Host *shost = aac->scsi_host_ptr;
> -	struct scsi_cmnd *scmnd = NULL;
>   	struct device *ctrl_dev;
> +	struct fib_count_data fcnt = { };
>   
> -	int mlcnt  = 0;
> -	int llcnt  = 0;
> -	int ehcnt  = 0;
> -	int fwcnt  = 0;
> -	int krlcnt = 0;
> -
> -	__shost_for_each_device(sdev, shost) {
> -		spin_lock_irqsave(&sdev->list_lock, flags);
> -		list_for_each_entry(scmnd, &sdev->cmd_list, list) {
> -			switch (scmnd->SCp.phase) {
> -			case AAC_OWNER_FIRMWARE:
> -				fwcnt++;
> -				break;
> -			case AAC_OWNER_ERROR_HANDLER:
> -				ehcnt++;
> -				break;
> -			case AAC_OWNER_LOWLEVEL:
> -				llcnt++;
> -				break;
> -			case AAC_OWNER_MIDLEVEL:
> -				mlcnt++;
> -				break;
> -			default:
> -				krlcnt++;
> -				break;
> -			}
> -		}
> -		spin_unlock_irqrestore(&sdev->list_lock, flags);
> -	}
> +	scsi_host_busy_iter(shost, fib_count_iter, &fcnt);
>   
>   	ctrl_dev = &aac->pdev->dev;
>   
> -	dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", mlcnt);
> -	dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", llcnt);
> -	dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", ehcnt);
> -	dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fwcnt);
> -	dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", krlcnt);
> +	dev_info(ctrl_dev, "outstanding cmd: midlevel-%d\n", fcnt.mlcnt);
> +	dev_info(ctrl_dev, "outstanding cmd: lowlevel-%d\n", fcnt.llcnt);
> +	dev_info(ctrl_dev, "outstanding cmd: error handler-%d\n", fcnt.ehcnt);
> +	dev_info(ctrl_dev, "outstanding cmd: firmware-%d\n", fcnt.fwcnt);
> +	dev_info(ctrl_dev, "outstanding cmd: kernel-%d\n", fcnt.krlcnt);
>   
> -	return mlcnt + llcnt + ehcnt + fwcnt;
> +	return fcnt.mlcnt + fcnt.llcnt + fcnt.ehcnt + fcnt.fwcnt;
>   }
>   
>   static int aac_eh_abort(struct scsi_cmnd* cmd)
> @@ -1675,7 +1677,6 @@ static int aac_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	shost->irq = pdev->irq;
>   	shost->unique_id = unique_id;
>   	shost->max_cmd_len = 16;
> -	shost->use_cmd_list = 1;
>   
>   	if (aac_cfg_major == AAC_CHARDEV_NEEDS_REINIT)
>   		aac_init_char();

Same comment here: could scsi_device_quiesce() and scsi_device_resume() 
have been used instead?

Thanks,

Bart.


