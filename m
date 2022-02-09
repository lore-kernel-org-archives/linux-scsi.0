Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC07C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 04:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345705AbiBIEHs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 23:07:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347376AbiBIDnz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 22:43:55 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A173C0401C3
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 19:34:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644377669; x=1675913669;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=ECyKNZsrCiAEyEZui/Gdj3P39GeKJgI9x3cOLnB6b1I=;
  b=KlVWb09EK5f1IL9yRBAiOO/0Xg+Sxw1Q4K+5LG+IUSzU+N6oj+N2Rbt+
   ieWwh1DBjTqk2Jrd3jHWnUmjJHZEuaj8R3udKKOZpeNjTf0E1e0fziawN
   wf8OLuAULIQ5vXE1o2OgpDLyhWM3k4CSGsH/3AsGzzVCzwugJYSyZcNDW
   mSK8jh22gI9BHGvSSkHx33cKLOE4IpiwwJ/BkLbFVpKC7VuhSGEn7cd0N
   iViGnSHudlDMQtx+OF6FAzPvoxEC6q/6cePxahERknkzG9cCD1Fe7MISp
   CtuZ3y7TbCmSQ3JjjvvuZTRzpfTPW3FpDAkCxSRrZlXgTljqQYX3y4Ufq
   A==;
X-IronPort-AV: E=Sophos;i="5.88,354,1635177600"; 
   d="scan'208";a="191411786"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 11:34:28 +0800
IronPort-SDR: SrUVEXCrzdXKrDM22GEH2B1Cm6z351zBf3CHdrojWs81ovhm0xeIbG4DEVEVhydGxWvCnuqT10
 C1ZyY08F+LTKQ0fgYwF2yYsMG5oqhT7hr3koHhNHx1ONGKm1lkMIflJ5pQARP3tznOgPnT7ooH
 1bfpnGnwQmA2huLfCf8ux8Yq76nKI98oiLFZ77o5qvg8TlWBDHupXLMz6brsnC9Dv/91dyIvnd
 F9fnCyVQNNGRhyCfB+S7FQ6zYy8UhjUCqTBh03S0Vznjxq4xW/lWIhbekKffaezXeHs/j2YqFM
 0ziGg86Et+QOTIEKm7KaiqPb
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 19:07:27 -0800
IronPort-SDR: SyXrE6+EUVcH9tGq1MX2Axq2Ob74Amt38FW7kuO3PFR3iPUoFiQVraJBsOeRnTCDeY8VfMh/d8
 YO5wMpDlypJbjJPrTFZF3eJ5BlmMxbX0VZ13T/AkyfPSecQVKxC6kCV5RQ7Ax6wYZKmcKJHoz/
 GZEZ/9lRPJ3Wo6UP8q9pgLzI6Lxsfb7CGodKMCZTJaGusc56EGjz4wqVkLLfjFBoFZErwL397P
 9arqRdZToLxJrGOFmIFSX8FlX6sAbVwajrOq5hIBH2QXjVOchMyuNApD+L0TQd8enwhb6k1dp+
 ab4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 19:34:29 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtlqS24lJz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 19:34:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644377667; x=1646969668; bh=ECyKNZsrCiAEyEZui/Gdj3P39GeKJgI9x3c
        OLnB6b1I=; b=YXp/9r3fixxNDIKmKPOYx3RrHjtLqJJIN+Ni5/IZLSK3Pd7t1ym
        ef3ynXSz0cM16OUsbc1TxHb2H1K6L9CxECfRDIzbP5sA2OHf9tmQK0IPe4yRjcXq
        NRYeKtiGZWhxTxvtO8nAG/MSiC1a4rWgTFETD7aE2RpbskOzdAuqAhYDlgK/iw9r
        0TcETHhaJLHuuFKvV8HMhH0pphtbLrm3uD0qWmp4HN2J8JFNOIX13JNv6Q86QIh5
        MlHdDqm/rYDm/YLOEllVzPwT9aShMxXl/W4iS+0EKRCNPRsXh/nG0O+c4PG8EiLW
        j3JtpHxQsXHPdBpFad8FYbtPJ/rBKSOP6Dg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Vlfp7EidAQ5X for <linux-scsi@vger.kernel.org>;
        Tue,  8 Feb 2022 19:34:27 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtlqQ1rVMz1Rwrw;
        Tue,  8 Feb 2022 19:34:26 -0800 (PST)
Message-ID: <8d7d36e6-66ac-a318-dfce-6d5b01b51f3c@opensource.wdc.com>
Date:   Wed, 9 Feb 2022 12:34:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH] scsi: csiostor: replace snprintf with sysfs_emit
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     Joe Perches <joe@perches.com>, davidcomponentone@gmail.com,
        jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        yang.guang5@zte.com.cn, jiapeng.chong@linux.alibaba.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
References: <d711ec5a5f416204079155666d2de49d43070897.1644287527.git.yang.guang5@zte.com.cn>
 <148a5448-71f1-4f39-834b-eb9283de0bfb@opensource.wdc.com>
 <f4b63b5a4177e38dd80f102f87bbec3ea77d9fe8.camel@perches.com>
 <0093948e-a408-61dd-3b51-524b6d112e35@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <0093948e-a408-61dd-3b51-524b6d112e35@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/09 12:16, Damien Le Moal wrote:
> On 2022/02/09 12:12, Joe Perches wrote:
>> On Wed, 2022-02-09 at 11:36 +0900, Damien Le Moal wrote:
>>> On 2/9/22 09:40, davidcomponentone@gmail.com wrote:
>>>> From: Yang Guang <yang.guang5@zte.com.cn>
>>>>
>>>> coccinelle report:
>>>> ./drivers/scsi/csiostor/csio_scsi.c:1433:8-16:
>>>> WARNING: use scnprintf or sprintf
>>>> ./drivers/scsi/csiostor/csio_scsi.c:1369:9-17:
>>>> WARNING: use scnprintf or sprintf
>>>> ./drivers/scsi/csiostor/csio_scsi.c:1479:8-16:
>>>> WARNING: use scnprintf or sprintf
>>>>
>>>> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
>> []
>>>> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
>> []
>>>> @@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
>>>>  	struct csio_hw *hw = csio_lnode_to_hw(ln);
>>>>  
>>>>  	if (csio_is_hw_ready(hw))
>>>> -		return snprintf(buf, PAGE_SIZE, "ready\n");
>>>> +		return sysfs_emit(buf, "ready\n");
>>>>  	else
>>>> -		return snprintf(buf, PAGE_SIZE, "not ready\n");
>>>> +		return sysfs_emit(buf, "not ready\n");
>>>
>>> While at it, you could remove the useless "else" above.
>>
>> Or not.  It's fine as is.  It's just a style preference.
> 
> It is. I dislike the useless line of code in this case :)
> 
>>
>> Another style option would be to use a ?: like any of
>>
>> 	return sysfs_emit(buf, "%sready\n", csio_is_hw_ready(hw) ? "" : "not ");
>> or
>> 	return sysfs_emit(buf, "%s\n", csio_is_hw_ready(hw) ? "ready" : "not ready");
>> or
>> 	return sysfs_emit(buf, csio_is_hw_ready(hw) ? "ready\n" : "not ready\n");
> 
> That is nice and can make that
> 	
> 	return sysfs_emit(buf, "%sready\n", csio_is_hw_ready(hw) ? "" : "not ");

Oops. You did have that one listed... Read too quickly...

> 
> too :)
> 


-- 
Damien Le Moal
Western Digital Research
