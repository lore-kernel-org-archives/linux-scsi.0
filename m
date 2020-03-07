Return-Path: <SRS0=IrwI=4Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D699C10F26
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 16:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5196D2073D
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 16:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgCGQfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 11:35:44 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:52643 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbgCGQfo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 11:35:44 -0500
Received: by mail-pj1-f66.google.com with SMTP id lt1so2402773pjb.2;
        Sat, 07 Mar 2020 08:35:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Cg5Oac7HLMeEEjCIuNmhZwN3uMpxeRRyG9r8siwTeQg=;
        b=rCykOpBuboU4+wNbBDIR1EW+yk1ZLh3rWYk6VzRj2917REQz2LrWnukjN/GqokgDuV
         vgWn1kPHvM8J8kt8J4sCZXlzrLNSGPX6fIZLMfjb7kPWR+MN/rxKa8SKjlUpNmMfyP9Z
         L9m2nuFxzeDpr3wQ5kpcUthuS0lBs4325h6jnlhiTeAolqs0qJoJQCtD9XDCbnYvi48C
         AH60K80Pghu4fhOKci8fuZHCJHlMjbopJ8EKgs+zytvtNSgWIV9Trw5PONJMRJIxAXsi
         y19xS9psfIw1JYjgsOuq/G2xLLpRmcMCP1MxPOSVYwo/NoNDozYAFPzJXzkilC2utpb9
         jRdw==
X-Gm-Message-State: ANhLgQ0T1qH6VB87UAOMymKh+Q+ileKQ3GXAu4MeG9jPBgzKAEWMUmgI
        0bouaCRGVr71WAZeJvsBXqo=
X-Google-Smtp-Source: ADFU+vv96XvdAh+wnowb1qq9ifLNtVXcR7qHX74D983ljxzgYzXTE682FVKTjOxvGULBnqTvc9dljg==
X-Received: by 2002:a17:902:aa04:: with SMTP id be4mr8630576plb.41.1583598941703;
        Sat, 07 Mar 2020 08:35:41 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:e84b:4a82:674e:2e4d? ([2601:647:4000:d7:e84b:4a82:674e:2e4d])
        by smtp.gmail.com with ESMTPSA id i197sm37506627pfe.137.2020.03.07.08.35.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 08:35:40 -0800 (PST)
Subject: Re: [PATCH] scsi: aacraid: fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, aacraid@microsemi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org
References: <20200307132103.4687-1-tranmanphong@gmail.com>
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
Message-ID: <26713759-34ff-5c47-95bf-83723e8eac39@acm.org>
Date:   Sat, 7 Mar 2020 08:35:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200307132103.4687-1-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-07 05:21, Phong Tran wrote:
> correct usage prototype of callback scsi_cmnd.scsi_done()
> Report by: https://github.com/KSPP/linux/issues/20
> 
> Signed-off-by: Phong Tran <tranmanphong@gmail.com>
> ---
>  drivers/scsi/aacraid/aachba.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 33dbc051bff9..92a1058df3f5 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -798,6 +798,11 @@ static int aac_probe_container_callback1(struct scsi_cmnd * scsicmd)
>  	return 0;
>  }
>  
> +static void  aac_probe_container_scsi_done(struct scsi_cmnd *scsi_cmnd)
> +{
> +	aac_probe_container_callback1(scsi_cmnd);
> +}
> +
>  int aac_probe_container(struct aac_dev *dev, int cid)
>  {
>  	struct scsi_cmnd *scsicmd = kmalloc(sizeof(*scsicmd), GFP_KERNEL);
> @@ -810,7 +815,7 @@ int aac_probe_container(struct aac_dev *dev, int cid)
>  		return -ENOMEM;
>  	}
>  	scsicmd->list.next = NULL;
> -	scsicmd->scsi_done = (void (*)(struct scsi_cmnd*))aac_probe_container_callback1;
> +	scsicmd->scsi_done = (void (*)(struct scsi_cmnd *))aac_probe_container_scsi_done;
>  
>  	scsicmd->device = scsidev;
>  	scsidev->sdev_state = 0;
> 

Since the above cast is not necessary, please remove it.

Thanks,

Bart.
