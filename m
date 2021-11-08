Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F079DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:26:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBB8261029
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Nov 2021 18:26:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhKHS3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 13:29:39 -0500
Received: from mail-pf1-f170.google.com ([209.85.210.170]:33376 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbhKHS3j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 13:29:39 -0500
Received: by mail-pf1-f170.google.com with SMTP id c126so8410390pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Nov 2021 10:26:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CxH87AxeY9lKWo5PzT/bziVGyijLBBB9I267ZQcLj04=;
        b=NX7gPffkieaZgdZKO3fD5cNjjGLNeC3sgqaT2AhZ7OT7RI4OOC/5mFN8luixtZOP3I
         Gf++jYaszG1fm+Li6gfIU1mga8Rb/c0pQpAcMHdUftGwnXnRXUcT5U6ivxR0xFyqNuae
         e+PTowJBEeoUKd00uQUR9mMafe7O6fHNvJdexFwERydI7//uqYzndJEJaGaqSo7MAOx3
         Sf8WhtjlobWMb9Em9e7TtLp81n3Y8HTpZ1uRFycDrUW7nqaMebG9XtP4BN41wqC8UnLP
         FEzfieCXq+g3SEfuKqVZm9q+66GPHDhHOO00AK+2KFf+q7N854aogm0x2xZ/6eVXNM8e
         5yjA==
X-Gm-Message-State: AOAM532pm7eWgQhN3eH2LvbtWwkKi8Pd6wyyZnksS22oMcwEiOdryz+f
        ysXaMcUARhdptmP+XU+SCow=
X-Google-Smtp-Source: ABdhPJz2F/IFGQHhCuLdJJTBdLSsoBodjiWIFrQF3P038tYUfM0mtFTeLum+B0W/IK2THHy7AlpHYg==
X-Received: by 2002:a63:f70a:: with SMTP id x10mr1123375pgh.12.1636396014241;
        Mon, 08 Nov 2021 10:26:54 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4ca8:59a2:ad3c:1580])
        by smtp.gmail.com with ESMTPSA id 17sm16830534pfp.14.2021.11.08.10.26.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Nov 2021 10:26:53 -0800 (PST)
Subject: Re: [PATCH 2/2] scsi: ufs: Fix a deadlock in the error handler
To:     Avri Altman <Avri.Altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211103000529.1549411-1-bvanassche@acm.org>
 <20211103000529.1549411-3-bvanassche@acm.org>
 <82dffddc-15e8-dc1a-abda-e84e7e441d87@intel.com>
 <DM6PR04MB6575BC6BCE4A6BFBB0E3F519FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <91e73a18-0487-d9e9-920e-5d3477410b69@acm.org>
Date:   Mon, 8 Nov 2021 10:26:52 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575BC6BCE4A6BFBB0E3F519FC909@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/7/21 3:07 AM, Avri Altman wrote:
> Instead of the reserved tag mechanism, since we are in reset-and-restore path,
> how about forcing one slot out if the doorbell is full?

That would result in significantly more complex code. I prefer the 
reserved tag approach since it results in elegant code and since this 
approach does not affect performance significantly.

Thanks,

Bart.
