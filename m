From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling mptsas_qcmd
Date: Fri, 17 Sep 2010 12:32:11 +0200
Message-ID: <AANLkTikDSbzqJHLToz9L7VhOtifzUANomYBBbbbEHBwt@mail.gmail.com>
References: <1284666254.7280.54.camel@schen9-DESK>
	<1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	<20100916212530.GA22051@gargoyle.ger.corp.intel.com>
	<4C929368.4040903@cisco.com>
	<1284675416.26423.47.camel@mulgrave.site>
	<20100917071656.GA2644@gargoyle.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0IQKcM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Sep 2010 06:32:12 -0400
Received: by iwn5 with SMTP id 5so1885887iwn.19
        for <linux-scsi@vger.kernel.org>; Fri, 17 Sep 2010 03:32:12 -0700 (PDT)
In-Reply-To: <20100917071656.GA2644@gargoyle.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Fri, Sep 17, 2010 at 9:16 AM, Andi Kleen <ak@linux.intel.com> wrote:
>
> > Not really ... look at the code path (in scsi.c:scsi_dispatch_cmd()).
> > We take the lock, then get the serial number (that would likley have to
> > be replaced with an atomic), check the state, call trace, call
>
> An atomic unfortunately usually doesn't scale much better than a spinlock.
> I suspect serials would need to be made optional, e.g.
> computing them lazily if really needed.

We should be careful that the command processing order for commands
issued by different threads is not altered by removing the host lock,
at least for those SCSI commands where in-order processing matters.
There might be better solutions than a serial number though.

Bart.
