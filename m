Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9142BC43334
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jun 2022 11:59:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242926AbiFIL7t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jun 2022 07:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbiFIL7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jun 2022 07:59:48 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDF466236
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 04:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654775985; x=1686311985;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=k6GMqgdfQiuwSMvo4xH5m3X/fWOrNnZneMsbYB8++Cw=;
  b=dcNLA9gftyDs3HPtCNn4bI1sZjiBB6IP/0C/PBRuPBEfESLYrUH7ZaZy
   kSRhXSQP7EUo2HRkZ6YfU3uj4p4HpTNVQMn7ZmisIz60ICNEfrgohvYYQ
   S3eo7OB3frlerilODOamUCbJ6j6eGkR06wM0mJyoEORy7FgIcn8gzrV+Q
   VooH3cTOohOPA54DEpw5abnjnKS6fsS5xTmbieGpGNYlsgQ5J+BdHjkO+
   8AQY0WX42ZS/cNYCZATeGMId7S3ZZTCN57Vtd8l8iyZEdFWjFPIyDWGXL
   EXx9zCVJMIb63Y7Zs47Va7qdzXN1jHr8yIczGdDd6y1b6aZFtQga8Rl2p
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,287,1647273600"; 
   d="scan'208";a="207547584"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Jun 2022 19:59:44 +0800
IronPort-SDR: spb9Y2de8V6c+kpPifF/AHAJs2FOgrDYHnxjS9pDb/P3wJZqlc2rGexKbwllH07dbwPLFMlA+s
 Kx93tV42mNuS9dKBxcioPGM+hLnZCXirPif0yW/nq/zBdcKj5aHhu2Aqj1cbKN3TA4Q2ztDPVV
 OfBQy8XWky2hoMALuQ0hr5Uj0w88nG0Rz3sNZF7mf+W6mituOPUNrkp9Pr7wayB6CFbbRoAqOn
 kj3ttLr1IBETKL0XQN/nVf4ptR9ToATgpx3Ht4PA4XoiDAlvl8oVav72jj7RYpfEBQHxwmLzum
 3GvmY3KJ2ro1h72W802J8J4j
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 04:18:33 -0700
IronPort-SDR: QHxa4wYTm0LFukwmG3NLp7oSXK+CmFcwoC0GUs525ZlVjSa7/JjP99dZeZovEG/1rv1dCuAkz3
 jRXl4zqgiN3fYXMHAwi8GRuJ8OcoabpCZeCoPwQQjcu23uzK61HdxJZvr9F45SM6gGdlxtKvf/
 ZO0fk/VPV/5kUBg48QO4EHa/7FB+vImamdRPeIZ9trBrl5F2waxTKJyItdTYkzUjIcUSrEMbGs
 ug/H4v/pGroEbjrQ0lOwmTnzXi+6OJRW9ncGgLrNfJP1Cb4I+bjJh3DAd6gUawF2l1nn5nxPNl
 R6E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jun 2022 04:59:47 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LJjM55YqYz1Rwrw
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jun 2022 04:59:45 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654775985; x=1657367986; bh=k6GMqgdfQiuwSMvo4xH5m3X/fWOrNnZneMs
        bYB8++Cw=; b=JqjbDSXAvhgUPpsAXwLQNARaPazoZOablATIX1MkRFBnMS1z9dc
        Sa9qVTN0SIPJvpqsHUo/QPNX4BB2Xog1L7Itw9Wg9fZ9X4DN1VtDQGLVZ/xtOFwT
        klzg4FcNIvwjtw6gI0b259gmQ3sjsFVgGdD2+Q/5VlWONJUcP75GPNeru3cFa1TL
        DsHpvv/PC6nybrrwKsmdwUUSUkt3OZJADuJrvBC9b/EXSD4EBHWuEq6Z//QyfGLL
        siO6aUrdGa87d3u7dzlMwldRGPr1XWNKS/iPUN8PXKYXUuWmuJ7m5La7dowumZT9
        40/ZARMcTh2kn7dxtZvRc6TfCkZZiQPAtkQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id w498JCBzuHIH for <linux-scsi@vger.kernel.org>;
        Thu,  9 Jun 2022 04:59:45 -0700 (PDT)
Received: from [10.225.163.72] (unknown [10.225.163.72])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LJjM46Pssz1Rvlc;
        Thu,  9 Jun 2022 04:59:44 -0700 (PDT)
Message-ID: <3a1ded4f-140e-57b7-732c-8c14a62e37eb@opensource.wdc.com>
Date:   Thu, 9 Jun 2022 20:59:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 1/3] scsi: libsas: introduce struct smp_disc_resp
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220609022456.409087-1-damien.lemoal@opensource.wdc.com>
 <20220609022456.409087-2-damien.lemoal@opensource.wdc.com>
 <9a4612db-7cc2-398d-f882-4190bc5d7759@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <9a4612db-7cc2-398d-f882-4190bc5d7759@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/9/22 17:43, John Garry wrote:
> 
>>   #define DISCOVER_REQ_SIZE  16
>> -#define DISCOVER_RESP_SIZE 56
>> +#define DISCOVER_RESP_SIZE sizeof(struct smp_disc_resp)
> 
> I feel that it would be nice to get rid of these.
> 
> Maybe something like:
> 
> #define smp_execute_task_wrap(dev, req, resp)\
> smp_execute_task(dev, req, sizeof(*req), resp, DISCOVER_REQ_SIZE)
> 
> 
> static int sas_ex_phy_discover_helper(struct domain_device *dev, u8 
> *disc_req, struct smp_disc_resp *disc_resp, int single)
> {
> 	res = smp_execute_task_wrap(dev, disc_req, disc_resp);
> 
> We could even introduce a smp req struct to get rid of DISCOVER_REQ_SIZE 
> - the (current) code would be a bit less cryptic then.

Yes, I think the req size needs a similar treatment too, and we can remove
all these REQ/RESP_SIZE macros. But for now, the req side does not bother
gcc and I do not see any warning, so I left it. This series is really
about getting rid of the warnings so that we can use CONFIG_WERROR.
There are some xfs warnings that needs to be taken care of too to be able
to use that one again though.

> 
> But no big deal. Looks ok apart from that.

If you agree to do the req cleanup as a followup series, can you send a
formal review please ?

> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
