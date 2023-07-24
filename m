Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A16AC001DF
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Jul 2023 17:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjGXRgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Jul 2023 13:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231442AbjGXRgC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2023 13:36:02 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C26BD1704
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2023 10:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690220161; x=1721756161;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6m42UxSHP9u2bRvT26dtdxwCuPfOw+rtrJhPd9Xhoa0=;
  b=bgN1HV6Gz9bC3iORBBdFZWauHLlXHYaHZCC9Cvko/Gu3fBLwPQ/HwzaP
   c4OTTRayfDZZbNe+8hRLbxoS17pPp7xDFZ/VXGSeO/il0FBCHPkKgYI59
   1VJGSinKK+x4b7Vr+ts1qx56AnFPB/3WGcnKqX3M3C6NsLIbQFGDbuUPI
   Ry4ISyxNNrRuD6z/FLQBdCDFs6OquZ6A55UEDNifnOws9v2cN4e0lJ7Ic
   I6eo2A38hE9lhs4X80vKi1Hb05JXWNhqV8WsHFCoBFP2CHaF/tROd4FTa
   zBux3qoPveOn+3UoWm7Q9E/XafXifF8BZoBBOS3bmGAhlETFKuVNN0fx5
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="364967450"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="364967450"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 10:35:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10781"; a="725796789"
X-IronPort-AV: E=Sophos;i="6.01,228,1684825200"; 
   d="scan'208";a="725796789"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.252.33.18])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2023 10:35:52 -0700
Message-ID: <b59cfe00-e385-04b1-3158-b0bacf7afe39@intel.com>
Date:   Mon, 24 Jul 2023 20:35:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH 2/3] scsi: ufs: Fix residual handling
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <quic_cang@quicinc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Bean Huo <beanhuo@micron.com>,
        Arthur Simchaev <Arthur.Simchaev@wdc.com>,
        Manivannan Sadhasivam <mani@kernel.org>
References: <20230721160154.874010-1-bvanassche@acm.org>
 <20230721160154.874010-3-bvanassche@acm.org>
 <DM6PR04MB6575C3A5197457FAE3F6C438FC3DA@DM6PR04MB6575.namprd04.prod.outlook.com>
 <98ef41e0-6805-dd81-a25e-55395c2475eb@acm.org>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <98ef41e0-6805-dd81-a25e-55395c2475eb@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/07/23 19:02, Bart Van Assche wrote:
> On 7/22/23 22:31, Avri Altman wrote:
>>>
>>> +       WARN_ON_ONCE(overflow && underflow);
>>> +       WARN_ON_ONCE(!overflow && !underflow && resid);
>> Do we really need to debug the hw? - see Table 10.16 (3.1 spec).
> 
> I was wondering about this too while writing this patch. If nobody objects I
> will leave the above two WARN_ON_ONCE() statements out when reposting this patch.

I agree.  Please do leave them out.

