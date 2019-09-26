Return-Path: <SRS0=YGqw=XV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6870C432C2
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 07:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6142146E
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Sep 2019 07:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfIZHze (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Sep 2019 03:55:34 -0400
Received: from mail.monom.org ([188.138.9.77]:44586 "EHLO mail.monom.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfIZHzd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Sep 2019 03:55:33 -0400
Received: from mail.monom.org (localhost [127.0.0.1])
        by filter.mynetwork.local (Postfix) with ESMTP id CB3D3500587;
        Thu, 26 Sep 2019 09:55:31 +0200 (CEST)
Received: from localhost (b9168f76.cgn.dg-w.de [185.22.143.118])
        by mail.monom.org (Postfix) with ESMTPSA id 6F25B500072;
        Thu, 26 Sep 2019 09:55:31 +0200 (CEST)
Date:   Thu, 26 Sep 2019 09:55:30 +0200
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Himanshu Madhani <hmadhani@marvell.com>
Subject: Re: WARN_ON_ONCE in qla2x00_status_cont_entry
Message-ID: <20190926075530.xzjpa733sw3ykr6g@beryllium.lan>
References: <20190925123928.kahpjtnikcmox7ug@beryllium.lan>
 <2e47b106-12d7-908a-857f-3908336f2e1f@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e47b106-12d7-908a-857f-3908336f2e1f@acm.org>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 25, 2019 at 06:33:35PM -0700, Bart Van Assche wrote:
> On 2019-09-25 05:39, Daniel Wagner wrote:
> > So I after starring on the code I am not sure if the WARN_ON_ONCE is
> > correct. It assumes that after processing one status continuation,
> > there is no more work. Though it looks like there is another element
> > to process. Is it possible that two sense continuation are possible?
> 
> According to the firmware documentation it is possible that multiple
> status continuations are emitted by the firmware. Do you want to submit
> a patch or do you prefer that I do this myself?

I just send out a patch, which removes the WARN_ON_ONCE. This solves
the obvious warning but drops the consistency check. Maybe
qla2x00_status_cont_entry() could return a status and the outer loop
could check at the end if sp->done() has been called. But I suppose
this should be done for all parsing functions not just for one.
