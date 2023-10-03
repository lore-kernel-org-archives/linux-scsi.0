Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 995FAE748FA
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Oct 2023 17:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232005AbjJCRpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Oct 2023 13:45:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjJCRpH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Oct 2023 13:45:07 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753E795
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 10:45:04 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1c723f1c80fso9205945ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 10:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696355104; x=1696959904;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gD2kV20rd1lMQaM/yyO1AV6V2XCHz+Kf9g1izzC3BIg=;
        b=MhSE1JUefqHpgX+3OQ+KS5WTGZr0gXKZgEMslIJ88RNly40+F4UFAphvibEEa/MQrJ
         DLKDaGWYVTmcMyloDaH9SCcoj7mXHvdWbjE82aKV0fiNTP9XVoeK9q3D8wFrC096DlQX
         bM2fAWgSsnPmW8Ap5f0Bl7lsLIaq0hwyVTRUhvLgpWxPHjAIZgYtPw5I4fIfNYYjpuw9
         3BXV01g55V/9AaxkxiKeH8+kkBHDn+wsktoVaJ8nM5nDfdMPx+oa0GIydibJ9+3x3sA2
         11val+UpdQQ11yiqPThWWfLXCKA19erRqL2PsxnZEcbum/tmtMbtQdrasyrjxvGja7KI
         26Sg==
X-Gm-Message-State: AOJu0Yx/CxY3vdXIe+g5LP6m87CPNqWPZbFyaU2DiL5F8pg0WGz7y48X
        53Y8DXMbwGpC0pElRJypR/c=
X-Google-Smtp-Source: AGHT+IF4LTMSxaQ4XKa/Dp9J46ikxs438riIKXLs4+0MQbNAOE9ergUYpTkQ6SP6/bM8pmEM5UXzow==
X-Received: by 2002:a17:903:2788:b0:1c0:d5c6:748f with SMTP id jw8-20020a170903278800b001c0d5c6748fmr184938plb.67.1696355103815;
        Tue, 03 Oct 2023 10:45:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:fc96:5ba7:a6f5:b187? ([2620:15c:211:201:fc96:5ba7:a6f5:b187])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b001bc6e6069a6sm1862024plh.122.2023.10.03.10.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Oct 2023 10:45:03 -0700 (PDT)
Message-ID: <435a39bf-bc7b-4cce-98ea-446cc0549e3b@acm.org>
Date:   Tue, 3 Oct 2023 10:45:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/7] scsi_error: streamline scsi_eh_bus_device_reset()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20231002155915.109359-1-hare@suse.de>
 <20231002155915.109359-8-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231002155915.109359-8-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/2/23 08:59, Hannes Reinecke wrote:
> Streamline to use a similar code flow as the other reset functions.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/scsi_error.c | 26 +++++++++++---------------
>   1 file changed, 11 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 21d84940c9cb..81b38f5da3b6 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -1581,6 +1581,7 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   {
>   	struct scsi_cmnd *scmd, *bdr_scmd, *next;
>   	struct scsi_device *sdev;
> +	LIST_HEAD(check_list);
>   	enum scsi_disposition rtn;
>   
>   	shost_for_each_device(sdev, shost) {
> @@ -1606,27 +1607,22 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
>   			sdev_printk(KERN_INFO, sdev,
>   				     "%s: Sending BDR\n", current->comm));
>   		rtn = scsi_try_bus_device_reset(sdev);
> -		if (rtn == SUCCESS || rtn == FAST_IO_FAIL) {
> -			if (!scsi_device_online(sdev) ||
> -			    rtn == FAST_IO_FAIL ||
> -			    !scsi_eh_tur(bdr_scmd)) {
> -				list_for_each_entry_safe(scmd, next,
> -							 work_q, eh_entry) {
> -					if (scmd->device == sdev &&
> -					    scsi_eh_action(scmd, rtn) != FAILED)
> -						__scsi_eh_finish_cmd(scmd,
> -								     done_q,
> -								     DID_RESET);
> -				}
> -			}
> -		} else {
> +		if (rtn != SUCCESS && rtn != FAST_IO_FAIL)
>   			SCSI_LOG_ERROR_RECOVERY(3,
>   				sdev_printk(KERN_INFO, sdev,
>   					    "%s: BDR failed\n", current->comm));
> +		list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
> +			if (scmd->device != sdev)
> +				continue;
> +			if (rtn == SUCCESS)
> +				list_move_tail(&scmd->eh_entry, &check_list);
> +			else if (rtn == FAST_IO_FAIL)
> +				__scsi_eh_finish_cmd(scmd, done_q,
> +						     DID_TRANSPORT_DISRUPTED);
>   		}
>   	}
>   
> -	return list_empty(work_q);
> +	return scsi_eh_test_devices(&check_list, work_q, done_q, 0);
>   }

I think the description of this patch is too brief. The following 
information is missing from the patch description:
- Why the scsi_device_online() and scsi_eh_tur() checks have been left
   out.
- Why DID_RESET has been changed into DID_TRANSPORT_DISRUPTED.
- Why the list_move_tail() call has been introduced.
- Why the scsi_eh_test_devices() call has been introduced.

Thanks,

Bart.

