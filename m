Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77641C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 05:35:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhK0Fi3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 00:38:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239959AbhK0Fg2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 00:36:28 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB1DFC061748;
        Fri, 26 Nov 2021 21:31:47 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so11177478pja.1;
        Fri, 26 Nov 2021 21:31:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DI+1ChY+PEq3YPocfZkTQipKgq0P/yR+1265NB6IhNU=;
        b=plwEzTUD0mrZ4256sgFXqmRV0ZRAGfGaiT0d9UOhA/KApif5JSDa+hstnefJMva3zK
         1043Ewf1pCfH9pml5kVF12pqlk59m5l9HdvuRdY4UmipRLjPaSetOf8TdkDGQYmPpGsT
         ExYG7XCBpPUq/Zrnf0ecBRy7C3u2pOLo1LK643B2PSTXgA40mXdyHoOv9KaXPfVLJVLo
         wrAfcJRyVcmqwHpU5kowKtsQTczM6fkGLXL4OjLao15A4/OvvpIOUyaQ7iRGGbieg4EV
         T4NImL+AsV47U4c4ovjTu7rK3FAC11AwWk3lG0X4RSpKlsZEqvmnWqQS00jY801q7mHA
         ZVbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DI+1ChY+PEq3YPocfZkTQipKgq0P/yR+1265NB6IhNU=;
        b=H5obcT7GN7lOuqMlAAZi40ypKl1/RJeL9BFJa5YongXUbZdmb6obQVYtuJ4j2qeLWj
         wYCSap4/ts/U/UIdUommgUDqaqCZTWKtuUUHJgaVqNrc6uiJJBpRAg45sm6qwBi0srGD
         aGZ/ymOaj/EebhFih9R4BdfVW/W/R78QokuIzJK2y8JX44O1kZ23qRhWA9JSflXlye9G
         5nWEmRxwKf/tChXJiCN+lGDrULnZayz76Os6Zd4TBZola5czPE6qVRZbycQmjXM9S0hx
         kI1gZYG63wX89IDU2B9DQKxS40TcXfFqSdpiv/rLY1YFU1lmxfXy/6Du44U39ReyZHYc
         bAig==
X-Gm-Message-State: AOAM532O1diOTD5sUa92QanZm/FmpuvQ9EmP+aBaeo5aS74QgBs86tqt
        wyMsyUwF/+Ot5xAlJh4xV9E=
X-Google-Smtp-Source: ABdhPJzG5sdTR8rqNCBl1aIOlcRY6HpG25eujBb737C70RHkhFJKD+L2DkssM0u1ThYCr/n13I7FAg==
X-Received: by 2002:a17:90b:4c03:: with SMTP id na3mr21216993pjb.62.1637991107127;
        Fri, 26 Nov 2021 21:31:47 -0800 (PST)
Received: from [192.168.1.5] (70-36-60-214.dyn.novuscom.net. [70.36.60.214])
        by smtp.gmail.com with ESMTPSA id t3sm7622165pfj.207.2021.11.26.21.31.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 21:31:46 -0800 (PST)
Message-ID: <be1624fe-f1e5-f008-32e8-af00a36e284c@gmail.com>
Date:   Fri, 26 Nov 2021 21:31:47 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page'
 variable
Content-Language: en-US
To:     Manish Rangankar <mrangankar@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:QLOGIC QL41xxx ISCSI DRIVER" <linux-scsi@vger.kernel.org>
References: <20211126051529.5380-1-f.fainelli@gmail.com>
 <20211126051529.5380-2-f.fainelli@gmail.com>
 <CO6PR18MB44199C2AE98B79EE9D46D679D8639@CO6PR18MB4419.namprd18.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <CO6PR18MB44199C2AE98B79EE9D46D679D8639@CO6PR18MB4419.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/26/2021 12:52 AM, Manish Rangankar wrote:
> 
> 
>> -----Original Message-----
>> From: Florian Fainelli <f.fainelli@gmail.com>
>> Sent: Friday, November 26, 2021 10:45 AM
>> To: linux-kernel@vger.kernel.org
>> Cc: Florian Fainelli <f.fainelli@gmail.com>; kernel test robot <lkp@intel.com>;
>> Nilesh Javali <njavali@marvell.com>; Manish Rangankar
>> <mrangankar@marvell.com>; GR-QLogic-Storage-Upstream <GR-QLogic-
>> Storage-Upstream@marvell.com>; James E.J. Bottomley <jejb@linux.ibm.com>;
>> Martin K. Petersen <martin.petersen@oracle.com>; open list:QLOGIC QL41xxx
>> ISCSI DRIVER <linux-scsi@vger.kernel.org>
>> Subject: [EXT] [PATCH 1/2] scsi: qedi: Remove set but unused 'page' variable
>>
>> External Email
>>
>> ----------------------------------------------------------------------
>> The variable page is set but never used throughout qedi_alloc_bdq() therefore
>> remove it.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/scsi/qedi/qedi_main.c | 3 ---
>>   1 file changed, 3 deletions(-)
>>
>> diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c index
>> 1dec814d8788..f1c933070884 100644
>> --- a/drivers/scsi/qedi/qedi_main.c
>> +++ b/drivers/scsi/qedi/qedi_main.c
>> @@ -1538,7 +1538,6 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
>>   	int i;
>>   	struct scsi_bd *pbl;
>>   	u64 *list;
>> -	dma_addr_t page;
>>
>>   	/* Alloc dma memory for BDQ buffers */
>>   	for (i = 0; i < QEDI_BDQ_NUM; i++) {
>> @@ -1608,11 +1607,9 @@ static int qedi_alloc_bdq(struct qedi_ctx *qedi)
>>   	qedi->bdq_pbl_list_num_entries = qedi->bdq_pbl_mem_size /
>>   					 QEDI_PAGE_SIZE;
>>   	list = (u64 *)qedi->bdq_pbl_list;
>> -	page = qedi->bdq_pbl_list_dma;
>>   	for (i = 0; i < qedi->bdq_pbl_list_num_entries; i++) {
>>   		*list = qedi->bdq_pbl_dma;
>>   		list++;
>> -		page += QEDI_PAGE_SIZE;
>>   	}
>>
>>   	return 0;
>> --
>> 2.25.1
> 
> Thanks,
> Acked-by: Manish Rangankar <mrangankar@marvell.com>

Thanks for taking a look, does not that make the loop iterating the list 
even more useless now, though? Should not page have been used for 
something in that function?
-- 
Florian
