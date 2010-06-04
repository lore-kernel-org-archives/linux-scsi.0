From: Nick Piggin <npiggin@suse.de>
Subject: Re: Wrong DIF guard tag on ext2 write
Date: Fri, 4 Jun 2010 13:09:43 +1000
Message-ID: <20100604030943.GA26335@laptop>
References: <1275411293.21962.387.camel@mulgrave.site>
 <20100601180905.GR8980@think>
 <20100601184649.GE9453@laptop>
 <20100601193528.GV8980@think>
 <20100602032030.GF9453@laptop>
 <yq17hmhbmkb.fsf@sermon.lab.mkp.net>
 <20100602134121.GD6152@laptop>
 <20100603154634.GC8980@think>
 <20100603162718.GR6822@laptop>
 <yq1y6evwox1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:38152 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932161Ab0FDDJs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 3 Jun 2010 23:09:48 -0400
Content-Disposition: inline
In-Reply-To: <yq1y6evwox1.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@oracle.com>, James Bottomley <James.Bottomley@suse.de>, Matthew Wilcox <matthew@wil.cx>, Christof Schmitt <christof.schmitt@de.ibm.com>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Thu, Jun 03, 2010 at 09:46:02PM -0400, Martin K. Petersen wrote:
> >>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:
> 
> Nick> Also I don't think we can deal with memory errors and scribbles
> Nick> just by crcing dirty data. The calculations generating the data
> Nick> could get corrupted.
> 
> Yep, the goal is to make the window as small as possible.
> 
> 
> Nick> Data can be corrupted on its way back from the device to
> Nick> userspace.
> 
> We also get a CRC back from the storage.  So the (integrity-aware)
> application is also able to check on read.

Well that's nice :)


> Nick> Obviously this feature is being pushed by databases and such that
> Nick> really want to pass checksums all the way from userspace. Block
> Nick> retrying is _not_ needed or wanted here of course.
> 
> Nope.  The integrity error is bubbled all the way up to the database and
> we can decide to retry, recreate or error out depending on what we find
> when we do validation checks on the data buffer and the integrity
> metadata.

By block retrying, I just meant the bounce / re-checksum approach.

