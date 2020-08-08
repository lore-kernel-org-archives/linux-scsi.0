Return-Path: <SRS0=ejtk=BS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFC01C433DF
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 22:57:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1CD2206CD
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Aug 2020 22:57:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgHHW46 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Aug 2020 18:56:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35193 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgHHW46 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Aug 2020 18:56:58 -0400
Received: by mail-pg1-f194.google.com with SMTP id o5so2869102pgb.2;
        Sat, 08 Aug 2020 15:56:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y9u9uwtjB5Nk/16KFaUQYZf5pTJjEDM6b10S2jbbdP0=;
        b=kn/3rvbR4fhXcba7taj0xoAa4GargvzYUAQObhalb3ZxJYtvdbGzjlSeTpkgDNs6z1
         24QnT8KBFAZxIHlxe0h8WxaFXXgEppuns0mmdv/akoCobafJhqVUeoUzNfD+yphEnzci
         nxyPuNjF6ws2FTRgkNhHmax+BmQaQJZBo7zWza/SxgfSH3fRleBla2Ia5YkpiPpomTuP
         usFLfZ3s2R0mxrpRY/4s9LpJrHH/sgPa9xOr6yUE7W/hCdcmtu1T3qQmcxeGMGdote81
         Zp96IvwyQjUpn24ceq4IpvNRgI6goAu2AHMG4PE7FsNzTGRpIuyKtbsD0KYUGP7yY/Cf
         dJ5A==
X-Gm-Message-State: AOAM531DqmPZggpKKbtdEloHnq9+IIs/iFdIwWhuqUBVLBbLZkf1xaN3
        JbrJDxCWYXHq9BtrByO/vCc=
X-Google-Smtp-Source: ABdhPJwIPSSunfCDcRthsG/Gzbl9acijXbEwF1QpT09f6ZKgqS9EzbDBzo7x/iFOFC9pjk2e1zfm1A==
X-Received: by 2002:a63:df01:: with SMTP id u1mr15310304pgg.401.1596927416923;
        Sat, 08 Aug 2020 15:56:56 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id f89sm15830883pje.11.2020.08.08.15.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 15:56:55 -0700 (PDT)
Subject: Re: [PATCH v8 2/4] scsi: ufs: Introduce HPB feature
To:     daejun7.park@samsung.com,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
References: <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
 <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
 <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
 <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
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
Message-ID: <4a91d02c-488c-86cd-325c-5e0ad9addd0b@acm.org>
Date:   Sat, 8 Aug 2020 15:56:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <231786897.01596705302142.JavaMail.epsvc@epcpadp1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-08-06 02:11, Daejun Park wrote:
> +static void ufshpb_issue_hpb_reset_query(struct ufs_hba *hba)
> +{
> +	int err;
> +	int retries;
> +
> +	for (retries = 0; retries < HPB_RESET_REQ_RETRIES; retries++) {
> +		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_SET_FLAG,
> +				QUERY_FLAG_IDN_HPB_RESET, 0, NULL);
> +		if (err)
> +			dev_dbg(hba->dev,
> +				"%s: failed with error %d, retries %d\n",
> +				__func__, err, retries);
> +		else
> +			break;
> +	}
> +
> +	if (err) {
> +		dev_err(hba->dev,
> +			"%s setting fHpbReset flag failed with error %d\n",
> +			__func__, err);
> +		return;
> +	}
> +}

Please change the "break" into an early return, remove the last
occurrence "if (err)" and remove the final return statement.

> +static void ufshpb_check_hpb_reset_query(struct ufs_hba *hba)
> +{
> +	int err;
> +	bool flag_res = true;
> +	int try = 0;
> +
> +	/* wait for the device to complete HPB reset query */
> +	do {
> +		if (++try == HPB_RESET_REQ_RETRIES)
> +			break;
> +
> +		dev_info(hba->dev,
> +			"%s start flag reset polling %d times\n",
> +			__func__, try);
> +
> +		/* Poll fHpbReset flag to be cleared */
> +		err = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,
> +				QUERY_FLAG_IDN_HPB_RESET, 0, &flag_res);
> +		usleep_range(1000, 1100);
> +	} while (flag_res);
> +
> +	if (err) {
> +		dev_err(hba->dev,
> +			"%s reading fHpbReset flag failed with error %d\n",
> +			__func__, err);
> +		return;
> +	}
> +
> +	if (flag_res) {
> +		dev_err(hba->dev,
> +			"%s fHpbReset was not cleared by the device\n",
> +			__func__);
> +	}
> +}

Should "polling %d times" perhaps be changed into "attempt %d"?

The "if (err)" statement may be reached without "err" having been
initialized. Please fix.

Additionally, please change the do-while loop into a for-loop, e.g. as
follows:

	for (try = 0; try < HPB_RESET_REQ_RETRIES; try++)
		...

Thanks,

Bart.
