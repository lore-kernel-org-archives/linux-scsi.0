From: "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH, RESEND] Avoid that SCSI device removal through sysfs
 triggers a deadlock
Date: Thu, 26 Jul 2018 07:14:35 -0700
Message-ID: <20180726141435.GV1934745@devbig577.frc2.facebook.com>
References: <20180725173828.2227-1-bart.vanassche@wdc.com>
 <20180726133527.GU1934745@devbig577.frc2.facebook.com>
 <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4dbd740c0555eb1bfcb4181eeaca5e397b6ab63c.camel@wdc.com>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "mingo@kernel.org" <mingo@kernel.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "oleg@redhat.com" <oleg@redhat.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Thu, Jul 26, 2018 at 02:09:41PM +0000, Bart Van Assche wrote:
> On Thu, 2018-07-26 at 06:35 -0700, Tejun Heo wrote:
> > Making removal asynchronous this way sometimes causes issues because
> > whether the user sees the device released or not is racy.
> > kernfs/sysfs have mechanisms to deal with these cases - remove_self
> > and kernfs_break_active_protection().  Have you looked at those?
> 
> Hello Tejun,
> 
> The call stack in the patch description shows that sdev_store_delete() is
> involved in the deadlock. The implementation of that function is as follows:
> 
> static ssize_t
> sdev_store_delete(struct device *dev, struct device_attribute *attr,
> 		  const char *buf, size_t count)
> {
> 	if (device_remove_file_self(dev, attr))
> 		scsi_remove_device(to_scsi_device(dev));
> 	return count;
> };
> 
> device_remove_file_self() calls sysfs_remove_file_self() and that last
> function calls kernfs_remove_self(). In other words, kernfs_remove_self()
> is already being used. Please let me know if I misunderstood your comment.

So, here, because scsi_remove_device() is the one involved in the
circular dependency, just breaking the dependency chain on the file
itself (self removal) isn't enough.  You can wrap the whole operation
with kernfs_break_active_protection() to also move
scsi_remove_device() invocation outside the kernfs synchronization.
This will need to be piped through sysfs but shouldn't be too complex.

Thanks.

-- 
tejun
