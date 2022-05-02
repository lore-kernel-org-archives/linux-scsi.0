Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 192F6C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 12:55:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385127AbiEBM6f (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 08:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385138AbiEBM6d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 08:58:33 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7155715706
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 05:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1651496101; x=1683032101;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JUhkvda0JEwXdsLju2Qm64dHW4RVR82QZ/jIjIRhXSc=;
  b=nbbBmYr5ExzSwmrKaOY66ByuZ6oP+fxie70r9d5slize8M4GIdx07MZX
   EA6w2xBBKz2JMRi2Ci/qGngGN/noQqaHrm7KFIErSDWK0QOyhyc2pMLE9
   PW9D+bGAf3tBOwf6TN6Pv5yuLWF8AN+KbUCCxqgJSwHJV3tvYV7IMZJx2
   mU1dBOwoC32d4FJN+O1F23GjPdCFqpu1aArC954pbHB6KgKG3ieJnexG8
   XoLsFBdBJaRadtpVHgCRm4Km2hBzgYKRi8kLjPNwJNPQCG1u11pi/N6cO
   83Eg7Ol8/IfzaMaccM3W2Z2ovDgqGD9qROPHZgFRAj6QKMMN9PBpf+NLj
   A==;
X-IronPort-AV: E=Sophos;i="5.91,192,1647273600"; 
   d="scan'208";a="204205554"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 02 May 2022 20:54:58 +0800
IronPort-SDR: Bmh+E7KNacOlUvj4TXj7nkbwaJe8hLiNA/OzWr+/EwRVjppGqxqSsbQKktHSSVf8iBGdWbjGhu
 Gx9n2wgDIdDitwLzW/vkBcsJdrIrdXcbvJG4AZ8hHogXqLtm1pyQGtGVKBNQ8HT+AG25DM4giV
 SSVJeR5GpEPjZRnDW3Db1y6q+piJxPcPZxrqGGbzDF2IVTG7sZ1QV2Zdo2LUwZsKLVoNvBpCaj
 El/LrRhUujEDIs4jqK4M3K2i76qqTzT1TjK050St5o90Jj7ZdZcfYmPFdBIYe8aaco0ABhI/+K
 GcMNlpYvZNgdLeaiS9AUaITJ
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 05:25:02 -0700
IronPort-SDR: +bmQxnI8qe1/rnoiJBoeO01WyTJOKZQA0gMHC32sMkcRUmfaLNQtEr6PVzHr4mHQDy/Y4gbWLe
 qgFizfUy7UjcZVd/9Dp/bPpu0P1lLarEkGmY5GNNUbf6JUnPcUQa8I6ZdL65r9yYFbe4juVkCe
 z2eXUm0ZDlkWnMawBNNtKPLyQAjufVOdy0douBohp+jBayq2OgxBFmhMxFcdSxdnjdl2thunJo
 V02BTxQKSZJE21871cBAAI+4+CJx2kMtT+qoxg1HwMjb4FRo3jQOVuqKfrvZsF1GkQlN6alJL3
 b0k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 May 2022 05:54:59 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KsNNL2Ccsz1SVp3
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 05:54:58 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1651496097; x=1654088098; bh=JUhkvda0JEwXdsLju2Qm64dHW4RVR82QZ/j
        IjIRhXSc=; b=AIzuKRzwZQVGatHl1N9EZyzvTE342Ex2Xsdk8dBzDQ7YlT68E2V
        jV+TRKCrZd4GXYnfbCwGUwR95UrtQKr2UfhYl8T65OJz4IyX5umhChjtkVGNhb78
        fifJnXe4HbDMbtWoKXkttpTB62VrmW8Nx3y8woeYDf4X2F5K5ujyv36d1+FWxt7o
        sb9+KnDWiv764wZ2QpUYFR4rpzUKq6nGrx3NzsjOE6RgwxGpfrSzxy7XJaamCLU4
        cKra1DSpG8GFVPnxcIuK8yBXF6OG4IuYh9XditWd0i9eLs+PM4Hw+wMdbnKYLvAZ
        DOChJiv+tRmTFj4WmOuvf97nM+M1QTprY6Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id PdG5X1vNI5Aq for <linux-scsi@vger.kernel.org>;
        Mon,  2 May 2022 05:54:57 -0700 (PDT)
Received: from [10.225.81.200] (hq6rw33.ad.shared [10.225.81.200])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KsNNJ5Mpmz1Rvlc;
        Mon,  2 May 2022 05:54:56 -0700 (PDT)
Message-ID: <46e95412-9a79-51f8-3d52-caed4875d41f@opensource.wdc.com>
Date:   Mon, 2 May 2022 21:54:55 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v4 00/10] Add Copy offload support
Content-Language: en-US
To:     Dave Chinner <david@fromorbit.com>,
        Nitesh Shetty <nj.shetty@samsung.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, nitheshshetty@gmail.com,
        linux-kernel@vger.kernel.org
References: <CGME20220426101804epcas5p4a0a325d3ce89e868e4924bbdeeba6d15@epcas5p4.samsung.com>
 <20220426101241.30100-1-nj.shetty@samsung.com>
 <6a85e8c8-d9d1-f192-f10d-09052703c99a@opensource.wdc.com>
 <20220427124951.GA9558@test-zns>
 <20220502040951.GC1360180@dread.disaster.area>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220502040951.GC1360180@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/05/02 13:09, Dave Chinner wrote:
> On Wed, Apr 27, 2022 at 06:19:51PM +0530, Nitesh Shetty wrote:
>> O Wed, Apr 27, 2022 at 11:19:48AM +0900, Damien Le Moal wrote:
>>> On 4/26/22 19:12, Nitesh Shetty wrote:
>>>> The patch series covers the points discussed in November 2021 virtua=
l call
>>>> [LSF/MM/BFP TOPIC] Storage: Copy Offload[0].
>>>> We have covered the Initial agreed requirements in this patchset.
>>>> Patchset borrows Mikulas's token based approach for 2 bdev
>>>> implementation.
>>>>
>>>> Overall series supports =E2=80=93
>>>>
>>>> 1. Driver
>>>> - NVMe Copy command (single NS), including support in nvme-target (f=
or
>>>>     block and file backend)
>>>
>>> It would also be nice to have copy offload emulation in null_blk for =
testing.
>>>
>>
>> We can plan this in next phase of copy support, once this series settl=
es down.
>=20
> Why not just hook the loopback driver up to copy_file_range() so
> that the backend filesystem can just reflink copy the ranges being
> passed? That would enable testing on btrfs, XFS and NFSv4.2 hosted
> image files without needing any special block device setup at all...

That is a very good idea ! But that will cover only the non-zoned case. F=
or copy
offload on zoned devices, adding support in null_blk is probably the simp=
lest
thing to do.

>=20
> i.e. I think you're doing this compeltely backwards by trying to
> target non-existent hardware first....
>=20
> Cheers,
>=20
> Dave.


--=20
Damien Le Moal
Western Digital Research
