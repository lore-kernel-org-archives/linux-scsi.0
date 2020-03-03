Return-Path: <SRS0=hRFu=4U=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1DEDC3F2C6
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C41920CC7
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Mar 2020 06:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725818AbgCCGgL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Mar 2020 01:36:11 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37411 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCCGgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2020 01:36:10 -0500
Received: by mail-pg1-f195.google.com with SMTP id z12so1053979pgl.4
        for <linux-scsi@vger.kernel.org>; Mon, 02 Mar 2020 22:36:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=39HOCf2JMg9+vgJ5wsw8QjVhYL09gU1lYCeWL3iw2Nw=;
        b=jZmFGEwUbFAQBcrUgLOK4mjugCtAMTqiIwFBTBpdxWFNs+P85c5T0FuQzsVZpkMD4H
         30Wf/o7E9Uv8F0Fo5RPHoJTVOeFNImBntAP1P91UFDmY31FLW0sSvv9yVHXLMzejPur4
         zNZgWyZih9xxWy6noaKOLF5QfXSLSTwnBncZY146tQXeDMbc7x+vrEWlcucKCPSw8GjH
         mVp7hb/hr8adt0R7SUC97uO7NQrZIBn+WnWl9YV/xOqrNsezXI594N9F9pT5ZsCcEvB4
         29Cplh3/dDHrdMO11mh1fcrnQlrQvYmSyX5eIsfqD7dNuETV1gpf2Q2pIL0HfHooBZWm
         SiOw==
X-Gm-Message-State: ANhLgQ0LOf3r4Z/snYu/BUDBgxYwg68mLHQDHVaKSINUUgq1VkfAYrxH
        dHumSXj4x7mpe9Hl7/X6P8Q=
X-Google-Smtp-Source: ADFU+vuhQ66dn7MNSRVkt48y6XbbUpGaD42DFNASQT53LHlOtr0yIr6ffPrHnkovxtEoQQfIbeVO8A==
X-Received: by 2002:a63:5124:: with SMTP id f36mr2558156pgb.288.1583217367693;
        Mon, 02 Mar 2020 22:36:07 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:5909:8e52:fd69:e98d? ([2601:647:4000:d7:5909:8e52:fd69:e98d])
        by smtp.gmail.com with ESMTPSA id t71sm1169751pjb.41.2020.03.02.22.36.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 22:36:06 -0800 (PST)
Subject: Re: [PATCH 3/4] qla2xxx: Fix endianness annotations in source files
To:     Daniel Wagner <dwagner@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20200302033023.27718-1-bvanassche@acm.org>
 <20200302033023.27718-4-bvanassche@acm.org>
 <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
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
Message-ID: <08d14c58-d8bb-b0ff-d81b-91373ab6a09c@acm.org>
Date:   Mon, 2 Mar 2020 22:36:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200302184055.dtjktj4sbsyysk5m@beryllium.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-02 10:40, Daniel Wagner wrote:
> On Sun, Mar 01, 2020 at 07:30:22PM -0800, Bart Van Assche wrote:
>> Fix all endianness complaints reported by sparse (C=2).
> 
> [...]
> 
>>  int
>> -qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
>> -    uint32_t ram_dwords, void **nxt)
>> +qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, __be32 *ram,
>> +		 uint32_t ram_dwords, void **nxt)
>>  {
>>  	int rval = QLA_FUNCTION_FAILED;
>>  	struct device_reg_24xx __iomem *reg = &ha->iobase->isp24;
>>  	dma_addr_t dump_dma = ha->gid_list_dma;
>> -	uint32_t *chunk = (void *)ha->gid_list;
>> +	uint32_t *chunk = (uint32_t *)ha->gid_list;
>>  	uint32_t dwords = qla2x00_gid_list_size(ha) / 4;
>>  	uint32_t stat;
>>  	ulong i, j, timer = 6000000;
>> @@ -252,9 +252,9 @@ qla24xx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint32_t *ram,
>>  			return rval;
>>  		}
>>  		for (j = 0; j < dwords; j++) {
>> -			ram[i + j] =
>> -			    (IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
>> -			    chunk[j] : swab32(chunk[j]);
>> +			ram[i + j] = (__force __be32)
>> +				((IS_QLA27XX(ha) || IS_QLA28XX(ha)) ?
>> +				 chunk[j] : swab32(chunk[j]));
> 
> Isn't this assuming the host runs in little endian mode? Because later down...

My goal was not to change the behavior of the code on x86. Bugs on big
endian systems can be fixed later on (my guess is that this driver does
not work reliably on big endian), and searching through the code for
__force casts probably provides some good starting points.

>> @@ -439,7 +439,7 @@ qla2xxx_dump_ram(struct qla_hw_data *ha, uint32_t addr, uint16_t *ram,
>>  		if (test_and_clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags)) {
>>  			rval = mb0 & MBS_MASK;
>>  			for (idx = 0; idx < words; idx++)
>> -				ram[cnt + idx] = swab16(dump[idx]);
>> +				ram[cnt + idx] = cpu_to_be16(le16_to_cpu(dump[idx]));
> 
> ... cpu_to_be16() is used.

The above code implements swab16() but without triggering sparse
endianness warnings.

>>  		if (!*srisc_addr) {
>>  			*srisc_addr = risc_addr;
>> -			risc_attr = be32_to_cpu(dcode[9]);
>> +			risc_attr = swab32(dcode[9]);
>>  		}
> 
> also here, this looks like hardcoded endianess.

It was not clear to me whether the purpose of the code was to convert
from __be32 to CPU endianness or from __be32 to __le32.

>> @@ -3398,7 +3399,7 @@ qla82xx_start_scsi(srb_t *sp)
>>  
>>  		memcpy(ctx->fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
>>  
>> -		fcp_dl = (uint32_t *)(ctx->fcp_cmnd->cdb + 16 +
>> +		fcp_dl = (void *)(ctx->fcp_cmnd->cdb + 16 +
>>  		    additional_cdb_len);
> 
> Shouldn't this be (__be32*)?

Good catch. I will change the cast.

>> @@ -3537,7 +3540,7 @@ qla24xx_get_flash_version(scsi_qla_host_t *vha, void *mbuf)
>>  	}
>>  
>>  	for (i = 0; i < 4; i++)
>> -		ha->gold_fw_version[i] = be32_to_cpu(dcode[4+i]);
>> +		ha->gold_fw_version[i] = swab32(dcode[4+i]);
>>  
>>  	return ret;
>>  }
> 
> Here again why the swab32() call.
I will restore the be32_to_cpu() call.

Bart.
