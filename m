Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2702C4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 00:27:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbiLIA1K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbiLIA1I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 19:27:08 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2BF9419D
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 16:27:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670545627; x=1702081627;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AuQCh/BiWNHtbzuTuOHbLElpQWq33rR9I5R3b/e1FRM=;
  b=GBIdj/s5RvSaqam7LjQdQAinhyLT7YEDrhSCNjBCMmv9r9odd8O++wch
   86MyqVYPDKORviQsmtiHra7wDbHZbYLhmNL2agerQ6zPRs8h5ieYf1DcC
   o0LBG8Ytu8Q01bA+I4/i4hu0OrJp+Px/En8ojiTwgvA5KeydI3l0F1YMW
   nkYsF6SnYweIxanvDzCUIc6GGVx7hSoKfJ+mrKIbS7QEWcGmHntSIApV5
   ZOTbI25uQ3K9urcmyRJCZPpRbY37+CVVKtAQeJERM4aArIu3kcIQHZgF6
   tKDfZbJ8LWV37I8tFt1l7m+k0o5INLT4xrrBVC0YkcoRxDDYHXF/5krmc
   w==;
X-IronPort-AV: E=Sophos;i="5.96,228,1665417600"; 
   d="scan'208";a="223387908"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Dec 2022 08:27:07 +0800
IronPort-SDR: 1CHjTcb4Ss6x+8h2awqAU2RPyDPQfhn1zEnzRUVRm7vcUcmzmNHOdher79jMIy8lG5QfBnKwzG
 eKLUPKZthxeQwszOzO8e3JeGaINjdyEBB7w/4HGbm6O8wbjevWdPabgKK7uvChPSmZpWhGmVtY
 UQVwR5UCPu6LMlTb8eFEInvsuAF/nOeWVmONmyei0783FGZd35JX17FCnSM2TshBZWdulF6laA
 6me5F1ztWxYaiknhEt6ByQDKoRS8DSE7pCgBTYHyqfWTV/eieVJ4vmfNcYemQwmwyVFlpErCzt
 7PM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 15:45:35 -0800
IronPort-SDR: Yn2XW2AK9OuNNRse9DXwG2STyoI0Hd1/Zv2w4ZZzzoiCgiogCjUB42yVxrUpJq1g+vTIcfCJRe
 vvFTEJOCs3Q9ygcuNJUL3owdrQHUU8tRP2KMCcPDBkiymcbJabvjcNY+j+r71mTPeqk+IydRQl
 BK6Xx6mNqM5u+ug9SlZdxgw5UC7qiNbVXQ2HbfFaBhblDXNxCMXCKvPf8MKdOkBKHxiVPiZoSJ
 inh0b07m2L3egJonvrmm9HPvyNf+U4pqMqJma2MShwlDJOnv8myI3A81qH6MclvOGjfP37U84c
 vuo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 16:27:08 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NSsKQ3NgBz1RvTp
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 16:27:06 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670545626; x=1673137627; bh=AuQCh/BiWNHtbzuTuOHbLElpQWq33rR9I5R
        3b/e1FRM=; b=ZJkMVCAvwZktlDpjZuVYUsJoM0KkdovPO9PbttAVRDxsPZUp32Q
        vhI9NAztRbPPN2yulgid2af/cG2GJmlRDYJJ+IuOim6ODrmcD2EP5FUZHa/mhCzj
        AkfEiU97Ox3y6XtRWqjnOVZZ+JAtW8mOiltlOWsRSE+lmhXrnuFjWIFmvNjPzGkL
        YAaBPFBPYXWDXrRTNpB6BVi9Ubbv60rMUrWAw+vACJmfPV0Elox6SLa/WYM3f9o3
        n6izhyLPbDqRpurHN3qt1CKt50F/4bOg4Sk3G+eWy8J4N4867gCgS5jzJrKAO2GO
        IQfa+8J9j30JCbjghdEht9wdHmqmgEdnu9Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F0ZcTJDE9lJx for <linux-scsi@vger.kernel.org>;
        Thu,  8 Dec 2022 16:27:06 -0800 (PST)
Received: from [10.225.163.85] (unknown [10.225.163.85])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NSsKM6fSsz1RvLy;
        Thu,  8 Dec 2022 16:27:03 -0800 (PST)
Message-ID: <49e12f8d-3a25-e1c4-9472-a3ab04a0f7a4@opensource.wdc.com>
Date:   Fri, 9 Dec 2022 09:26:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 23/25] scsi: sd: handle read/write CDL timeout failures
To:     Mike Christie <michael.christie@oracle.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <20221208105947.2399894-24-niklas.cassel@wdc.com>
 <2fe5212b-308a-54a2-cf44-9b2895132f74@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <2fe5212b-308a-54a2-cf44-9b2895132f74@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 09:13, Mike Christie wrote:
>> @@ -595,6 +596,22 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>>  		if (sshdr.asc == 0x10) /* DIF */
>>  			return SUCCESS;
>>  
>> +		/*
>> +		 * Check aborts due to command duration limit policy:
>> +		 * ABORTED COMMAND additional sense code with the
>> +		 * COMMAND TIMEOUT BEFORE PROCESSING or
>> +		 * COMMAND TIMEOUT DURING PROCESSING or
>> +		 * COMMAND TIMEOUT DURING PROCESSING DUE TO ERROR RECOVERY
>> +		 * additional sense code qualifiers.
>> +		 */
>> +		if (sshdr.asc == 0x2e &&
>> +		    sshdr.ascq >= 0x01 && sshdr.ascq <= 0x03) {
>> +			set_scsi_ml_byte(scmd, SCSIML_STAT_DL_TIMEOUT);
>> +			req->cmd_flags |= REQ_FAILFAST_DEV;
> 
> Why are you setting the REQ_FAILFAST_DEV bit? Does libata check for it?
> 
> I thought you might have set it because DID_TIME_OUT was set and you wanted
> to hit that check in scsi_noretry_cmd. However, I see that patch where you
> added the new flag so DID_TIME_OUT does not get set sometimes so you probably
> don't hit that path, and you have that check for SCSIML_STAT_DL_TIMEOUT in there
> below.

This is for the block layer (blk_noretry_request() helper) so that the
remainder of the request is not retried. Retrying a CDL command that
timedout goes against the goal of CDL.



-- 
Damien Le Moal
Western Digital Research

