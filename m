Return-Path: <SRS0=Iijn=Y7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C1C2C43331
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7480421D7F
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Nov 2019 21:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725906AbfKGV0z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Nov 2019 16:26:55 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44062 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGV0y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2019 16:26:54 -0500
Received: by mail-pl1-f194.google.com with SMTP id az9so1639403plb.11
        for <linux-scsi@vger.kernel.org>; Thu, 07 Nov 2019 13:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uAcn44eV8touOXErcC7+99cxgpgjrFCO/hINUAiY3/s=;
        b=gfcGrImG+pMN796qq9ZawbS58GqYvr2HGyUsfLJ+D5ceUsAVsqwzqQB8x63hK/VD8+
         HBiR+qzi28Lxq7KWHdO6nu/ZtnzIF3HH4Ije3zyQsvpGxV6U0mOiXFNhku3Dl6QPhV6C
         3wGgpy+RGRQ4P0nv9xGk1NXZ4Y87cO3dJs+FXYTPIDtbi8QbguZJTNlrJ68Rp2Rbqovc
         K8J+G5fNSBnY7Tni19KuNDSDT007rdd6zc6zPK5hOz5GsW7f7zvwr83qYrPO/Pbe7TeJ
         uPS/MbiTGSa1sLIWRRCND7VxS9MC8PANp0ccEkweUQ1xzUiAyhU2/32B6F0L6WHDWLXl
         Um8g==
X-Gm-Message-State: APjAAAVQITsX4ZlKs6mCLe1lWnza7VyBLPecHjNOZbHnvx4eMnJggZkK
        fnb3ecwXWWBTja05n5WXvaRocbZT
X-Google-Smtp-Source: APXvYqwCzOYihJt1VFaE+9b5cQCIqO8jOXnr8DiU+j9s8dnKZzkG9nx/Lbu08Toj/Hqyo2C7zr+OfA==
X-Received: by 2002:a17:902:694a:: with SMTP id k10mr6328989plt.304.1573162012545;
        Thu, 07 Nov 2019 13:26:52 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id x2sm5356597pfj.90.2019.11.07.13.26.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Nov 2019 13:26:51 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: qla2xxx: don't use zero for FC4_PRIORITY_NVME
To:     Martin Wilck <Martin.Wilck@suse.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Michael Hernandez <mhernandez@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20191107164848.31837-1-martin.wilck@suse.com>
 <20191107164848.31837-2-martin.wilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4935afb4-a54f-5ebd-d9bd-bf4da70ba088@acm.org>
Date:   Thu, 7 Nov 2019 13:26:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191107164848.31837-2-martin.wilck@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/19 8:49 AM, Martin Wilck wrote:
> Avoid an uninitialized value being falsely treated as NVMe priority.

Although this patch looks fine to me: which uninitialized value are you 
referring to and how does this patch make a difference?

Thanks,

Bart.
