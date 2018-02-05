From: Laurence Oberman <loberman@redhat.com>
Subject: Re: All scsi_debug devices in the scsi_debug driver share the same
 RAM space
Date: Mon, 05 Feb 2018 09:32:31 -0500
Message-ID: <1517841151.11655.1.camel@redhat.com>
References: <1517686992.18584.8.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:34799 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752612AbeBEOcd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Feb 2018 09:32:33 -0500
Received: by mail-qk0-f180.google.com with SMTP id m130so7790902qke.1
        for <linux-scsi@vger.kernel.org>; Mon, 05 Feb 2018 06:32:33 -0800 (PST)
In-Reply-To: <1517686992.18584.8.camel@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: John Pittman <jpittman@redhat.com>, Jon Magrini <jmagrini@redhat.com>

On Sat, 2018-02-03 at 14:43 -0500, Laurence Oberman wrote:
> Hello Doug
> 
> I had emailed you earlier about this issue forgetting to copy others.
> 
> All test devices in the scsi_debug driver share the same ram space so
> we cannot really have individual devices for testing stuff like md-
> raid.
> 
> I bumped into this a few times already and I think it would be useful
> to make each device an individual RAM entry so we can create multiple
> unique devices.
> 
> Of course this means also now having to maybe start using attributes
> for each device do we can selectively choose which devices get the
> fault injections.
> 
> I know its adding complexity here but wanted to get input about the
> possibility of changing this.
> 
> For a particular fault injection case this morning I had to use 5
> regular drives and 1 scsi-debug drive to inject faults to reproduce
> an
> md-raid issue.
> 
> I also wanted a different start sector and range and sent an earlier
> patch for that.
> 
> So is this something worth considering ?
> If so, i will start working on it.
> 
> Regards
> Laurence
> 
> 
> 
> 

I chatted with Doug about this.

Seems that many of the use cases for scsi_debug involved creating high
count devices for testing etc. so having each with its own ram space
could land up chewing a bunch of memory.

I am going to drop this idea for now, but the patch I sent for the
choice of sector for MEDIUM errors and count is very useful so I hope
that one gets accepted.
That patch changes nothing if the two new parameters are not set so
should be low risk for acceptance.

Thanks
Laurence
