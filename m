Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72408C433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 06:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiCCGKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Mar 2022 01:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiCCGKS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Mar 2022 01:10:18 -0500
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A3F163D54
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 22:09:33 -0800 (PST)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id D05E66156D;
        Thu,  3 Mar 2022 06:09:31 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id C7E72630B6;
        Thu,  3 Mar 2022 06:09:31 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id 2j6jcRG3GoYO; Thu,  3 Mar 2022 06:09:31 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 7A3B2630AE;
        Thu,  3 Mar 2022 06:09:29 +0000 (UTC)
Message-ID: <5a532d1a-d1b8-a153-4988-7ac62ae6441d@interlog.com>
Date:   Thu, 3 Mar 2022 01:09:28 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Reply-To: dgilbert@interlog.com
Subject: Re: SCSI discovery update
Content-Language: en-CA
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Cc:     "Knight, Frederick" <Frederick.Knight@netapp.com>
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-03-02 00:35, Martin K. Petersen wrote:
> This series addresses several issues in the SCSI device discovery
> code:
> 
>   - Fetch the VPD header before getting the full VPD page. This removes
>     the guesswork from sizing the VPD buffer and fixes problems with
>     RAID controllers that wedge when we try to fetch the IDENTIFY
>     DEVICE information trailing the ATA Information VPD page.
> 
>   - Cache the VPD pages we need instead of fetching them every
>     revalidate iteration.
> 
>   - Avoid truncating the INQUIRY length for modern devices. This allows
>     us to query the version descriptors reported by most contemporary
>     drives. These version descriptors are used as an extra heuristic
>     for querying protocol features.

Version descriptors used to be updated by Ralph Weber (WDC, T10) but
he stopped doing that about 2 years ago. When that was pointed out
he made a proposal to T10 [20-022r0] for dropping version descriptors
henceforth. The proposal was voted down but no-one has stepped up at
T10 to keep the version descriptors up to date.

Version descriptors used to have an entry on this page:
     https://www.t10.org/lists/1spc-lst.htm
That is no longer the case. They are still in spc6r06.pdf (latest draft)
but haven't been updated for the same period.

I believe Seagate never supported version descriptors. Hitachi/WD
used to support them. But I have a WD SAS disk manufactured last
month and it has no version descriptors.

I have no Toshiba, Samsung nor Kioxia disks. Could someone report if their
recent SAS disks support version descriptors?

>   - Additional sanity checking for the reported minimum and optimal I/O
>     sizes.
> 
>   - Fix reported discard failures by making the configuration a
>     two-stage process. Completing full VPD/RSOC discovery before we
>     configure discard prevents a small window of error where the wrong
>     command and/or wrong limit would briefly be applied.
> 
>   - Make the zeroing configuration a two-stage process as well.
> 
>   - Implement support for the NDOB flag for both discards and
>     zeroing. The "No Data Out Buffer" flag removes the need for a
>     zeroed payload to be included with a WRITE SAME(16) command.
> 
>   - Remove the superfluous revalidate operation historically required
>     by the integrity profile registration. This further reduces the
>     commands we send during device discovery.
> 
>   - Add additional heuristics for enabling discards on modern devices.
>     Specifically, if a device reports that it supports logical block
>     provisioning, attempt to query the LBP VPD page.
> 
>   - Also query the device VPD pages if a device reports conformance to
>     a recent version of the SCSI Block Commands specification.

Everything else here looks great.

Ah, one thing. If you cache VPD pages (and the standard INQUIRY response),
then if an INQUIRY DATA CHANGED Unit Attention occurs, all the cached data
should be invalidated and the cached VPD pages re-fetched. The Last n Inquiry
Data Changed log page [0xb,0x1] could help with that, but I haven't seen
it implemented yet.

Doug Gilbert

> Thanks to several bug reporters and volunteers this series has been
> extensively tested with a much wider variety of USB/UAS devices than I
> have access to.
> 

