Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DA0DC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 06:40:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343607AbiDAGmB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343516AbiDAGlw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 02:41:52 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8898E1959C7
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 23:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648795106; x=1680331106;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sBVGSwYGpPqUZX6NgXCmjBmaMoMEoju8k2821wQdjgc=;
  b=UdR2l9Ka3N0awZbMCbhVKqC4GLT4UUw06B8YZ4bbwB56iREIQxgFV0l/
   JnaErfBx15rx7UXzFSQOJRaVXATnd0ZX9BHeQ2j9F8nU2PWXGcMegjzOp
   hpAYyFOUbsMV7LXFOa+g5WoiKbbLB0Xql9ot5hf6l3EZPuw2e/OuhxKry
   nUwePYw5cA1oYpPJpMcRrYoZeykO4AVGzFU5ClDYW8PnPF9eekow52dc2
   Sx4kxfhUOeae91X5qgEYG8wFHuyXzm1MuhZoXAXvNk/HxoWVrm5T9fyPy
   4u7RXwpJugk+AHUQtscsJ5S3YqrWbdB5Msob1LEIgSN/cMTFlwAILQDzk
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="260042270"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="260042270"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:38:21 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="567204395"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.63.177])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:38:12 -0700
Message-ID: <c4b47162-1f98-c03b-d041-dc7ac8bd9ae2@intel.com>
Date:   Fri, 1 Apr 2022 09:38:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bean Huo <beanhuo@micron.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Daejun Park <daejun7.park@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Eric Biggers <ebiggers@google.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mike Snitzer <snitzer@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Peter Wang <peter.wang@mediatek.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ye Bin <yebin10@huawei.com>,
        ChanWoo Lee <cw9316.lee@samsung.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Jinyoung Choi <j-young.choi@samsung.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-30-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220331223424.1054715-30-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/04/2022 1.34, Bart Van Assche wrote:
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---

Commit message?

In particular drivers/ufs/core and drivers/ufs/host would seem a
more typical arrangement.

