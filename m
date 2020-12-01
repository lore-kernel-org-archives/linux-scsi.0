Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE3EC64E7B
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:09:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E689322249
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Dec 2020 09:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="rqdfqmmu";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ndUpCPjh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729446AbgLAJJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Dec 2020 04:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389405AbgLAJJQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2020 04:09:16 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F251BC0613D2;
        Tue,  1 Dec 2020 01:08:35 -0800 (PST)
Date:   Tue, 1 Dec 2020 10:08:32 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1606813714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L9+gkIZnLOvuCQK81cg/lOyvVKTHIgD55nPaV4Hs4MQ=;
        b=rqdfqmmup0rMLp3sI2EV0Ma8bbRk2XDXDlwpwqB4oCFmHiEAi+cTzNtAIm9benWRWHlC2i
        XYw2O+kbpqy0GFl6TDXwwQq+bs3VsMi7Th200p9IHh6xULB87NEdFNClG8JWKTtqL0+yjO
        zdxBTONddz7YaRB5euisDD992TXgwFTsUsXYr98LPVlwenq2RTyVSsoI+Qpl2Bd06Zr2Vw
        zDrYqZ9WbGJcvy1r8pi4YA6IXd/eyqR1yV7FJ5O5EWBd+PcC13bNO1Ga/MOiwWyrWsdNBz
        dBrCihoB6Il6oZYJmeqYV7lUuohquFSWMUd26GC3U6wi8GPP02lxNylnr44aPQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1606813714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L9+gkIZnLOvuCQK81cg/lOyvVKTHIgD55nPaV4Hs4MQ=;
        b=ndUpCPjhPFZJ4H+BmwnZ0ZK87Hxs0Vm00Wh6Ax8oQVsiysM6pjBAbxG2KNqEV9LMAa6Mq/
        ioT9pUImcHLj87Ag==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Finn Thain <fthain@telegraphics.com.au>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        John Garry <john.garry@huawei.com>, linux-m68k@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        Nilesh Javali <njavali@marvell.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vikram Auradkar <auradkar@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Xiaofei Tan <tanxiaofei@huawei.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>
Subject: Re: [PATCH 00/14] scsi: Remove in_interrupt() usage.
Message-ID: <20201201090832.6th7lqrkmyhnlmlr@linutronix.de>
References: <20201126132952.2287996-1-bigeasy@linutronix.de>
 <yq1ft4qi095.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <yq1ft4qi095.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-01 00:06:55 [-0500], Martin K. Petersen wrote:
>
> Applied series to 5.11/scsi-staging except for the NCR patch. Would like
> to see where that lands first.

Thank you Martin.

> Thanks!

Sebastian
