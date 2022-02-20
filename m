Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F029DC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 01:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233344AbiBTBgR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 20:36:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232149AbiBTBgQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 20:36:16 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3BDB3CA62
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 17:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645320955; x=1676856955;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4nHGlwgRZuE9Lp4BMD81ppHcFElNhTj3jUMkQGGZ5k8=;
  b=T34RSnjBjEwrEDkOoThO3tsuYfkpuAO8RjQMAQbpXLXcVNc/AmC0EBpn
   c1TOErxvm50MGkJnT/nyDyR200UYBk1nL46wsP6xXXL9pATtxzew5pol3
   a3MnUU4e0ODGhLCWR27x7+Qx+wbqErTnaowVlJAsROQjn0U3ZSUgAENa7
   d9Ih5Pou6YHaU0zqh46FywSeIKTIw3kFr8+qCQNhd5BgPlJwqfCut3ZjS
   J0hgrszz6DcSPrhSJqfLNCYGlxz7i579BlRJ4yZiJhsRkXu84qDZysYyx
   GTUKJykLcq3Jlb1L+C+EZtC5uqge7LC6IMuLGJZehiShQJ0pO4sKw3qn+
   g==;
X-IronPort-AV: E=Sophos;i="5.88,382,1635177600"; 
   d="scan'208";a="198228952"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Feb 2022 09:35:55 +0800
IronPort-SDR: elkpUhXPmvUs6/slIySdRNDg2AvbhJQ/khI0EFN7iwo8cmAeydDuYbhxQ/17qpOlPpz1Qmtw0W
 ZI2NiI1/ceveoQOqEmzSqOv5viIwwTg99f3uaYz54Y/fhI6WXUROT/OfEVzRigcWBxyRIgny1C
 kkLixDqcdfwEm2E+H/uCuNolO2XKDgR+w2c13nOG/bNee/KBwGbtXhlG6kEo2m3Ja4r6+jTs2t
 S0DpM+ir7WbEV8JZOFoz+EIg2/Ay8VjbjI7Uv5yESBygM8EvnRQxBbqNsfekyC9/yIKTvZIAzt
 S3VaLHExjyhkgcQLyynGJXcf
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 17:08:38 -0800
IronPort-SDR: vk/3y2DQSQtvfAuyNyBLiBgNmkK6TuqkKZh8ujST3FmRXCVNIJXNrT+YmPd+fBpwtcbKyaDqjK
 wityWhjsCBXxBjoPuJ4ilN33+wH2Lzb9ATREupWjYjDejpAsxoY94ANNlS0ZKOrYNYfsil5KPL
 BuqPXRWyKEasrDWH5irNbYaXL6se8XRFGh1INhsmX1cN7soTIl24DtuXq0Dy+ZOwaMMaQNqIX8
 dzj/PQsRAAwMvFN6QgO8kYTl44g/6564MImhkC6nZ8Yqh7jzWDokXGSoaUNs/isQZcRfRhHs8I
 SOo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2022 17:35:56 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K1Sgb5w3Rz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 17:35:55 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645320955; x=1647912956; bh=4nHGlwgRZuE9Lp4BMD81ppHcFElNhTj3jUM
        kQGGZ5k8=; b=CRWGiFOYkXfdfAr5bbwI6vhVPdyeCybDs/IXSkE49kta3uSe+ES
        hK6s3vnsvOWs8+IYWKxYI0r87n8PDArUNgkIC86PEC09FcOI1gFHP/JirRThb6q4
        2XzX+HiXASgkA8scuPl632LFOnWEZZFOmM1Jy+a3qtb4LrigFS8X2gSt5HuVL25u
        VlNac/mdvX6HG1e7//CDNp1mFfEN1uUYKT80HVSw3s92YaWppoWBWL9UgmvUbgEB
        BysCc/56KbzGz9KQKu1LrCwBFspZT1Uo5Luni980lznkrB1/GoPb91kH05OqrRvY
        6reXX98fP8r7owGNeRFR9lTU0astCuJWR/g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id h7qx_1aAx1gk for <linux-scsi@vger.kernel.org>;
        Sat, 19 Feb 2022 17:35:55 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K1SgZ6Skwz1Rvlx;
        Sat, 19 Feb 2022 17:35:54 -0800 (PST)
Message-ID: <35b0d7bb-95d0-6c6a-2486-4d1336b9b98f@opensource.wdc.com>
Date:   Sun, 20 Feb 2022 10:35:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: sd: Unaligned partial completion
Content-Language: en-US
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
 <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
 <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/20/22 09:56, Douglas Gilbert wrote:
> On 2022-02-19 17:46, Martin K. Petersen wrote:
>>
>> Douglas,
>>
>>> What should the sd driver do when it gets the error in the subject
>>> line? Try again, and again, and again, and again ...?
>>>
>>> sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
>>> sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00
>>>
>>> Not very productive, IMO. Perhaps, after say 3 retries getting the
>>> _same_ resid, it might rescan that disk. There is a big hint in the
>>> logged data shown above: trying to READ 1 block (sector_sz=4096) and
>>> getting a resid of 3584. So it got back 512 bytes (again and again
>>> ...). The disk isn't mounted so perhaps it is being prepared. And
>>> maybe that preparation involved a MODE SELECT which changed the LB
>>> size in its block descriptor, prior to a FORMAT UNIT.
>>
>> The kernel doesn't inspect passthrough commands to track whether an
>> application is doing MODE SELECT or FORMAT UNIT. The burden is generally
>> on the application to do the right thing.
> 
> No, of course not. But the kernel should inspect all UAs especially the one
> that says: CAPACITY DATA HAS CHANGED !
> 
>> I'm assuming we're trying to read the partition table. Did the device
>> somehow get closed between the MODE SELECT and the FORMAT UNIT?
> 
> Nope, look up "format corrupt" state in SBC, there is a asc/ascq code for
> that, and it was _not_ reported in this case. The disk was fine after those
> two commands, it was sd or the scsi mid-level that didn't observe the UAs,
> hence the snafu. Sending a READ command after a CAPACITY DATA HAS CHANGE
> UA is "undefined behaviour" as the say in the C/C++ spec.
> 
> Also more and more settings in SCSI *** are giving the option to return an
> error (even MEDIUM ERROR) if the initiator is reading a block that has never
> been written. So if the sd driver is looking for a partition table (LBA 0 ?)
> then you have a chicken and egg problem that retrying will not solve.

It is not the scsi driver looking for partitions. This is generic block
layer code rescanning the partition table together with disk revalidate
after the bdev is closed. The disk revalidate should have caught the
change in LBA size, so it may be that the partition scan is before
revalidate instead of after... That would need checking.

>>> Another issue with that error message: what does "unaligned" mean in
>>> this context? Surely it is superfluous and "Partial completion" is
>>> more accurate (unless the resid is negative).
>>
>> The "unaligned" term comes from ZBC.
> 
> The sd driver should take its lead from SBC, not ZBC.

It was observed in the past that some HBAs (Broadcom I think it was)
returned a resid not aligned to the LBA size with 4Kn disks, making it
impossible to restart the command to process the reminder of the data.
This problem was especially apparent with ZBC disks writes.

So unaligned here is not just for ZBC disks.

> 
> Doug Gilbert
> 
> 
> *** for example, FORMAT UNIT (FFMT=2)
> 


-- 
Damien Le Moal
Western Digital Research
