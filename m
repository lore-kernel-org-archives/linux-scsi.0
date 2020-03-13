Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8C18C10DCE
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:44:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 931A4206FA
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 14:44:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgCMOoS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 10:44:18 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40880 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgCMOoS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Mar 2020 10:44:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id l184so5333683pfl.7
        for <linux-scsi@vger.kernel.org>; Fri, 13 Mar 2020 07:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=OenbLq0rz9jOfLGpuXm6ZF1/ixCgqIJE2NQxATS07Ls=;
        b=QlXqhGUvsDTCj/VbOupR2DvKsdjP/bEE7o/4ITB+GuBdsOII461oIMlP2/dR5Du+Ps
         xL142+1k+6NssOTNCYGlDC2BZsKRLjfjR81M1tNjI73mqDRuaeCkuQGO87fCh0ERpGYx
         zgBvNxC6/ZEP/NW55c63YDn67jljsWQmfqs5shoJh30x6hd3/CnqN/WXt2P5+tKR7S59
         QUnDQNmyn7/D7KNIPwcndGsmdltcUbPgt5KFKmsqpuCyj68jBP/gXmdoWBwfzXO3zx+X
         JlyHe9J+S6hEakpQc+CK98sAh1VlbAPtX0BHu2MRc07kDAxaqaJwpwKq08ub7cuR2wQ5
         O3rw==
X-Gm-Message-State: ANhLgQ3vKzaATJQtiCEK6V+tM4fG33yGzkSL9zv2zgHDiyd+hI4yUN0C
        UNRq5qeDX0LzgDdgXjUOjuQ=
X-Google-Smtp-Source: ADFU+vvWDjXwWK0Zp9lLjxOf+oXEQ3PysyhWzdP37Tw56JCzR7m0QQ4JnaUWuO2uGgMRpnhK6c3Llg==
X-Received: by 2002:a62:31c3:: with SMTP id x186mr2591142pfx.5.1584110655337;
        Fri, 13 Mar 2020 07:44:15 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:4927:51b8:6d1e:6c02? ([2601:647:4000:d7:4927:51b8:6d1e:6c02])
        by smtp.gmail.com with ESMTPSA id j5sm18458929pfe.32.2020.03.13.07.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 07:44:14 -0700 (PDT)
Subject: Re: [PATCH] qla2xxx: Fix I/Os being passed down when FC device is
 being deleted.
To:     "Ewan D. Milne" <emilne@redhat.com>,
        Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com
References: <20200313085001.3781-1-njavali@marvell.com>
 <6240fa5ec0069c7695ba763f371036e526efff77.camel@redhat.com>
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
Message-ID: <65771e71-f461-98b1-5cd6-9663bf607b07@acm.org>
Date:   Fri, 13 Mar 2020 07:44:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6240fa5ec0069c7695ba763f371036e526efff77.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-13 07:09, Ewan D. Milne wrote:
> On Fri, 2020-03-13 at 01:50 -0700, Nilesh Javali wrote:
>> From: Arun Easi <aeasi@marvell.com>
>>
>> I/Os could be passed down while the device FC SCSI device is being deleted.
>> This would result in unnecessary delay of I/O and driver messages (when
>> extended logging is set).
>>
>> Signed-off-by: Arun Easi <aeasi@marvell.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_os.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
>> index b520a98..7a94e11 100644
>> --- a/drivers/scsi/qla2xxx/qla_os.c
>> +++ b/drivers/scsi/qla2xxx/qla_os.c
>> @@ -864,7 +864,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>>  		goto qc24_fail_command;
>>  	}
>>  
>> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
>> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
>>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>>  			ql_dbg(ql_dbg_io, vha, 0x3005,
>> @@ -946,7 +946,7 @@ void qla2xxx_qpair_sp_compl(srb_t *sp, int res)
>>  		goto qc24_fail_command;
>>  	}
>>  
>> -	if (atomic_read(&fcport->state) != FCS_ONLINE) {
>> +	if (atomic_read(&fcport->state) != FCS_ONLINE || fcport->deleted) {
>>  		if (atomic_read(&fcport->state) == FCS_DEVICE_DEAD ||
>>  			atomic_read(&base_vha->loop_state) == LOOP_DEAD) {
>>  			ql_dbg(ql_dbg_io, vha, 0x3077,
> 
> This fixes an easily reproducible problem and should
> be considered for -stable.  It generally happens with
> extended driver logging enabled though.
> 
> Fixes: a8a12eb1920c ("scsi: qla2xxx: Remove defer flag to indicate immeadiate port loss")
> Reviewed-by: Ewan D. Milne <emilne@redhat.com>

Hi Ewan,

That commit ID does not exist. Did you perhaps want to refer to
3c75ad1d87c7 ("scsi: qla2xxx: Remove defer flag to indicate immeadiate
port loss") # v5.6-rc1?

Thanks,

Bart.
