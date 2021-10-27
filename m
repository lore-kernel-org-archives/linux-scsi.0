Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BEEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3533560E54
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Oct 2021 03:42:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237691AbhJ0Dom (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 23:44:42 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:34938 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbhJ0Dol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 23:44:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1635306137; x=1666842137;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=xPGvWc/CDKA9F05lC6rPfMyvBm5J0XVlHTqQNKB5Uag=;
  b=f2einf0JUNU13vVc/+L0JHdm6mk2oM7C4/BW5m+v1HNm6fON2HUF9744
   cBC97Oqql/0biwD+RwdxZOjt4+KWdz4kgvKPsvaKW5Dpeo8bn3b/11lIc
   fg5mGyCsvUPpERG9+EmBdAnYaiRaBC6oMqy/fFvTlncHlo7D0rjEzyF77
   HyQR5HZLnX0z3AP/wjDnQPstWiOyFRzXOvf0THefMfHABYWPRm7jhMDey
   QvaYZKHLiHdJzPfUnxVWjuqrlfsRspfxJEXNDFg//Kye7SyFnPidRUjcR
   54431W+AjEOG6I5SnWS91o9rpFjxDjWLiCdbN3uQGKyzY9SLxrm5VO4DT
   A==;
X-IronPort-AV: E=Sophos;i="5.87,184,1631548800"; 
   d="scan'208";a="182940835"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Oct 2021 11:42:16 +0800
IronPort-SDR: rM0Nwg3XRqlqkjqacSzMeVGurlxc1g3+/Up4YncVXXZXyzsx64ShuKalEm0sDgV8HXsd5J/ll1
 WeBm3oPWSgHyzGQqWMiKsEl21w132h3ohgI+hsutQ4daIKIPjPBMKLU/E3ldR0B/zKWnqD1nE4
 Evea0ghbTHqkfi4rGzZIVTtrIrhVGC6Xll5B/XkUqc0Refy1MBvqWbHr4D/yLYOiJP0wTj0ZXz
 4+s5/GjJvi9p+w223sQ+rEnW3XRapKTAwimvijnWLWeRC+gK1IoQkgJEGhlHOaqETv8ZCziHk+
 KPqwPOzPIiCD5J5s2PGYWE9V
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 20:17:45 -0700
IronPort-SDR: 2kFBiw6XUrxOxKhRR9BGiWHOVHdXP60P4VV2uR/NRZqiBgSZ+UcJb3HU6XOOrjPxsnSA2WRGdd
 cVcIQh6r3wp3RjploYoQmBAcgPoW76dM6ScSWP5UuVP3IxU4yod1VRpRiD8iq2yQ7ZN8d96EN2
 tpf8yHr8kstpXswOS75HMhpaP2bGtwzHPb1cPpwGlkvbVUm2WKNlmeC4F8Aj+0WadwRQ5XeMWw
 348I+77CxCxz1knFdVWtvUjQiDuT1ENXT8GR/V7gUdioLstLBO8c9dzdL8DeixX30WOUZZr2gx
 B00=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 20:42:17 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HfDyw0v5gz1RtVp
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2021 20:42:16 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1635306135; x=1637898136; bh=xPGvWc/CDKA9F05lC6rPfMyvBm5J0XVlHTq
        QNKB5Uag=; b=DmhuyViXMiYIEWLuaxh6z1VVq0f1tqJFvt6cDm4t7Ofp6g9zYlq
        DPOmrYNRsCc1Y4Tawz3Yu7iPKL80/21IZ+RUpCT7EXnAtcHB9swQW+Bia1H9gYqp
        d2XkmccjmWBFcsNtiuTopvTOy/WwWMt9oQ467MJQJ6Pj6giLdBOlvgtkCxngjYf6
        7HLmhrqp4q3v4B36iF6L+F+lL6aI4tH5fpHK6wJjuZ2LpCa3LRvkUq+59szTxJwu
        rcnZRy1EQ5fWXeEq38mIJM9dJM4anq8IsEndSzyNOLBcErJMPsjN61mQcBu01oSi
        LDvMhk546pXCQnnms+53Eu5ujQkooxPtjeQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id o_Oxfz7lfR7b for <linux-scsi@vger.kernel.org>;
        Tue, 26 Oct 2021 20:42:15 -0700 (PDT)
Received: from [10.89.86.157] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.86.157])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HfDyt4RM1z1RtVl;
        Tue, 26 Oct 2021 20:42:14 -0700 (PDT)
Message-ID: <c47af2f2-2d33-fc54-efe3-f20b286e80c5@opensource.wdc.com>
Date:   Wed, 27 Oct 2021 12:42:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v9 0/5] Initial support for multi-actuator HDDs
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20211027022223.183838-1-damien.lemoal@wdc.com>
 <cea34b2a-6835-d090-4f0c-3bf456a6ed00@kernel.dk>
 <CH2PR04MB70782D5877F24ECC9A0F644AE7859@CH2PR04MB7078.namprd04.prod.outlook.com>
 <64a81be7-ef62-8f8c-bfdc-759e04530366@kernel.dk>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <64a81be7-ef62-8f8c-bfdc-759e04530366@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/10/27 12:03, Jens Axboe wrote:
> On 10/26/21 8:49 PM, Damien Le Moal wrote:
>> On 2021/10/27 11:38, Jens Axboe wrote:
>>> On 10/26/21 8:22 PM, Damien Le Moal wrote:
>>>> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>>>>
>>>> Single LUN multi-actuator hard-disks are cappable to seek and execute
>>>> multiple commands in parallel. This capability is exposed to the host
>>>> using the Concurrent Positioning Ranges VPD page (SCSI) and Log (ATA).
>>>> Each positioning range describes the contiguous set of LBAs that an
>>>> actuator serves.
>>>>
>>>> This series adds support to the scsi disk driver to retreive this
>>>> information and advertize it to user space through sysfs. libata is
>>>> also modified to handle ATA drives.
>>>>
>>>> The first patch adds the block layer plumbing to expose concurrent
>>>> sector ranges of the device through sysfs as a sub-directory of the
>>>> device sysfs queue directory. Patch 2 and 3 add support to sd and
>>>> libata. Finally patch 4 documents the sysfs queue attributed changes.
>>>> Patch 5 fixes a typo in the document file (strictly speaking, not
>>>> related to this series).
>>>>
>>>> This series does not attempt in any way to optimize accesses to
>>>> multi-actuator devices (e.g. block IO schedulers or filesystems). This
>>>> initial support only exposes the independent access ranges information
>>>> to user space through sysfs.
>>>
>>> I've applied 1/9 for now, as that clearly belongs in the block tree.
>>> Might be the cleanest if SCSI does a post tree that depends on
>>> for-5.16/block. Or I can apply it all as they are reviewed. Let me
>>> know.
>>
>> Forgot: They are all reviewed, including Martin who sent a Reviewed-by for the
>> series, but not an Acked-by for patch 2. As for libata patch 3, obviously, this
>> is Acked-by me.
> 
> Queued up 2-5 in the for-5.16/scsi-ma branch.
> 

Thanks !

-- 
Damien Le Moal
Western Digital Research
