Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FB67C10F25
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFFC521655
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 03:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCKDwE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 23:52:04 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:32883 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727685AbgCKDwE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Mar 2020 23:52:04 -0400
Received: by mail-pf1-f194.google.com with SMTP id n7so519856pfn.0;
        Tue, 10 Mar 2020 20:52:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4jWgXx47//lwhsK545GCcf8+J7kzYJPs216sdqcaw9s=;
        b=TW+0cTiFtTEVo4Tv7RTH10WLCdTdyFE/bpVL1Od7GanN4NbkkSEOqbyWJHiwiXRZFc
         /yinK0PrikS3BmS1SAS2s5ZX8meLUAWOIrWsjtF07x10DUpxl3FlnS5hUX/lh5Ryw+sn
         DzszxHO2r4V7S3AbJxwcmj9X/cCbge9CMqhSDr7tI6YnsozpGrgmNqlN2hJm7KxlP6/W
         o0WJXH/GaY7plIOF0BrBZLxZWUNcFBLt1CIWEZvfLdnJyC8uVGuSDWHlJDqMh8pOK/ir
         /Km30cAIUDlB3Qv9ksGj2Pux+/D3ufO2673rACqDi+34cwDKyor7shLwFwz91k/oflhJ
         imew==
X-Gm-Message-State: ANhLgQ2+F/lkgZlQTRX3m0ksRsgHIScmA6YoX4S9iFAJRbiDotZoycel
        vB0OIpPDB+5fcyqwCYfhBnyWDvmk
X-Google-Smtp-Source: ADFU+vsPe3nR1yGq0IDimdwPKTmAbQvmNKp34gHbk96fo5xifYNzU9RqWOJGKqN9VqdizJVY2fi/ew==
X-Received: by 2002:a65:5688:: with SMTP id v8mr850865pgs.403.1583898722629;
        Tue, 10 Mar 2020 20:52:02 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g11sm20680768pfo.184.2020.03.10.20.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 20:52:01 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect
 initialization issue
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200309161057.9897-1-beanhuo@micron.com>
 <20200309161057.9897-2-beanhuo@micron.com>
 <ede4addf-73c7-e5f8-5143-91eb0cd3eb9b@acm.org>
 <BN7PR08MB5684F9667DE1CD05D0D01EE6DBFF0@BN7PR08MB5684.namprd08.prod.outlook.com>
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
Message-ID: <00b4f8d0-32d3-58c7-6361-6177ed8aaaed@acm.org>
Date:   Tue, 10 Mar 2020 20:49:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB5684F9667DE1CD05D0D01EE6DBFF0@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-10 00:53, Bean Huo (beanhuo) wrote:
> Hi, Bart 
> 
>> Subject: [EXT] Re: [PATCH v3 1/1] scsi: ufs: fix LRB pointer incorrect initialization
>> issue
>>
>> On 2020-03-09 09:10, huobean@gmail.com wrote:
>>> @@ -4834,6 +4829,7 @@ static void __ufshcd_transfer_req_compl(struct
>> ufs_hba *hba,
>>>  			continue;
>>>  		cmd = blk_mq_rq_to_pdu(req);
>>>  		lrbp = scsi_cmd_priv(cmd);
>>> +		ufshcd_init_lrb(hba, lrbp, index);
>>>  		if (ufshcd_is_scsi(req)) {
>>>  			ufshcd_add_command_trace(hba, req, "complete");
>>>  			result = ufshcd_transfer_rsp_status(hba, lrbp);
>>
>> This ufshcd_init_lrb() call looks incorrect to me. I think that
>> ufshcd_init_lrb() should only be called before a request is submitted to the UFS
>> controller and also that ufshcd_init_lrb() should not be called from the
>> completion path.
> 
> __ufshcd_transfer_req_compl()
> 	ufshcd_transfer_rsp_status()  will access lrbp->ucd_rsp_ptr.
> Without calling ufshcd_init_lrb() here, there will be an error.

Hi Bean,

I think that ufshcd_init_lrb() should only be called from the code that
prepares a command before it is submitted and not from the command
completion path. Because v5.6-rc5 has already been released, there is
not that much time left until the merge window opens. I think it is less
risky to revert commit 34656dda81ac ("scsi: ufs: Let the SCSI core
allocate per-command UFS data") than to proceed with the above patch. Do
you want to submit a revert or do you perhaps want me to do that?

Thanks,

Bart.

