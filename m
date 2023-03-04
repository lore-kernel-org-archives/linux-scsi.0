Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C14EC61DA4
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Mar 2023 03:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCDDDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 22:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDDDL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 22:03:11 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF42105
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 19:03:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677898990; x=1709434990;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3lWiarmQOcrWaCsXEfjcrR1Yb/NXGJN/bPn+VTIy9ag=;
  b=MC40bXoIJBYPAtgs5f3yDDMGgY/PQaBy89NW4re5JvFVq111Ep3zooXI
   rvbkHUaH9APHz3F5W2prnMaW3GovkgdEJsWHDNreWa2aQwdimqy6V0cbZ
   9HjWY/GnjS8Ht+334yomxBHjbAw3x0KoOIMo0/0nYSFmVw8fZK9FRbRXl
   f1wYgUZ5PCZPqWOt0CS9/il6UhaVnbVnJpj2VFlRLvfescSGyDTCs7xjM
   rHSn3hIfDhUBbxtUNmnJAmxi0aZnQStsKndi91bxFTXZKFQ+3qfZNtGav
   u1aMM00SmO9E4+2eP+lyBBU0sF0XFlJwvXfGppesAxSqn95Uu0JU6XstE
   w==;
X-IronPort-AV: E=Sophos;i="5.98,232,1673884800"; 
   d="scan'208";a="223060155"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 04 Mar 2023 11:03:09 +0800
IronPort-SDR: E3LNNLVxx3LhyY6OXJv1+0poXGrCEuplv+yRGCzpr/+NOiDfDlB0e9lLYlGQTU5sfmEFkSn4AI
 lGiSh9qTp3Z+AKePgg+qd4nRIHLsH0rzJubIG7zw3tCjEcHfJ6LpfNRUkComvBjdg1kgc/Yts6
 u5OeRdI4ZXJBnNXyhPDT0FV8SdbwGfcDHao+ihA8hFj11HM/n0l646K7GRHfidwyEg2PFM3jT9
 TVfrRtd1tFpxCyZHY6wYnylUIUoxjsunwu+moupL1NzD4F6O41rM5HPBB557wlq21PK+0NrkvK
 kNw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2023 18:14:12 -0800
IronPort-SDR: H0q+UhNaai7yZBzVJdqzRkTJGInruxPRI1mFQke09DV9j8xqDDwwArF4Kb1v6f5CRPu4Ul3vzP
 cA/DCiZSwCEYnYSgR1SONkT/5cnMvRKYeWBZtGiBc7Ad6x0/bjEGaD7DSdPZ3Lf2w0cE8OtA1M
 mIWPLBDvCdhvx9ZNrubjR4BNZEIPi8CrEJ04CS++nmOB5uZKKJSxHjwOQrWvZKrl3eNhPbk1LW
 D4GIyptiiqqnVPtgs5iJOkd1smnpx5ppJCJ5tAHKSggMGEUsrmI0fTI+xtMoee3JfHpnAmRG5f
 iTo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Mar 2023 19:03:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PT8mF5t02z1Rwt8
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2023 19:03:09 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677898989; x=1680490990; bh=3lWiarmQOcrWaCsXEfjcrR1Yb/NXGJN/bPn
        +VTIy9ag=; b=ACOU67S22dvHE8KQqJQ0szaI4mruybzb96x7sAiUz1sX6XUDizO
        4kS3BZFmjgsDaLlq4+qiOPtUJr0AlFQMnUZtkboE2ktVxdh0CWwAaYhGk6E7go+z
        vlGr5XlBJpvuYgbE6Cr5/IjlehLJnWS64sKmQJmK+R9CWCGStozHBloOzb38JpDO
        SCkjQk0koKoZu0ObN5XiQEb7+XNdns1wxmdsI1Ze0LAue5WeAXHOBbjgtI/4fRSZ
        Oe3XF+fo6OLUibYZtoTzJkJFJAfmYqblUeJj7eG6kMJtKd6rW8VMpPDGQfLzaVZC
        ZJLjp9SWtASoedTbObQRRvToHO3GhJs5vCA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id NpkAW8v--zCy for <linux-scsi@vger.kernel.org>;
        Fri,  3 Mar 2023 19:03:09 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PT8mD3wxhz1RvLy;
        Fri,  3 Mar 2023 19:03:08 -0800 (PST)
Message-ID: <23ac3205-d92a-b32f-d0e3-29604cf859cd@opensource.wdc.com>
Date:   Sat, 4 Mar 2023 12:03:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] scsi: sd: Check physical sector alignment of
 sequential zone writes
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20230303014422.2466103-1-shinichiro.kawasaki@wdc.com>
 <20230303014422.2466103-2-shinichiro.kawasaki@wdc.com>
 <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <8be7cebf-a5dc-4742-1ef2-207d1797f2f3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/23 03:03, Bart Van Assche wrote:
> On 3/2/23 17:44, Shin'ichiro Kawasaki wrote:
>> +	if (sdkp->device->type == TYPE_ZBC && blk_rq_zone_is_seq(rq) &&
>> +	    (req_op(rq) == REQ_OP_WRITE || req_op(rq) == REQ_OP_ZONE_APPEND) &&
>> +	    (!IS_ALIGNED(blk_rq_pos(rq), pb_sectors) ||
>> +	     !IS_ALIGNED(blk_rq_sectors(rq), pb_sectors))) {
>> +		scmd_printk(KERN_ERR, cmd,
>> +			    "Sequential write request not aligned to the physical block size\n");
>> +		goto fail;
>> +	}
> 
> I vote -1 for this patch because my opinion is that we should not 
> duplicate checks that must be performed by the storage controller anyway 
> inside the sd driver.

Sure, the drive will fail this request, so the end result is the same. But what
is the point of issuing such unaligned request that we know will fail ? The
error message also make it easier to debug as it clarifies that this is not a
write pointer violation. So while this change is not critical, it does have
merits in my opinion.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

