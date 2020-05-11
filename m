Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 889BEC54E4B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 19:22:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76E3720736
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 19:22:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731375AbgEKTWD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 15:22:03 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44265 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728613AbgEKTWC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 15:22:02 -0400
Received: by mail-pg1-f195.google.com with SMTP id b8so4984754pgi.11;
        Mon, 11 May 2020 12:22:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2N/AgLj1DBS9CiNbjnd0KAxdA/GYcDwBv6C5ujRtDa8=;
        b=twH3AUtbneF2/aTXIpoE0oZjH+/eckuAMvy6j6moPQIWCPHcExtoAO508+8oJE9J2e
         VldnQETjO3VYtfTpK/zktc6CaMvJzlvH6HJarCPEEFWuWNy6qB2QV84l4XQxq589ptln
         IC1nIg+gqpsjpWQ014a7cRKgx+hFxMFVZNGtlpyiUAfMmQ/gNhyUK8TUQTJfvCaSZret
         P5zaMTu6PNaUlSw4ly8BXTlDxhDWIKggbONsAL5EpKm2thPeNXjE3YMwyS+dF8ILnV5y
         aOTHvHapZziRrHmpsmXlN3mjlGY41ty2WAvJInZSppovAYGjQ95z/SmnNboThuhehxxO
         21Xw==
X-Gm-Message-State: AGi0PubpTYR+cTcvK+yDvMXlyVtAUKih+3dDe7uvlywIVlIibFR6xXRg
        LyTbJ27ZN6IeF/XrUMq1TdM=
X-Google-Smtp-Source: APiQypLz6yvLzSVHJu69acWxa4acjKpOdcjg0mqCLViJxxNurvYOxq1MREMYGn1xEHgSwtqaciUZzg==
X-Received: by 2002:a63:f54d:: with SMTP id e13mr17072575pgk.325.1589224921387;
        Mon, 11 May 2020 12:22:01 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:c4e5:b27b:830d:5d6e? ([2601:647:4000:d7:c4e5:b27b:830d:5d6e])
        by smtp.gmail.com with ESMTPSA id m7sm9852297pfb.48.2020.05.11.12.22.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 12:22:00 -0700 (PDT)
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        Mike Christie <mchristi@redhat.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
 <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
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
Message-ID: <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
Date:   Mon, 11 May 2020 12:21:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-05-11 11:39, Bodo Stroesser wrote:
> On 05/10/20 23:57, Mike Christie wrote:
>> This patch adds helpers to add/remove a dir per session. There is only 2
>> files/dirs initially.
>>
> 
> ...
> 
>> +
>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>> +                 struct se_session *se_sess)
>> +{
>> +    int ret;
>> +
>> +    /*
>> +     * Copy ACL name so we don't have to worry about mixing configfs
>> +     * and sysfs refcounts.
>> +     */
>> +    if (!se_sess->se_node_acl->dynamic_node_acl) {
>> +        se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
>> +                        GFP_KERNEL);
>> +        if (!se_sess->acl_name)
>> +            return -ENOMEM;
>> +    }
>> +
>> +    ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
>> +              se_sess->tpt_id->name, se_sess->sid);
>> +    if (ret) {
>> +        pr_err("Could not add session%d to sysfs. Error %d.\n",
>> +               se_sess->sid, ret);
>> +        goto free_acl_name;
>> +    }
>> +
>> +    ret = add_transport_id_attrs(se_sess);
>> +    if (ret)
>> +        goto del_kobj;
>> +
>> +    if (se_sess->tfo->session_attrs) {
>> +        ret = sysfs_create_group(&se_sess->kobj,
>> +                     se_sess->tfo->session_attrs);
>> +        if (ret)
>> +            goto rm_tpt_id_grps;
>> +    }
>> +
>> +    ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
>> +                se_sess->kobj.name);
> 
> I would prefer to have links named "session-%d" or "%d" only, of course
> with se_sess->sid as the value for '%d'.

Isn't se_sess->sid a property that is filled in by the iSCSI target
driver only? Is se_sess->sid zero for all other target drivers than the
iSCSI target driver?

> If userspace knows the session-id only, such names make it easier to
> find the corresponding link.

Personally I prefer the %s-%d naming scheme. I think that naming scheme
has the following advantages:
1. No need to run cat ... to retrieve the initiator name.
2. It becomes possible to derive from the 'ls' output which initiators
created multiple sessions.
3. All sessions created by the same initiator appear consecutively.

Thanks,

Bart.
