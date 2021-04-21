Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA44C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A0CA613FB
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 22:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbhDUWzw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 18:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbhDUWzw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 18:55:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E8EC06174A;
        Wed, 21 Apr 2021 15:55:17 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id d10so31365560pgf.12;
        Wed, 21 Apr 2021 15:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h6FBT/lUZI4K31IEb2wPoiktbI4AIGFwSE4EAX16/8M=;
        b=Ucqy5dnLf6Of5yarLmOQr/o7UC4d6NdWgcL4DsTGz7qjyqS+fuHjyGlYtJCHyFUDZq
         6bI3bETCcIshg31bKpaw5s12FbYcXbLjW5UQlCDh4wgnVhnWFk8YMvJD4vl1XlOj1LCF
         mx3wM2UOqNRO99Qi43tz68JkdRAn/aDBvP13SGHm299THoS1alfWd3CWcw841gvgTRzJ
         HfetbCbxx7lfqeOi/7UNOV+M/fGwyDberDdCNvM8bMNN9j+aIn5nRhbArFNogvRLG/eT
         CqaFmfXQayv2qDg0pM46Cn3LzSewgxOEUpSH8UojGW8JNEK5BsmHNepEoGQD31HriB91
         C3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h6FBT/lUZI4K31IEb2wPoiktbI4AIGFwSE4EAX16/8M=;
        b=QyE8u31MR6XEOpJ9dYJY0cmDurCZUd07fY1gByEPzXAEGPvAsH3/1b+0GqzuQUFZXD
         HnpSH4t2fMjRhBAOebPDHrAZWI9ihpVHvsAMOWW34GqISMhWj7A/VxWcA3H7Jh2AgyPp
         gM/yW4Cn605r8BBKOOySPyvQcJQ3b1Er3qkBc3rZTWa+qtFhYkH5nA3tXS/SAHt8jLL6
         iLAsdozddTA1f12Iqz/Rsm53h6QmN31xNTOHaU40JQJzHLo2rGO9eYSduGhKZ5Fcp4eQ
         EIkRV1K8XqDF06Y2CcfC4JR8mbxEjhPveuHngOoXsKSgqon0OC7tNzc4NW+DkBxSOvK7
         X/rw==
X-Gm-Message-State: AOAM530JrPjaeMzeYOSliQMZQMtXjvFk8BnoYuUjs6VmQWY13xd6ZOqo
        RRku7Jdw2h8CkI1L5R/8Eew=
X-Google-Smtp-Source: ABdhPJy31+pmr7w0dBrNomOAjC/MaYqz6PPUglrDMOHTTwAvWqLPYHDl4isJE0ISnGDTtEF19VkQTA==
X-Received: by 2002:a17:90a:2c0f:: with SMTP id m15mr13706243pjd.83.1619045716770;
        Wed, 21 Apr 2021 15:55:16 -0700 (PDT)
Received: from [10.230.185.151] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m188sm346881pga.23.2021.04.21.15.55.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 15:55:16 -0700 (PDT)
Subject: Re: [PATCH v9 07/13] lpfc: vmid: Implements ELS commands for appid
 patch
To:     Benjamin Block <bblock@linux.ibm.com>,
        Muneendra <muneendra.kumar@broadcom.com>, hare@suse.de
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org, emilne@redhat.com,
        mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-8-git-send-email-muneendra.kumar@broadcom.com>
 <YH7LPd8c4PZa1qFC@t480-pf1aa2c2.linux.ibm.com>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <d9d57857-83f5-9ff7-a427-0817d37f5f84@gmail.com>
Date:   Wed, 21 Apr 2021 15:55:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YH7LPd8c4PZa1qFC@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/20/2021 5:38 AM, Benjamin Block wrote:
...
>> +	len = *((u32 *)(pcmd + 4));
>> +	len = be32_to_cpu(len);
>> +	memcpy(vport->qfpa_res, pcmd, len + 8);
>> +	len = len / LPFC_PRIORITY_RANGE_DESC_SIZE;
>> +
>> +	desc = (struct priority_range_desc *)(pcmd + 8);
>> +	vmid_range = vport->vmid_priority.vmid_range;
>> +	if (!vmid_range) {
>> +		vmid_range = kcalloc(MAX_PRIORITY_DESC, sizeof(*vmid_range),
>> +				     GFP_KERNEL);
>> +		if (!vmid_range) {
>> +			kfree(vport->qfpa_res);
>> +			goto out;
>> +		}
>> +		vport->vmid_priority.vmid_range = vmid_range;
>> +	}
>> +	vport->vmid_priority.num_descriptors = len;
>> +
>> +	for (i = 0; i < len; i++, vmid_range++, desc++) {
>> +		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_ELS,
>> +				 "6539 vmid values low=%d, high=%d, qos=%d, "
>> +				 "local ve id=%d\n", desc->lo_range,
>> +				 desc->hi_range, desc->qos_priority,
>> +				 desc->local_ve_id);
>> +
>> +		vmid_range->low = desc->lo_range << 1;
>> +		if (desc->local_ve_id == QFPA_ODD_ONLY)
>> +			vmid_range->low++;
>> +		if (desc->qos_priority)
>> +			vport->vmid_flag |= LPFC_VMID_QOS_ENABLED;
>> +		vmid_range->qos = desc->qos_priority;
> 
> I'm curios, if the FC-switch signals it supports QoS for a range here, how
> exactly interacts this with the VM IDs that you seem to allocate
> dynamically during runtime for cgroups that request specific App IDs?
> You don't seem to use `LPFC_VMID_QOS_ENABLED` anywhere else in the
> series. >
> Would different cgroups get different QoS classes/guarantees depending
> on the selected VM ID (higher VM ID gets better QoS class, or something
> like that?)? Would the tagged traffic be handled differently than the
> ordinary traffic in the fabric?

The simple answer is there is no interaction w/ the cgroup on priority.
And no- we really don't look or use it.  The ranges don't really have 
hard priority values. The way it works is that all values within a range 
is equal; a value in the first range is "higher priority" than a value 
in the second range; and a value in the second range is higher than 
those in the third range, and so on. Doesn't really matter whether the 
range was marked Best Effort or H/M/L. There's no real "weight".

What you see is the driver simply recording the different ranges so that 
it knows what to allocate from later on. The driver creates a flat 
bitmap of all possible values (max of 255) from all ranges - then will 
allocate values on a first bit set basis.  I know at one point we were 
going to only auto-assign if there was 1 range, and if multiple range 
was going to defer a mgmt authority to tell us which range, but this 
obviously doesn't do that.

Also... although this is coded to support the full breadth of what the 
standard allows, it may well be the switch only implements 1 range in 
practice.

> 
> I tried to get something from FC-LS (-5) or FC-FS (-6), but they are extremely
> sparse somehow. FC-LS-5 just says "QoS priority provided" for the
> field.. and FC-FS doesn't say anything regarding QoS if the tagging
> extension in CS_CTL is used.

Yes - most of the discussion on how this form of VMID is used/performed 
was given in the T11 proposals, but as most of that is informational and 
non-normative, very little ends up getting into the spec.

FC-LS-5 section 9 "Priority Tagging" is what you want to look at.

The other form of VMID is the Application Tag (up to 32bits) which is 
described in FC-GS-8 section 6.9 Application Server.  Both forms map a 
value to a uuid and the switch may apply some QoS level to the value 
when it sees it.

The priority tagging method seems to tie in more to qos, but the 
application tag is can equally be done although any qos aspects are 
solely in the switch and not exported to the driver/host.

-- james
