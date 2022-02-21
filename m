Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD364C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Feb 2022 00:13:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239104AbiBUANc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Feb 2022 19:13:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiBUANb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Feb 2022 19:13:31 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86F6A344D8
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 16:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645402388; x=1676938388;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=lGMmzzlY0lJRAvCgGqxr8sNyXO1+5FsBQVwYorgZuVQ=;
  b=kxE1BHwN6Lm0PgxP+EpVmXnz++v872aaGyDwUpGxfpm6ee6fBrOp/EF0
   yzmnwkiTM0FOqRejnuScnlkQOcO1U74jXCv5goD0GBEhYq/g7+vnprVZX
   x0KXoQH77+XeR8LvcB3/j+ioyP6z9Iii7/ecUhEPZ6z1NXAPEgvzrsRY9
   fV1lfF7suPbcEmlv/kT1clzIZA4CXK3Pc4Ym7kfyFp/Wy+2ic7hk97F5Z
   VUMRJylfRcnx8dQquyWPScXRux1rBUwELmFfCTNN6DEX6rQppyiig7PzD
   BQXGILiiecnen+gkDEiWlYCqY/Y0j1C28LbCLO3zm0npMlEdW09PRUyhR
   g==;
X-IronPort-AV: E=Sophos;i="5.88,384,1635177600"; 
   d="scan'208";a="193474913"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Feb 2022 08:13:08 +0800
IronPort-SDR: LlPW+TVpyt51S2Iz7AcLthFysOQWqvrpYv9LY+RtEte1mkYl/JxaJVBCrLlkiZqX162Qw2/0y2
 LXLQFhPBZnNBdR7a/Gb4nfhsqYrKoL8XZSAFkDJtvs4jJNHxO/zBZ1gl54VovWJ038Z0eN0OvO
 JUwGWMnvE231j7JZ2VjvZLMiRFvSI6HghSw48ca4Fzhl/ZbI78YnlKwN1bkTFP/oX+el/ucX5l
 088wPMoceYhn01+zmoftV8ftnCfvNM9inwA5+/s3dxGPMxXH0pgadmwcII4m39ZHsgNXpv1Rlt
 BW1wt3QV0NhGkuOLyxtpOC/1
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 15:44:43 -0800
IronPort-SDR: j5ZsAeHCIxNbhiRFRTNisBmzwya/Gqz+xHGAQSWK0yhHAJveNQfa+ZvDLFXTHJshXoM5m/Dy1Y
 FLEHNRHB0Si1TI931QWQKamLk9jfcpcFhD951G3l6McIRSyZaeyrALnMKKOPgnt+pIlRAKzVDm
 feM10NLwXtEh3OXrbWXoG119ip1nHfVaRB1nyrJQCajT3BmW4Fqw578eNp1akWvkTTsf59zaly
 qIFnYTTxVMSPVJOjfDFywTxyqtwph+qDDNhLJpk+zsqdkuhcVGWeCuIPcFBkV/z5f3vxcBiH/J
 XFc=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 16:13:09 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K22nc5FFtz1Rwrw
        for <linux-scsi@vger.kernel.org>; Sun, 20 Feb 2022 16:13:08 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645402388; x=1647994389; bh=lGMmzzlY0lJRAvCgGqxr8sNyXO1+5FsBQVw
        YorgZuVQ=; b=tVF13NnyCTqojBnVrWwsFhvoNh7SgncjnK/QIbUHERm/aBU7+DG
        dSzeFqaf92ojTgIxh+NqdazG/pnX6MgdMnuOPeGdSHZ7Qe2OHxz7xcyfQNABoKuJ
        t0rlK1mGz8a555owX1C6mGEMLIqfix6Fl4U2XJVFyd5yaQ9asUE5USm15RrW/Y5+
        U/5ToY/IUidRnx+XUxCucBtdYe74zNR8dwQtTwMSYfh0cSYW4WDyJxtm41znIx/W
        cnKDkKDl9gvE1wDkNu8O1PtCIsjEspfSyy7v1dhCNEw5pnFP2e9QPy3Ee/zwNAHY
        AAclpyvjJoBSYYko8N3yPEJJ3jGc9Soi4ig==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id agV8jAmd8hOv for <linux-scsi@vger.kernel.org>;
        Sun, 20 Feb 2022 16:13:08 -0800 (PST)
Received: from [10.89.87.236] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.87.236])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K22nb5t65z1Rvlx;
        Sun, 20 Feb 2022 16:13:07 -0800 (PST)
Message-ID: <6d2b59af-ae8d-fb8c-cc9c-6ec436d3ffef@opensource.wdc.com>
Date:   Mon, 21 Feb 2022 09:13:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: sd: Unaligned partial completion
Content-Language: en-US
To:     dgilbert@interlog.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
 <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
 <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
 <35b0d7bb-95d0-6c6a-2486-4d1336b9b98f@opensource.wdc.com>
 <3d57d895-d133-87a5-23a6-721641711000@interlog.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <3d57d895-d133-87a5-23a6-721641711000@interlog.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/02/20 16:16, Douglas Gilbert wrote:
> On 2022-02-19 20:35, Damien Le Moal wrote:
>> On 2/20/22 09:56, Douglas Gilbert wrote:
>>> On 2022-02-19 17:46, Martin K. Petersen wrote:
>>>>
>>>> Douglas,
>>>>
>>>>> What should the sd driver do when it gets the error in the subject
>>>>> line? Try again, and again, and again, and again ...?
>>>>>
>>>>> sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
>>>>> sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00
>>>>>
>>>>> Not very productive, IMO. Perhaps, after say 3 retries getting the
>>>>> _same_ resid, it might rescan that disk. There is a big hint in the
>>>>> logged data shown above: trying to READ 1 block (sector_sz=4096) and
>>>>> getting a resid of 3584. So it got back 512 bytes (again and again
>>>>> ...). The disk isn't mounted so perhaps it is being prepared. And
>>>>> maybe that preparation involved a MODE SELECT which changed the LB
>>>>> size in its block descriptor, prior to a FORMAT UNIT.
>>>>
>>>> The kernel doesn't inspect passthrough commands to track whether an
>>>> application is doing MODE SELECT or FORMAT UNIT. The burden is generally
>>>> on the application to do the right thing.
>>>
>>> No, of course not. But the kernel should inspect all UAs especially the one
>>> that says: CAPACITY DATA HAS CHANGED !
>>>
>>>> I'm assuming we're trying to read the partition table. Did the device
>>>> somehow get closed between the MODE SELECT and the FORMAT UNIT?
>>>
>>> Nope, look up "format corrupt" state in SBC, there is a asc/ascq code for
>>> that, and it was _not_ reported in this case. The disk was fine after those
>>> two commands, it was sd or the scsi mid-level that didn't observe the UAs,
>>> hence the snafu. Sending a READ command after a CAPACITY DATA HAS CHANGE
>>> UA is "undefined behaviour" as the say in the C/C++ spec.
>>>
>>> Also more and more settings in SCSI *** are giving the option to return an
>>> error (even MEDIUM ERROR) if the initiator is reading a block that has never
>>> been written. So if the sd driver is looking for a partition table (LBA 0 ?)
>>> then you have a chicken and egg problem that retrying will not solve.
>>
>> It is not the scsi driver looking for partitions. This is generic block
>> layer code rescanning the partition table together with disk revalidate
>> after the bdev is closed. The disk revalidate should have caught the
>> change in LBA size, so it may be that the partition scan is before
>> revalidate instead of after... That would need checking.
>>
>>>>> Another issue with that error message: what does "unaligned" mean in
>>>>> this context? Surely it is superfluous and "Partial completion" is
>>>>> more accurate (unless the resid is negative).
>>>>
>>>> The "unaligned" term comes from ZBC.
>>>
>>> The sd driver should take its lead from SBC, not ZBC.
>>
>> It was observed in the past that some HBAs (Broadcom I think it was)
>> returned a resid not aligned to the LBA size with 4Kn disks, making it
>> impossible to restart the command to process the reminder of the data.
> 
> But restarting the READ of one "logical block" at LBA 0 when the kernel
> thought that was 4096 bytes and the drive returned 512 bytes is exactly
> what I observed; again and again.

As I said, it may be because the block layer disk revalidate call and partition
scan are reversed, or not synchronized, causing the partition scan read to be
dealt with without the sector size yet being updated in the sd driver. We should
check the block layer. Will have a look.

> 
> IMO the kernel should be prepared for surprises when reading LBA 0,
> such as:
>    - the block size is not what it was expecting [as in this case]
>    - that block has never been written and the disk has been told to
>      return an (IO) error in that case
> 
> It is a pity that a SCSI pass-through like the bsg or sg driver cannot
> establish its own I_T nexus, separate from the I_T nexus that the
> sd driver uses. The reason is that if an I_T nexus causes a UA (e.g.
> MODE SELECT change LB size) then the next command (apart from
> INQUIRY, REPORT LUNS and friends) will _not_ receive that UA. [Other
> I_T nexi will receive that UA.]
> 
>> This problem was especially apparent with ZBC disks writes. > So unaligned here is not just for ZBC disks.
> 
> SCSI data-out and data-in transfers are inherently unaligned (or byte
> aligned) but I suppose the DMA silicon in the HBA may have some
> alignment requirements.

Sure, I know that. But the kernel never asks for unaligned read/writes and the
disk will certainly never return a half backed sector for reads or partially
writes sectors. So getting back a resid that is not aligned on the LBA size is a
gross bug from the HBA and we should not allow that to go unnoticed.

> 
>>
>>>
>>> Doug Gilbert
>>>
>>>
>>> *** for example, FORMAT UNIT (FFMT=2)
>>>
>>
>>
> 


-- 
Damien Le Moal
Western Digital Research
