From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 18:47:31 +0000
Message-ID: <1237402051.3350.29.camel@localhost.localdomain>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:42316 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750737AbZCRSri (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Mar 2009 14:47:38 -0400
In-Reply-To: <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu

On Tue, 2009-03-17 at 18:36 -0700, Chandra Seetharaman wrote:
> From: Peter Jones <pjones@redhat.com>
> 
> This patch allows the use of modaliases on scsi targets to correctly
> load scsi device handler modules when the devices are found.
> 
> Signed-off-by: Peter Jones <pjones@redhat.com>
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

I have to say this is a bit icky.

overloading the modalias type like this produces several nasty effects:

     1. You don't actually care about type for any of the scsi_dh
        handlers, so they all have it as a useless extra field
     2. TYPE_ANY is a bogus (non SAM) definition ... I suppose it's
        unlikely ever to clash, but you never know
     3. scsi_dh handlers would now get loaded on *any* system ...
        regardless of whether it's using multipathing or not ... that's
        going to cause problems with other multi path solutions, I bet.

Why not use a separately defined module alias for this ... and then
program udev to understand it and do the loading only if multipath is
actually present?  I think we might have to add the INQUIRY strings to
the uenv for this, but it would be a much more elegant solution.

James


