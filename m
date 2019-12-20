Return-Path: <SRS0=ZPSI=2K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D958C43603
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:39:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3E34420663
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Dec 2019 14:39:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728132AbfLTOj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Dec 2019 09:39:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:39186 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727525AbfLTOj0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Dec 2019 09:39:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 16D27ADFE;
        Fri, 20 Dec 2019 14:39:24 +0000 (UTC)
Date:   Fri, 20 Dec 2019 15:39:22 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] scsi: blacklist: add VMware ESXi cdrom - broken tray
 emulation
Message-ID: <20191220143922.GM4113@kitsune.suse.cz>
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
> 
Is there any description of what the format is supposed to be?

From the current code it looks like comma separated list of blacklist
entries that may be optionally quoted in some way.

The quoting is basically ignored but it is not clear if the inidividual
entries are supposed to be quoted or the whole thing.

Thanks

Michal
