Return-Path: <SRS0=HsAm=ZT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E889C432C0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B57120722
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Nov 2019 02:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfK0CxO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 21:53:14 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34988 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfK0CxO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 21:53:14 -0500
Received: by mail-pg1-f196.google.com with SMTP id l24so1558036pgk.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2019 18:53:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ziegqnyWFS64ngNROo1CHlXId5O/HmNM5cB6751pYZw=;
        b=t1DvQEGKvszHTtrlDMchf89MiYdfReMfwYHZyD1KbcHxXn/7cBHfwmHppxb3CssDyw
         gK1REKwyyflzGCkynnyoXE5TOCutIuRNicD2yOZdgbALXin0ixvVhGCpqBiZ7PXpD2Bm
         vG6s3ow4df2iONjHeU7j9q6NS9RrnHaDIkgqBRWMPrIVqOBDnRcOnMVKlrPokLo+nU4X
         FqfKYFk3H3I20/qGCTeaEr+Lpa4vDmiu46TuVhkJIdD19/ijbs/HiOfvsCkljacUUTrs
         UmOylkLZ+acq7A8lmN4MuPs0OyUhoMDuSKusVKtMCKbZH93ZAELwVNIePl8M5rzx6BDJ
         S2eA==
X-Gm-Message-State: APjAAAWJ8vak2+ixD2gcSGFm5oH9Nztw381ZFZzFL4dToSK0qT+JzhCr
        yHAe+LrM8UVnNOAre2w98/0=
X-Google-Smtp-Source: APXvYqzY3UaNn7T9LWZdyCG7TGVQLemqSMi5ayaBt0WGyxnz3k0lUrLoiXM4riQiiUQZa/LaZcnIjw==
X-Received: by 2002:a63:fb15:: with SMTP id o21mr2044036pgh.193.1574823193879;
        Tue, 26 Nov 2019 18:53:13 -0800 (PST)
Received: from ?IPv6:2601:647:4000:1248:95a7:5888:e7d6:d4f3? ([2601:647:4000:1248:95a7:5888:e7d6:d4f3])
        by smtp.gmail.com with ESMTPSA id x25sm14464313pfq.73.2019.11.26.18.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 18:53:13 -0800 (PST)
Subject: Re: [PATCH v6 2/4] ufs: Avoid busy-waiting by eliminating tag
 conflicts
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     Bean Huo <beanhuo@micron.com>, Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-3-bvanassche@acm.org>
 <42f44ffb-15c2-ce99-ec4e-4f012fee4831@suse.de>
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
Message-ID: <337e599a-5fa0-1912-6f7e-02ffc9160c5d@acm.org>
Date:   Tue, 26 Nov 2019 18:53:11 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <42f44ffb-15c2-ce99-ec4e-4f012fee4831@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-26 03:51, Hannes Reinecke wrote:
> On 11/21/19 11:08 PM, Bart Van Assche wrote:
>> @@ -561,7 +560,6 @@ struct ufs_hba {
>>  	u32 ahit;
>>  
>>  	struct ufshcd_lrb *lrb;
>> -	unsigned long lrb_in_use;
>>  
>>  	unsigned long outstanding_tasks;
>>  	unsigned long outstanding_reqs;
>>
> This is pretty similar to the 'reserved tags' patchset I send as a
> proposal a while ago (cf 'scsi: enable reserved commands for LLDDs').
> 
> Shouldn't we resurrect this? Once the shared host_tags have gone in we
> can leverage this from other dreivers, too ...

Hi Hannes,

As you may have noticed a previous version of this patch series used
reserved tags. That approach has been abandoned because it made it
impossible to suspend SCSI command processing without suspending
processing of other UFS commands.

Bart.
