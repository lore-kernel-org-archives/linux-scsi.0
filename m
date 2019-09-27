Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C512C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 06:33:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 065B920872
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 06:33:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725808AbfI0GdP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 02:33:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:54738 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725802AbfI0GdP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Sep 2019 02:33:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A7F0CB11A;
        Fri, 27 Sep 2019 06:33:13 +0000 (UTC)
Message-ID: <08eb80bb23d057f6ba1cf44cf8d4e2d3e597a25e.camel@suse.de>
Subject: Re: [EXT] Re: [PATCH v2 04/14] qla2xxx: Optimize NPIV tear down
 process
From:   Martin Wilck <mwilck@suse.de>
To:     Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>,
        "James.Bottomley@HansenPartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date:   Fri, 27 Sep 2019 08:33:16 +0200
In-Reply-To: <CFC8098F-46C2-49E6-9BC3-7E220F6F2535@marvell.com>
References: <20190912180918.6436-1-hmadhani@marvell.com>
         <20190912180918.6436-5-hmadhani@marvell.com>
         <767fe8f1a50b10d430c30886031251c8f9e4c2dd.camel@suse.de>
         <CFC8098F-46C2-49E6-9BC3-7E220F6F2535@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-09-26 at 16:56 +0000, Quinn Tran wrote:
>     
>     Are you missing a negation in this last line?
>     Also, what's the point of adding this loop? 
> 
> QT:  good catch.  The idea is to not sleep the full 10Hz, if the
> vref_count already reaches zero or reaches zero under
> 10Hz.  Otherwise, loop/wait for 10Hz.   We're trying to get NPIV tear
> down to go faster.

AFAIU, wait_event_timeout() returns before the timeout has elapsed, if
the tested condition becomes true _and_ the wait queue is woken up. 
Thus the loop shouldn't be necessary. Are you missing a wake_up() call
to vref_waitq somewhere? 

Perhaps you should replace all calls to 

        atomic_dec(&X->vref_count);

with something like

        if (atomic_dec_and_test(&X->vref_count))
                wake_up(&X->vref_waitq);

??

Martin


