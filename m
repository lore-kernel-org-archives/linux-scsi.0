Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C926E8181F
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 06:34:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbjIZGek (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 02:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbjIZGej (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 02:34:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C92C124;
        Mon, 25 Sep 2023 23:34:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0923FC433C8;
        Tue, 26 Sep 2023 06:34:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695710072;
        bh=QsI2pUTTkzt/ygVYQnnWHO0uD5ET7jjD1UVqExQ7A7U=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=A8oBKi5ZDrh6YbSe2xk2nkf4Ad4shboYx4nq7iOGdJmKi+AmcQF2jWzIbJdBxqR8j
         3sa0z220ZJzYCQWx1qYUTJ+Z4bVNp/hJbUY6ZwthomNOnuyJN17NFySbeMrrgdBWEu
         W8ldo2qcYiAL2q76Ggsgdel52sPRyT5ISU9E+VHvdBmxwFhcNjgCBmJE1YjK+IXo87
         2rbMF8/mT0OymCnhlFg81doqpDTdbv70kbQqr8cU66jBJaeJttSmpA7KCZC6+T3jhR
         pCLarylzkxTZ/jWvlCRQsEj6Rw5VV6DBvzWu3l5DLvAoaj5xWynmN26V2X7PpgBArk
         5OFhuI7/MusAQ==
Message-ID: <23761577-932f-6332-c46e-d27768a481b0@kernel.org>
Date:   Tue, 26 Sep 2023 08:34:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: [PATCH v6 05/23] ata: libata-scsi: Disable scsi device
 manage_system_start_stop
Content-Language: en-US
From:   Damien Le Moal <dlemoal@kernel.org>
To:     Phillip Susi <phill@thesusis.net>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
 <20230923002932.1082348-6-dlemoal@kernel.org>
 <87r0mmux6s.fsf@vps.thesusis.net>
 <613610e3-5eaf-f3f9-005c-f9a3903b6e3c@kernel.org>
Organization: Western Digital Research
In-Reply-To: <613610e3-5eaf-f3f9-005c-f9a3903b6e3c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/09/26 8:19, Damien Le Moal wrote:
> On 2023/09/25 16:27, Phillip Susi wrote:
>>
>> Damien Le Moal <dlemoal@kernel.org> writes:
>>
>>> However, restoring the ATA device to the active power mode must be
>>> synchronized with libata EH processing of the port resume operation to
>>> avoid either 1) seeing the start stop unit command being received too
>>> early when the port is not yet resumed and ready to accept commands, or
>>> after the port resume process issues commands such as IDENTIFY to
>>
>> I do not believe this is correct.  The drive must respond to IDENTIFY
>> and SET FEATURES while in standby mode.  Some of the information in the
>> IDENTIFY block may be flagged as not available because it requires media
>> access and the drive is in standby.  There is a bit in the IDENTIFY
>> block that indicates whether the drive will automatically spin up for
>> media access commands or not, and if not, then you must issue the SET
>> FEATURES command to spin it up.  For such drives, that VERIFY command
>> will fail.
> 
> Yes about the IDENTIFY command. But exactly as you said, some drives have
> metadata on the media and will not report everything, or we outright not like
> receiving an IDENTIFY command while spun down (I have a couple of these odd
> clown drives in my collection).
> 
> However, regarding the SET FEATURES command to spin up the drive, you are
> confusing the basic power management (STANDBY IMMEDIATE command support), which
> is a mandatory feature of ATA disks, with the Extended Power Conditions (EPC)
> feature set, which is optional. The latter one defines the behavior of the SET
> FEATURES command with the Extended Power Conditions subcommand to control the
> disk power state and power state transitions timers. The former, basic power
> management, does NOT have this. So trying what you suggest would only work for
> drives that support and enable EPC. Given that EPC is optional, and that we are
> not probing/supporting it currently in libata, we cannot rely on that.

Note: re-reading the specs, I found that the mandatory (simple) power management
feature set mandates support for the CHECK POWER MODE command, which reports the
current power state of the device without affecting it. So we could use that to
try to be a little more refined about resume. But sending a CHECK POWER MODE and
then do nothing or send a VERIFY command is in a sense more complicated than
always sending a VERIFY commands, even if that may be useless in some cases.

I will think about this as a follow up cleanup/improvement. Starting using "new"
commands that where not used until now is scary though. Every time we do that,
there are some regressions reported because so crappy drive that does not follow
the standards choke on that new command. And unfortunately, there are *a lot* of
such drive out there.

> 
>>> revalidate the device. In this last case, the risk is that the device
>>> revalidation fails with timeout errors as the drive is still spun down.
>>
>> If a request can timeout before the drive has time to spin up, then that
>> would be a problem outside of suspend/resume.  You would get such
>> timeouts any time you manually suspend the drive with hdparm -y, or the
>> drive auto suspends ( hdparm -S ).  The timeout needs to be long enough
>> for the drive to spin up.  IIRC, it defaults to 10 seconds, which is
>> plenty of time.
> 
> That already is all taken care of. That is the basics for even the initial scan
> on boot where we send commands to the disk while it is still spinning up. The
> timeout I am mentioning is the drive not responding at all because it is spun
> down, no matter how many times one retries. And given that the ATA specs clearly
> define that a drive should not change its power state with a reset, even the
> reset after the command timeout does not change anything with some drives (I do
> have some drives that actually spin up on reset, but many that don't, as per spec).
> 
>> It sounds like you are saying that you unconditionally wake the drive
>> with a VERIFY command to make sure that you can then IDENTIFY.  This
> 
> Exactly. As you said yourself, there are some drives that will not report
> everything unless they are spun up. And I have some old drives that really do
> not like receiving that command at all while spun down. So the safer approach
> taken is to spinup the drive upfront, before doing anything else.
> 
>> should not be needed.  In addition, if the drive has PuiS enabled, I
>> would like to leave it in standby after a system resume, not force it to
>> wake up.  After all, that is why it has PuiS enabled.
> 
> PUIS is another optional feature that we do not directly support in the kernel.
> If you want/need that, patches are welcome. With detection of that feature
> added, we could improve resume and avoid useless drive spinup. That is currently
> outside the scope of this series since we are not supporting PUIS currently.
> 
>>
> 

-- 
Damien Le Moal
Western Digital Research

