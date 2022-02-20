Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1805EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 07:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232942AbiBTHRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Feb 2022 02:17:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiBTHRS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Feb 2022 02:17:18 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A80E102D
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 23:16:57 -0800 (PST)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id AE4AD61462;
        Sun, 20 Feb 2022 07:16:56 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id A64663C0FD;
        Sun, 20 Feb 2022 07:16:56 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id huKa3A0lye_5; Sun, 20 Feb 2022 07:16:56 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 2FC663C0FB;
        Sun, 20 Feb 2022 07:16:56 +0000 (UTC)
Message-ID: <3d57d895-d133-87a5-23a6-721641711000@interlog.com>
Date:   Sun, 20 Feb 2022 02:16:54 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: sd: Unaligned partial completion
Content-Language: en-CA
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
 <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
 <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
 <35b0d7bb-95d0-6c6a-2486-4d1336b9b98f@opensource.wdc.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <35b0d7bb-95d0-6c6a-2486-4d1336b9b98f@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-02-19 20:35, Damien Le Moal wrote:
> On 2/20/22 09:56, Douglas Gilbert wrote:
>> On 2022-02-19 17:46, Martin K. Petersen wrote:
>>>
>>> Douglas,
>>>
>>>> What should the sd driver do when it gets the error in the subject
>>>> line? Try again, and again, and again, and again ...?
>>>>
>>>> sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
>>>> sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00
>>>>
>>>> Not very productive, IMO. Perhaps, after say 3 retries getting the
>>>> _same_ resid, it might rescan that disk. There is a big hint in the
>>>> logged data shown above: trying to READ 1 block (sector_sz=4096) and
>>>> getting a resid of 3584. So it got back 512 bytes (again and again
>>>> ...). The disk isn't mounted so perhaps it is being prepared. And
>>>> maybe that preparation involved a MODE SELECT which changed the LB
>>>> size in its block descriptor, prior to a FORMAT UNIT.
>>>
>>> The kernel doesn't inspect passthrough commands to track whether an
>>> application is doing MODE SELECT or FORMAT UNIT. The burden is generally
>>> on the application to do the right thing.
>>
>> No, of course not. But the kernel should inspect all UAs especially the one
>> that says: CAPACITY DATA HAS CHANGED !
>>
>>> I'm assuming we're trying to read the partition table. Did the device
>>> somehow get closed between the MODE SELECT and the FORMAT UNIT?
>>
>> Nope, look up "format corrupt" state in SBC, there is a asc/ascq code for
>> that, and it was _not_ reported in this case. The disk was fine after those
>> two commands, it was sd or the scsi mid-level that didn't observe the UAs,
>> hence the snafu. Sending a READ command after a CAPACITY DATA HAS CHANGE
>> UA is "undefined behaviour" as the say in the C/C++ spec.
>>
>> Also more and more settings in SCSI *** are giving the option to return an
>> error (even MEDIUM ERROR) if the initiator is reading a block that has never
>> been written. So if the sd driver is looking for a partition table (LBA 0 ?)
>> then you have a chicken and egg problem that retrying will not solve.
> 
> It is not the scsi driver looking for partitions. This is generic block
> layer code rescanning the partition table together with disk revalidate
> after the bdev is closed. The disk revalidate should have caught the
> change in LBA size, so it may be that the partition scan is before
> revalidate instead of after... That would need checking.
> 
>>>> Another issue with that error message: what does "unaligned" mean in
>>>> this context? Surely it is superfluous and "Partial completion" is
>>>> more accurate (unless the resid is negative).
>>>
>>> The "unaligned" term comes from ZBC.
>>
>> The sd driver should take its lead from SBC, not ZBC.
> 
> It was observed in the past that some HBAs (Broadcom I think it was)
> returned a resid not aligned to the LBA size with 4Kn disks, making it
> impossible to restart the command to process the reminder of the data.

But restarting the READ of one "logical block" at LBA 0 when the kernel
thought that was 4096 bytes and the drive returned 512 bytes is exactly
what I observed; again and again.

IMO the kernel should be prepared for surprises when reading LBA 0,
such as:
   - the block size is not what it was expecting [as in this case]
   - that block has never been written and the disk has been told to
     return an (IO) error in that case

It is a pity that a SCSI pass-through like the bsg or sg driver cannot
establish its own I_T nexus, separate from the I_T nexus that the
sd driver uses. The reason is that if an I_T nexus causes a UA (e.g.
MODE SELECT change LB size) then the next command (apart from
INQUIRY, REPORT LUNS and friends) will _not_ receive that UA. [Other
I_T nexi will receive that UA.]

> This problem was especially apparent with ZBC disks writes. > So unaligned here is not just for ZBC disks.

SCSI data-out and data-in transfers are inherently unaligned (or byte
aligned) but I suppose the DMA silicon in the HBA may have some
alignment requirements.

> 
>>
>> Doug Gilbert
>>
>>
>> *** for example, FORMAT UNIT (FFMT=2)
>>
> 
> 

