Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7DFC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Apr 2022 06:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243548AbiDAG4L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Apr 2022 02:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241223AbiDAG4J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2022 02:56:09 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA6490FD2
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 23:54:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648796060; x=1680332060;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=aXmCylgBYh+WzN2lHnr1+QJLJhj1G49uR6RpYGjVltE=;
  b=FZTsb5ULmdwR537mhPFF9xGfoeaXsf1BsUpfxBa/U80A8J6UBDiSaRnh
   hnPz4Uxh6gbCBUpi/aUtsxRCQiDHCUdoSGKmFL/5Dif9kqgh9RY8gkK4y
   fZqsnLrdt5jKWxP4/gGlbFzpmuiwQpcYUuceS0yhELtGgm+evYLtbq7kq
   P98Ea1DJWrFT3gTnRUa1bDJt8TE/h5UPBsYi2KE4vTN/Uvi1buOcJ9Ygl
   FBXgBCBDazOehF6Q1T6aOaUZ721T3QEC7sYGJQR7UTlKuBDUv3lM5rBxS
   FlrtgkD5vw+IU1rkuHfC1bYgWVnmg8Hy8vsgRvbEg97jIYSjE4hxOriha
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10303"; a="259761054"
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="259761054"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:54:10 -0700
X-IronPort-AV: E=Sophos;i="5.90,226,1643702400"; 
   d="scan'208";a="567215813"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.63.177])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 23:54:03 -0700
Message-ID: <3b9c8411-b778-3eb3-ef7b-0fcef2863724@intel.com>
Date:   Fri, 1 Apr 2022 09:53:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [PATCH 25/29] scsi: ufs: Minimize #include directives
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
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Chanho Park <chanho61.park@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Can Guo <cang@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kiwoong Kim <kwmad.kim@samsung.com>
References: <20220331223424.1054715-1-bvanassche@acm.org>
 <20220331223424.1054715-26-bvanassche@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20220331223424.1054715-26-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 01/04/2022 1.34, Bart Van Assche wrote:
> Sort #include directives alphabetically.

I do not think we should start the "what is the correct order for includes" debate.
Can't we leave them alone.
