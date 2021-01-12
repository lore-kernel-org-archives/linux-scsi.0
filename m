Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7ABC432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 13:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AEBB22571
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 13:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhALNUE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 08:20:04 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46084 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbhALNUD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 08:20:03 -0500
Date:   Tue, 12 Jan 2021 14:19:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610457561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/VWB0fCsPvUGFSmikizfqSo7xug3MKhclkhQ+H6pyM=;
        b=ZjV09O//O6L5Np6VcjV6OCFjGiy+gjje329oC9V6HINakAy8L4DtvMl/eztN6MzycZsM7T
        Cii13gDpyyliCRgQYykazLp3vLYJFxiI4dcHXJKoEHye262D6m2ZnzP4aNyDqmIOHIUmQp
        fVP4juy7SbtE2TZWaVwdvFjd6OBoCOs955qM+zfo0ASAJwAkKVOuPWVku2qJIdSXOscrKE
        qAa+KNPKyQMSpz3x+6I/vg79YzB0SBe2iV93kc944GamAfGObANs2a4gVu+dostZNE8gW5
        HwihEKIG6jatFNsSFKtTxksMNSbqw7aMNN5yXv/qXIOiqFAIE3pICN7CHMax4w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610457561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=g/VWB0fCsPvUGFSmikizfqSo7xug3MKhclkhQ+H6pyM=;
        b=+Krcyb89Ggw/SfxKIn+0DMxbJRzKXOPBv0vr82K6SsheaIJnADyju6UJaB799YeeRovM6f
        EOa73gUeOjsSCLAA==
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
Subject: Re: [PATCH v2 00/19] scsi: libsas: Remove in_interrupt() check
Message-ID: <X/2h0yNqtmgoLIb+@lx-t490>
References: <20210112110647.627783-1-a.darwish@linutronix.de>
 <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8683f401-29b6-4067-af51-7b518ad3a10f@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 11:53:50AM +0000, John Garry wrote:
> On 12/01/2021 11:06, Ahmed S. Darwish wrote:
> > Hi,
> >
> > Changelog v2
> > ------------
...
>
> I'll give this a spin today and help review also then.
>
> There's 18 patches here - it would be very convenient if they were on a
> public branch :)
>

Konstantin's "b4" is your friend:

  https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation

It boils down to:

  $ pip install b4
  $ b4 am -v2 20210112110647.627783-1-a.darwish@linutronix.de

Kind regards,

--
Ahmed S. Darwish
Linutronix GmbH
