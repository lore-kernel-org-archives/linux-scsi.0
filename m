From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [RFC] embryonic RAID class
Date: Wed, 17 Aug 2005 18:45:25 -0400
Message-ID: <1124318725.5221.12.camel@mulgrave>
References: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709318@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:52202 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751292AbVHQWpc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Aug 2005 18:45:32 -0400
In-Reply-To: <547AF3BD0F3F0B4CBDC379BAC7E4189F01709318@otce2k03.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2005-08-17 at 16:25 -0400, Salyzyn, Mark wrote:
> Under aac based adapters the build task reports the task number, current
> array water mark and end of array but not the array number associated
> with the build task in the AIF events returning from the Firmware. The
> management applications generally issue a series of enumerations to the
> devices and the arrays to build a set of objects, one of these object
> attributes is the build task associated with the array (if it is
> rebuilding).
> 
> Really simple to report the percentage completed as the driver already
> sniffs the AIFs to generate hot-add and hot-remove actions, much more
> difficult and quite possibly driver bloating to associate that build
> task status with an array or underlying targets.

Yes, fusion also necessitates some digging to get the correct
information.

> Compromise? Well, what about exporting an raid adapter class and having
> 'resync' associated with that adapter object? Array creation will no
> doubt have to go to the raid adapter class in any case, so it will be a
> requirement if configuration is to be allowed in this RAID class.

But isn't that what you currently have?  The HBA exports a get_resync()
method via the function templates which the raid class makes use of.

I admit that the whole thing will get hugely complex if configuration
becomes allowable via this class, but at the moment I'm just trying to
get at useful information display ... configuration can come later.

> Add hotspare-0, hotspare-1 ... to the list?

Yes ... I only have two disks though, so I've reached the limit of what
I can do with my current fusion setup.  The whole of the component
display has to be reworked anyway (I only provide add, but obviously
delete should be allowed as well as component type).  I'll add it to the
list.  Probably we also need a component state model as well (and
perhaps spare would be one of the states).

> A target id written to resync would be used to 'suck in' a hotspare or
> trigger a rebuild to a failed target?

Actually, probably do that via an echo to the state.  The user would be
allowed to kick certain state transitions, and degraded->resyncing
should probably be one of them.

James


