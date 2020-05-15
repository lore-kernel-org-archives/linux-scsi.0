Return-Path: <SRS0=Oq5V=65=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08909C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:23:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D96AE20728
	for <linux-scsi@archiver.kernel.org>; Fri, 15 May 2020 19:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgEOTW7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 May 2020 15:22:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34500 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgEOTW7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2020 15:22:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so1442385pfa.1
        for <linux-scsi@vger.kernel.org>; Fri, 15 May 2020 12:22:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=e9HM9d2wty9UHEgodxV4n2P4xLNXtpVA/UEIVMfsTYw=;
        b=T1iesowehyz6MFY4lKWyGbj9Qbyk1k3OMhsLc246W7+AtWCW3fQKgTA6Mzh6WnAT2/
         3+2GBQqr3TJD6VPK9H06fPk4qAdqVMG2ernoUUa6OBHT5FjKIcFt604G175DEq2GkpyG
         ttQYxGQOkgiMe0nKjFMVek4T2ycbiqFkThOc0IiqhcTnVNETnrGi6fV8KSJr7LYcNOpp
         Jnq20X4WyBGzBLD/xyWtqFTCA2/C8NxI0Vzjl2N0/REC64g4GRvuoPcE/Pskzg95JGVg
         9ewYMKWRFbsckJv+wmPemh2uysMmEgar4TtI2LPMENnjY14AxU7kZHEtfAa3qP6l4AEL
         NDRw==
X-Gm-Message-State: AOAM530zt7ghSzBw8V+AQk/y/dzDYp5b+7D1BCzHuniBg5bBOhuRmMSb
        XoB4Uvb2c6klkT2yYE4uNKZibHD/
X-Google-Smtp-Source: ABdhPJxLIQ6iuo5sa3PScp9YdKRsSTbSo4xa8i62Yu+/UNjZ+HYVVMexXDICM3Vjiz+LsGGRg7WGAQ==
X-Received: by 2002:a63:7c50:: with SMTP id l16mr4623211pgn.59.1589570578210;
        Fri, 15 May 2020 12:22:58 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:f99a:ee92:9332:42a? ([2601:647:4000:d7:f99a:ee92:9332:42a])
        by smtp.gmail.com with ESMTPSA id q9sm2502927pff.62.2020.05.15.12.22.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 12:22:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v6 15/15] qla2xxx: Fix endianness annotations in source
 files
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Arun Easi <aeasi@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200514213516.25461-1-bvanassche@acm.org>
 <20200514213516.25461-16-bvanassche@acm.org>
 <77c33a4e-c67c-1978-8b72-ceca58d4309d@suse.de>
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
Message-ID: <fdc5993d-ffb8-cd7f-06a3-20e16a1017d0@acm.org>
Date:   Fri, 15 May 2020 12:22:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <77c33a4e-c67c-1978-8b72-ceca58d4309d@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-14 23:50, Hannes Reinecke wrote:
> On 5/14/20 11:35 PM, Bart Van Assche wrote:
>> diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c
>> b/drivers/scsi/qla2xxx/qla_tmpl.c
>> index f05a4fa2b9d7..b91ec1c3a3ae 100644
>> --- a/drivers/scsi/qla2xxx/qla_tmpl.c
>> +++ b/drivers/scsi/qla2xxx/qla_tmpl.c
>> @@ -922,9 +922,9 @@ qla27xx_firmware_info(struct scsi_qla_host *vha,
>>       tmp->firmware_version[0] = vha->hw->fw_major_version;
>>       tmp->firmware_version[1] = vha->hw->fw_minor_version;
>>       tmp->firmware_version[2] = vha->hw->fw_subminor_version;
>> -    tmp->firmware_version[3] = cpu_to_le32(
>> +    tmp->firmware_version[3] = (__force u32)cpu_to_le32(
>>           vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
>> -    tmp->firmware_version[4] = cpu_to_le32(
>> +    tmp->firmware_version[4] = (__force u32)cpu_to_le32(
>>         vha->hw->fw_attributes_ext[1] << 16 |
>> vha->hw->fw_attributes_ext[0]);
>>   }
>>  
> Why do you need (__force u32) here?
> It should be a 32bit array, and cpu_to_le32() trivially returns 32bits.
> What's there to force?

The hw->fw_{major,minor,subminor}_version and also the
hw->fw_attributes_ext variables have been annotated as CPU endian. I
inserted the (__force u32) casts because that suppresses the endianness
warnings without affecting the generated code on little endian or big
endian systems. Thinking further about this, storing CPU endian values
in a firmware data structure is most likely wrong. How about modifying
patch 15/15 as follows?

 drivers/scsi/qla2xxx/qla_tmpl.c | 10 +++++-----
 drivers/scsi/qla2xxx/qla_tmpl.h |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index b91ec1c3a3ae..8dc82cfd38b2 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -919,12 +919,12 @@ static void
 qla27xx_firmware_info(struct scsi_qla_host *vha,
     struct qla27xx_fwdt_template *tmp)
 {
-	tmp->firmware_version[0] = vha->hw->fw_major_version;
-	tmp->firmware_version[1] = vha->hw->fw_minor_version;
-	tmp->firmware_version[2] = vha->hw->fw_subminor_version;
-	tmp->firmware_version[3] = (__force u32)cpu_to_le32(
+	tmp->firmware_version[0] = cpu_to_le32(vha->hw->fw_major_version);
+	tmp->firmware_version[1] = cpu_to_le32(vha->hw->fw_minor_version);
+	tmp->firmware_version[2] = cpu_to_le32(vha->hw->fw_subminor_version);
+	tmp->firmware_version[3] = cpu_to_le32(
 		vha->hw->fw_attributes_h << 16 | vha->hw->fw_attributes);
-	tmp->firmware_version[4] = (__force u32)cpu_to_le32(
+	tmp->firmware_version[4] = cpu_to_le32(
 	  vha->hw->fw_attributes_ext[1] << 16 | vha->hw->fw_attributes_ext[0]);
 }

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.h b/drivers/scsi/qla2xxx/qla_tmpl.h
index bba8dc90acfb..89280b3477aa 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.h
+++ b/drivers/scsi/qla2xxx/qla_tmpl.h
@@ -27,7 +27,7 @@ struct __packed qla27xx_fwdt_template {
 	uint32_t saved_state[16];

 	uint32_t reserved_3[8];
-	uint32_t firmware_version[5];
+	__le32 firmware_version[5];
 };

 #define TEMPLATE_TYPE_FWDUMP		99

Thanks,

Bart.
