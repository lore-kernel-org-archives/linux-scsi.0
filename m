Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D575C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 083E923107
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 17:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392158AbhALREl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 12:04:41 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:47204 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391244AbhALREl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 12:04:41 -0500
Date:   Tue, 12 Jan 2021 18:03:58 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610471040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mNh+yzVHE/sNBkk7cHTXw7yap6jYDVOK0gkef2AcTtU=;
        b=3hU04IR+oMWYinzQj/t8LllbUtDL4GVTBb0qV6z7x5O+NYx5LD2CYZArTqSu7gEb1LA25r
        3krHlVkIKTWIBtdDM+jm9vZP2HD5KGYRwHkK2ntsMTr2EVHnOFh6xPLLvkLifyIwxFl0O9
        uDRU9KhSLM1UZVCLZ+z32lnIdXW0oA/mUXyu/nSXWzdE1PQnsPfghNHnBALVvIC8kZIAfu
        kYBcWAdHSWfIgPifSWz8cEfTh/0MEYsO5+F1s4i+Pw4zL2Ivk28zWMR8636pqA8TavP6/c
        uFugp7NUk1Ugc1zdUc7XG/UQ0zn8y+DTvRGO+ua0mjJse6IBoQ1k01gJeG7G1A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610471040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mNh+yzVHE/sNBkk7cHTXw7yap6jYDVOK0gkef2AcTtU=;
        b=qSnuyRnWxHoXNLjppHjjzN6/VfMepBsXXa0FcEbeA3e6dp4MhaXmlzqWxCIOLaYevbTErU
        HKxTztqNtzw1NqDw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 04/19] scsi: mvsas: Pass gfp_t flags to libsas event
 notifiers
Message-ID: <X/3Wfj9KiQeFsdxA@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-5-a.darwish@linutronix.de>
 <20210112154642.GC1185705@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112154642.GC1185705@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 03:46:42PM +0000, Christoph Hellwig wrote:
> >  	} else if (mwq->handler & EXP_BRCT_CHG) {
> >  		phy->phy_event &= ~EXP_BRCT_CHG;
> > -		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> > +		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);
>
> Please don't add pointless lines > 80 chars.  This seems to happen a lot
> more in the series.

I didn't break the lines because they will be modified at the end of the
series anway.

When the _gfp() suffix is removed (patches #13 => #19), the lines get
within the 80 cols range.

Thanks,

--
Ahmed S. Darwish
Linutronix GmbH
