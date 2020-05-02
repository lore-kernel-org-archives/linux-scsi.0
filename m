Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BFF3C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:10:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21BE624956
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 16:10:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbgEBQKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 12:10:37 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37591 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728222AbgEBQKh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 12:10:37 -0400
Received: by mail-pj1-f67.google.com with SMTP id a7so1424594pju.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 May 2020 09:10:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=SLvzoc4y1aMWyUFjJ3yqKUnm/rnyoINULt1TS8E7oHk=;
        b=o3cHiRi8MsYKWXppqDlL9GzUzItDX/Qi1pL9K5J8gn19hAWHK0xPQS7cD9qJeb5W1s
         +iNmyzoVx1nc+j6CMBppgJmnYNVl/yDKDK2q4JHBDv8zntHT1mMXXp+LCYWdjadSaIMS
         a7DakmjWxLmAZ9WEAoGUVCid8gwu2ewTypudzkUlDaXrjRmrTMRyRZFyIKKlcxAk2FOH
         wekqVZaKDzvPLioI6u2UG4zH84zqidoql8N23HVhQIEqIhX9CXTqGu6DSTyywCN4UNx7
         TSzFXEWEb7sYzzHWb81jvi5ncy5vltDKMBSvHxhKOPc+I5rkSaj0PgKHsHlrssJnM6SF
         g8eA==
X-Gm-Message-State: AGi0PuY9CK1zdHi1PCWjjt0gnDg1wThN7HpKbG4hW6DnDmiimWRKWVb7
        6m6bL8Gdgja4YyjNigwElpI=
X-Google-Smtp-Source: APiQypJUK+oDZ3HMgo7fN5T65ROMmHWytVN/QGaeTT6V0fnKr/jQszCbd9IovQO+JGLutdBdUGCN0g==
X-Received: by 2002:a17:90a:648d:: with SMTP id h13mr6967688pjj.12.1588435835158;
        Sat, 02 May 2020 09:10:35 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f841:776c:f563:db5c? ([2601:647:4000:d7:f841:776c:f563:db5c])
        by smtp.gmail.com with ESMTPSA id y16sm4932187pfp.45.2020.05.02.09.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 09:10:34 -0700 (PDT)
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
To:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de> <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590> <20200501174505.GC23795@lst.de>
 <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
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
Message-ID: <49cb5125-4195-dddb-05a8-5bec627608f0@acm.org>
Date:   Sat, 2 May 2020 09:10:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-02 01:49, Hannes Reinecke wrote:
> On 5/1/20 7:45 PM, Christoph Hellwig wrote:
>> On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
>>>> We cannot increase MAX_QUEUE arbitrarily as this is a compile time
>>>> variable,
>>>> which seems to relate to a hardware setting.
>>>>
>>>> But I can see to update the reserved command functionality for
>>>> allowing to
>>>> fetch commands from the normal I/O tag pool; in the case of LUN
>>>> reset it
>>>> shouldn't make much of a difference as the all I/O is quiesced anyway.
>>>
>>> It isn't related with reset.
>>>
>>> This patch reduces active IO queue depth by 1 anytime no matter there
>>> is reset
>>> or not, and this way may cause performance regression.
>>
>> But isn't it the right thing to do?  How else do we guarantee that
>> there always is a tag available for the LU reset?
>>
> Precisely. One could argue that this is an issue with the current
> driver, too; if all tags have timed-out there is no way how we can send
> a LUN reset even now. Hence we need to reserve a tag for us to reliably
> send a LUN reset.
> And this was precisely the problem what sparked off this entire
> patchset; some drivers require a valid tag to send internal, non SCSI
> commands to the hardware.
> And with the current design it requires some really ugly hacks to make
> this to work.

Hi Hannes,

The above explanation seems incomplete to me. The code in
drivers/scsi/scsi_error.c and several SCSI LLDs use scsi_eh_prep_cmnd()
and scsi_eh_restore_cmnd() to reset a controller without allocating a
new command. Has it been considered to use that approach in the csiostor
driver?

Thanks,

Bart.
