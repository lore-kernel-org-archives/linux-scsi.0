From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Is there a grand plan for FC failover?
Date: 29 Jan 2004 10:05:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075388747.2381.36.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C013B0@xbl.ma.emulex.com>
	<1075328212.2534.14.camel@mulgrave>
	<20040129094910.F11527@vienna.EGENERA.COM>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:53955 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266176AbUA2PF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jan 2004 10:05:57 -0500
In-Reply-To: <20040129094910.F11527@vienna.EGENERA.COM>
List-Id: linux-scsi@vger.kernel.org
To: "Philip R. Auld" <pauld@egenera.com>
Cc: "Smart, James" <James.Smart@Emulex.com>, 'Patrick Mansfield' <patmans@us.ibm.com>, Simon Kelley <simon@thekelleys.org.uk>, SCSI Mailing List <linux-scsi@vger.kernel.org>, dm-devel@sistina.com

On Thu, 2004-01-29 at 09:49, Philip R. Auld wrote:
> It needs to be known to the pathing layer if you've got load balancing. 
> It has to know which path has the reservation and only use that one.

Well, yes, but your multiple active path implementation just collapsed
back down to single path in the face of reservations, so it would
probably be better simply to use failover in the face of reservations
and clustering.

For the single path case, something like the HP MSA/EVA arrays simply
throw away reservations on path switch over.  This allows the user level
watchdog code to reassert them in a cluster down the new path.  However,
there are array that will do a path switchover and then return
reservation conflict to everyone (including the taking node).  These
arrays will need some type of special handling.

James



