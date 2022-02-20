Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A053EC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Feb 2022 00:56:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbiBTA4r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 19 Feb 2022 19:56:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiBTA4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 19 Feb 2022 19:56:46 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D0A369D0
        for <linux-scsi@vger.kernel.org>; Sat, 19 Feb 2022 16:56:26 -0800 (PST)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id A873261514;
        Sun, 20 Feb 2022 00:56:24 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id A026D3BF81;
        Sun, 20 Feb 2022 00:56:24 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id nJMyc30S1I_2; Sun, 20 Feb 2022 00:56:24 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 1DB303BF79;
        Sun, 20 Feb 2022 00:56:24 +0000 (UTC)
Message-ID: <22a343a6-f659-3938-b83e-a3842486bbb8@interlog.com>
Date:   Sat, 19 Feb 2022 19:56:23 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: sd: Unaligned partial completion
Content-Language: en-CA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     SCSI development list <linux-scsi@vger.kernel.org>
References: <ae40bef0-702f-04c4-9219-47502c37d977@interlog.com>
 <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <yq11qzyh4zj.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-02-19 17:46, Martin K. Petersen wrote:
> 
> Douglas,
> 
>> What should the sd driver do when it gets the error in the subject
>> line? Try again, and again, and again, and again ...?
>>
>> sd 2:0:1:0: [sdb] Unaligned partial completion (resid=3584, sector_sz=4096)
>> sd 2:0:1:0: [sdb] tag#407 CDB: Read(16) 88 00 00 00 00 00 00 00 00 00 00 00 00 01 00
>>
>> Not very productive, IMO. Perhaps, after say 3 retries getting the
>> _same_ resid, it might rescan that disk. There is a big hint in the
>> logged data shown above: trying to READ 1 block (sector_sz=4096) and
>> getting a resid of 3584. So it got back 512 bytes (again and again
>> ...). The disk isn't mounted so perhaps it is being prepared. And
>> maybe that preparation involved a MODE SELECT which changed the LB
>> size in its block descriptor, prior to a FORMAT UNIT.
> 
> The kernel doesn't inspect passthrough commands to track whether an
> application is doing MODE SELECT or FORMAT UNIT. The burden is generally
> on the application to do the right thing.

No, of course not. But the kernel should inspect all UAs especially the one
that says: CAPACITY DATA HAS CHANGED !

> I'm assuming we're trying to read the partition table. Did the device
> somehow get closed between the MODE SELECT and the FORMAT UNIT?

Nope, look up "format corrupt" state in SBC, there is a asc/ascq code for
that, and it was _not_ reported in this case. The disk was fine after those
two commands, it was sd or the scsi mid-level that didn't observe the UAs,
hence the snafu. Sending a READ command after a CAPACITY DATA HAS CHANGE
UA is "undefined behaviour" as the say in the C/C++ spec.

Also more and more settings in SCSI *** are giving the option to return an
error (even MEDIUM ERROR) if the initiator is reading a block that has never
been written. So if the sd driver is looking for a partition table (LBA 0 ?)
then you have a chicken and egg problem that retrying will not solve.

>> Another issue with that error message: what does "unaligned" mean in
>> this context? Surely it is superfluous and "Partial completion" is
>> more accurate (unless the resid is negative).
> 
> The "unaligned" term comes from ZBC.

The sd driver should take its lead from SBC, not ZBC.

Doug Gilbert


*** for example, FORMAT UNIT (FFMT=2)

