From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] scsi, mptsas : drop scsi_host lock when calling
 mptsas_qcmd
Date: Thu, 16 Sep 2010 17:24:47 -0400
Message-ID: <1284672287.26423.41.camel@mulgrave.site>
References: <1284666254.7280.54.camel@schen9-DESK>
	 <1284670136.13344.93.camel@haakon2.linux-iscsi.org>
	 <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60238 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752677Ab0IPVYy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Sep 2010 17:24:54 -0400
In-Reply-To: <20100916212530.GA22051@gargoyle.ger.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@linux.intel.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Tim Chen <tim.c.chen@linux.intel.com>, Eric Moore <Eric.Moore@lsi.com>, linux-scsi@vger.kernel.org, vasu.dev@intel.com, willy@linux.intel.com

On Thu, 2010-09-16 at 23:25 +0200, Andi Kleen wrote:
> > I asked James about getting Vasu's unlocked_qcmds=1 patch merged, but he
> > convinced me that doing conditional locking while is very simple, is not
> > the proper way for getting this resolved in mainline code.  I think in
> > the end this will require a longer sit down to do a wholesale conversion
> > of all existing SCSI LLD drivers, and identifing the broken ones that
> > still need a struct Scsi_Host->host_lock'ed SHT->queuecommand() for
> > whatever strange & legacy reasons.
> 
> The standard way to do that would be to first move the lock down
> into the drivers (similar to how it has been done with the BKL).
> This would be a fairly mechanic mindless patch. Lots of typing,
> but not really a lot of real code review needed.
> 
> Then next step the drivers who know they don't want it can remove it.

Yes, that's basically what Christoph did when he moved the lock out of
the eh path.

James


