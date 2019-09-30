Return-Path: <SRS0=m3i9=XZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4432C4360C
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 09:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A48D121855
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 09:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfI3JqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 05:46:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:52566 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726329AbfI3JqD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Sep 2019 05:46:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 974A3AC11;
        Mon, 30 Sep 2019 09:46:01 +0000 (UTC)
Message-ID: <c0f30c298cd40dc3dee8d6963f60f72330e7de72.camel@suse.de>
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
From:   Martin Wilck <mwilck@suse.de>
To:     mgandhi@redhat.com, Laurence Oberman <loberman@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Mon, 30 Sep 2019 11:46:06 +0200
In-Reply-To: <31eb5bb6-ca4e-1c6c-3013-7d94ff49623d@redhat.com>
References: <20190923060122.GA9603@machine1>
         <471732f03049a1528df1d144013d723041f0a419.camel@suse.de>
         <3a8ee584f9846fba94d98d0e6941fefdcbed5d71.camel@redhat.com>
         <f2c97e860f895613ba81b69c962660b0c712723a.camel@suse.de>
         <31eb5bb6-ca4e-1c6c-3013-7d94ff49623d@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Milan,

On Mon, 2019-09-30 at 14:35 +0530, Milan P. Gandhi wrote:
> On 9/30/19 2:12 PM, Martin Wilck wrote:

> > Wrt the enablement of the option on highly loaded systems, I'm not
> > sure
> > I understand. You need to enable SCSI logging anyway, don't you?
> 
> By default we keep the SCSI debug logging disabled or am I missing 
> something?
> 
> > Is it an issue to have to set 2 sysfs values rather than just one?
> 
> The idea here is to capture the above debug data even without 
> any user interventions to change any sysfs entries or to enable 
> debug logging on busy, critical production systems.

So, you're looking at the scsi_io_completion() code path. In my
experience that isn't reliable for bug hunting because of the the
message rate limiting. Therefore I prefer using SCSI logging
MLCOMPLETE=1, where no rate limiting applies. But that's just a side
note, it depends on the case what's more useful.

Back to the cmd age output, IMO we're are on a thin line between
capturing useful information and keeping the logs neat. As I already
said, I'm not convinced that this information, as important it may be
for the case(s) you're currently investigating, has the same generic
degree of importance or usefulness as what's currently printed (the CDB
and the sense data). But OTOH, that's just a gut feeling, and I can't
claim to have the experience to make general statement on it. If noone
else has issues with this being printed by default, I'm not going
oppose it. 

> Also, we are not changing the existing text in SCSI command error
> log,
> but we are only adding one single word at the end of message. Ideally
> the user scripts are written to grep specific pattern from the logs.
> Since we are not replacing any existing text from the logs, the 
> scripts should still work with this change as well.

You are certainly aware that such scripts don't necessarily conform to
what kernel developers would consider "ideal" :-) But again, I just
wanted to raise the issue; if noone else thinks it matters, fine with
me.

Thanks
Martin


