Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3720CC76195
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Mar 2023 23:58:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbjC0X6n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Mar 2023 19:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjC0X6m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Mar 2023 19:58:42 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4631719A8
        for <linux-scsi@vger.kernel.org>; Mon, 27 Mar 2023 16:58:38 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 73AAF7595C;
        Mon, 27 Mar 2023 23:58:37 +0000 (UTC)
Received: from localhost (mailpool-mx-02.fibernetics.ca [208.85.217.141])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 5A0EF60AA4;
        Mon, 27 Mar 2023 23:58:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-02.fibernetics.ca [208.85.217.141]) (amavisd-new, port 10024)
        with ESMTP id iXSEOSz7t8G1; Mon, 27 Mar 2023 23:58:36 +0000 (UTC)
Received: from [192.168.48.17] (host-184-164-23-94.dyn.295.ca [184.164.23.94])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id E861260256;
        Mon, 27 Mar 2023 23:58:35 +0000 (UTC)
Message-ID: <3f02a075-cc30-5584-704b-da88be1d6b31@interlog.com>
Date:   Mon, 27 Mar 2023 19:58:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Reply-To: dgilbert@interlog.com
Subject: Re: [RFC PATCH 0/3] sg3_utils: udev rules: restrict use of ambiguous
 device IDs
Content-Language: en-CA
To:     mwilck@suse.com, Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        Franck Bui <fbui@suse.de>, dm-devel@redhat.com,
        linux-scsi@vger.kernel.org,
        Benjamin Marzinski <bmarzins@redhat.com>
References: <20230327132459.29531-1-mwilck@suse.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20230327132459.29531-1-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023-03-27 09:24, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Most modern SCSI devices provide VPD page 83 with at least one highly
> reliable device identifier, like NAA Registered Extended or EUI-64, or
> the ata-id identifier. Other device identifier types have shown to be less
> reliable and possibly ambiguous. Ambiguity in particular is a problem with
> multipath-tools, which may group unrelated devices together in a multipath
> map, causing possible data corruption.
> 
> The device identifiers are used in two independent ways by the udev rules:
> a) to set ID_SERIAL for subsystems like multipath, and b) to create
> /dev/disk/by-id/scsi-... symlinks. Our udev rules have traditionally created
> symlinks for every device identifier obtained from either VPD 83 or 80. This
> may cause issues, especially on large installments with storage devices that
> exhibit the same identifier for many logical units. At the same time, these
> symlinks are rarely used.
> 
> Avoid using unreliable identifiers for setting ID_SERIAL, and don't create
> symlinks for these identifiers. Add a configuration method that allows
> users to easily re-enable these methods and symlinks if they need to
> (this might be the case on systems with legacy devices that are referenced
> in /etc/crypttab, lvm.conf, or the like). This is done by introducing
> environment variables .SCSI_ID_SERIAL_SRC and .SCSI_ID_SYMLINK_SRC, to
> control use of device identifiers for determining ID_SERIAL and for creating
> symlinks, respectively. Both variables can contain the letters "T", "L", "V",
> and "S" to enable T10-vendor ID, NAA local ID, vendor-specific ID, and VPD 80
> based ID, respectively.
> 
> Distributions can change the defaults for these environment variables
> to provide backward compatibility for their users, while offering users
> an easy way to change the settings.
> 
> I'm sending this as RFC, because I expect that not everyone will agree
> which identifiers should be enabled by default.

Lets see if anything happens. Applied as sg3_utils revision 1019 and
pushed to https://github.com/doug-gilbert/sg3_utils .

Didn't see any effect on an Ubuntu 22.10 when sg3_utils deb package
built and installed. No sign of 00-scsi-sg3_config.rules being placed
anywhere by Ubuntu. Does Suse install those rules?

Doug Gilbert

> Martin Wilck (3):
>    55-scsi-sg3_id.rules: don't set unreliable device ID by default
>    58-scsi-sg3_symlink.rules: don't create extra by-id symlinks by
>      default
>    udev: add 00-scsi-sg3_config.rules for user configuration
> 
>   Makefile.am                       |  1 +
>   scripts/00-scsi-sg3_config.rules  | 23 ++++++++++++++
>   scripts/55-scsi-sg3_id.rules      | 53 ++++++++++++++++++++++++++++---
>   scripts/58-scsi-sg3_symlink.rules | 46 +++++++++++++++++++++------
>   4 files changed, 109 insertions(+), 14 deletions(-)
>   create mode 100644 scripts/00-scsi-sg3_config.rules
> 

