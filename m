Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE6AAC10DCE
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 20:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD9372067C
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 20:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgCHU4H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 16:56:07 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46182 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726332AbgCHU4G (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2020 16:56:06 -0400
Received: by mail-pf1-f193.google.com with SMTP id c19so1574216pfo.13
        for <linux-scsi@vger.kernel.org>; Sun, 08 Mar 2020 13:56:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=AZ7v8grRna6jwbVxs/BIawQiWcEEVjqvd8INa/kzMK4=;
        b=eqFY69unxS0g8pV5svN7GHlFBQi7axXcjzmEuDAASPjuMotJwY1WsmXXKkPvx5LNy9
         IW5f/YjWqRsPOqdWLrvVc7f8HnvSlazhe3ZL0zcSYfFnf+Z7I3N6f7KoFl8gkT4v0/K0
         uGZZqjxW2CWcoJNPBLt66WpCTHpPHG2JnyRsgoEPqJ1yz0PyrmgDUS7NlfefQdLl5pwb
         HAavMZg78/uHSBTO2aw9KFPgEBdbqHHMkg/LOKsmVumZvomFLWk9u/Y/Jl5DhHMPzFbj
         vS12yTIFzu5XGhpD7pk9EIsyNbM3TnFQwoKFzyg3jCIWWSajrzOUcUr32I0eTBRljByB
         njfg==
X-Gm-Message-State: ANhLgQ3bTH6bm0X2lldGYyxK4maajS9kIWcDzP2Oj40kbotKXEFhdHye
        MYZl3LlNghv9cZzJeomkyga2t88f
X-Google-Smtp-Source: ADFU+vvXrNBXw9sBVyFaQ32OXWA/kGUXZiHXacToohvhAfanKd6padNAN6zdCk42RtN2VElpxGAJtw==
X-Received: by 2002:a63:be09:: with SMTP id l9mr13231435pgf.439.1583700965232;
        Sun, 08 Mar 2020 13:56:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:1b6:6e46:9c16:a30? ([2601:647:4000:d7:1b6:6e46:9c16:a30])
        by smtp.gmail.com with ESMTPSA id y9sm6718888pgo.80.2020.03.08.13.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 13:56:04 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 0/4] ufs: Let the SCSI core allocate
 per-command UFS data
To:     "Bean Huo (beanhuo)" <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20200123035637.21848-1-bvanassche@acm.org>
 <yq1v9nq5enp.fsf@oracle.com>
 <BN7PR08MB56844C7D0198E487B9F31A03DBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
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
Message-ID: <63f2ab75-6d23-855b-ba26-0c9260f86df9@acm.org>
Date:   Sun, 8 Mar 2020 13:56:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <BN7PR08MB56844C7D0198E487B9F31A03DBE10@BN7PR08MB5684.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-08 06:31, Bean Huo (beanhuo) wrote:
> The 4/4 of this series patch has huge impact on UFS driver, we didn't test yet and thoroughly review it.
> It has been mainlined. After the  4/4 patch, UFS device probe failed and the root case is the incorrect lrbp.
> I submitted a workaround patch for this.
> we can now either withdraw this 4/4 patch, or need fixup patch.

Thanks for having reported this. Let's continue the conversation on the
patch with the proposed fix.

Bart.

