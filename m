Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0615AC10F25
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 04:04:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D049721D56
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 04:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgCKEEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 00:04:10 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37176 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbgCKEEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 00:04:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id p14so525256pfn.4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2020 21:04:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SImUdL5+Px2FKhiXlk6gKByruov3pRF3MA7DTFrWhiY=;
        b=oHb3qam5Vepu9k/sufaWkA+LE74L+UjBRuJ9tIr+yMhL1uuDBAl8N/A/Y8dMo1zuqW
         xg6qEhn5fRE5La9SfWKW6ZGq+6imkMed7J3GG5uWZOWscl/y0gm0biimHCIcWCHdM5lv
         1KBDbtP6L0/0F7DorP0twEC7l8xWKo75ClU83lTlcLHTgpEfjCy8NpkAzUxCQoeyj869
         ryY5pGNGD2JeUwijeX6a7JsWuGH+DRSh6U3PwkwmBypyTbJzf+jVUj2G8w72FnYL7szE
         g6Am3PD0KqQT/aBg1m5jeiFAC2StzUUa3XjPOZwvf9qFsKjnedTRhFWuZZ7ScExVIKnd
         gz/w==
X-Gm-Message-State: ANhLgQ3Y0Z0u39Rp4egWYcvZULs5fsOCk82SIoNH6logKRjFpo5xBQOg
        dMsAYicH2UE0VTjrNB5O7YcRXd8h
X-Google-Smtp-Source: ADFU+vvHBEiYhLiJSjPGJbW3SEMEMF7VcaWHHfrmVuTj/AOGU5z+TD1PN1Om3q8wvPD9LjSiHGAP8A==
X-Received: by 2002:a63:9d04:: with SMTP id i4mr976636pgd.294.1583899447098;
        Tue, 10 Mar 2020 21:04:07 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id b12sm3614528pjz.46.2020.03.10.21.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 21:04:06 -0700 (PDT)
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline messages
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20200309181416.10665-1-emilne@redhat.com>
 <b7f3c0d1-0f08-83e2-6df5-8b6a02201ba6@acm.org>
 <c9ebe5ecaff898c848402413d9404b23dfe999e6.camel@redhat.com>
 <ccbaa97a-c946-f235-c7c3-3d9d6bf319c0@acm.org>
 <e13d0e51e83fd2fc5d653633a9cfb74e2b24b5a6.camel@redhat.com>
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
Message-ID: <789f1dc7-38bf-eced-85b1-ad22e7d69757@acm.org>
Date:   Tue, 10 Mar 2020 21:01:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <e13d0e51e83fd2fc5d653633a9cfb74e2b24b5a6.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-10 09:44, Ewan D. Milne wrote:
> On Mon, 2020-03-09 at 19:02 -0700, Bart Van Assche wrote:
>> On 2020-03-09 13:54, Ewan D. Milne wrote:
>>> The only purpose of the flag is to try to suppress duplicate messages,
>>> in the common case it is a single thread submitting the queued I/O which
>>> is going to get rejected.  If multiple threads submit I/O there might
>>> be duplicated messages but that is not all that critical.  Hence the
>>> lack of locking on the flag.
>>
>> My concern is that scsi_prep_state_check() may be called from more than
>> one thread at the same time and that bitfield changes are not thread-safe.
> 
> Yes, I agree that the flag is not thread-safe, but I don't think that
> is a concern.  Because if we get multiple rejecting I/O messages until
> the other threads see the flag change we are no worse off than before,
> and once the sdev state changes back to SDEV_RUNNING we won't call
> scsi_prep_state_check() and examine the flag.

Hi Ewan,

This is the entire list of bitfields in struct scsi_device:

	unsigned removable:1;
	unsigned changed:1;
	unsigned busy:1;
	unsigned lockable:1;
	unsigned locked:1;
	unsigned borken:1;
	unsigned disconnect:1;
	unsigned soft_reset:1;
	unsigned sdtr:1;
	unsigned wdtr:1;
	unsigned ppr:1;
	unsigned tagged_supported:1;
	unsigned simple_tags:1;
	unsigned was_reset:1;
	unsigned expecting_cc_ua:1;
	unsigned use_10_for_rw:1;
	unsigned use_10_for_ms:1;
	unsigned set_dbd_for_ms:1;
	unsigned no_report_opcodes:1;
	unsigned no_write_same:1;
	unsigned use_16_for_rw:1;
	unsigned skip_ms_page_8:1;
	unsigned skip_ms_page_3f:1;
	unsigned skip_vpd_pages:1;
	unsigned try_vpd_pages:1;
	unsigned use_192_bytes_for_3f:1;
	unsigned no_start_on_add:1;
	unsigned allow_restart:1;
	unsigned manage_start_stop:1;
	unsigned start_stop_pwr_cond:1;
	unsigned no_uld_attach:1;
	unsigned select_no_atn:1;
	unsigned fix_capacity:1;
	unsigned guess_capacity:1;
	unsigned retry_hwerror:1;
	unsigned last_sector_bug:1;
	unsigned no_read_disc_info:1;
	unsigned no_read_capacity_16:1;
	unsigned try_rc_10_first:1;
	unsigned security_supported:1;
	unsigned is_visible:1;
	unsigned wce_default_on:1;
	unsigned no_dif:1;
	unsigned broken_fua:1;
	unsigned lun_in_cdb:1;
	unsigned unmap_limit_for_ws:1;
	unsigned rpm_autosuspend:1;

If any thread modifies any of these existing bitfields concurrently with
scsi_prep_state_check(), one of the two modifications will be lost. That
is because compilers implement bitfield changes as follows:

new_value = (old_value & ~(1 << ...)) | (1 << ...);

If two such assignment statements are executed concurrently, both start
from the same 'old_value' and only one of the two changes will happen.
I'm concerned that this patch introduces a maintenance problem in the
long term. Has it been considered to make 'offline_already' a 32-bits
integer variable or a boolean instead of a bitfield? I think such
variables can be modified without discarding values written from another
thread.

Thanks,

Bart.


