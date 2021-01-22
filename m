Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5817BC43331
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 19:35:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 311CC23AFE
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 19:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbhAVTTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 14:19:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:46092 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730736AbhAVTFM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Jan 2021 14:05:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611342263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+0la0GT8DdB0xDaPlbexomDNYf1VKOLi9W9YQO/CEbM=;
        b=DdO0lp3/urVxTIysnjBZMoXmJXdCZRRyB+GPkQVvwRvBZadCbg6zlUS7ZoBDN8USvTrA6b
        lrt8ldJkK7p7c9T3EhyzUmLgmdlDoPfffeFWCMOptjFwji6yo9Byq83fzHdWDR3Yf+/MkP
        BTSOuwpLuqDCg81ZclQDaK2AAfppm5Q=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 745D1AC45;
        Fri, 22 Jan 2021 19:04:23 +0000 (UTC)
Message-ID: <11234f95b342b713a11b4c51e797e768e6410cc3.camel@suse.com>
Subject: Re: [PATCH V3 06/25] smartpqi: add support for BMIC sense feature
 cmd and feature bits
From:   Martin Wilck <mwilck@suse.com>
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com,
        Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 22 Jan 2021 20:04:22 +0100
In-Reply-To: <SN6PR11MB284867A86A867CDBC39548FDE1A09@SN6PR11MB2848.namprd11.prod.outlook.com>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763249519.26927.10907963332068924699.stgit@brunhilda>
         <688b16a6318e11967d6032b94248db5f66b6503b.camel@suse.com>
         <SN6PR11MB284867A86A867CDBC39548FDE1A09@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-01-22 at 16:45 +0000, Don.Brace@microchip.com wrote:
> 
> > @@ static int pqi_ctrl_init_resume(struct pqi_ctrl_info *ctrl_info)
> > 
> >         pqi_start_heartbeat_timer(ctrl_info);
> > 
> > +       if (ctrl_info->enable_r5_writes || ctrl_info-
> > > enable_r6_writes) {
> > +               rc =
> > pqi_get_advanced_raid_bypass_config(ctrl_info);
> > +               if (rc) {
> > +                       dev_err(&ctrl_info->pci_dev->dev,
> > +                               "error obtaining advanced RAID
> > bypass
> > configuration\n");
> > +                       return rc;
> 
> Do you need to error out here ? Can't you simply unset the
> enable_rX_writes feature?
> 
> Don: If the call to pqi_get_advanced_raid_bypass_config fails, then
> there most likely be some serious issues. So we abandon the
> initialization process.

Ok, understood. A reader who isn't fully familiar with the HW
properties (like myself) may think that "advanced_raid_bypass"
is an optional performance-related feature and that the controller
could be operational without it. If that's not the case, fine.

Martin


