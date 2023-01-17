Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3974C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 08:00:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235858AbjAQIAL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 03:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235841AbjAQIAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 03:00:09 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C487325E1E
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673942408; x=1705478408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g9jZ4NXxoTsdj4fcvmZe+9a9/ft8JBcGnJUfqd1G/YM=;
  b=QO5NfqRp6PBNV7PTIej3TR+ydbTl452vNIZhQT1ecRe7VCe8qr/Ygt2O
   smetn2rpuYPR1wgUMS7S4gDk8B7DCzrGBK5xKuqzs9b6pvq0YHhI4Cpt1
   irylngZly0Hg9oW00bgTjkkQBCONUV+b5B2jf4vhTs754OKsDWdrDe3wd
   3kbm+hY1rzSkMcbq/3MawpSMe/TxnNpxnBeT1YbB42jNVsoIGDaTE7yNW
   eP7ozW4vZyr9g7jh24MMdHYNNXijAhgd3mQQdEtthbuwJZAOhiFA7jBkr
   EvNwV2SeyV/mbb4qADG1Pyk4WYS8Uci3M3wbWgHcnacxBQjTby4QjbpB/
   g==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669046400"; 
   d="scan'208";a="220819960"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2023 16:00:07 +0800
IronPort-SDR: 26bKZQzP7uAfCHz+0cxkXel5wNhxCOVdPRyBFsbLh1otxF8YvDyFnL8FZhvlfenAD/xptHrt2l
 sm5C1Im/2ezG7ib2NGLaiSl/cRXgah8qh7Q3zCw88u22eVJLitjyAgbk5Q5o34/urmj6Yj8sN5
 ve6+EyijBovrDldt0GI+VpxR0kPsKbyzBT1lXEyCKKu68t7CS6+hZW+iF7/9vSXXdn1/WO4Y+l
 +jiP7xpjAvWbzlEcv+o02E711owGOoLjjWy6TpH4qmNOZ1fv4ywrvcrJYE0VxaWZ7DsL6fRTWV
 Do8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 23:17:49 -0800
IronPort-SDR: fjN2uDo3I+/d37C99Qz45bm2FdmgEPJRjNQs/oGXm+6KeOIJiHUKDRMS5lvKW3yOmw1ytiquvj
 F272oi0PPEZ3xusQ9rhEoK72tMxpmT8m+aNIlcJwktlO8HolPXYoNWUFQ63mEQYBXEIpBN4Eo6
 NjV3MAIivMIAyZmNI8kNSfE0EtZSLoR/RD6FK0ChmTr0y0GEbhG8sY2j4mBnmhxWPEb+MDtgkV
 VHJszb3QJ+bJx6jFtMPgNlI2F9gYIi81+yMPAQu1j+atonGPCCOk6OyD8wavxMq0PJEO88Ndgi
 wPQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jan 2023 00:00:08 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nx1X71bs9z1Rwtl
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:00:07 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1673942406; x=1676534407; bh=g9jZ4NXxoTsdj4fcvmZe+9a9/ft8JBcGnJU
        fqd1G/YM=; b=gh+HNdU5lPDHjtYtR8YwkLMsGJcCWv0G5fvflwB4/e79NO4dc95
        CATSrXcZ3Hq0ngy8y5zaWrZl1c/tM0v+J/VEtzb5EqDCRTqg+7dM9f8LWFNswk34
        batIoLERiycRRwPhxp3tvG0vhfu/Mf7Qbhst/wFKoTRscOcO9vtBCeKLqQj3ee1D
        pyA1yP4KDRjvVZ39vpyO6/dphfv8oZAF05HlR95Bx6mQDflzukwuc5JgYILNasq4
        m7HPVA+71cQRWFjOU4zK/hNTbfA3gxAeUK8EZ6uzVEEObnSuWcuH/IgypkD7RiJF
        TDs3dvl4udySqNBAt8aQdh7F8Os5b310S2w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KbxDHZzpYlvF for <linux-scsi@vger.kernel.org>;
        Tue, 17 Jan 2023 00:00:06 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nx1X5302dz1RvLy;
        Tue, 17 Jan 2023 00:00:05 -0800 (PST)
Message-ID: <16676885-5e71-4a5d-1b75-db2ddeb8e16f@opensource.wdc.com>
Date:   Tue, 17 Jan 2023 17:00:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 14/18] scsi: sd: detect support for command duration
 limits
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-15-niklas.cassel@wdc.com>
 <Y8ZQQRO/O/3JjHtV@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y8ZQQRO/O/3JjHtV@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 16:37, Christoph Hellwig wrote:
> Is sysfs really the right interface here?  I would have expected an
> ioctl (and for kernel use method) on the block device to more
> useful.  Especially all the dynamic sysfs manipulation from a driver
> is a little scary to me.

I found it convenient to have everything in sysfs as everything is visible
from the shell without needing any extra tooling. And I did that because I
thought ioctls should not be added... We could add one though, but then I
do not see much value since cdl-tools (cdladm utility) and sg3utils/sdparm
can give that information already.

-- 
Damien Le Moal
Western Digital Research

