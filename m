Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBA73C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A340961B96
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Nov 2021 03:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243969AbhKPDdi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Nov 2021 22:33:38 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33808 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345237AbhKPDcK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Nov 2021 22:32:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637033353; x=1668569353;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=c5ETFoirunbyuyUC8z9oYbeKYQgeS2dACtcVhs6x5vA=;
  b=pYRmpgoZvTlq7P4VcIq1/sQAyNJ8PI0i/YqZ08mg/0g/bCK8SLpDMbKp
   eNBKquR0NW31s/fHjCj5cwrPmDQ/DrXwgy3sOmIAR8KZyRRFCF0p19IKj
   HrGCkdPNGdrOXzraqWOhmQFuVii6rlyXB0k7qnxzlaDpSfomLWQK/IVwn
   UOwJETZGk2zM5a7e5tw5dG1cN3GhGahVzCciaXBV3Ag6OS8pHglQNIqjg
   vKJxpnf0+Pzp1IDqn/gWs5dPY5t2P5wll/XjrYfBS/Ki8fa0dNfm14Pxz
   Z1Ccc3DZD5ldbG8wQrWpqt6p64kcx/nL9A33LKvnVbLG0Jurw/jRsPobf
   w==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289630538"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 11:29:13 +0800
IronPort-SDR: IDNjHARbE+itB9JHE0H94r1cTVC+hm0uOxtUSH6JBNGCofuskCi2y359UOh9FIf7Tj2ftkvEZt
 nuYAn9Vr3XsNoJqjL2C5fAog+4zYt3jFNVx2sl7L87sXGhb1fpx3Fhmpy4HssYjpFERIBSxgdh
 wu/1CRD67NQedLAXO+rVvYdBFvvFeDZ1e4SCF9vxm/MtxWk9DCiQbuLYvOAaGlK3NRyTov9bmV
 wRKI2FPRBS/5n5nlxiHZn+z+pWBJsj5ca4yS/WyIM/STQA+YbN1SWhDCk8nQcad2Kl8RpDtNi6
 m4tj1D2D9KhcGxa8g2ZFJUXo
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 19:02:44 -0800
IronPort-SDR: 59x/8KbbGBm9JmRHsEyUxNewdrKE9Kwd1v824pIdEJPUQ1TVXQ2z0yJ7tRM9M4lZS4O3BNnlvb
 /YmYVk+XRPDILcFS0HSoVDROBhJDBuD97f2xKqPONG1Sb04ePPJ4G1mD4ZGuEKkFglh4fYIHPs
 /8uTc+B+cb+aBa/soehN9xFV3kDmoBLxOWVQVucs/iuq3qaJuPgn2fZg0Ha4gI+LuWlay7+fEu
 XvWAzV5GE+FcG+aN3l2B95LX2+k8Mt550q/DvkG9xnJ2M1aSEs095ZHEUhyqNw9QxR44cwwmT3
 Lc0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 19:29:13 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4HtWkd0lxMz1RtVt
        for <linux-scsi@vger.kernel.org>; Mon, 15 Nov 2021 19:29:13 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1637033352; x=1639625353; bh=c5ETFoirunbyuyUC8z9oYbeKYQgeS2dACtc
        Vhs6x5vA=; b=Nhw+29yozXisU84oBF7z8kRCJsoXXEZGz7jfE9SfTHoUPlwcsVw
        dsYF3oSUYJdOdc97uMQrzBaUcJtoZO/TC61QoWUiIEnY5gaJ9DU1ZWJ+XwZlryPM
        CcQu+Olb+PRTn2DYzAp0RCV3vsjN2qKDTQy5tEumMCHjN6Vx8iaY6FwS1jUOFulc
        d3zh//6pp5tOx5eYBfVCEW5UfPIQI5VfF06IogakyhYrAZai/pGlWQSZmMw5JlWh
        gf7ZzmuFZ+dIj1XmOL2R4+I9ITvf2dEpwHUyMYLPVaPBIHtb9Z0KjIvZviVkwsy+
        Wj0d1TLfqvqyzG0Xg4dcNir5nPvN5jUuaCw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6N85faEqYejS for <linux-scsi@vger.kernel.org>;
        Mon, 15 Nov 2021 19:29:12 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4HtWkb5VSzz1RtVl;
        Mon, 15 Nov 2021 19:29:11 -0800 (PST)
Message-ID: <00694cf2-b6d6-fd40-2d80-a36d306302b9@opensource.wdc.com>
Date:   Tue, 16 Nov 2021 12:29:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.0
Subject: Re: [PATCH] scsi: simplify registration of scsi host sysfs attributes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Steffen Maier <maier@linux.ibm.com>
References: <20211115092922.367777-1-damien.lemoal@opensource.wdc.com>
 <52cea40c-1de2-9742-168a-c8ff0a29f0bf@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital
In-Reply-To: <52cea40c-1de2-9742-168a-c8ff0a29f0bf@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021/11/16 11:18, Bart Van Assche wrote:
> On 11/15/21 1:29 AM, Damien Le Moal wrote:
>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>> index 8049b00b6766..c3b6812aac5b 100644
>> --- a/drivers/scsi/hosts.c
>> +++ b/drivers/scsi/hosts.c
>> @@ -359,6 +359,7 @@ static void scsi_host_dev_release(struct device *dev)
>>   static struct device_type scsi_host_type = {
>>   	.name =		"scsi_host",
>>   	.release =	scsi_host_dev_release,
>> +	.groups =	scsi_sysfs_shost_attr_groups,
>>   };
> 
> Many SCSI LLDs use class_to_shost() to convert a device pointer into a SCSI host
> pointer. This patch makes the use of that macro very confusing since the SCSI
> host class is no longer involved in attribute registration.

OK. But at least I think we should fix this:

WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups));

to change it into:

if (WARN_ON_ONCE(j >= ARRAY_SIZE(shost->shost_dev_attr_groups)))
	shost->shost_dev_attr_groups[j] = NULL;

to guarantee that the attribute groups array is NULL terminated, as it should
be. This will ensure that we do not end up with a kernel crash when a buggy
driver is loaded. No ?

> 
> Thanks,
> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
