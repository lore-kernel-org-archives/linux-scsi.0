Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48165C07E95
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:50:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28FC6613EE
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 16:50:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhGPQxH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 12:53:07 -0400
Received: from mail-pf1-f182.google.com ([209.85.210.182]:35708 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhGPQxH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 12:53:07 -0400
Received: by mail-pf1-f182.google.com with SMTP id d12so9403568pfj.2
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 09:50:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xOcQYRV+/5uCP0h3K0dmMGb7R6QsryGLSIBnKNu6ZDE=;
        b=CUVimIrT2zww7kBvS2+uniSIWDsq/AFwR3PEh/mv74hI03UO3nRC2dFz9yQN1TzJt/
         in+o7EI7E49Xsj8JhOzCFb16tutgdVn78R34TdLjnotta0Y0pKOxBczol6G5/eP5SlLM
         X/gecSKsQ8EDeZlV88CTFyisl3NULhAetLYjhvsbeJBSZKqvttXlCD9nVLoWJXr3mOjm
         4mq86JEXzz5M+CGhasvO0MQWb+IAJLYXg1XGWt9/BHz11wNofEBgbFFfooCagM4jVAc2
         VkzpihH68//lUknfF3qjyvYN9aNJd2O1TOMCXKZHwUFnj50wk2jtjgJ8pKCgdKjWN44i
         JIiw==
X-Gm-Message-State: AOAM530UysdJV92/S9jGvytrIS7qnMBUdrtPw9r+bvry0E1jmahu7lrr
        0cY4NL9ZJW2OnYtjbzVfaIs=
X-Google-Smtp-Source: ABdhPJwl9ymnwf84BNGpyYN/z8f2NBGbG0A+IyXYQCujD55G1SA2QS8tZ4jHSjhgqlAoTSCTkO8dcQ==
X-Received: by 2002:a65:67d6:: with SMTP id b22mr10951193pgs.271.1626454210750;
        Fri, 16 Jul 2021 09:50:10 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:ad12:9dbc:6e29:6c02? ([2620:0:1000:2004:ad12:9dbc:6e29:6c02])
        by smtp.gmail.com with ESMTPSA id o10sm11024675pfu.131.2021.07.16.09.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 09:50:09 -0700 (PDT)
Subject: Re: [PATCH v2 13/19] scsi: ufs: Fix a race in the completion path
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
References: <20210709202638.9480-1-bvanassche@acm.org>
 <20210709202638.9480-15-bvanassche@acm.org>
 <DM6PR04MB65750B644072145010B7D952FC169@DM6PR04MB6575.namprd04.prod.outlook.com>
 <fe3076c3-f835-b7e4-c5be-4ba55d5e0e41@acm.org>
 <1b35777f-bea2-9443-0bac-c42b37acf8b3@acm.org>
 <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <979d677d-dde2-ec08-831b-0907d2f57b71@acm.org>
Date:   Fri, 16 Jul 2021 09:50:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB65759F6FCD2293AC9FED6C9CFC119@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/16/21 5:39 AM, Avri Altman wrote:
> But does your platform make use of REG_UTP_TRANSFER_REQ_LIST_COMPL?
> With 60k IOPS I suspect it doesn't, and the comparison is irrelevant.

Yes, my test setup supports the UTRLCNR register (let's use the acronyms 
from the UFS specification). However, it is not clear to me why that 
register has been introduced? Using that register in the completion path 
requires one register read + one register write while using the doorbell 
register in the completion path involves a single register read. My 
understanding is that register reads and writes are much slower than 
DRAM reads or writes. Does this mean that using the doorbell register in 
the compleiton path is always faster than using the UTRLCNR register?

Thanks,

Bart.
