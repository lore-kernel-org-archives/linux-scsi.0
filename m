Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C728CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 04:25:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243935AbiDZE2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Apr 2022 00:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243916AbiDZE2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Apr 2022 00:28:41 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBED47576
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 21:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650947134; x=1682483134;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=jZAWSem7tWU2tMWpU4Jy6443ujmS6/pmN4ww1qhZjag=;
  b=hV7BwjS2srFlU3AEZe3IoDhOo2TAYafBGFABYgETsibIa224RZxgRPF4
   +xzNzdu9V1onAZmgA1gWb0P213N3rZfinqb8tNjlKvWhTCUPKMUtiGexn
   yCauIeySwFkad3jAM6Sp6vo9KDNNYtP7/M+O6MsDN5iuX8o8G7hhHKpon
   SMuANVoN+sXuaAKx0zPAa7FHKFXSyBg54ApWuTqzY6K45Yzv+G6ZK3/kw
   CqpVnKjojK83Ra1q1HRb4BCzfSd7SdMT/qXPc/R/5NMLl0vsU1Tq06ee0
   40sLV8lhniaBE5gRjA1Cw1xA83S3oE9yAQZHufHGypMXH36bbhB4pFCyA
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,290,1643644800"; 
   d="scan'208";a="310788485"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 26 Apr 2022 12:25:33 +0800
IronPort-SDR: LQYJ+Mjb8upJVQPQ6t79hZ8FbuDN7BPPW5t5Ut2PbtVD5bElsR61Kq3eUMWDoFXfMpFM63nqvA
 bloI9CJtiOkQjcJ6RcwVK4+cemAXKyr3QpaHcQ4v0dkHdzPOlD7GWIBlaaHNuhBXN9HvOMf97L
 +BJEMrcWi3b4fqp6rTbpnpc3b1PHmd77LEVft+a+cNf6WcXnunVta9CgUeDP2D9cFNwIBk5jTt
 3a//t1A7xegfhqCnyLxrAttlHLZEb77VaQwbAV4uTGQwxyQpvT1TT569LZToy2fuHTWMvdRO68
 KJCnUPO7VFAdOqP1xfDONJDv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Apr 2022 20:56:28 -0700
IronPort-SDR: 3OJ4e50w85/4vJYR/98ES9eU2YZFCWL/LR8VTCkF8o5TvOr5+0Vre8byZvGSuB7Qec1/Fr4YIT
 0CgVAMDImQyx7cyV4iTEgMlHOf0aFbbJXQdhu49hMkj4DWRiqq4EXYNiOuzq9r/KsoiOWuAIRZ
 vXTGC1WGxem4Gk1vyKRSnXC5UKdzFP1PVBt1UOFMles+md03WaLNliTjUWbP33xKaLCvcBBmq3
 zuaPJAlVErLKPZC1frc3k3euxC2RZpTHlfwZdc8XxuanzVNiQxzKjFIU2Az8ThC1Hnd2RJi+Tb
 VlI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Apr 2022 21:25:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KnTMK0v2wz1SVp1
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 21:25:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650947132; x=1653539133; bh=jZAWSem7tWU2tMWpU4Jy6443ujmS6/pmN4w
        w1qhZjag=; b=MdDlBNGaZ+Ya1KsJOf0QtL/JBJYZV4YZMOHwSVuq2H3SMhTU73Y
        CyfhG/h8iqzvv0RvhYq8zC4Hgx79c+0dknp6RD2QfKcyFJJSbqwLyn7Kfcl3Tr4Y
        TPmvskZZS/5VUMYPvX+hxh5ZXksbSr2ME4V81rnqm0CUrx3Izx0IN0j3GKxfVYnA
        vGfQvkFIEVbWpmi3kLmhy4F8yZ4ZVRYMiZJZh/UNRAQH6H7ilLP+2+1vtvOtORpT
        UFPe/qRgearS2uEM2kn4kUT6+U7GKt6xUVcg/Zqt1ERVpaif5AoX6JOE8AoQFWYV
        94DpKN8L3cQz4W09jWVturW1Ch+m+Jyn47Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id d1-O87pZAutA for <linux-scsi@vger.kernel.org>;
        Mon, 25 Apr 2022 21:25:32 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KnTMH2Kc5z1Rvlx;
        Mon, 25 Apr 2022 21:25:31 -0700 (PDT)
Message-ID: <a1293ec4-d160-9ebb-d20c-d120b14e6da6@opensource.wdc.com>
Date:   Tue, 26 Apr 2022 13:25:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v3 0/5] Fix mpt3sas driver sparse warnings
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
References: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220307234854.148145-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/22 08:48, Damien Le Moal wrote:
> This series fix (remove) all sparse warnings generated when compiling
> the mpt3sas driver. All warnings are related to __iomem access and
> endianness.
> 
> The series was tested on top of Martin's 5.18/scsi-staging branch with a
> 9400-8i HBA with direct attached iSAS and SATA drives. The fixes need
> careful review by the maintainers as there is no documentation clearly
> explaning the proper endianness of the values touched.

Martin,

Can we get this one queued for 5.19 ?

> 
> Changes from v2:
> * Reworked patch 5 to keep writel() calls. Sparse warnings are
>   suppressed with a declaration fix.
> 
> Changes from v1:
> * Reworked patch 1 to remove the TaskMID field type change and simplify
>   _ctl_set_task_mid() code.
> 
> Damien Le Moal (5):
>   scsi: mpt3sas: fix _ctl_set_task_mid() TaskMID check
>   scsi: mpt3sas: Fix writel() use
>   scsi: mpt3sas: fix ioc->base_readl() use
>   scsi: mpt3sas: fix event callback log_code value handling
>   scsi: mpt3sas: fix adapter replyPostRegisterIndex declaration
> 
>  drivers/scsi/mpt3sas/mpt3sas_base.c  | 32 ++++++++++++++--------------
>  drivers/scsi/mpt3sas/mpt3sas_base.h  |  2 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c   | 11 +++++-----
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c |  6 +++---
>  4 files changed, 26 insertions(+), 25 deletions(-)
> 


-- 
Damien Le Moal
Western Digital Research
