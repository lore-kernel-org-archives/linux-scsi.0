From: Dave Chinner <david@fromorbit.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 13:17:42 +1100
Message-ID: <20110330021742.GL3008@dastard>
References: <1301373398.2590.20.camel@mulgrave.site>
 <4D91BF90.8070909@redhat.com>
 <1301445210.2731.14.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:1562 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754170Ab1C3CRr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Mar 2011 22:17:47 -0400
Content-Disposition: inline
In-Reply-To: <1301445210.2731.14.camel@mingming-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>

On Tue, Mar 29, 2011 at 05:33:30PM -0700, Mingming Cao wrote:
> Ric,
> 
> May I propose some discussion about concurrent direct IO support for
> ext4?

Just look at the way XFS does it and copy that?  i.e. it has a
filesytem level IO lock and an inode lock both with shared/exclusive
semantics. These lie below the i_mutex (i.e. locking order is
i_mutex, i_iolock, i_ilock), and effectively result in the i_mutex
only being used for VFS level synchronisation and as such is rarely
used inside XFS itself.

Inode attribute operations are protected by the inode lock, while IO
operations and truncation synchronisation is provided by the IO
lock.

So for buffered IO, the IO lock is used in shared mode for reads
and exclusive mode for writes. This gives normal POSIX buffered IO
semantics and holding the IO lock exclusive allows sycnhronisation
against new IO of any kind for truncate.

For direct IO, the IO lock is always taken in shared mode, so we can
have concurrent read and write operations taking place at once
regardless of the offset into the file.

> I am looking for some discussion about removing the i_mutex lock in the
> direct IO write code path for ext4, when multiple threads are
> direct write to different offset of the same file. This would require
> some way to track the in-fly DIO IO range, either done at ext4 level or
> above th vfs layer. 

Direct IO semantics have always been that the application is allowed
to overlap IO to the same range if it wants to. The result is
undefined (just like issuing overlapping reads and writes to a disk
at the same time) so it's the application's responsibility to avoid
overlapping IO if it is a problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
