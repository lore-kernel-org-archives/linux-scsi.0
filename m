Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCC4DC56201
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 08:53:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94CF220756
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 08:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgJaIxk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 04:53:40 -0400
Received: from verein.lst.de ([213.95.11.211]:56356 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbgJaIxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Oct 2020 04:53:30 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 38F8867373; Sat, 31 Oct 2020 09:53:27 +0100 (CET)
Date:   Sat, 31 Oct 2020 09:53:27 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
Message-ID: <20201031085327.GA6112@lst.de>
References: <20201029145841.144173-1-hch@lst.de> <20201029145841.144173-3-hch@lst.de> <20201029192236.GA991240@kroah.com> <20201029193242.GA4799@lst.de> <20201030104033.GA2392682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201030104033.GA2392682@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 30, 2020 at 11:40:33AM +0100, Greg Kroah-Hartman wrote:
> On Thu, Oct 29, 2020 at 08:32:42PM +0100, Christoph Hellwig wrote:
> > On Thu, Oct 29, 2020 at 08:22:36PM +0100, Greg Kroah-Hartman wrote:
> > > After this, you want me to get rid of kobj_map, right?  Or you don't
> > > care as block doesn't use it anymore?  :)
> > 
> > I have a patch to kill it, but it causes odd regressions with the
> > tpm driver according to the kernel test.  As I have grand plans that
> > build on the block ѕide of this series for 5.11, I plan to defer the
> > chardev side and address it for 5.12.
> 
> Ok, sounds good.
> 
> Wow, I just looked at the tpm code, and it is, um, "interesting" in how
> it thinks device lifespans work.  Nothing like having 4 different
> structures with different lifespans embedded within a single structure.
> Good thing that no one can dynamically remove a TPM device during
> "normal" operation.

The regressions were during suspend then the tpm gets removed.  In
fact I'm pretty sure it is an existing problem that the change in the
lookup just surfaced in a way that the test bot notices, but I didn't
want to guard the block changes on it.
