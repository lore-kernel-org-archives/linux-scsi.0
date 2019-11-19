Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DC17C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 13:29:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E63E222C7
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 13:29:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfKSN24 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:28:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:44504 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725904AbfKSN24 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 08:28:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9E8ECB2B8;
        Tue, 19 Nov 2019 13:28:54 +0000 (UTC)
Date:   Tue, 19 Nov 2019 14:28:54 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: lpfc: Move work items to a stack list
Message-ID: <20191119132854.mwkxx4fixjaoxv4w@beryllium.lan>
References: <20191105080855.16881-1-dwagner@suse.de>
 <yq1h838pivf.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1h838pivf.fsf@oracle.com>
User-Agent: NeoMutt/20180716
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 12, 2019 at 10:15:00PM -0500, Martin K. Petersen wrote:
> > While trying to understand what's going on in the Oops below I figured
> > that it could be the result of the invalid pointer access. The patch
> > still needs testing by our customer but indepent of this I think the
> > patch fixes a real bug.

I was able to reproduce the same stack trace with this patch
applied... That is obviously bad. The good news, I have access to this
machine, so maybe I able to figure out what's the root cause of this
crash.
