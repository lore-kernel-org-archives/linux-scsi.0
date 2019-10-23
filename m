Return-Path: <SRS0=dT41=YQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25265C47E49
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 17:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E998F21929
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Oct 2019 17:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571852138;
	bh=nU+t6hJBerEGHVpX83l9jQCd8/P6S+syZ7EgEoM54YM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Ku/cEuISmkddbFVSphfIdDrm7ssaxEPbmOQVaGI9l6tPiFyWAfOmLL/L6VxjIY5wT
	 z8INXNL9EirmVddJgt5FC5QbPmOSvlnM7wAutT37p6EqsqdyWVniFBe9kKk3Gm+iza
	 vqJOTWewtLLtSjNopGwnKyP4m9zSdVFtPjAvIWrQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbfJWRf1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:35:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:46004 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730453AbfJWRf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 23 Oct 2019 13:35:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8E590AD29;
        Wed, 23 Oct 2019 17:35:25 +0000 (UTC)
Date:   Wed, 23 Oct 2019 19:35:24 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Mike Christie <mchristi@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        martin@urbackup.org, Damien.LeMoal@wdc.com
Subject: Re: [PATCH] Add prctl support for controlling PF_MEMALLOC V2
Message-ID: <20191023173524.GM17610@dhcp22.suse.cz>
References: <20191021214137.8172-1-mchristi@redhat.com>
 <20191022112446.GA8213@dhcp22.suse.cz>
 <5DAF2AA0.5030500@redhat.com>
 <20191022163310.GS9379@dhcp22.suse.cz>
 <20191022204344.GB2044@dread.disaster.area>
 <20191023071146.GE754@dhcp22.suse.cz>
 <5DB08D81.8050300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5DB08D81.8050300@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed 23-10-19 12:27:29, Mike Christie wrote:
> On 10/23/2019 02:11 AM, Michal Hocko wrote:
> > On Wed 23-10-19 07:43:44, Dave Chinner wrote:
> >> On Tue, Oct 22, 2019 at 06:33:10PM +0200, Michal Hocko wrote:
> > 
> > Thanks for more clarifiation regarding PF_LESS_THROTTLE.
> > 
> > [...]
> >>> PF_IO_FLUSHER would mean that the user
> >>> context is a part of the IO path and therefore there are certain reclaim
> >>> recursion restrictions.
> >>
> >> If PF_IO_FLUSHER just maps to PF_LESS_THROTTLE|PF_MEMALLOC_NOIO,
> >> then I'm not sure we need a new definition. Maybe that's the ptrace
> >> flag name, but in the kernel we don't need a PF_IO_FLUSHER process
> >> flag...
> > 
> > Yes, the internal implementation would do something like that. I was
> > more interested in the user space visible API at this stage. Something
> > generic enough because exporting MEMALLOC flags is just a bad idea IMHO
> > (especially PF_MEMALLOC).
> 
> Do you mean we would do something like:
> 
> prctl()
> ....
> case PF_SET_IO_FLUSHER:
>         current->flags |= PF_MEMALLOC_NOIO;
> ....

yes, along with PF_LESS_THROTTLE.

-- 
Michal Hocko
SUSE Labs
