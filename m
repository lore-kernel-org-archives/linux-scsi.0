Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B78CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66E11603E5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Oct 2021 20:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234913AbhJLUlT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Oct 2021 16:41:19 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:37384 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbhJLUlK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Oct 2021 16:41:10 -0400
Received: by mail-pf1-f171.google.com with SMTP id q19so548437pfl.4
        for <linux-scsi@vger.kernel.org>; Tue, 12 Oct 2021 13:39:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHSOnFFCcKtMxkmaw0QgeFwJS/pj2VDRMPtDHFHnnnE=;
        b=KignrvTGTOne6TyPjA3WXnZP/6271bM2GSupDjSm0uflrRixb21Gvxjjdppwx57UoF
         +2bQBYsYi/AVT4YURGJ4PdIoB0iqBwvUkfaIbykd7MNY9ehsl5kmF72SlrqRiGpUwPjp
         C6np+MHWMUJFnzUaErrZjHpDuCWFSMss8eQmQWehl5609yqZK+Vl/y+29zFEz3ceyy3l
         bsx0cOP3Y2BDx9pxakOjacOH8g+TRrCJSj7RKqtmWSAHdRlUNxj/IPG485Mx0J6X/baD
         qlE8CsUerE+t0gP25wGVBuRT9tu/V2TkY2fz9gfRylVsy5HlJkvt3Hfu3wLpe5yyhFdY
         2P3w==
X-Gm-Message-State: AOAM532MpRbRrXp9OztynnVA6KeFsBc4cjfpGyTfexSsxqe9MaNtbOA+
        xXEndMfN4F0bN70SppCpUDw=
X-Google-Smtp-Source: ABdhPJzzBZNwMSMw8mjwuIfnMozUrrerJolVILM8LxQdiM+6AGRO6Tr+OKM+Mg7lR4u6QXL/UdKlug==
X-Received: by 2002:a63:1b23:: with SMTP id b35mr24354636pgb.262.1634071148334;
        Tue, 12 Oct 2021 13:39:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8c1a:acb2:4eff:5d13])
        by smtp.gmail.com with ESMTPSA id s2sm11607302pfe.215.2021.10.12.13.39.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Oct 2021 13:39:07 -0700 (PDT)
Subject: Re: [PATCH v3 06/46] scsi: zfcp: Switch to attribute groups
To:     Benjamin Block <bblock@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-7-bvanassche@acm.org>
 <YWQ7g3tpmPBVO0dc@t480-pf1aa2c2.linux.ibm.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fe3297b2-0f6d-8a24-fa03-c799aa676da6@acm.org>
Date:   Tue, 12 Oct 2021 13:39:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YWQ7g3tpmPBVO0dc@t480-pf1aa2c2.linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/11/21 6:26 AM, Benjamin Block wrote:
> On Fri, Oct 08, 2021 at 01:23:13PM -0700, Bart Van Assche wrote:
>> -extern struct device_attribute *zfcp_sysfs_sdev_attrs[];
>> -extern struct device_attribute *zfcp_sysfs_shost_attrs[];
>> +extern const struct attribute_group *zfcp_sdev_attr_groups[];
>> +extern const struct attribute_group *zfcp_shost_attr_groups[];
> 
> I'd prefer it, if you leave the `zfcp_sysfs_` intact; while not
> universally used in the whole driver, its a convention we've been trying
> to follow regarding the symbols declared by the driver in the recent
> time (`zfcp_sysfs.o` is the compilation unit).

Hi Benjamin,

I will restore these prefixes and post a fourth version of this patch 
series.

Thanks,

Bart.
