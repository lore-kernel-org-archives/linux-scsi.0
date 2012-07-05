From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: New Defects based on recent changes in Kernel code found by
 Coverity Scan
Date: Thu, 5 Jul 2012 12:44:26 -0700
Message-ID: <20120705124426.c4a2f347.akpm@linux-foundation.org>
References: <829BE905228AE14A9AE1A46E6F2E371605538D039D@VA3DIAXVS891.RED001.local>
	<20120703152739.ea7df9e6.akpm@linux-foundation.org>
	<20120705153316.GN14928@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120705153316.GN14928@shiny>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Mason <chris.mason@fusionio.com>
Cc: Scan Subscription <scan-subscription@coverity.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chris L. Mason" <clmason@fusionio.com>, Bing Zhao <bzhao@marvell.com>, Robert Love <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Theodore Ts'o <tytso@mit.edu>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 5 Jul 2012 11:33:16 -0400 Chris Mason <chris.mason@fusionio.com> wrote:

> > > * CID 709112: Dereference after null check - fs/btrfs/ioctl.c, line: 1309 Comparing "device->fs_devices" to null implies that "device->fs_devices" might be null, and then it is deference
> > > fs/btrfs/ioctl.c:1309
> > 
> > Chris.
> 
> Thanks for forwarding this.  But I'm a little confused, our line 1309 is
> this:
> 
>         if (device->fs_devices && device->fs_devices->seeding) {
> 
> Is coverity telling me that I'm using fs_devices later on in the
> function without extra checks?  Some functions we call do assume it
> isn't null, but the seeding devices are special snowflakes. 

There were more details further down in the email:

> ____________________________________________________________________________________________________________
> CID 709112: Dereference after null check 
> 
> fs/btrfs/ioctl.c:1309
> 1256 static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
> 1257                                        void __user *arg)
> 1258 {
> ...
> >>> At conditional (1): "device->fs_devices" taking the false branch.
> >>> CID 709112: Dereference after null check (FORWARD_NULL) Comparing "device->fs_devices" to null implies that "device->fs_devices" might be null.
> 1309        if (device->fs_devices && device->fs_devices->seeding) {
> 1310                printk(KERN_INFO "btrfs: resizer unable to apply on "
> 1311                       "seeding device %llu\n", devid);
> 1312                ret = -EINVAL;
> 1313                goto out_free;
> 1314        }
> ...
> >>> Passing null variable "device->fs_devices" to function "btrfs_grow_device", which dereferences it. 
> 1367                ret = btrfs_grow_device(trans, device, new_size);
> 1368                btrfs_commit_transaction(trans, root);
> 1369        } else if (new_size < old_size) {
> >>> Passing null variable "device->fs_devices" to function "btrfs_shrink_device", which dereferences it. 
> 1370                ret = btrfs_shrink_device(device, new_size);
> 1371        }
> 1378 }
