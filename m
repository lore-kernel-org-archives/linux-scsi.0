Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1771DC10F25
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1E23206D5
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:23:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgCHCXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:23:40 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40876 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgCHCXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 21:23:40 -0500
Received: by mail-pg1-f195.google.com with SMTP id t24so3042551pgj.7;
        Sat, 07 Mar 2020 18:23:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=prRadkOgljmcVFZ0EQ43osDjYhqzZ8ylMyUcgnXfTLI=;
        b=t+PyG7exAmaLMMrfercqQWvZ3tnDuEiKKh/KGEBxXuJOGbZGnWhE7PpOHipdbHHNxU
         fZ/CqgNTLSO2RAP5OfK2KXlLcK7xJ7TJ8ZmAmoHW+zkAemmUAHb+7iLh368g9gXc4CEQ
         bckl9jc2wXTP31Y1WnRiRUFvAebv41YxUoo4ra04eXuRxov4x9uRllu2184woQQseinr
         27gYbI5Vo6N5me5EV8RIaNzv08YVyLHXVLieQARZ+kCmTIEQN4IuVZI378V47+BAsW8j
         jQqRVBF+dfan88uzvIdBIoyb/TwnuQW3yDE8ezIUueEYfD43OQSviRHaLYwrnFnLkQH6
         oS8g==
X-Gm-Message-State: ANhLgQ0eA16H5TI5QKNZK/TxABZ0EN3qIvZz3uMpOCy6Z+rhr6EYRiJM
        3N1/6r9PRx9ZHpA3Mn9nKR0=
X-Google-Smtp-Source: ADFU+vvnClbMcuiLeqrDI5Lh99HdoJJA21S7J1NbeCWVEL9gbVNgSRgtAtCfZna2aKWto3/j77Rs5w==
X-Received: by 2002:a63:fc1c:: with SMTP id j28mr10281377pgi.289.1583634219265;
        Sat, 07 Mar 2020 18:23:39 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:b9ba:8890:46d5:d60d? ([2601:647:4000:d7:b9ba:8890:46d5:d60d])
        by smtp.gmail.com with ESMTPSA id ay10sm13897002pjb.37.2020.03.07.18.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 18:23:38 -0800 (PST)
Subject: Re: [PATCH v2] scsi: aacraid: fix -Wcast-function-type
To:     Phong Tran <tranmanphong@gmail.com>, aacraid@microsemi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        keescook@chromium.org
References: <20200307132103.4687-1-tranmanphong@gmail.com>
 <20200308020143.9351-1-tranmanphong@gmail.com>
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
Message-ID: <d18e3d83-d1b5-5979-c2ec-235e4f5095a3@acm.org>
Date:   Sat, 7 Mar 2020 18:23:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200308020143.9351-1-tranmanphong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-07 18:01, Phong Tran wrote:
> correct usage prototype of callback scsi_cmnd.scsi_done()
> Report by: https://github.com/KSPP/linux/issues/20

This description is confusing. I think a better description would have
been "Make the aacraid driver -Wcast-function-type clean."

Anyway:

Reviewed-by: Bart van Assche <bvanassche@acm.org>




