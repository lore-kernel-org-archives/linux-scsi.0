From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 02 Feb 2007 08:53:27 -0600
Message-ID: <1170428007.3380.4.camel@mulgrave.il.steeleye.com>
References: <200701301947.08478.liml@rtr.ca>
	 <1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	 <45C2474E.9030306@rtr.ca>
	 <1170366920.3388.62.camel@mulgrave.il.steeleye.com>
	 <45C32C7F.9050706@emc.com>  <20070202144211.5a2d2365@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070202144211.5a2d2365@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>, Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2007-02-02 at 14:42 +0000, Alan wrote:
> > The interesting point of this question is about the typically pattern of 
> > IO errors. On a read, it is safe to assume that you will have issues 
> > with some bounded numbers of adjacent sectors.
> 
> Which in theory you can get by asking the drive for the real sector size
> from the ATA7 info. (We ought to dig this out more as its relevant for
> partition layout too).
> 
> > I really like the idea of being able to set this kind of policy on a per 
> > drive instance since what you want here will change depending on what 
> > your system requirements are, what the system is trying to do (i.e., 
> > when trying to recover a failing but not dead yet disk, IO errors should 
> > be as quick as possible and we should choose an IO scheduler that does 
> > not combine IO's).
> 
> That seems to be arguing for a bounded "live" time including retry run
> time for a command. That's also more intuitive for real time work and for
> end user setup. "Either work or fail within n seconds"

Actually, then I think perhaps we use the allowed retries for this ...

So you would fail a single sector and count it against the retries.
When you've done this allowed retries times, you fail the rest of the
request.

James


