Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 800A1C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 00:52:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiGLAwC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:52:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiGLAwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 20:52:00 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94ED92DA8B
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:51:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657587119; x=1689123119;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=RsBnmb3W9TjP5bmY3p5IB12iDxV4xR00dP7JOJqPLMo=;
  b=E0ZY7uk0mIbYpNqY5CIHCc07Ac8gos1JgHppiUL52/E1jb/9Az70ToPY
   pWJlSUudFgtIZOmsAOSnPBnVpjYMlW652uQbtWvd93N7MhUVBv7LFw1L1
   OB3RBtpr6KTSzFMvRhyYmNPPC58jbhesI2RtSbX4UV+Rik6RZHniSGFIL
   O1QI5yQcuwmNJQHbvbi27r4/bL/dzGG9wMJjLW2sIZDHnLcpWxNf5IJ/P
   Dn3opLr5Ijylbo0075ABF68I4KrnzBAU46d4WcdsGOXdS8vEgOVoJ3L+B
   oc11Mw6w2JGe6Dwct9v2JFyIfyVvTi07Jp869lNcHiUj1fqOzRKu5jOs4
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="317567869"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 08:51:58 +0800
IronPort-SDR: 41P7Gu6sNFIK5/3fzc01Gg9csw+BjCS+XWloXpS5OkaYOai5H5rchNjMYGQpoFSfGoeBi7qcuW
 q6L5L+Isew6KKW9mIeMu7NuFmcVQgxVu84czLV9PVxCjR6Wit4NUrTp6O2Nzal9y9dwo8MopcQ
 chS46UR6VwGIup6zUMfbxab273+3OWl0ORx33/GRn7MGMmiEcXyvX7ffszUEbwgSGReJdX730O
 d7M6LpbAjIeUpVmYF7dKVoNlJRX7JzboXWxXmZ/gxqZdIgYI1A5bDCyHAXnJtFPK1QWkS9/tfZ
 ejWYIW/jrVcPZmjO3fqMeTJp
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 17:08:57 -0700
IronPort-SDR: w7QliJQz5JB0hdpfEP9QGWGt3ySBKuzJDFnztxRHOxrfw65wPrrQTBIh5Ryn9gmKzvv/iOMsQC
 YK+UfvrpZvBpT95tjpsk0my+Rmm0gKaDGjpnDPEH0lEInyXq1ag4dKzYU3Bhkc5oWwCs7ml77Y
 Zu/VYmQc9E/3dwx7ZsAuyBzCWAORw83EVeO1ZMMrW4ODh/Sy3KlNb5JWX4FhhVcAluGA+ut5kT
 Qq+QAjx/SDffYy3yI54sWFZc+nGaK1xwFPUM+Iv7MH8tGy5sKCMDTeUCIwt7nTmvs3oq4GwGZd
 FJg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 17:51:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LhhzL4JrCz1Rwnm
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:51:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657587118; x=1660179119; bh=RsBnmb3W9TjP5bmY3p5IB12iDxV4xR00dP7
        JOJqPLMo=; b=Ep/DAvPF1tAs0OL/RwB2XTleNm5pa9A6SflhiJupFvZYDW96CFm
        wkAEvMG4FnFv/bWanlaFDHVAm6WuSHiFf6HXOg7e/H0K+09Wyoo31tsB/nWWBWqs
        61NsLsTVRxLPQ6xcAsv4Bg01wMQ38g0m2CMiUamKtI+fiMzmXsgHOTGZNj8NGE+G
        zs4NJt5vNsfF3Iy5ZQHm50b17HJayR2WvsE7QSkVO/yN/dmsdGM8TOSWYFumD19Z
        /bp8zxbhzsHx15JZbu/hOEEz5PuwJUQ0AwZlWzQnsDrdomnwX758DorPhQC1+1mU
        Db4pLpAEGCsn62NoSah5ocOLUN0wzz3w/1w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id AMXBdotZO5GY for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 17:51:58 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LhhzK0hr3z1RtVk;
        Mon, 11 Jul 2022 17:51:56 -0700 (PDT)
Message-ID: <23369a70-43f3-a6a9-355f-13eba8eafbba@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 09:51:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <dc7d4d18-cd3c-46a6-2905-3bdbced11b53@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <dc7d4d18-cd3c-46a6-2905-3bdbced11b53@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 09:39, Bart Van Assche wrote:
> On 7/11/22 16:11, Damien Le Moal wrote:
>> Do you have these cases:
>> 1) host-managed disks:
>> SWR zones are *mandatory* so there is at least one. Thus read capacity
>> will return either 0 if there are no conventional zones (they are
>> optional) or the total capacity of the set of contiguous conventional
>> zones starting at lba 0. In either case, read capacity does not give you
>> the actual total capacity and you have to look at the report zones reply
>> max lba field.
> 
> Does the scsi_debug driver allow to create a host-managed disk with one 
> or more conventional zones and one or more sequential write required zones?

As per specs, conventional zones are optional. SWR zones are mandatory.
See this code in sdebug_device_create_zones():

	conv_capacity = (sector_t)sdeb_zbc_nr_conv << devip->zsize_shift;
        if (conv_capacity >= capacity) {

                pr_err("Number of conventional zones too large\n");

                return -EINVAL;

        }

        devip->nr_conv_zones = sdeb_zbc_nr_conv;

        devip->nr_seq_zones =
		ALIGN(capacity - conv_capacity, devip->zsize) >>
                              devip->zsize_shift;

        devip->nr_zones = devip->nr_conv_zones + devip->nr_seq_zones;

> 
>> Note that anyway, there are no drives out there that use RC BASIS = 0. I
>> had to hack a drive FW to implement it to test this code...
> 
> A JEDEC member is telling me that I should use RC BASIS = 0 for 
> host-managed zoned storage devices that only have sequential write 
> required zones. That sounds weird to me so I decided to take a look at 
> how the sd_zbc.c code handles RC BASIS.

RC BASIS = 0 makes sense only for host-managed drives that have
conventional zones starting at LBA 0 *AND* want to have some sort of
backward compatibility with a regular disk by advertizing only the
capacity of these conventional zones (all together, the set of
conventional zones starting at LBA 0 can be used like a regular disk).

That is a fairly narrow use case that is in my opinion not useful at all
given that the device type differs from regular disks anyway. For
host-managed disks, RC BASIS = 1 makes more sense. All SMR disks I know of
on the market use that.

> 
> Bart.
> 


-- 
Damien Le Moal
Western Digital Research
