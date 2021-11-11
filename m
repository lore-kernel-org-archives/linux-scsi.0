Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E8DAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C42961177
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Nov 2021 03:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbhKKDez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 22:34:55 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:37365 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhKKDey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 22:34:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1636601526; x=1668137526;
  h=message-id:date:mime-version:to:from:subject:
   content-transfer-encoding;
  bh=YSfVGQ8z6Z0weMtmITkzNe9e9ctABDRbwu6tDBFvrQo=;
  b=RPVSZKEPDeZOhXxpL357tmi363wcY5OIRx/+4UVt92JEt94cvRyeA/4N
   ScYYqPYkI83tUesmfVFJuaqK/Oh89cJHV1d4qt+VsAwTKbpUpSQTMlCHa
   oY2RYW2FuXkqOU9TkOOUftNpDpWQ54oGq6lzMRrkU7SFoK12TEAArVf1D
   g4vZLXseCz3FRwr5cQnbc1uNq7g2OD0R6+4c5su+chOuDiv/KXSvb0ile
   pVRr2zOC3qxygMwAvrsO+neUBYQGA2SNrmkI5ktZN1kjFF4A3vUa7jA23
   2fn9c8dsPPI2wAale94WvnzM4DaZAG9k5b+rDxKJpHUP8xTR7XEKzDSaF
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,225,1631548800"; 
   d="scan'208";a="186299209"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 11 Nov 2021 11:32:02 +0800
IronPort-SDR: eVItAH0cIHSEBmgTOsrdCu/bmFKKmAhKJhSc4K0Xjz/YtlgnA72spSBVA5MjCzeQo3IRef2VEl
 AQPWfAh9HiByUPuDByAzNa/CuniphmwbdBVLvg2wwD662pcmWyTemKHtlz39+eGqc7N9H2LjVl
 RuycbFw2cGk6hUGKPQJNIMZdmEEFUugBXU5CULPfVM/y2T5q+GF0T3x01DMR1O2PPMJXw6s6i6
 FO03Esqwmv7LtQYtCN1QV6su6b3tObF98X1U8QcggvCJhsJtX8vUOl0jiqsQFbc1yKe0WuZ2B3
 v/GXs31MSksXvv8JSALG5M52
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:05:38 -0800
IronPort-SDR: vO2lkozUHeBLtOYC7c7FLINlRKiDyvIOOV+vKyRDQVXtloBRLVznV41ulO0g6yYgWUxBy2kNSe
 2ZGvkKNLsKdKfgsu2DCS8Fny7QTheRi6tr9jNgFO9+syI6Z8owNDIdeHHNP48dyGMXx2w51kmt
 JvEP5BrEpuf326fqUpLFlggu3MDjBzVQZ6E4CUVakfgEzFZY/aaWBYyQLbWn5ryJehgfQgu07J
 RcdyKo3u9lH3dRo53utTJHg1w1htlRvC8MhPpitleqzLkDBmkApr0BCJmvSiScyC5Q8f0fTW1r
 KWY=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 19:32:01 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HqS290Vytz1RtVn
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 19:32:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :organization:subject:from:to:content-language:user-agent
        :mime-version:date:message-id; s=dkim; t=1636601520; x=
        1639193521; bh=YSfVGQ8z6Z0weMtmITkzNe9e9ctABDRbwu6tDBFvrQo=; b=b
        5PCCDUztiiaeWi3lgzPA/dt/wnD4/AU+P26JDdZdJvZg9qublcdPSk7W6TsGmh7x
        u6skYW6Yzvn9GjeYU/vhUrqMAy4WqaVuLQISFhaYX7z77BIaUIWZB/uALUG/8+uL
        gWfC1Yuy1GkABOruCRItAsrpZN1CzXunqA+B1bLL9FgXSKUwGyyvGq6f+cauoevM
        Ziv91y0Th+YFwoOdeegN0wYqYBn06oIue7AgNfyhFX/7ukm4S+/26XznTj6vrGWv
        fRMXL7Rb6WotSy5HgRZ462pE9MXc394+VB6Wt0usXgueflj9sXNbyme0Ct4pAJdq
        41yE4w6kfsnKfZWhsytlQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id bdxmo0UcYkus for <linux-scsi@vger.kernel.org>;
        Wed, 10 Nov 2021 19:32:00 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HqS2772lbz1RtVl;
        Wed, 10 Nov 2021 19:31:59 -0800 (PST)
Message-ID: <4b3e8a72-0b48-95e3-6617-a685d42c08fb@opensource.wdc.com>
Date:   Thu, 11 Nov 2021 12:31:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "linux-scsi @ vger . kernel . org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Problem with scsi device sysfs attributes
Organization: Western Digital
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart,

Your patch 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
modified the scsi device sysfs attributes initialization to use the scsi
template shost_groups and sdev_groups for adding attributes using groups instead
of arrays of attrs. However, this patch completely removed the
sysfs_create_groups() call to actually create the attributes listed in the groups.

As a result, I see many missing sysfs device attributes for at least ahci (e.g.
ncq_prio_enavle, ncq_prio_supported), but I suspect other device types may have
similar problems.

I do not see where the attribute groups in the arrray sdev->gendev_attr_groups
are registered with sysfs. In fact, it looks like sdev->gendev_attr_groups is
referenced only in scsi_sysfs.c but only for initializing it. It is never used
to actually register the attr groups... Am I missing something ?

This is at least breaking NCQ priority support right now. Did your patch
92c4b58b15c5 remove too much code ? Shouldn't we have a call to
sysfs_create_groups() somewhere ? I think that should be in
scsi_sysfs_device_initialize() but I am not 100% sure.



-- 
Damien Le Moal
Western Digital Research
