Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DAA1C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 01:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234510AbiDZCAG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbiDZCAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:00:05 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228F475219
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 18:56:58 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id E26C4659FE;
        Tue, 26 Apr 2022 01:56:57 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id D10E561951;
        Tue, 26 Apr 2022 01:56:57 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id OvZQEPcGHdWj; Tue, 26 Apr 2022 01:56:57 +0000 (UTC)
Received: from [192.168.48.23] (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id C271C6046A;
        Tue, 26 Apr 2022 01:56:56 +0000 (UTC)
Message-ID: <3ff7b8a3-882d-5516-7583-0c50cff296a0@interlog.com>
Date:   Mon, 25 Apr 2022 21:56:56 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v2 0/9] Support zoned devices with gap zones
Content-Language: en-CA
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org
References: <20220421183023.3462291-1-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-04-21 14:30, Bart Van Assche wrote:
> Hi Martin,
> 
> In ZBC-2 support has been improved for zones with a size that is not a power
> of two by allowing host-managed devices to report gap zones. This patch adds
> support for zoned devices for which data zones and gap zones alternate if the
> distance between zone start LBAs is a power of two.
> 
> Please consider this patch series for kernel v5.19.

whole series:
Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> Changes compared to v1:
> - Made this patch series compatible with the zone querying code in BTRFS.
> - Addressed Damien's off-list review comments.
> - Added patch "Return early in sd_zbc_check_zoned_characteristics()" to this
>    series.
> 
> Bart Van Assche (9):
>    scsi: sd_zbc: Improve source code documentation
>    scsi: sd_zbc: Verify that the zone size is a power of two
>    scsi: sd_zbc: Use logical blocks as unit when querying zones
>    scsi: sd_zbc: Introduce struct zoned_disk_info
>    scsi: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
>    scsi: sd_zbc: Hide gap zones
>    scsi_debug: Fix a typo
>    scsi_debug: Rename zone type constants
>    scsi_debug: Add gap zone support
> 
>   drivers/scsi/scsi_debug.c | 149 ++++++++++++++++++------
>   drivers/scsi/sd.h         |  32 ++++--
>   drivers/scsi/sd_zbc.c     | 236 +++++++++++++++++++++++++++++---------
>   include/scsi/scsi_proto.h |   9 +-
>   4 files changed, 331 insertions(+), 95 deletions(-)
> 

