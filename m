Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE26C4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 13:40:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A94361213
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 13:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238726AbhJDNmR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 09:42:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:6485 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238494AbhJDNke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 4 Oct 2021 09:40:34 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10126"; a="206236058"
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="206236058"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2021 06:27:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,345,1624345200"; 
   d="scan'208";a="711216451"
Received: from ahunter-desktop.fi.intel.com (HELO [10.237.72.76]) ([10.237.72.76])
  by fmsmga006.fm.intel.com with ESMTP; 04 Oct 2021 06:27:51 -0700
Subject: Re: [PATCH RFC 0/6] scsi: ufs: Start to make driver synchronization
 easier to understand
To:     Avri Altman <Avri.Altman@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <huobean@gmail.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211004120650.153218-1-adrian.hunter@intel.com>
 <DM6PR04MB6575172F68B25EA1E4A258F1FCAE9@DM6PR04MB6575.namprd04.prod.outlook.com>
From:   Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Message-ID: <6a352069-d4bc-9dac-1830-3a1217f6dce9@intel.com>
Date:   Mon, 4 Oct 2021 16:27:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <DM6PR04MB6575172F68B25EA1E4A258F1FCAE9@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/10/2021 15:42, Avri Altman wrote:
>  
>> Driver synchronization would be easier to understand if we used the
>> clk_scaling_lock as the only lock to provide either shared (down/up_read)
>> or exclusive (down/up_write) access to the host.
>>
>> These patches make changes with that in mind, finally resulting in being
>> able to hold the down_write() lock for the entire error handler duration.
>>
>> If this approach is acceptable, it could be extended to simplify the
>> the synchronization of PM vs error handler and Shutdown vs sysfs.
> Given that UFSHCD_CAP_CLK_SCALING is only set for ufs-qcom:
> If extending its use, wouldn't that become a source of contention for them?

It is a good question. The error handler already seems to stop clock scaling.
PM / Shutdown seem to suspend / resume clock scaling. So it doesn't *look*
like it should make much difference.
