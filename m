From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: don't count non-failure CHECK_CONDITION as error
Date: Fri, 15 Jan 2016 11:36:08 -0800
Message-ID: <1452886568.2356.23.camel@HansenPartnership.com>
References: <20160114214602.GC3520@mtj.duckdns.org>
	 <1452872774.2356.5.camel@HansenPartnership.com>
	 <1452873302.2356.9.camel@HansenPartnership.com>
	 <56992361.7030606@interlog.com>
	 <1452882934.2356.13.camel@HansenPartnership.com>
	 <20160115184252.GJ3520@mtj.duckdns.org>
	 <1452884956.2356.21.camel@HansenPartnership.com>
	 <20160115192755.GK3520@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57952 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbcAOTgL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2016 14:36:11 -0500
In-Reply-To: <20160115192755.GK3520@mtj.duckdns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Dave Jones <dsj@fb.com>, kernel-team@fb.com

On Fri, 2016-01-15 at 14:27 -0500, Tejun Heo wrote:
> Hello, James.
> 
> On Fri, Jan 15, 2016 at 11:09:16AM -0800, James Bottomley wrote:
> > If we want to change what is being counted, we have to change the
> > definition, so what is the definition you want to see for counting
> > errors? and what's the reason driving this change?
> 
> There isn't anything else to it than what I already wrote.  It goes
> up
> for things which aren't failures making the counter essentially
> useless.  It's confusing from userland as it's unintuitive that these
> commands are wrapped in SCSI ATA passthrough commands which use sense
> data for result reporting and doing equivalent operations on native
> SCSI and ATA devices lead to different outcomes.  The counter as-is
> is
> just useless for libata devices.  If it can be rectified easily,
> great.  If not, it isn't anything critical.

That's the point we were making: it can't be rectified easily.  Simply
counting non-good returns is easy.  Counting something that's closer to
errors is hard because first we have to define what an "error" is (I
could see queue full being not an error, but what about not ready or
initializing command required?) and then implement and infrastructure
to classify and count the returns, which means an awful lot of sense
data parsing.

James

