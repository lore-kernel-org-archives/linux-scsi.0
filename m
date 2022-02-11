Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B238C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 12:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350330AbiBKM5Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:57:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239825AbiBKM5Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 07:57:25 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98E1E5E
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644584242; x=1676120242;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=MfSJfZZ/dqjduJU30VQ/R1UMLcoQOXIy4Zv8wXe5oOQ=;
  b=jG+LWjU0TVvDHGh50LEmdsXCApXm0ghRNJDSRX4u/ms+HTuFvUFTcl/o
   q3xtKwKSm6cPwMoQuOxq/jyz6u8gSBnPqpAt/3Nj0l7UFp2YDFwODresd
   dIXZQQm6bRxQ5gtvvfuYwE54A17lgtJzKFHw9ZZwlMIFi2XCPd7b+Ddpy
   lwz3A29XPdBnO4xblp1QnTWdGiuY0hGl/tMonPc4DzNL2xgz19oCd5BdB
   Pb5vCHymnS19oTX0oidUfvCqVnz99XxQA94gMYuWpOX3+rj+o08HlyIK5
   qdHSgB9BIXGk6Og0z05d40W5frbmlHP26NRfIrRCPAPXMxBcPJftvYBrs
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,360,1635177600"; 
   d="scan'208";a="197514791"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 11 Feb 2022 20:57:22 +0800
IronPort-SDR: 3nlqSOYwQlGCTRbkAFKoZd0YooIPz/pSti6c5cUPG906LtpKzuYK1RhQbQrcM9L6x6HlK2e1Y9
 ZTdA9+66kR+3EHgnuGKe8amFQzph+gECxnvAn2kAdi3NgY3qaDDFGvjmp0/dTq10LeRXAnqe7J
 OQSNqhgzXsYLJfenvtS58oDDYMFuF9D9S7AcTIEIYkyiEpiPng6Enb8SvvImhlkGzZlr9XNauQ
 f1rp0kq0MBuu6ZnN+Ep7ARM2bvkPtJSS/TG2Dio3D/RiRBozsnliqECqGYxIY0pLlWW15N3/2l
 jvmQxPcx+wgpksr0icf+thYI
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:30:18 -0800
IronPort-SDR: 2HqKfelgD6R4t1kx/SWjsMkfFVFWGlg2wfe0cA8leDi3XlPgTEJ8kr2OzEUQPM+GI7PTmbYSBB
 VR+aW9Oo8xE1cqPUkZXlbuI6nVfCbTwjZ8btscFlUmZom0rEIxtL5NFoFa8Ri7QYMhCtxX5MUP
 5LrNOxdqqk2vtikyRRBKdJOmCQzRNn3lxU8hHEQnaU0QOagFuattAUXSO1Cxr9UGELwaGQUM2h
 AzbnReINq/xzW8nPqp2H5M9RCST/05+vNffNZMmXkw2oinpYd5acLTKrB+XL4MoVMZC+9Jt8zM
 8IA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 04:57:24 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JwDD31mNWz1SVp0
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 04:57:23 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644584242; x=1647176243; bh=MfSJfZZ/dqjduJU30VQ/R1UMLcoQOXIy4Zv
        8wXe5oOQ=; b=N4i9QfwK1AcTe3m5FYj3U7YAdQLHZYyfiQolPAOl66rg0gyvXak
        i28seChWEwTyc8r2ZqeSZQVn87LPNa51Ll70Y6VFijCB8IHgmQ+TbxcBhcUhFu8/
        9lV1QPkrSppfmy2Ln5gDMsbWpnfgbynUhRSjGa+48PPW2h+kTZ4Dphs72UWGaz9g
        FmJOkPDneojnAUtMWe16321JPHOBfwA08O5nBGQd7fsKqWtRmBMqUvF134zbhzGg
        02fhcODYGQ33yljI0YJS8rqmLSI09XYow0zT9H5wuVDOS7cdVTvSwUShm6uloUrP
        3qjDNIjsVftX39CD6lScLBhqHNBp2d0JCtg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id CWQDIpatfsBv for <linux-scsi@vger.kernel.org>;
        Fri, 11 Feb 2022 04:57:22 -0800 (PST)
Received: from [10.225.163.67] (unknown [10.225.163.67])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JwDD15Y9Qz1Rwrw;
        Fri, 11 Feb 2022 04:57:21 -0800 (PST)
Message-ID: <c21ed2da-73e9-b388-cef6-d350b504d0f1@opensource.wdc.com>
Date:   Fri, 11 Feb 2022 21:57:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 21/24] scsi: pm8001: Fix pm8001_task_exec()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
 <84d4c573-661a-39d5-f639-a3eb9ba8c0ee@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <84d4c573-661a-39d5-f639-a3eb9ba8c0ee@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/22 21:51, John Garry wrote:
> On 11/02/2022 07:37, Damien Le Moal wrote:
> 
> Hi Damien,
> 
>> The n_elem local variable in pm8001_task_exec() is initialized to 0 and
>> changed set to the number of DMA scatter elements for a needed for a
>> task command only for ATA commands and for SAS commands that have a
>> non-zero number of sg segments. n_elem is never initialized to 0 for SAS
> 
> Do you mean re-initialized?
> 
> I thought the current code was ok, as we init n_elem = 0 and we only 
> ever loop once. Am I missing something?

It was not clear to me because of the loop. If the loop is done only
once, why the loop in the first place ?

Hold on...

Oh ! It is a while(0)... OK, this too ugly to live. We need to do
something about this. The continue at the beginning of the loop seems
totally crazy as it may lead to the same task being reused, so multiple
->task_done() calls for the same task. Is that sane ?

-- 
Damien Le Moal
Western Digital Research
