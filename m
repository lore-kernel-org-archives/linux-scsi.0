Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7638C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F27D2070B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 16:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbgEKQIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 12:08:02 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:50926 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730612AbgEKQIB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 12:08:01 -0400
Received: by mail-pj1-f67.google.com with SMTP id t9so8141922pjw.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 09:07:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=inMeMFW1trvPQKioCVVtm4GtjAqhIxmuCda3l3GaVe0=;
        b=nnHoZXBYkbf0DTeXH8T0xBpOt5L5WDLnFE5t0r5+6oQ5eh3xyz1Hsl6wQHJvdAZzg7
         GZXP65e0EWD/qSyKPTxtcqpILEy1ZxfTvkHLw933W0wKrcrL+KW4TnZv1ngPz3uKOe8N
         gEUpvj+eUM+oS9ylo+41qQeMbnjeP5E2IYUkHKcOtZdpegIcOah+q2hLu2fOXMkYQ83g
         0uhOoqmXxSXufYJ3UxvjK2PAyDrJjFo5wESmBpiLmokqD2aQZlA3CNq6thzv9EMDL11C
         ynNb0Co/MYVUi/QNH2qVDjEezXVKFfOmQJuubcM9ZjiEZyuz1XRxj6LewbDOj2737/sj
         YykQ==
X-Gm-Message-State: AGi0PuakoncHr2nbkrhluoUL3QBv43FxPG41dSTUSMhHbrGf0MOL4Mf8
        wPLdakQco3+cisbZZ0D46tA=
X-Google-Smtp-Source: APiQypKfWZK4/yovBGuwe+hA5Rm3OWLFYj23dqbQH5aCSNC5LYqg5yf4E+LM8I6c0PNxpBf4bSpdzw==
X-Received: by 2002:a17:90b:3547:: with SMTP id lt7mr17168533pjb.14.1589213279325;
        Mon, 11 May 2020 09:07:59 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c4e5:b27b:830d:5d6e? ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id g25sm9347863pfo.150.2020.05.11.09.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 09:07:58 -0700 (PDT)
Subject: Re: [PATCH v4 08/11] qla2xxx: Fix the code that reads from mailbox
 registers
To:     Arun Easi <aeasi@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200427030310.19687-1-bvanassche@acm.org>
 <20200427030310.19687-9-bvanassche@acm.org>
 <alpine.LRH.2.21.9999.2005110037000.23618@irv1user01.caveonetworks.com>
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
Message-ID: <0eae3a14-6ffd-b637-e753-3f0d684bd267@acm.org>
Date:   Mon, 11 May 2020 09:07:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.9999.2005110037000.23618@irv1user01.caveonetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 00:39, Arun Easi wrote:
> On Sun, 26 Apr 2020, 8:03pm, Bart Van Assche wrote:
>>  	default:
>> -		ha->aenmb[1] = RD_REG_WORD(&reg->aenmailbox1);
>> -		ha->aenmb[2] = RD_REG_WORD(&reg->aenmailbox2);
>> -		ha->aenmb[3] = RD_REG_WORD(&reg->aenmailbox3);
>> -		ha->aenmb[4] = RD_REG_WORD(&reg->aenmailbox4);
>> -		ha->aenmb[5] = RD_REG_WORD(&reg->aenmailbox5);
>> -		ha->aenmb[6] = RD_REG_WORD(&reg->aenmailbox6);
>> -		ha->aenmb[7] = RD_REG_WORD(&reg->aenmailbox7);
>> +		ha->aenmb[1] = RD_REG_DWORD(&reg->aenmailbox1);
>> +		ha->aenmb[2] = RD_REG_DWORD(&reg->aenmailbox2);
>> +		ha->aenmb[3] = RD_REG_DWORD(&reg->aenmailbox3);
>> +		ha->aenmb[4] = RD_REG_DWORD(&reg->aenmailbox4);
>> +		ha->aenmb[5] = RD_REG_DWORD(&reg->aenmailbox5);
>> +		ha->aenmb[6] = RD_REG_DWORD(&reg->aenmailbox6);
>> +		ha->aenmb[7] = RD_REG_DWORD(&reg->aenmailbox7);
> 
> Please leave the older access as is. The way you did is right, but
> these adapters are not frequently qualified, so please leave it the
> tested way.

The current code silently truncates 32-bit values into 16-bit values on
little endian architectures. The current code is totally broken on big
endian architectures. So I think the above changes are an important bug
fix. If these changes would introduce a regression, these changes are
easy to revert.

Thanks,

Bart.
