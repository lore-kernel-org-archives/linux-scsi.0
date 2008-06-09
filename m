From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 0 of 3] [RFC] I/O Hints
Date: Mon, 9 Jun 2008 11:47:58 +0100
Message-ID: <20080609104758.GB25541@shareable.org>
References: <patchbomb.1212643369@sermon.lab.mkp.net> <20080605062754.GQ2961@webber.adilger.int> <yq1od6fml2q.fsf@sermon.lab.mkp.net> <20080606140205.GF19246@shareable.org> <yq14p86mrvw.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:40593 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759260AbYFIKsP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2008 06:48:15 -0400
Content-Disposition: inline
In-Reply-To: <yq14p86mrvw.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Andreas Dilger <adilger@sun.com>, linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org

Martin K. Petersen wrote:
> Jamie> Where it is due to specific values being not exactly right -
> Jamie> like the subdevice offset (or modulo-offset) in MD because it
> Jamie> doesn't represent all subdevices - it would be good for the
> Jamie> info to have flags saying which _specific_ values are not
> Jamie> exactly right.
> 
> You get that traversing the sysfs tree.

Ok.  So I should always traverse the sysfs tree, and only use the leaf
values, combining them at MD nodes as I see fit, and ignoring the
values you provide at MD nodes?

Is there enough information in sysfs for me to combine the values?
I.e. offsets of all child disks, etc.?

What about future compound disk types that my app doesn't know about?
Use your values, I guess.

> Jamie> So that programs can choose their heuristics appropriately.
> Jamie> After all, users will use suboptimal layouts, and still want
> Jamie> the best performance it can do.
> 
> I'd like to keep a clear distinction between normal applications and
> programs like mkfs.  I'm targeting the latter.
>
> Given that filesystems can lay out files at will, I/O characteristics
> for normal applications is really FIEMAP territory.

I'm thinking of database type applications directly on block devices.
They need similar performance guides as filesystems.

You're right that most apps are FIEMAP territory.

Vice versa: Filesystems on LVM may be FIEMAP territory, if there are
many non-contiguous LVM strips, spanning multiple devices, LVM
snapshots, etc.

-- Jamie
