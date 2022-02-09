Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9923CC43219
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Feb 2022 04:07:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345836AbiBIEHx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Feb 2022 23:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346067AbiBIDVg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Feb 2022 22:21:36 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7315EC0613CC
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 19:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644376895; x=1675912895;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=bG51Nl2Ql0sNOokMZGbhgn1+otGBW36quGu5gynwTYs=;
  b=q2s2Uj2PLLsycVF9VNtDH6W4XJPPugdi/SP4JYdQ9f2IMBntoYr9SHWr
   OVXW78qV9z7p+0XtXBZuIr4nUbQWbsLsqbR5C9+YwEBB21br7P2SSsHJe
   7CX+7sgKjLxpxlCFbLaNYU8oF6KyoUhbQtQqk206eOQfqYCv8FBtWwBKG
   iB3tAXzdPxMOar/9Xs7wSA7cX8b865S6oJ79HTkclmzblPdtW6y2yDTQt
   pHBRhkcohUFKdcxrXBu9Av3pa1W4MiCQG5090q5T67as0BYMxl3hp1I9j
   Pouc0NYyVubpa/CqcNTAkDH6fN6hd7ZUHT3qAQ5IIjkUZTKxs4wJP+UBQ
   Q==;
X-IronPort-AV: E=Sophos;i="5.88,354,1635177600"; 
   d="scan'208";a="191410510"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 09 Feb 2022 11:16:32 +0800
IronPort-SDR: HxKdpEFDQ0ObNeujTxuLH6UgrDu8wz2OSP5OrHawE8MxQ18BVtqryShT29P/br5XKZR51G8U3c
 q7AsRMG8GPY3EjzE1jUTfZSxbA6ypHiVLhLhi0hC91McSZIf/hOF7wlFFoSI5iPwmZDP1foi8n
 PCIWg//6thnhLih44GEFpLtSKx17/6w8Mf2fAxOv+WilDk7WcbvQUT3g8zN+U3G8ywy6VV42Gg
 p0tnCpZ996LEa13oMqmRbu4ViQmGHZ6d/ogKA5VREYe536L28+iosgwVE1v+wUm0IWROuTO3Dk
 572qibO/9UCOp8mBa6ULu8L+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 18:49:31 -0800
IronPort-SDR: 3f6XVCr7jDAFC1qfMPp+A2hlgJ8Cq+3nE6gUvk9CwmoUOm429Vwz3ghLQQJUHBAYvkJmRY5eCl
 EYfptKxq5TNpEsAvWyrlj2D+HbeGKcCXmgwHKEuaInI21ZTCY5UB55cgwzAPOuUvfRB9sxD3gh
 bNmO1kmiJuWtWpBqiGv08/Wu4WL3kNie9gQeJ2HgZRC6Hen1gZJvWmaD4nkDvWN+7sS26tBslJ
 +bPn8bqmljQcXR2+d2/ddfmHnOs0+9D9Er3m9TGdvxLVOKVf18A8Csre/Ve1W/701wlmUhVXDY
 am4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2022 19:16:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JtlQl6Ckwz1SVp5
        for <linux-scsi@vger.kernel.org>; Tue,  8 Feb 2022 19:16:31 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1644376591; x=1646968592; bh=bG51Nl2Ql0sNOokMZGbhgn1+otGBW36quGu
        5gynwTYs=; b=m3VC1PkiFVw9+a+cl8Pi88PT/aN/rN+M5jTPRrlPzqSu/NYiSoi
        x1u6Bf8v0MhjmzI75pNzZo0PehdxR06PfiUJmcYap7M0pXDYkUFXqVeHW02xo03p
        47z4nQUO1/qkpwnK6iFRpk8D4ueFt3MF3tdqPfw5rx4JCefQp22/Ru3kiLmPfqGe
        jMMo1e+bS5FeQNxvHyjRJY5FaD3djeM7+n6eCUwMTY7dxTim/0di7QKkYGZX/eBc
        0kHO0XFTj6elfZMls6Er8bDNyXTHs7+U8G7kdc7A2O3ArkMRTaHn+e/k9qT4fGYk
        HHcbW21/0zuEwzg6jjm7JWo1kNrHCQIPZWQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id if0-J87K5dfS for <linux-scsi@vger.kernel.org>;
        Tue,  8 Feb 2022 19:16:31 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JtlQj448cz1Rwrw;
        Tue,  8 Feb 2022 19:16:29 -0800 (PST)
Message-ID: <0093948e-a408-61dd-3b51-524b6d112e35@opensource.wdc.com>
Date:   Wed, 9 Feb 2022 12:16:27 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH] scsi: csiostor: replace snprintf with sysfs_emit
Content-Language: en-US
To:     Joe Perches <joe@perches.com>, davidcomponentone@gmail.com,
        jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        yang.guang5@zte.com.cn, jiapeng.chong@linux.alibaba.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
References: <d711ec5a5f416204079155666d2de49d43070897.1644287527.git.yang.guang5@zte.com.cn>
 <148a5448-71f1-4f39-834b-eb9283de0bfb@opensource.wdc.com>
 <f4b63b5a4177e38dd80f102f87bbec3ea77d9fe8.camel@perches.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <f4b63b5a4177e38dd80f102f87bbec3ea77d9fe8.camel@perches.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/09 12:12, Joe Perches wrote:
> On Wed, 2022-02-09 at 11:36 +0900, Damien Le Moal wrote:
>> On 2/9/22 09:40, davidcomponentone@gmail.com wrote:
>>> From: Yang Guang <yang.guang5@zte.com.cn>
>>>
>>> coccinelle report:
>>> ./drivers/scsi/csiostor/csio_scsi.c:1433:8-16:
>>> WARNING: use scnprintf or sprintf
>>> ./drivers/scsi/csiostor/csio_scsi.c:1369:9-17:
>>> WARNING: use scnprintf or sprintf
>>> ./drivers/scsi/csiostor/csio_scsi.c:1479:8-16:
>>> WARNING: use scnprintf or sprintf
>>>
>>> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> []
>>> diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
> []
>>> @@ -1366,9 +1366,9 @@ csio_show_hw_state(struct device *dev,
>>>  	struct csio_hw *hw = csio_lnode_to_hw(ln);
>>>  
>>>  	if (csio_is_hw_ready(hw))
>>> -		return snprintf(buf, PAGE_SIZE, "ready\n");
>>> +		return sysfs_emit(buf, "ready\n");
>>>  	else
>>> -		return snprintf(buf, PAGE_SIZE, "not ready\n");
>>> +		return sysfs_emit(buf, "not ready\n");
>>
>> While at it, you could remove the useless "else" above.
> 
> Or not.  It's fine as is.  It's just a style preference.

It is. I dislike the useless line of code in this case :)

> 
> Another style option would be to use a ?: like any of
> 
> 	return sysfs_emit(buf, "%sready\n", csio_is_hw_ready(hw) ? "" : "not ");
> or
> 	return sysfs_emit(buf, "%s\n", csio_is_hw_ready(hw) ? "ready" : "not ready");
> or
> 	return sysfs_emit(buf, csio_is_hw_ready(hw) ? "ready\n" : "not ready\n");

That is nice and can make that
	
	return sysfs_emit(buf, "%sready\n", csio_is_hw_ready(hw) ? "" : "not ");

too :)

-- 
Damien Le Moal
Western Digital Research
