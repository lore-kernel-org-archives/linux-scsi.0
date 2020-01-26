Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2877C35246
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 03:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E23A2075D
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 03:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbgAZD37 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 25 Jan 2020 22:29:59 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39841 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728842AbgAZD37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 25 Jan 2020 22:29:59 -0500
Received: by mail-pf1-f194.google.com with SMTP id q10so3195411pfs.6;
        Sat, 25 Jan 2020 19:29:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=N+COkGkdfHeb1HY7LPYrfTxzXMweLGHf0JX8QC6GcnE=;
        b=l/4WbgkerBcuHFxWDnUNtCGnrGS9nKPTQVgnppUhw2/jg5zWfZy1uCma+Y4Wjf1oq9
         S3oU8fs5He6w7Isp3CTDq78laLeqh0m5n64YCzeYTa9K7At0UINa0cK4P0hzWy7QoNbM
         421RRImHSCZYUSp+bZ0K1FwMifQkx8KzlDw3INjoduaI6CT126WvJ7EN9YBCe1WFErOo
         1duK6bmS4oVELCMsRuCKXs0X1M/qzR0lYyUykRjNwg1xic9T/I16oqU7V7c6v0Q+UT2G
         EbMGnkLdSmKVTbDoVnBKj8U6HBZZfVUpgaaQZzUu+o8xQ5cFrE1buYf6dFrqn31SI5al
         qPBw==
X-Gm-Message-State: APjAAAWhe2KwlGI9gnpEXCVzTvv679aX4ryGSNTvnPw6WdPn0H501FFo
        2xfnaKmhsWFV9KWWo0BmtjNVVWFJoeM=
X-Google-Smtp-Source: APXvYqwQ5vnYMPjXlEC23TI50IHXd8maikfNyaFxlIbAfHWWbi7aeaUZ/eMahXpiCU1ZobApoKYcgQ==
X-Received: by 2002:a63:7c2:: with SMTP id 185mr12219013pgh.446.1580009398138;
        Sat, 25 Jan 2020 19:29:58 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:a876:9802:4659:f0bd? ([2601:647:4000:d7:a876:9802:4659:f0bd])
        by smtp.gmail.com with ESMTPSA id z30sm11605612pfq.154.2020.01.25.19.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Jan 2020 19:29:57 -0800 (PST)
Subject: Re: [PATCH v4 1/8] scsi: ufs: Flush exception event before suspend
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Cc:     Sayali Lokhande <sayalil@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Pedro Sousa <pedrom.sousa@synopsys.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Venkat Gopalakrishnan <venkatg@codeaurora.org>,
        Tomas Winkler <tomas.winkler@intel.com>,
        open list <linux-kernel@vger.kernel.org>
References: <1579764349-15578-1-git-send-email-cang@codeaurora.org>
 <1579764349-15578-2-git-send-email-cang@codeaurora.org>
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
Message-ID: <525e4f67-f471-54a6-aaea-b3772a550af1@acm.org>
Date:   Sat, 25 Jan 2020 19:29:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1579764349-15578-2-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-22 23:25, Can Guo wrote:
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 1201578..c2de29f 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -4760,8 +4760,15 @@ static void ufshcd_slave_destroy(struct scsi_device *sdev)
>  			 * UFS device needs urgent BKOPs.
>  			 */
>  			if (!hba->pm_op_in_progress &&
> -			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr))
> -				schedule_work(&hba->eeh_work);
> +			    ufshcd_is_exception_event(lrbp->ucd_rsp_ptr)) {
> +				/*
> +				 * Prevent suspend once eeh_work is scheduled
> +				 * to avoid deadlock between ufshcd_suspend
> +				 * and exception event handler.
> +				 */
> +				if (schedule_work(&hba->eeh_work))
> +					pm_runtime_get_noresume(hba->dev);
> +			}

Please combine the two logical tests with "&&" instead of nesting two
if-statements inside each other.

>  			break;
>  		case UPIU_TRANSACTION_REJECT_UPIU:
>  			/* TODO: handle Reject UPIU Response */
> @@ -5215,7 +5222,14 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
>  
>  out:
>  	scsi_unblock_requests(hba->host);
> -	pm_runtime_put_sync(hba->dev);
> +	/*
> +	 * pm_runtime_get_noresume is called while scheduling
> +	 * eeh_work to avoid suspend racing with exception work.
> +	 * Hence decrement usage counter using pm_runtime_put_noidle
> +	 * to allow suspend on completion of exception event handler.
> +	 */
> +	pm_runtime_put_noidle(hba->dev);
> +	pm_runtime_put(hba->dev);
>  	return;
>  }
>  
> @@ -7901,6 +7915,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
>  			goto enable_gating;
>  	}
>  
> +	flush_work(&hba->eeh_work);
>  	ret = ufshcd_link_state_transition(hba, req_link_state, 1);
>  	if (ret)
>  		goto set_dev_active;

I think this patch introduces a new race condition, namely the following:
- ufshcd_slave_destroy() tests pm_op_in_progress and reads the value
  zero from that variable.
- ufshcd_suspend() sets hba->pm_op_in_progress to one.
- ufshcd_slave_destroy() calls schedule_work().

How about fixing this race condition by calling
pm_runtime_get_noresume() before checking pm_op_in_progress and by
reallowing resume if no work is scheduled?

Thanks,

Bart.


