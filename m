Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39E1DC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 12:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 136B12310C
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 12:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732322AbhALMJu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 07:09:50 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45708 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732067AbhALMJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 07:09:50 -0500
Date:   Tue, 12 Jan 2021 13:09:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610453348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKoDSC87wBJ/q7tk2afi6RH/hGLuq+/LxTP4N37BM5E=;
        b=WoTM0EQMX+E98si1mt2VtvXkIt8F9pq7dB0X8V2csa96u0FNNMo6msAnBY2TmtVWRwXBpx
        PB2DtNVD88zmechuvuID8f53rk7bumOvxj5lK4ZaUm2vf+aHzIzETTAm7uSX+XXQg12+P6
        iJmfTc5MR15/ioXz7r2JlNpDGLgwOMSkm2ckTruklStLUlRMpPMQQaFz5CETPR7Ok5gSUg
        UNI+I4GxlDo+VdP8fzVeN7toh1sEwtO8DuKrYce9va9ac0KOiIYN9EZARgV/+5UqRxvHYa
        qTGy2Gu+g3bxIAHpBBsD33OnXJJvE6xfUaJT/tKpMZm+HI3qBdcE7ssycLYz6g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610453348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKoDSC87wBJ/q7tk2afi6RH/hGLuq+/LxTP4N37BM5E=;
        b=vNjGBZNVrBVTt9jpPkkUqVGa22ypbKA0FdGR+HBFM7KuHLsGbGzf2TV23WMwa0gVfnXk8h
        qeDfBgjMGbxy9qCw==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jason Yan <yanaijie@huawei.com>,
        Daniel Wagner <dwagner@suse.de>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        linux-scsi@vger.kernel.org, intel-linux-scu@intel.com,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>
Subject: Re: [PATCH v2 02/19] scsi: libsas and users: Remove notifier
 indirection
Message-ID: <X/2RYvDDmMs61Uen@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <20210112110647.627783-3-a.darwish@linutronix.de>
 <21eefa9b-7ff5-b418-6db4-7e0039c24473@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21eefa9b-7ff5-b418-6db4-7e0039c24473@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 11:36:21AM +0000, John Garry wrote:
> On 12/01/2021 11:06, Ahmed S. Darwish wrote:
> > From: John Garry<john.garry@huawei.com>
> >
> > The LLDDs report events to libsas with .notify_port_event and
> > .notify_phy_event callbacks.
> >
> > These callbacks are fixed and so there is no reason why we cannot call the
> > functions directly, so do that.
> >
> > This neatens the code slightly.
> >
> > [a.darwish@linutronix.de: Remove the now unused "sas_ha" local variables]
> > Signed-off-by: John Garry<john.garry@huawei.com>
>
> Don't forget your signed-off-by :)
>

Oh, yes.

> >
> > diff --git a/Documentation/scsi/libsas.rst b/Documentation/scsi/libsas.rst
> > index f9b77c7879db..a183b1d84713 100644
> > --- a/Documentation/scsi/libsas.rst
> > +++ b/Documentation/scsi/libsas.rst
> > @@ -189,8 +189,8 @@ num_phys
> >   The event interface::
> >   	/* LLDD calls these to notify the class of an event. */
> > -	void (*notify_port_event)(struct sas_phy *, enum port_event);
> > -	void (*notify_phy_event)(struct sas_phy *, enum phy_event);
> > +	void sas_notify_port_event(struct sas_phy *, enum port_event);
> > +	void sas_notify_phy_event(struct sas_phy *, enum phy_event);
> >   When sas_register_ha() returns, those are set and can be
> >   called by the LLDD to notify the SAS layer of such events
>
> Maybe this was missed in the rebase, but I think that this comment can go/be
> changed at some stage.
>

Yeah, I pulled the patch yesterday from:

  https://github.com/hisilicon/kernel-dev/commit/87fcd7e113dc05b7933260e7fa4588dc3730cc2a

Lemme check if there are any other differences.

Thanks,
--
Ahmed S. Darwish
