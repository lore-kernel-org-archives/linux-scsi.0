From: David Disseldorp <ddiss@suse.de>
Subject: Re: Persistent Reservation API
Date: Tue, 11 Aug 2015 11:30:41 +0200
Message-ID: <20150811113041.68d9f122@g21.suse.de>
References: <1438672271-11309-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40436 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933704AbbHKJan (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 05:30:43 -0400
In-Reply-To: <1438672271-11309-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi Christoph,

On Tue,  4 Aug 2015 09:11:05 +0200, Christoph Hellwig wrote:

> This series adds support for a simplified persistent reservation API
> to the block layer.  The intent is that both in-kernel and userspace
> consumers can use the API instead of having to hand craft SCSI or NVMe
> command through the various pass through interfaces.  It also adds
> DM support as getting reservations through dm-multipath is a major
> pain with the current scheme.
> 
> NVMe support currently isn't included as I don't have a multihost
> NVMe setup to test on, but if I can find a volunteer to test it I'm
> happy to write the code for it.
> 
> The ioctl API is documented in Documentation/block/pr.txt, but to
> fully understand the concept you'll have to read up the SPC spec,
> PRs are too complicated that trying to rephrase them into different
> terminology is just going to create confusion.

Do you have any thoughts on where SCSI-2 RESERVE/RELEASE should fit into
this API, if at all? I.e. as a new enum pr_type members for
pr_reserve()/pr_release(), as separate pr_ops hooks, etc?
Similarly for PR_IN - IIUC, if LIO is to handle cluster wide PRs
for Ceph rbd via the block layer, these will all need to be supported
by block layer (and LIO backend) APIs.

Cheers, David
