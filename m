Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68726ECE599
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E372082C
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 02:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbfJQCpy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Oct 2019 22:45:54 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42450 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfJQCpx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Oct 2019 22:45:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id q12so613417pff.9
        for <linux-scsi@vger.kernel.org>; Wed, 16 Oct 2019 19:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=excLhEeUmW9TIVj8cK5oUPto75Q1gN9WYfayHYY/3Ao=;
        b=Gm6iau8xPoCWuxorU+qTdCkw5O7IjaPMbKD5v3U9M1swDiPGbnbHlhfxMlqsVWVyRn
         CuPWWk+A6zfa6y6aaKpQL3da9j2h45S+ecxLzJMrdR8qrNs9sHc103dOVC2WWxCbCXd9
         6oCR4GxK94oiT06Et4z1G5lwbISM00NoA5GFs4jbvBOhWCPm3451vD+3gLOAOoI0MSDV
         YEI3maZm692UoEqqiHVqgiUzalArcwJ1fHoDorN4Sm38vsn1N7dx1/7TftUNQEnCtHV5
         tVTnRn7t0Y18reXVwdB6jFbKzFbu4jGOdtwe+NjQJZRkli8kEzmPzAaMuzvKRQPRCnpk
         oPZw==
X-Gm-Message-State: APjAAAVMldYCq8uPqCSexvKp+8uAPCInyQCxDHWpMmfj5mNKbItvFlD6
        blm9Oh5W/ttTFdSCJR0BdmA=
X-Google-Smtp-Source: APXvYqyUVzOoAaWyo1KtfWuAxy2fD6597Ph9mrIGksraxGQnDPo1mrCj/fzmcweCRi4RR6tOngHCGg==
X-Received: by 2002:a17:90a:246c:: with SMTP id h99mr1308362pje.127.1571280352943;
        Wed, 16 Oct 2019 19:45:52 -0700 (PDT)
Received: from localhost.localdomain ([2601:647:4000:6f7:39e3:62ec:4c0a:9f8e])
        by smtp.gmail.com with ESMTPSA id j126sm500562pfb.186.2019.10.16.19.45.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 19:45:51 -0700 (PDT)
Subject: Re: [PATCH v3] scsi: core: fix uninit-value access of variable sshdr
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     yi.zhang@huawei.com
References: <1570850706-12063-1-git-send-email-zhengbin13@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <3e3f05fb-387a-d55f-fc90-72d01c6d026a@acm.org>
Date:   Wed, 16 Oct 2019 19:45:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1570850706-12063-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-10-11 20:25, zhengbin wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 5447738..d5e29c5 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -255,6 +255,13 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
>  	struct scsi_request *rq;
>  	int ret = DRIVER_ERROR << 24;
> 
> +	/*
> +	 * Zero-initialize sshdr for those callers that check the *sshdr
> +	 * contents even if no sense data is available.
> +	 */
> +	if (sshdr)
> +		memset(sshdr, 0, sizeof(struct scsi_sense_hdr));
> +
>  	req = blk_get_request(sdev->request_queue,
>  			data_direction == DMA_TO_DEVICE ?
>  			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);

Although I don't have a strong opinion about this, I'm still wondering
whether 'sshdr' should be initialized in __scsi_execute() or by its caller.

> diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
> index ffcf902..335cfdd 100644
> --- a/drivers/scsi/sr_ioctl.c
> +++ b/drivers/scsi/sr_ioctl.c
> @@ -206,6 +206,11 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
> 
>  	/* Minimal error checking.  Ignore cases we know about, and report the rest. */
>  	if (driver_byte(result) != 0) {
> +		if (!scsi_sense_valid(sshdr)) {
> +			err = -EIO;
> +			goto out;
> +		}
> +
>  		switch (sshdr->sense_key) {
>  		case UNIT_ATTENTION:
>  			SDev->changed = 1;

Shouldn't this be a separate patch?

Thanks,

Bart.
