Return-Path: <SRS0=VYtg=2Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65DF4C2D0DA
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D1220838
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Dec 2019 17:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfLZRXk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Dec 2019 12:23:40 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42015 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfLZRXk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Dec 2019 12:23:40 -0500
Received: by mail-pf1-f196.google.com with SMTP id 4so13445844pfz.9
        for <linux-scsi@vger.kernel.org>; Thu, 26 Dec 2019 09:23:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jVU6qO7Ws6mT15yhInH/d9GNw/xOPtxEnxXJ/qCTvk=;
        b=YYy6o5Sx+XcWwxoWc0kLV3J6TrvmeZm+MAvkVVnjNYTaLXLE65wEtaOPXfVoCVNUSr
         cNMUJu+YhUu3Y4LMh50M7KmjMFtfM1PCnLdAYrtR/cCND4cjbfTYfOFNvy19vrYNXsw6
         5eumrbnIsxQ9VMmtX/JLG3HO14xMxRJNGf5CNKjq5TlXq5mIF8QxEtTZ0XBIb1mcY4oI
         HOf7cP2b3OrYYlhuPH/SxM++KuS6sxjEJQvkmthNNeZNIZD9u2j5zWWI/34UyyCmuj+I
         7GWfsyDB0RHaiQYHvTvVmmB8GzMTejYmjhT/QVjstVNV1QBHjYdhvi6M+wuoU4TX1lSL
         3WyA==
X-Gm-Message-State: APjAAAUIjElHlSmD1Mc0QMO07Fu2JPpiTbtpMEjOhdYOu9PlxDQosd1+
        B+UU3sJGgLJsCdWPEWKMqnk=
X-Google-Smtp-Source: APXvYqx8qjXhnbzz9Xg+H2p7otOHKf9ttI6LylIX+NI4gGsRzu3ruSpzOeRJEe7hVx9U96QuL/5KQA==
X-Received: by 2002:a63:303:: with SMTP id 3mr49605893pgd.372.1577381019904;
        Thu, 26 Dec 2019 09:23:39 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id w38sm35401289pgk.45.2019.12.26.09.23.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2019 09:23:38 -0800 (PST)
Subject: Re: [PATCH] qla2xxx: Fix the code that reads from mailbox registers
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>,
        Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20191220183357.16655-1-bvanassche@acm.org>
 <201912252157.xVgr2QmT%lkp@intel.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <02a2099f-638f-06ac-acdc-4f7fa731526a@acm.org>
Date:   Thu, 26 Dec 2019 09:23:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <201912252157.xVgr2QmT%lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/25/19 5:29 AM, kbuild test robot wrote:
> sparse warnings: (new ones prefixed by >>)
> 
>>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse: sparse: incorrect type in argument 1 (different base types)
>>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    expected restricted __le32 const volatile [noderef] [usertype] <asn:2> *addr
>>> drivers/scsi/qla2xxx/qla_os.c:1203:40: sparse:    got unsigned int [noderef] <asn:2> *

Please ignore these warnings for now because these do not indicate a 
shortcoming in the posted patch but are the result of making 
RD_REG_BYTE() etc. verify the endianness of the pointers passed to these 
functions. The patches to fix these new endianness warnings are ready 
and I plan to post these soon.

Bart.
