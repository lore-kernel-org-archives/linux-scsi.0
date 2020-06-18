Return-Path: <SRS0=Iqxk=77=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B0EC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 00:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F5FA2184D
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Jun 2020 00:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726899AbgFRAkp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 20:40:45 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33172 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbgFRAkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2020 20:40:45 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 2C6062073E;
        Wed, 17 Jun 2020 20:40:40 -0400 (EDT)
Date:   Thu, 18 Jun 2020 10:40:37 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
cc:     Chris Boot <bootc@boo.tc>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux1394-devel@lists.sourceforge.net" 
        <linux1394-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuhong Yuan <hslester96@gmail.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
In-Reply-To: <yq1366ul8o4.fsf@ca-mkp.ca.oracle.com>
Message-ID: <alpine.LNX.2.22.394.2006180953320.8@nippy.intranet>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>        <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>        <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>        <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
        <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>        <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>        <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>        <SN4PR0401MB35982D889857E3C03E96E49D9B9D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
        <1592321667.4394.5.camel@HansenPartnership.com>        <5e512185-45d1-61eb-9bec-91e9f9d53ea3@boo.tc> <yq1366ul8o4.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Jun 2020, Martin K. Petersen wrote:

> 
> However, keeping code around is not free.

Right. And removing code isn't free either, if it forces people to find 
workarounds.

> Core interfaces change frequently.  Nobody enjoys having to tweak host 
> templates for 50 devices they have never even heard about.

And yet some people seem to enjoy writing patches that are as trivial as 
they are invasive...

You seem to be making an argument for more automation here, not an 
argument for less code. Or is there some upper bound to the size of the 
kernel, that might be lifted by adding maintainers? (Can you deliver a 
better product by adding more developers to your project?)

> Also, we now live in a reality where there is a constant barrage of 
> build bots and code analyzers sending mail. So the effective cost of 
> keeping code around in the tree is going up.

But if maintenance cost rises due to good analysis, the value of the code 
should rise too. So what's the problem? It seems to me that the real 
problem is too many analyses that generate pedantic noise and no tangible 
improvement in code quality or value.

> I get a substantial amount of code analysis mail about drivers nobody 
> have touched in a decade or more.
> 

When stable, mature code fails analysis, the analysis is also questionable 
(in the absence of real examples).

> Consequently, I am much more inclined to remove drivers than I have been 
> in the past. But I am also very happy to bring them back if somebody 
> uses them or - even better - are willing to step up and maintain them.
> 

You seem to be saying that 1) a driver should be removed when it no longer 
meets the present threshold for code quality and 2) that a low quality 
driver is eligible for re-addition because someone wants to use it.
I don't think you can have it both ways.

> I don't particularly like the notion of a driver being orphaned because 
> all that really means is that the driver transitions from being (at 
> least partially) somebody else's problem to being mine and mine alone.
> 

Yes it's your problem but only on a best-effort basis.

Many issues detected by automatic analyzers can be fixed with automatic 
code transformation tools. This kind of solution works tree-wide, so even 
if some defect in your driver is "yours and yours alone", the solution 
will probably come from others.

This email, like yours, is just hand-waving. So feel free to ignore it or 
(preferably) provide evidence of real defects.
