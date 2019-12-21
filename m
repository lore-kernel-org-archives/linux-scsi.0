Return-Path: <SRS0=9hKQ=2L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0974DC2D0D2
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Dec 2019 11:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DE4892070C
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Dec 2019 11:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbfLULyW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 06:54:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:33248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726291AbfLULyW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 06:54:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D3DCEAAC3;
        Sat, 21 Dec 2019 11:54:20 +0000 (UTC)
Date:   Sat, 21 Dec 2019 12:54:19 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: blacklist: add VMware ESXi cdrom - broken tray
 emulation
Message-ID: <20191221115419.GN4113@kitsune.suse.cz>
References: <20191217180840.9414-1-msuchanek@suse.de>
 <yq1bls6h9ir.fsf@oracle.com>
 <20191219143422.GJ4113@kitsune.suse.cz>
 <yq1pngjc2pr.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1pngjc2pr.fsf@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 19, 2019 at 06:31:12PM -0500, Martin K. Petersen wrote:
> 
> Michal,
> 
> >> Please don't introduce a blist flag to work around deficiencies in the
> >> matching interface. I suggest you tweak the matching functions so they
> >> handle a NULL vendor string correctly.
> >
> > I don't think that will work with the interface for dynamically adding
> > entries through sysfs.
> 
> Please make it work :)
> 
> There's nothing conceptually wrong with being able to do:
> 
>         echo ":Model:Flags" > /proc/scsi/device_info
> 
> We keep running into issues where the same device needs to be listed
> many times because it gets branded by different vendors.

Actually the flag is really needed. The vendor string is a field of
specific length, not a pointer. This makes sense because the vendor
string is fixed length. The code adding the blacklist entries  cannot
handle NULL, and the matching code works with char array already.

What can be done differently is stop space-padding the values and
instead match the length of the string as provided. This will however
cause API break. Currently short entries are space-padded to match
exactly the provided vendor string. If we change the match to only the
provided string length it will potentially match and blacklist
additional devices.

If a flag is required to trigger the prefix matching it can be used
instead of the flag that disables vendor matching with empty vendor
string.

Thanks

Michal
