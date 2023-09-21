Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0B1CE7D0B0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Sep 2023 22:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbjIUW03 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbjIUWJg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Sep 2023 18:09:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEAFA1F05;
        Thu, 21 Sep 2023 15:06:56 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068D3C433C8;
        Thu, 21 Sep 2023 22:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695334016;
        bh=kT0e72tCIEAvk5dMKfTfwqeHv4BEqCLZkqxf7evQD1o=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tcLNscMwCk0715c6IAzqV1CA3r2EpHPWR5HxweRata8zenEqlbQXqvTuK+nLkDQ71
         Can0UNlyCDH2HaATjUS9emOC1UvgZPji2ZSZUzy840sB5D+7E4JOfZvJRbDGybE+5y
         92+wA4ZKOmF2U9UL3x3cLSQUmp2W+VINnvie0kG1fgOfcPJuy0JFlDh96pZHB7xL3e
         JJk7ruqZKGGZxac140UJ2fcfNdeYqy+y2xwiJoH3BJAex/FTJ5eBafw64hUtSuObFj
         4mhtGVnc90+rmiWdhAz+hbrquDXh4Ay76f8c9zNsS1oq8/ViuV+7O7P/KSahV8PedS
         fqynT6FOj+s3w==
Message-ID: <3dd76ffc-d66d-f37f-27da-6c39edbc7e9c@kernel.org>
Date:   Thu, 21 Sep 2023 15:06:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v4 09/23] scsi: sd: Do not issue commands to suspended
 disks on shutdown
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230920135439.929695-1-dlemoal@kernel.org>
 <20230920135439.929695-10-dlemoal@kernel.org>
 <daa44a6b-59fd-4735-b881-7d182a7d2a41@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <daa44a6b-59fd-4735-b881-7d182a7d2a41@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/21 14:36, Bart Van Assche wrote:
> On 9/20/23 06:54, Damien Le Moal wrote:
>> If an error occurs when resuming a host adapter before the devices
>> attached to the adapter are resumed, the adapter low level driver may
>> remove the scsi host, resulting in a call to sd_remove() for the
>> disks of the host. This in turn results in a call to sd_shutdown() which
>> will issue a synchronize cache command and a start stop unit command to
>> spindown the disk. sd_shutdown() issues the commands only if the device
>> is not already suspended but does not check the power state for
>> system-wide suspend/resume. That is, the commands may be issued with the
>> device in a suspended state, which causes PM resume to hang, forcing a
>> reset of the machine to recover.
>>
>> Fix this by not calling sd_shutdown() in sd_remove() if the device
>> is not running.
> 
> Hi Damien,
> 
> I'd like to look into an alternative fix (after this patch series went 
> in) but I couldn't identify the call chain in the ATA resume code that 
> results in removal of the SCSI host. Can you please show me the call 
> chain that results in SCSI host removal if resuming fails?

See the pm80xx driver for which I recently fixed a resume issue. That is how I
found this problem with device removal: resuming the pm800xx HBA was failing and
the driver then called scsi_remove_host() to drop the ports and that led to
trying to removed sd devices that were still suspended.

> 
> Thanks,
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

