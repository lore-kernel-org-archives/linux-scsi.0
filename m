From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass
	of disks naming
Date: Mon, 2 Apr 2012 10:20:09 +0300
Message-ID: <20120402072009.GF30360@redhat.com>
References: <4F7581D4.4040301@cn.fujitsu.com> <4F7582B0.5010609@cn.fujitsu.com>
	<20120330152606.GB28934@google.com>
	<20120330152808.GC28934@google.com>
	<4F78FE89.2070707@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <4F78FE89.2070707@cn.fujitsu.com>
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
Cc: Jens Axboe <axboe@kernel.dk>, KVM <kvm@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 02, 2012 at 09:19:05AM +0800, Ren Mingxin wrote:
>  On 03/30/2012 11:28 PM, Tejun Heo wrote:
> >On Fri, Mar 30, 2012 at 08:26:06AM -0700, Tejun Heo wrote:
> >>On Fri, Mar 30, 2012 at 05:53:52PM +0800, Ren Mingxin wrote:
> >>>  The current virtblk's naming algorithm only supports 263  disks.
> >>>If there are mass of virtblks(exceeding 263), there will be disks
> >>>with the same name.
> >>>
> >>>By renaming "sd_format_disk_name()" to "disk_name_format()"
> >>>and moving it into block core, virtio_blk can use this function to
> >>>support mass of disks.
> >>>
> >>>Signed-off-by: Ren Mingxin<renmx@cn.fujitsu.com>
> >>I guess it's already way too late but why couldn't they have been
> >>named vdD-P where both D and P are integers denoting disk number and
> >>partition number?  [sh]dX's were created when there weren't supposed
> >>to be too many disks, so we had to come up with the horrible alphabet
> >>based numbering scheme but vd is new enough.  I mean, naming is one
> >>thing but who wants to figure out which sequence is or guess what
> >>comes next vdzz9?  :(
> >>
> >>If we're gonna move it to block layer, let's add big blinking red
> >>comment saying "don't ever use it for any new driver".
> >And also let's make that clear in the function name - say,
> >format_legacy_disk_name() or something.
> 
> So, to legacy disks [sh]d, we'd name them as [sh]d[a-z]{1,}. To new devices
> like vd, we'd name them as vd<index>(vd<index>p<partno> as partitions)?

Pleae don't rename virtio disks, it is way too late for that:
virtio block driver was merged around 2007, it is not new by
any measure, and there are many systems out there using
the current naming scheme.

> And how about the rssd in the patch 3 then?

Probably same. Renaming existing devices will break setups.
I think the idea is to avoid using the
legacy naming in new drivers *that will be added from now on*.

> Besides, does anybody have comments?
> Looking forward to your replies ;-)
> 
> -- 
> Thanks,
> Ren
