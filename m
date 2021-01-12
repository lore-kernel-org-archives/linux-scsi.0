Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DECE6C43381
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B038023131
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 15:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405750AbhALPsK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 10:48:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405742AbhALPsJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 10:48:09 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C20C061786;
        Tue, 12 Jan 2021 07:47:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UKM0jxJzjj7aZZaUpjoPtSaloslyeAwT5PAA2KS1qPw=; b=sfoDpnQpTy15YMXkKej9WwbmtA
        oT79dKefFx8gZXg1glqjV0U6ETsrwvcf3jwSDwYr1otHR+umhbzkCqx6rlEzX5NPMuHPsX+GCTrLS
        n3Yd99v3qS9hmzmcHrFhYx8QsOKGHyzMotAl4/gH6WwJswte8e36vlaHcoewe7AiRRGacMSzg11pO
        sQo6pwNf33lMicwFnqZFlxFkv+eQQi4pv83DoQkCnrtc59it5Q/zWw7CJICQ6uDhbyxy1OxOIzYgl
        WiHp4LSi9zeb7akNA/cGqRcOQ+W4k3a4qUHKM2Sp8Yh5BwmJb3T8D3kfU3MVwBQfd1+3WLrUeHu74
        pO2JunnQ==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1kzLsY-004yr9-AY; Tue, 12 Jan 2021 15:46:49 +0000
Date:   Tue, 12 Jan 2021 15:46:42 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>
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
Message-ID: <20210112154642.GC1185705@infradead.org>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-5-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112110647.627783-5-a.darwish@linutronix.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>  	} else if (mwq->handler & EXP_BRCT_CHG) {
>  		phy->phy_event &= ~EXP_BRCT_CHG;
> -		sas_notify_port_event(sas_phy, PORTE_BROADCAST_RCVD);
> +		sas_notify_port_event_gfp(sas_phy, PORTE_BROADCAST_RCVD, GFP_ATOMIC);

Please don't add pointless lines > 80 chars.  This seems to happen a lot
more in the series.
