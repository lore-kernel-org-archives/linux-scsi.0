Return-Path: <SRS0=bO3J=AJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98821C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 22:31:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B8AC206E9
	for <linux-scsi@archiver.kernel.org>; Sun, 28 Jun 2020 22:31:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbgF1Wbm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 28 Jun 2020 18:31:42 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36353 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgF1Wbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Jun 2020 18:31:41 -0400
Received: by mail-pf1-f196.google.com with SMTP id 207so6882395pfu.3
        for <linux-scsi@vger.kernel.org>; Sun, 28 Jun 2020 15:31:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=62E7yOYQxC+9YP0F/YCLcKWyEYKy3xypofdzWTc24F4=;
        b=opIT2rSUbYZWpmX27+8NcLugOShqCrWlcqWgxVghdHmm3OQMjUlniRU6W4arY6wbKe
         EsaV5cGpOcVznnN5y2ha1r0ivZD4Cbii2UMbP5arWK5Rl3ZucN9oex5b8FWy50T88Y9G
         OZfJoLX7W1tGOlpCKJEFygsO3aQNdZE1nzZdta7aCLOXWo7/x2I4EnyOUjzsaYoY627A
         0Ez9piqIaG66iabdWT1ovJJa0sTlNVpv8GykN91TFs3pqnmepa2vcSyHIu3D7c5CnclW
         2V7El0He/ZuDb5jOmiaUrSLazIVQsqJZrAvGt5gfoTcupu6mJGKzEkKgxIFL3Fc9vGUG
         o4WQ==
X-Gm-Message-State: AOAM5304iMyk4yAsYAjNxNm2ZJvKd/QFQdv5kJjLHXEZAlahT7kyn2xZ
        xtQFHaD1drMekDtkpKzA5Zw=
X-Google-Smtp-Source: ABdhPJzs0gaRpHDjICwBrKAE7IJs9DJNF/h97t/S/eU7+EyKT7zNxp+Vk14+FPUhnWy8T3IWIpF9lg==
X-Received: by 2002:a05:6a00:1514:: with SMTP id q20mr12300850pfu.243.1593383500793;
        Sun, 28 Jun 2020 15:31:40 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id m1sm16950657pjr.56.2020.06.28.15.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Jun 2020 15:31:39 -0700 (PDT)
Subject: Re: [PATCH 7/9] qla2xxx: Fix a Coverity complaint in
 qla2100_fw_dump()
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200614223921.5851-1-bvanassche@acm.org>
 <20200614223921.5851-8-bvanassche@acm.org>
 <20200623083354.2fldcoancxym6s6n@beryllium.lan>
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
Message-ID: <c0b9309f-0da6-f5f5-d1c3-4b01986d9e72@acm.org>
Date:   Sun, 28 Jun 2020 15:31:37 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200623083354.2fldcoancxym6s6n@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-06-23 01:33, Daniel Wagner wrote:
> On Sun, Jun 14, 2020 at 03:39:19PM -0700, Bart Van Assche wrote:
>> @@ -1063,7 +1063,8 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
>>  	}
>>  
>>  	if (rval == QLA_SUCCESS)
>> -		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
>> +		qla2xxx_copy_queues(ha, (char *)fw +
>> +				    offsetof(typeof(*fw), risc_ram) + cnt);
> 
> This looks pretty ugly to me. Any chance to write this in a way it's
> understandable by humans and coverity is not annoyed?
> 
> Do I understand it correctly, it's valid to read after the end of risc_ram?

Doesn't the function qla2xxx_copy_queues() write to the pointer passed
as the second argument instead of reading?

A possible alternative can be found below. The only reason I can think
of why this works is because the qla2100_fw_dump structure is occurs in
a union and because there is probably a larger structure present in the
same union. I would like to specify a size for the queue_dump[] array
but I am not sure where to get that information from.

Subject: [PATCH] qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()

'cnt' can exceed the size of the risc_ram[] array. Prevent that Coverity
complains by rewriting an address calculation expression. This patch
fixes the following Coverity complaint:

CID 337803 (#1 of 1): Out-of-bounds read (OVERRUN)
109. overrun-local: Overrunning array of 122880 bytes at byte offset
122880 by dereferencing pointer &fw->risc_ram[cnt].

---
 drivers/scsi/qla2xxx/qla_dbg.c | 2 +-
 drivers/scsi/qla2xxx/qla_dbg.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 19005710f7f6..41493bd53fc0 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1063,7 +1063,7 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
 	}

 	if (rval == QLA_SUCCESS)
-		qla2xxx_copy_queues(ha, &fw->risc_ram[cnt]);
+		qla2xxx_copy_queues(ha, &fw->queue_dump[0]);

 	qla2xxx_dump_post_process(base_vha, rval);
 }
diff --git a/drivers/scsi/qla2xxx/qla_dbg.h b/drivers/scsi/qla2xxx/qla_dbg.h
index 54ed020e6f75..91eb6901815c 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.h
+++ b/drivers/scsi/qla2xxx/qla_dbg.h
@@ -53,6 +53,7 @@ struct qla2100_fw_dump {
 	__be16 fpm_b0_reg[64];
 	__be16 fpm_b1_reg[64];
 	__be16 risc_ram[0xf000];
+	u8	queue_dump[];
 };

 struct qla24xx_fw_dump {
