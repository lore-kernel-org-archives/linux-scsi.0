From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [Lsf] Preliminary Agenda and Activities for LSF
Date: Wed, 30 Mar 2011 14:49:58 -0700
Message-ID: <1301521798.7449.65.camel@mingming-laptop>
References: <1301373398.2590.20.camel@mulgrave.site>
	 <4D91BF90.8070909@redhat.com> <1301445210.2731.14.camel@mingming-laptop>
	 <20110330021742.GL3008@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110330021742.GL3008@dastard>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Ric Wheeler <rwheeler@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, lsf@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-03-30 at 13:17 +1100, Dave Chinner wrote:
> On Tue, Mar 29, 2011 at 05:33:30PM -0700, Mingming Cao wrote:
> > Ric,
> > 
> > May I propose some discussion about concurrent direct IO support for
> > ext4?
> 
> Just look at the way XFS does it and copy that?  i.e. it has a
> filesytem level IO lock and an inode lock both with shared/exclusive
> semantics. These lie below the i_mutex (i.e. locking order is
> i_mutex, i_iolock, i_ilock), and effectively result in the i_mutex
> only being used for VFS level synchronisation and as such is rarely
> used inside XFS itself.
> 
> Inode attribute operations are protected by the inode lock, while IO
> operations and truncation synchronisation is provided by the IO
> lock.
> 

Right, inode attribute operations should be covered by the i_lock. in
ext4 the i_mutex is used to protect IO and truncation synch, along with
the i_datasem to pretect concurrent access.modification to file's
allocation. 

> So for buffered IO, the IO lock is used in shared mode for reads
> and exclusive mode for writes. This gives normal POSIX buffered IO
> semantics and holding the IO lock exclusive allows sycnhronisation
> against new IO of any kind for truncate.
> 
> For direct IO, the IO lock is always taken in shared mode, so we can
> have concurrent read and write operations taking place at once
> regardless of the offset into the file.
> 

thanks for reminding me,in xfs concurrent direct IO write to the same
offset is allowed.

> > I am looking for some discussion about removing the i_mutex lock in the
> > direct IO write code path for ext4, when multiple threads are
> > direct write to different offset of the same file. This would require
> > some way to track the in-fly DIO IO range, either done at ext4 level or
> > above th vfs layer. 
> 
> Direct IO semantics have always been that the application is allowed
> to overlap IO to the same range if it wants to. The result is
> undefined (just like issuing overlapping reads and writes to a disk
> at the same time) so it's the application's responsibility to avoid
> overlapping IO if it is a problem.
> 


I was thinking along the line to provide finer granularity lock to allow
concurrent direct IO to different offset/range, but to same offset, they
have to be serialized. If it's undefined behavior, i.e. overlapping is
allowed, then concurrent dio implementation is much easier. But not sure
if any apps currently using DIO aware of the ordering has to be done at
the application level. 

> Cheers,
> 
> Dave.


