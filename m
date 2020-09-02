Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6C7C433E7
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 09:28:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7317E2072A
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 09:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgIBJ2K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:28:10 -0400
Received: from mga03.intel.com ([134.134.136.65]:29045 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgIBJ2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 05:28:10 -0400
IronPort-SDR: IGaoofaOCszIrAuqNFsQINaqArFCKV958pWyWmAkrk/alYSpUuawG4aNBDwje61pB/+OCd7NDH
 8onUK8KQDMWw==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="157358867"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="157358867"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 02:28:04 -0700
IronPort-SDR: ZjOyCf8L1o3UKofFPyqqcqzz4hgmZuuvLS8kECsM066KHnnFFTKEm2pxywaWzq2OEqdvtrc3Gs
 oZd4kRBuzGuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="297617334"
Received: from slisovsk-lenovo-ideapad-720s-13ikb.fi.intel.com (HELO [10.237.72.190]) ([10.237.72.190])
  by orsmga003.jf.intel.com with ESMTP; 02 Sep 2020 02:28:03 -0700
Subject: Re: [PATCH V2] scsi: ufs-pci: Add LTR support for Intel controllers
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
References: <20200827072030.24655-1-adrian.hunter@intel.com>
 <yq14kohexka.fsf@ca-mkp.ca.oracle.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <dc615e02-18a3-334d-dbc4-8aba94e4be6b@intel.com>
Date:   Wed, 2 Sep 2020 12:27:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <yq14kohexka.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/09/20 5:12 am, Martin K. Petersen wrote:
> 
> Adrian,
> 
>> Intel host controllers support the setting of latency tolerance.
>> Accordingly, implement the PM QoS ->set_latency_tolerance() callback. The
>> raw register values are also exposed via debugfs.
> 
> Does not apply to 5.10/scsi-queue. Please rebase. Thanks!
> 

Hi

Thanks for processing this.

The 5.10/scsi-queue branch seems to be missing the following fix.  If you cherry
pick that, then it applies.


                                                                                                                                                                                                                                                                                          
commit 8da76f71fef7d8a1a72af09d48899573feb60065                                                                                                                                                                                                                                                                                                                                     
Author: Adrian Hunter <adrian.hunter@intel.com>                                                                                                                                                                                                                                                                                                                                     
Date:   Mon Aug 10 17:10:24 2020 +0300                                                                                                                                                                                                                                                                                                                                              
                                                                                                                                                                                                                                                                                                                                                                                    
    scsi: ufs-pci: Add quirk for broken auto-hibernate for Intel EHL                                                                                                                                                                                                                                                                                                                
                                                                                                                                                                                                                                                                                                                                                                                    
    Intel EHL UFS host controller advertises auto-hibernate capability but it
    does not work correctly. Add a quirk for that.
    
    [mkp: checkpatch fix]
    
    Link: https://lore.kernel.org/r/20200810141024.28859-1-adrian.hunter@intel.com
    Fixes: 8c09d7527697 ("scsi: ufshdc-pci: Add Intel PCI IDs for EHL")
    Acked-by: Stanley Chu <stanley.chu@mediatek.com>
    Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
    Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

