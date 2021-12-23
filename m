Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CF58C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 09:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347341AbhLWJBn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 04:01:43 -0500
Received: from verein.lst.de ([213.95.11.211]:53199 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347339AbhLWJBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 04:01:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 89FF468AA6; Thu, 23 Dec 2021 10:01:37 +0100 (CET)
Date:   Thu, 23 Dec 2021 10:01:37 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Baoquan He <bhe@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2] sr: don't use GFP_DMA
Message-ID: <20211223090137.GB7555@lst.de>
References: <20211222090842.920724-1-hch@lst.de> <20211222093707.GA23698@MiWiFi-R3L-srv> <20211222094216.GA28018@lst.de> <20211222104046.GB23698@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211222104046.GB23698@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 22, 2021 at 06:40:46PM +0800, Baoquan He wrote:
> Any thought or plan for those callsites in other places? Possibly we can
> skip those s390 related drivers since s390 only has DMA zone, no DMA32,
> it should be OK.

Yes, this needs a bit of an audit.  A lot of them might be best handled
by the subsysem maintainers, e.g. for crypto media and sound.

> And could you please also add me to CC when send out these patches? We
> have this problem in our RHEL8 which is based on kernel4.18, if finally
> removing dma-kmalloc(), we need back port these driver fixes too. If
> not paying attention, these patches may scatter in different
> sub-components and unnoticable.

I already sent them out yesterday.  Just look for everything with
GFP_DMA in the subject line in the current scsi tree for 5.17.
