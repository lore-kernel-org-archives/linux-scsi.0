Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49126C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 05:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiGLFRI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jul 2022 01:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiGLFRH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jul 2022 01:17:07 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F7F820D5
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 22:17:05 -0700 (PDT)
Received: from mailpool-fe-01.fibernetics.ca (mailpool-fe-01.fibernetics.ca [208.85.217.144])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id BEC286F45C;
        Tue, 12 Jul 2022 05:17:04 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-01.fibernetics.ca (Postfix) with ESMTP id B012B51CD0;
        Tue, 12 Jul 2022 05:17:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-01.fibernetics.ca ([208.85.217.144])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id QaMPWxYxJkD4; Tue, 12 Jul 2022 05:17:04 +0000 (UTC)
Received: from [192.168.48.23] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id C20C54FF94;
        Tue, 12 Jul 2022 05:17:03 +0000 (UTC)
Message-ID: <c9143a39-e235-aa03-3dff-288a759e1504@interlog.com>
Date:   Tue, 12 Jul 2022 01:17:03 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-4-bvanassche@acm.org>
 <90cb95f0-7d8b-af10-9480-76a2163993e2@opensource.wdc.com>
 <dc7d4d18-cd3c-46a6-2905-3bdbced11b53@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <dc7d4d18-cd3c-46a6-2905-3bdbced11b53@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-07-11 20:39, Bart Van Assche wrote:
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
> Does the scsi_debug driver allow to create a host-managed disk with one or more 
> conventional zones and one or more sequential write required zones?

Yes. See https://doug-gilbert.github.io/scsi_debug.html

Example from that page:
    # modprobe scsi_debug max_luns=1 sector_size=512 zbc=managed zone_size_mb=8 
zone_nr_conv=3

   # sg_rep_zones -S /dev/sda
Number of conventional type zones: 3

Number of sequential write required type zones: 13

     Lowest starting LBA: 0xc000

Number of 'not write pointer' condition zones: 3

     Lowest starting LBA: 0x0

Number of empty condition zones: 13

     Lowest starting LBA: 0xc000

Number of used blocks in write pointer zones: 0x0

Size of all conventional zones: 25165824 bytes, 24.0 MiB, 0.03 GB

All zones are the same size. So if you rmmod that instance and do:

   # modprobe scsi_debug max_luns=1 sector_size=512 zbc=managed zone_size_mb=8 
zone_nr_conv=3 dev_size_mb=40


   # sg_rep_zones /dev/sda -S

Number of conventional type zones: 3

Number of sequential write required type zones: 2

     Lowest starting LBA: 0xc000

Number of 'not write pointer' condition zones: 3

     Lowest starting LBA: 0x0

Number of empty condition zones: 2

     Lowest starting LBA: 0xc000

Number of used blocks in write pointer zones: 0x0

Size of all conventional zones: 25165824 bytes, 24.0 MiB, 0.03 GB

So the 40 MiB was divided up into 3 conventional zones followed by
2 SWR zones, each of 8 MiB. So you have all the control needed to
specify 1 (zero ?) or more conventional zones and 1 or more SWR
zones.

Doug Gilbert

>> Note that anyway, there are no drives out there that use RC BASIS = 0. I
>> had to hack a drive FW to implement it to test this code...
> 
> A JEDEC member is telling me that I should use RC BASIS = 0 for host-managed 
> zoned storage devices that only have sequential write required zones. That 
> sounds weird to me so I decided to take a look at how the sd_zbc.c code handles 
> RC BASIS.
> 
> Bart.
> 

