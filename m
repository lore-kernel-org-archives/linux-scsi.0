From: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
Subject: Re: Large disk drives
Date: Thu, 6 Nov 2014 10:53:56 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1411061049310.886-100000@iolanthe.rowland.org>
References: <545B86AC.3080704@plexistor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <545B86AC.3080704-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Boaz Harrosh <boaz-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Dale R. Worley" <worley-FrUbXkNCsVf2fBVCVOL8/A@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 6 Nov 2014, Boaz Harrosh wrote:

> On 11/06/2014 12:30 PM, James Bottomley wrote:

> > We really don't want to make the decision within the kernel of whether
> > we believe the partition size or the disk capacity.   For these disk
> > problems we need it to be the former, but if we choose that always,
> > we'll get weird results on mispartitioned devices.
> > 
> > The usual rule is no policy in the kernel and which to choose is policy,
> > so just export the knob (as Alan's patch does) and then let userspace
> > decide.

Another alternative would be to export a policy setting for whether or 
not to take the capacity from the partition table.  That would be more 
convenient for users, because then they wouldn't have to figure out the 
number of blocks in the drive.  On the other hand, it wouldn't work so 
well if there is no partition table and the user wants to create one.

> I do not think it is a matter of policy.
> 
> From what I understand the situation is that read_capacity_10() which is
> 32bit, Max 2T byte disks. fails with 0xffffffff and read_capacity_16() (64bit)
> is not supported because of wrong scsi-version or because it is blacklisted.
> (or device returns not-supported)

No, that is not the problem.  read_capacity_10() succeeds but gives an 
incorrect value.  read_capacity_16() fails.

> Now If sd_read_capacity() succeed then off-course we choose it. What I'm saying
> is if read-capacity fails, then should we attempt a new read_capacity_part()?

sd_read_capacity() succeeds, but the value it gets is wrong.

> And sure a user-mode knob if he wants to make policy, like you said, is fine
> by me.
> 
> But just the simple case of read-capacity failure should we then?

That's a separate question.  As far as I know, the case you are 
describing has not come up.

Alan Stern

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
