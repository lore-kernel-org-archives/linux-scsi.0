From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 3 Oct 2006 13:52:37 -0700 (PDT)
Message-ID: <20061003205237.18125.qmail@web31803.mail.mud.yahoo.com>
References: <1159885160.3443.20.camel@mulgrave.il.steeleye.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:52057 "HELO
	web31803.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1030390AbWJCUwh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 16:52:37 -0400
In-Reply-To: <1159885160.3443.20.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Tue, 2006-09-26 at 15:05 -0700, Alexis Bruemmer wrote:
> > In some cases while hotplugging disks on a system with an expander the
> > broadcast primitive will be posted and begin processing before the
> > expander change count is updated.  This causes the device that triggered
> > the broadcast to not be found.
> 
> Thanks; I'll stick this in.
> 
> However, it has always struck me that this broadcast code is fragile
> because of the way event processing works.  If we get two fairly close
> together broadcast events, we'll amalgamate them into a single event and
> then stop processing as soon as we find one expander that changed, if
> you want to look at sorting that out ...

You have to make a clarification: "the way event processing works" means
the way it works after you removed all of event processing from my code the
way I wrote it, and added a very naive "event processing" if it can be
called that.

Event processing seems to work just fine with my version of my code the
way I maintain it, and the way you had it originally on this list.

Just clarifying in case someone gets confused reading the code.

> 
> James
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

