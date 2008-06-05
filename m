From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Thu, 5 Jun 2008 11:40:42 +0100
Message-ID: <20080605104042.GB20308@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:58788 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbYFEKko (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jun 2008 06:40:44 -0400
Content-Disposition: inline
In-Reply-To: <patchbomb.1212643369@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

Martin K. Petersen wrote:
> At the Filesystem & Storage Workshop there was lots of discussion
> about how to communicate I/O alignment, stripe width, etc. to the
> filesystems so they could lay out things properly.

That's really nice, thanks.

Does it handle devices with different properties in differeng offset
ranges?  E.g. a RAID setup where the first 100GB have one stripe
width, but the next 100GB have a different stripe width - as you can
get if you join two different hardware RAIDs with LVM, for example.

> The physical sector offset for the start of the "virtual" block device
> is also exported.  This includes partitions so you can get the actual
> physical start sector offset for - say - an MD device sitting on a
> partitioned set of drives.

If it's a set of drives, doesn't it need to return multiple offsets,
and drive identities?

> Comments and suggestions are welcome.

>From a database perspective, I'm thinking it would be very useful to
provide similar information for large files.  Database engines have
the same requirement to know stripe width etc., and filesystems
allocate large contiguous extents so it it makes sense to pass the
device characteristics up to the app, with appropriate offset.

(Same for loopback devices.)

This is an extreme example of different properties in different offset
ranges - it depends on file allocation.

Is there scope to extend FIEMAP to pass this sort of information?

-- Jamie
