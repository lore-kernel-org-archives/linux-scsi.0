Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3095EE3F06
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:51:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbjIKUu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236982AbjIKLsW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 07:48:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 564EDCDD;
        Mon, 11 Sep 2023 04:48:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A7BCC433CB;
        Mon, 11 Sep 2023 11:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694432897;
        bh=Ka8kxyqihersE36rdzLjT/pV65yW2aDcxlKjtq+pLA0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=MtAtZOrGGcZUa38EeLQZ1SAz27ziuqGgb5GAYyV1SdPhDiihIQbhPoiT9HLvPcJZT
         Y0IJ6cUuwaW0yoCfH3GiYOmG1KvLKQhyDT8La6ZHciZaaH1s/aAuaGbCZbcR8e9TZa
         RIY09wf9CQeiY76W1iZzlqbBykGP/YLeRKNxplI1vgN3bebwbkCET9NHTb+UOtczgo
         lI7zRH3qANlVODl7j5TfNeHsQrkh0FxP99m/3NdJ214/JBTbiYj9BUzYZEE5MdGeVY
         JjFJ/7gKbjgptCWyzN3txkvZJ2IGyujxxD3+V6N9T8M3P40gP7l0I3xH0dTASiL3Aq
         U0NIZgwg9pWug==
Message-ID: <f56e4e80-1905-0dcd-fb59-aaba7a9f8adb@kernel.org>
Date:   Mon, 11 Sep 2023 20:48:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 03/19] ata: libata-scsi: link ata port and scsi device
To:     John Garry <john.g.garry@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-4-dlemoal@kernel.org>
 <e8ca70d1-9c88-4a80-83e4-a65f4bbe6b72@suse.de>
 <8874a3d5-355e-c354-fd85-0dfa7ab77b54@kernel.org>
 <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <5825b4b9-0bc8-4c27-d576-070c7113e1f8@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/11/23 19:38, John Garry wrote:
> On 11/09/2023 07:48, Damien Le Moal wrote:
>>>>   #define ATA_BASE_SHT(drv_name)                    \
>>> I do understand the rationale here, as the relationship between ata port and
>>> scsi devices are blurred. Question is: blurred by what?
>>> Is it the libata/SAS duality where SCSI devices will have a different
>>> ancestry for libata and libsas?
>>> If so, why don't we need the 'link' mechanism for SAS?
>>> Or is it something else?
>> On scsi, ancestry from Scsi_Host is clear: host->target->device->disk.
>> For ATA, it is also clear: port->link->device
>>
>> The relationship is that ata port has its own Scsi_Host, but no "family"
>> relationship here. They are just "friends", so scsi disk and ata_port have no
>> direct ancestry. Adding the link creates that.
>>
>> libsas does not need the link because it does its own PM management of the
>> ports, not relying on PM to order things.
>>
> 
> For hisi_sas v3, RPM is supported and a link was required to be added in 
> that driver between the sdev and those host controller device - see 
> 16fd4a7c59. And that is for a similar reason here. I see that we already 
> have an ancestry for libata between ata_dev -> ata_link -> ata_port -> 
> ata_host dev, so it seems reasonable to add ata_dev  <-> sdev dependency 
> here.

libata creates a link between ata_port and sdev. This is not very natural, but
as I said in the cover letter, the power management model is weird as everything
is per port, even if a port has multiple devices. Nevertheless, I tried to apply
the same for libsas but failed: if I add the link creation in the slave_alloc
method, I fail to get the scsi disks to show up (no /dev/sdX device files). Not
sure why. That was with my pm8001 adapter, which is the only libsas one I have.

Side note: having an ata_debug (ata equivalent of scsi_debug) driver that could
act as a pure libata driver or as a libsas adapter would really be awesome for
this kind of tests :)

> I think that this should really be added for all libsas drivers which 
> support RPM - pm8001 is missing, IIRC.

Will try again tomorrow looking at hisi driver for inspiration. The other thing
I need to better understand is how the suspend & resume operations of libsas get
triggered. For suspend, it is easy-ish, but for resume, it seems to be tightly
coupled with discovery, so the the adapter resume (scsi host class resume ?).
If that is the case, then that is done *before* the scsi_dev resume because of
the existing device link dependencies. So I am not yet entirely convinced that
adding a link between ata_port and sdev will serve any purpose now that the
asynchronous libata resume is fixed and synchronized with the scsi disk
resume... Will dig further.

That said, it may be good to move libsas suspend/resume fixes to another patch
series. There is an outstanding regression/problem for pure libata devices that
this series fixes. So would like to get the fixes patches in Linus tree ASAP.

Cheers.

-- 
Damien Le Moal
Western Digital Research

