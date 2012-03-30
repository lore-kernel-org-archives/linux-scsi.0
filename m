From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
	of disks naming
Date: Fri, 30 Mar 2012 08:28:08 -0700
Message-ID: <20120330152808.GC28934@google.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
	<20120330152606.GB28934@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20120330152606.GB28934@google.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: Jens Axboe <axboe@kernel.dk>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
> On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
> >  The current virtblk's naming algorithm only supports 263  disks.
> > If there are mass of virtblks(exceeding 263), there will be disks
> > with the same name.
> > 
> > By renaming "sd_format_disk_name()" to "disk_name_format()"
> > and moving it into block core, virtio_blk can use this function to
> > support mass of disks.
> > 
> > Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> 
> I guess it's already way too late but why couldn't they have been
> named vdD-P where both D and P are integers denoting disk number and
> partition number?  [sh]dX's were created when there weren't supposed
> to be too many disks, so we had to come up with the horrible alphabet
> based numbering scheme but vd is new enough.  I mean, naming is one
> thing but who wants to figure out which sequence is or guess what
> comes next vdzz9?  :(
> 
> If we're gonna move it to block layer, let's add big blinking red
> comment saying "don't ever use it for any new driver".

And also let's make that clear in the function name - say,
format_legacy_disk_name() or something.

Thanks.

-- 
tejun
