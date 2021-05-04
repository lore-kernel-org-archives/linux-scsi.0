Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C679FC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:55:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92A09613B4
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 09:55:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhEDJ4s (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 May 2021 05:56:48 -0400
Received: from verein.lst.de ([213.95.11.211]:38793 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229953AbhEDJ4s (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 May 2021 05:56:48 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8937168AFE; Tue,  4 May 2021 11:55:51 +0200 (CEST)
Date:   Tue, 4 May 2021 11:55:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 05/18] scsi: use real inquiry data when initialising
 devices
Message-ID: <20210504095551.GD25986@lst.de>
References: <20210503150333.130310-1-hare@suse.de> <20210503150333.130310-6-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503150333.130310-6-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 03, 2021 at 05:03:20PM +0200, Hannes Reinecke wrote:
> Use dummy inquiry data when initialising devices and not just
> some 'nullnullnull' string.

Why?

> +/*
> + * Dummy inquiry for virtual LUNs:
> + *
> + * standard INQUIRY: [qualifier indicates no connected LU]
> + *  PQual=1  Device_type=31  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
> + *  [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
> + *  SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
> + *  EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
> + *  [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
> + *    length=36 (0x24)   Peripheral device type: no physical device on this lu
> + * Vendor identification: LINUX
> + * Product identification: VIRTUALLUN
> + * Product revision level: 1.0
> + */

You don't juse set this up for virtual Luns, but as a default for all
scsi_devices before calling inquirty.  I'd much helper with a helper
to fill out fake inquiry data rather than having seemingly valid data
for all devices before inquirty is called or if it fails.
