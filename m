Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA87C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 00:31:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiJ0AbB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 20:31:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233512AbiJ0AbA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 20:31:00 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6816A106928
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 17:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666830659; x=1698366659;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uNlqtDf6jWpkFPA0E2cg8BhVIpvaDxbPOBiNnbpCpcg=;
  b=V2pkz3+zenShnSgsRjbBFO3naYyoIBY534C4KUp22r1rrwgPujllcAFD
   AJ8iZO4g/OGxoZ72hNdRkn4dQI8BZe71DbDDmqUzNl+qqNEZ2FuX0Z+3/
   PsdMTunAW4VPql0+yCgLKfVc53uJNO+RRbShORXlhKo8aAxdKfE9KVkrI
   hHq2jRU3BMgTXBMR7L7/J+qlJS3pSKdZjrM2MxGf1SUwbfm22vALRbgE3
   MTo9jU7CizNF8avLyWhFBfdN54BgFvo4iIQZHagqSKJ4OQSq8msq57NIB
   +zkJ8KjRhxERnSz6wl1gUWJSSSJQuK23J9a2oDD6SNM7kwqUFGWOI+r36
   w==;
X-IronPort-AV: E=Sophos;i="5.95,215,1661788800"; 
   d="scan'208";a="219994893"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2022 08:30:58 +0800
IronPort-SDR: l+3Ud2L7dfeCWci39rphTCwFQNuGR6iJtwFhU6dhHTbO64C6gVKhE16DYR5/my9HD6x3/3HJ88
 e6jTgfqPW3fzv4KA6kw7Bq2ZnGeR59vgXjTT7jAukVd08qub7bLIbhbBLaW2tsMxQWhJPVMbG9
 ReKvs8orZOiSu0AA6zNFec3AggPtYQG9nLRg5ANky9rIrbRAM+y5nobTPur2oWbpu0OPOy9hGC
 /RhjdUlc3QHhgE0rz98fdJHDNvQm2Ybm9QG2ZXVjqf3SXfbiRuEzgYnEwBXuKPXchSbLU5fAod
 SAoyfULlwhcrHvE3pmqxwAcm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 16:50:18 -0700
IronPort-SDR: 0vwsuRcKChr0CxskHW63aTBKuYBu9CsWdEefvRIYvCXMeJLLo+/2YKPpt++CkCddyhF4s6aKAr
 1AuBLmd0W1d+YX1LxM/EiLZeGIJjOuyuBRHfJMvD9RxpYhparCAdUnnuDbZcGKoOTJZruUjBbZ
 HeiC0rdmuSnRLSz8caaSrrQhk+d0AWWAykoTiKUf/NA6rcla++cN1+vj4c3tZFzNs1w6eEzLvP
 fyyjpos+re8bQ9ItdM52b8spcJFAF1FfjkF9csIoFeAcF9BvCivW/FNVkWBYkWF344VpGZQU8L
 S1g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Oct 2022 17:30:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MyRRh5FdKz1RvTr
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 17:30:56 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:content-language:references:to
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666830656; x=1669422657; bh=uNlqtDf6jWpkFPA0E2cg8BhVIpvaDxbPOBi
        NnbpCpcg=; b=EmJz53YhIuBHiIY3ei1U3aKKp940WjQ2V8n2aGWzEOVHOXFqHw+
        F+ST5FDSsRDf5L6i6vnb56UxNGUkqU5bqF0npHqh2syqrURlAp5dNeVdz8WfJzHv
        yZKT8K4Szth/Yp6izNkT8Sqy3XLYUdRf5HbE3BrSKbh9eQ9buWeRriAeS7k2mIwE
        LWZUmyOW7mYs1YMANChRgWtVEDPxMDmHxC0acD6sytZWi44GrxMeF0FsxaQQA/lh
        iMzZztxhXOGYhU1iW2s29QrvpcaltA50LpMjc+ciNuoPWzuVRdRunJg5iaMczK2m
        8TcCQHE+UIIHIUNPnFO8mBoZuRUSaEmnAbg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RA4tjpN-EL2i for <linux-scsi@vger.kernel.org>;
        Wed, 26 Oct 2022 17:30:56 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MyRRf6Xd1z1RvLy;
        Wed, 26 Oct 2022 17:30:54 -0700 (PDT)
Message-ID: <23b7b1f7-94c1-9c01-e1c8-c0a30a4aa06d@opensource.wdc.com>
Date:   Thu, 27 Oct 2022 09:30:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: pm8001: Drop !task check in pm8001_abort_task()
To:     John Garry <john.garry@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1666781764-123090-1-git-send-email-john.garry@huawei.com>
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1666781764-123090-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/22 19:56, John Garry wrote:
> In commit 0b639decf651 ("scsi: pm8001: Modify task abort handling for SATA
> task"), code was introduced to dereference "task" pointer in
> pm8001_abort_task(). However there was a pre-existing later check for
> "!task", which spooked the kernel test robot.
> 
> Function pm8001_abort_task() should never be passed NULL for "task"
> pointer, so remove that check. Also remove the "unlikely" hint, as this is
> not fastpath code.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> 
> diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
> index 2359e827c9e6..e5673c774f66 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.c
> +++ b/drivers/scsi/pm8001/pm8001_sas.c
> @@ -979,7 +979,7 @@ int pm8001_abort_task(struct sas_task *task)
>  	u32 phy_id, port_id;
>  	struct sas_task_slow slow_task;
>  
> -	if (unlikely(!task || !task->lldd_task || !task->dev))
> +	if (!task->lldd_task || !task->dev)
>  		return TMF_RESP_FUNC_FAILED;
>  
>  	dev = task->dev;

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

