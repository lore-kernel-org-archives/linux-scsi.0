From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: Hotplug ex_change_count race fix
Date: Tue, 03 Oct 2006 09:19:20 -0500
Message-ID: <1159885160.3443.20.camel@mulgrave.il.steeleye.com>
References: <1159308320.9567.55.camel@alexis>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:16803 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932245AbWJCOTX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 3 Oct 2006 10:19:23 -0400
In-Reply-To: <1159308320.9567.55.camel@alexis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2006-09-26 at 15:05 -0700, Alexis Bruemmer wrote:
> In some cases while hotplugging disks on a system with an expander the
> broadcast primitive will be posted and begin processing before the
> expander change count is updated.  This causes the device that triggered
> the broadcast to not be found.

Thanks; I'll stick this in.

However, it has always struck me that this broadcast code is fragile
because of the way event processing works.  If we get two fairly close
together broadcast events, we'll amalgamate them into a single event and
then stop processing as soon as we find one expander that changed, if
you want to look at sorting that out ...

James


