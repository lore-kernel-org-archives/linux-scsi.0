Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239D6C433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 08:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F34282084C
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 08:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599034730;
	bh=7+JEzktISsgTMdUzuapRscBPtX4N6Y3wMNOli4jVPQ4=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:List-ID:From;
	b=P1gvr9tbnS5svsA3XfRSm65O6hXK+UqgsxPIb7IrClf9Q2u91A0xbMjK7jyDaG8vQ
	 7vHAfzY6qat54mlmN7TrmZDUVI//MlY8NYgqAc5eSt2S9F5OyBUyD5ZyvgVp7hsiRQ
	 LariXgOBPT6SzpwDKxljC7lcKcQHNmvkoaBWhtdI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIBISl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 04:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgIBISl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 04:18:41 -0400
Received: from pobox.suse.cz (nat1.prg.suse.com [195.250.132.148])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BADA92084C;
        Wed,  2 Sep 2020 08:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599034720;
        bh=7+JEzktISsgTMdUzuapRscBPtX4N6Y3wMNOli4jVPQ4=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=AUuruMhNnTWN9d+oIWMoSqWA8+m8sBM+oeWPLsiObVeHFiq7BNSvIvN4IuQjBGrUN
         k+B+5u9HrYhoRwTH/Os1qWGB1TXIiwzK1gOw6wV1fQkR0xWwE/1B4a4FZP7bKSHIC9
         PP5dp0UkLkUuQvkHkcTKYHlSgMUgvsrGj9E2u+Z4=
Date:   Wed, 2 Sep 2020 10:18:35 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Boqun Feng <boqun.feng@gmail.com>
cc:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: Re: [RFC v2 09/11] HID: hyperv: Make ringbuffer at least take two
 pages
In-Reply-To: <20200902030107.33380-10-boqun.feng@gmail.com>
Message-ID: <nycvar.YFH.7.76.2009021018080.4671@cbobk.fhfr.pm>
References: <20200902030107.33380-1-boqun.feng@gmail.com> <20200902030107.33380-10-boqun.feng@gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2 Sep 2020, Boqun Feng wrote:

> When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> least 2 * PAGE_SIZE: one page for the header and at least one page of
> the data part (because of the alignment requirement for double mapping).
> 
> So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> using vmbus_open() to establish the vmbus connection.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>

Acked-by: Jiri Kosina <jkosina@suse.cz>

-- 
Jiri Kosina
SUSE Labs

