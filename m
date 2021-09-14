Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B92C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 16:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3920B60FD7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Sep 2021 16:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbhINQaq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 12:30:46 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:39446 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhINQaq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Sep 2021 12:30:46 -0400
Received: by mail-pj1-f46.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso2592753pji.4;
        Tue, 14 Sep 2021 09:29:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QjlesuhvlVz3gLSCmOj89/oPsKe96hh19xGjilZitls=;
        b=VrdgJxygPaZ3FDxy/+JdRX4Rro5iK7NIQu7hYafGgukCQA5xVo9QxI/n9QWnx5cfBv
         99wWC5sgyA6GLXMo8kXPIYaUWsE3X6Q7JvB18kUIOCQ42ml9WEKYQEfThJkK5aWFzaf7
         MVOxm9cRnEKdDyJGQHxu0sDOrVA0E/tDLzJB3XOiLUGCU/CKgOe1sn5mt0LaA7RqAi81
         aN+BhpobJD/mcRAK3n9YZ3ltS8VvqEMOTU0zS+OL6G6QRKeNWx1KI6+Kzh34AYenA+o+
         UNGCbcEB+yj4kFehvBLHe++3LvyDawkNNixwSIAfuPjSHvcgeh9Plngk6q37QoW6nbDK
         2RQQ==
X-Gm-Message-State: AOAM5319pxC2QPvlUnM+JtCNZ2ZL+Jj8hubVEYDJ8kyTWFSEroNGz09+
        dI4V50m9yFGw5F5AOfjOunY=
X-Google-Smtp-Source: ABdhPJyVS1KigviNZIGrcJmwfjd8slneezNv+QT52hJiarjEYForltgHvFQ4xnLenZ5wN+bCXZ3iGg==
X-Received: by 2002:a17:90a:9cd:: with SMTP id 71mr3046937pjo.62.1631636968579;
        Tue, 14 Sep 2021 09:29:28 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:c71d:6cb8:8fe5:9909])
        by smtp.gmail.com with ESMTPSA id c4sm12076092pga.4.2021.09.14.09.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 09:29:27 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] scsi: ufs: introduce vendor isr
To:     Avri Altman <Avri.Altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "sc.suh@samsung.com" <sc.suh@samsung.com>,
        "hy50.seo@samsung.com" <hy50.seo@samsung.com>,
        "sh425.lee@samsung.com" <sh425.lee@samsung.com>,
        "bhoon95.kim@samsung.com" <bhoon95.kim@samsung.com>
References: <cover.1631519695.git.kwmad.kim@samsung.com>
 <CGME20210913081150epcas2p11f98eed5939bf082981e2a4d6fd9a059@epcas2p1.samsung.com>
 <6801341a6c4d533597050eb1aaa5bf18214fc47f.1631519695.git.kwmad.kim@samsung.com>
 <c6b2007b-155b-18b2-e45d-06f600c98797@acm.org>
 <DM6PR04MB6575324A3F4E2C040BB46864FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9bb610ec-affb-819a-6f3a-98d74db72132@acm.org>
Date:   Tue, 14 Sep 2021 09:29:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575324A3F4E2C040BB46864FCDA9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/14/21 4:53 AM, Avri Altman wrote:
>> Since "static inline irqreturn_t ufshcd_vendor_isr_def(struct ufs_hba
>> *hba)" occupies less than 80 columns please use a single line for the
>> declaration of this function.
>
> btw, It is 100 now.

Are you sure? In Documentation/process/coding-style.rst I found the following:

     The preferred limit on the length of a single line is 80 columns.

 From the commit message of bdc48fa11e46 ("checkpatch/coding-style: deprecate
80-column warning"):

     Yes, staying withing 80 columns is certainly still _preferred_.  But
     it's not the hard limit that the checkpatch warnings imply, and other
     concerns can most certainly dominate.

     Increase the default limit to 100 characters.  Not because 100
     characters is some hard limit either, but that's certainly a "what are
     you doing" kind of value and less likely to be about the occasional
     slightly longer lines.

Bart.
