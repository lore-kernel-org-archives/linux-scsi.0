Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61899C2BA4C
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jan 2022 07:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238058AbiAZHvp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:51:45 -0500
Received: from verein.lst.de ([213.95.11.211]:38788 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229840AbiAZHvo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 26 Jan 2022 02:51:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 48D1267373; Wed, 26 Jan 2022 08:51:41 +0100 (CET)
Date:   Wed, 26 Jan 2022 08:51:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH] scsi: make "access_state" sysfs attribute always
 visible
Message-ID: <20220126075141.GA22962@lst.de>
References: <20220125162441.2226-1-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220125162441.2226-1-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 25, 2022 at 05:24:41PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If a SCSI device handler module is loaded after some SCSI devices
> have already been probed (e.g. via request_module() by dm-multipath),
> the "access_state" and "preferred_path" sysfs attributes remain invisible for
> these devices, although the handler is attached and live. The reason is
> that the visibility is only checked when the sysfs attribute group is
> first created. This results in an inconsistent user experience depending
> on the load order of SCSI low-level drivers vs. device handler modules.
> 
> This patch changes user space API: attempting to read the "access_state"
> or "preferred_path" attributes will now result in -EINVAL rather than
> -ENODEV for devices that have no device handler, and tests for the existence
> of these attributes will have a different result.

Sounds fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>
