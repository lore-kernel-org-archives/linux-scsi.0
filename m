From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] scsi_lib.c: continue after MEDIUM_ERROR
Date: Fri, 2 Feb 2007 14:42:11 +0000
Message-ID: <20070202144211.5a2d2365@localhost.localdomain>
References: <200701301947.08478.liml@rtr.ca>
	<1170206199.10890.13.camel@mulgrave.il.steeleye.com>
	<45C2474E.9030306@rtr.ca>
	<1170366920.3388.62.camel@mulgrave.il.steeleye.com>
	<45C32C7F.9050706@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45C32C7F.9050706@emc.com>
Sender: linux-ide-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mark Lord <liml@rtr.ca>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> The interesting point of this question is about the typically pattern of 
> IO errors. On a read, it is safe to assume that you will have issues 
> with some bounded numbers of adjacent sectors.

Which in theory you can get by asking the drive for the real sector size
from the ATA7 info. (We ought to dig this out more as its relevant for
partition layout too).

> I really like the idea of being able to set this kind of policy on a per 
> drive instance since what you want here will change depending on what 
> your system requirements are, what the system is trying to do (i.e., 
> when trying to recover a failing but not dead yet disk, IO errors should 
> be as quick as possible and we should choose an IO scheduler that does 
> not combine IO's).

That seems to be arguing for a bounded "live" time including retry run
time for a command. That's also more intuitive for real time work and for
end user setup. "Either work or fail within n seconds"


Alan
