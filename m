Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE6CE7D0C5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 06:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbjIZGAf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 02:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjIZGAe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 02:00:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF690F0;
        Mon, 25 Sep 2023 23:00:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001F8C433C7;
        Tue, 26 Sep 2023 06:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695708027;
        bh=JOdeTOHliFdzR8vYJRDRtCxpnixRIe/pqbjuXlopTLU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YZo+bDSZ0kc4N16EsmwY2nMg5EAKcY9I2ZIgd/h9WDZLNTyCnexYA7hHsz0DLlehn
         +ZcPX8BOH1Q/fKLE8ZI0sFIcnCEiAPsQjLsZRNgz09fTxuw9I77Kjxrte4Hq/d67tH
         QuktvNcHyf2fQQLXUo0atzRFP+AePaeCA+8aNBuycChKGO3Z0/Kk5Gqzc46GkiQ5cc
         uaXYSEIKkHO8Mm5/4kN/Zg+B8E11+Fv3jslNPUAZuVuZDMMragj2MHf5F343u8p4gJ
         mMWnAhF1aaNQQzq8ep9ZZ53RoHQP2rFR4VKfEQ3zAMXwI4UYuDDcQMVgIfUhUpPObP
         G1FTmg/ooWPxA==
Message-ID: <2b3ceca3-9e1c-7266-1f60-19e5f032c3e3@kernel.org>
Date:   Tue, 26 Sep 2023 08:00:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6 09/23] scsi: sd: Do not issue commands to suspended
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
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-10-dlemoal@kernel.org>
 <ca064bd3-2496-4d79-b68c-beff775228c3@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ca064bd3-2496-4d79-b68c-beff775228c3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/25 22:22, Bart Van Assche wrote:
> On 9/22/23 17:29, Damien Le Moal wrote:
>> diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
>> index 5eea762f84d1..4d42392fae07 100644
>> --- a/drivers/scsi/sd.h
>> +++ b/drivers/scsi/sd.h
>> @@ -150,6 +150,7 @@ struct scsi_disk {
>>   	unsigned	urswrz : 1;
>>   	unsigned	security : 1;
>>   	unsigned	ignore_medium_access_errors : 1;
>> +	unsigned	suspended : 1;
>>   };
>>   #define to_scsi_disk(obj) container_of(obj, struct scsi_disk, disk_dev)
> 
> If the 'suspended' member is retained, please do not use a bitfield for the
> but use type 'bool' instead. Updates of instances of type 'bool' are atomic
> while there is no guarantee in the C standard that bitfield updates will be
> atomic. Bitfield updates are typically translated into a combination of &,
> | and ~ operations.

Sure, I can make it a bool.

> Additionally, I'm not convinced that we need the new 'suspended' member.
> The Linux kernel runtime PM subsystem serializes I/O and system-wide power
> operations. No I/O happens during system-wide suspend or resume operations
> and no system-wide suspend or resume callbacks are invoked while I/O is
> ongoing. The only exception is I/O that is initiated as the result of error
> handling by suspend or resume callbacks, e.g. the SCSI commands submitted
> by sd_shutdown(). Even if sd_shutdown() is called indirectly by a suspend
> or resume callback, I don't think that it can happen that a suspend or
> resume operation is ongoing for the device sd_shutdown() operates on. If

Yes, but that is not what this patch addresses.

> scsi_remove_host() is called from inside a resume callback, resuming of the
> devices affected by sd_shutdown() will only be attempted after the host
> adapter resume callback has finished.

No it will not because the commands issued in sd_shutdown() are synchronous, so
the adapter resume will wait for these to complete. But they will never complete
as the adapter itself is not fully resumed, AND the disk may not be in a state
that allows commands to be executed. Deadlock.

It is easy to recreate this issue if you have a pm8001 adapter: remove that fix
patch I sent to correctly re-allocate IRQs on resume and do a suspend-resume
cycle: on resume, the adapter fails to allocate IRQs and gives up, calling
scsi_remove_host(). The system end being stuck in resume context with no forward
progress ever made.

It seems that you are suggesting that we should use some information from the
scsi_device->power structure to detect the suspended state... But as mentioned
before, these are PM internal and should not be touched without the device lock
held. So the little "suspended" falg simplifies things a lot.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

