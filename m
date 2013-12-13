From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [usb-storage] UAS hangs khubd on USB disconnect
Date: Fri, 13 Dec 2013 12:03:19 -0800
Message-ID: <1386964999.2055.59.camel@dabdike.int.hansenpartnership.com>
References: <20131213180907.GB10727@xanatos>
	 <Pine.LNX.4.44L0.1312131316470.1185-100000@iolanthe.rowland.org>
	 <20131213183343.GC27070@htj.dyndns.org>
	 <1386962327.2055.54.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1386962327.2055.54.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB Storage List <usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2013-12-13 at 11:18 -0800, James Bottomley wrote:
> On Fri, 2013-12-13 at 13:33 -0500, Tejun Heo wrote:
> > Hello, guys.
> > 
> > (cc'ing Greg)
> > 
> > On Fri, Dec 13, 2013 at 01:19:36PM -0500, Alan Stern wrote:
> > > On Fri, 13 Dec 2013, Sarah Sharp wrote:
> > > 
> > > > > Given the way things work now, I suspect these warnings are truly 
> > > > > harmless.  We could simply get rid of the WARN in sysfs_remove_group.
> > > > > 
> > > > > The alternative is to call device_del for SCSI targets earlier on, such 
> > > > > as when their hosts are unregistered.  I don't know how James would 
> > > > > feel about this approach.  It would be difficult because targets use 
> > > > > their own reference counts instead of relying on the usual device 
> > > > > refcounting mechanism.
> > > > 
> > > > Thanks for looking into this.  I think just getting rid of the WARN
> > > > would be sufficient.  Can you make a patch for that?
> > > 
> > > Easily.  The downside is that there would no longer be any warning 
> > > when someone tries to remove a wrong subdirectory by mistake.
> > > 
> > > > The patch still won't help with the UAS issues with
> > > > scsi_init_shared_tag_map though.
> > > 
> > > I wasn't clear on the reason for that problem.  Does it also arise from 
> > > late device_del for scsi_target?  I could try to change the way that 
> > > works, if anybody (Hans?) would like to test it.
> > 
> > While the recent sysfs changes made this issue more visible, Greg
> > wants to make sure that devices are removed from leaf up in all cases
> > and keep the warning to ensure that.  Would there be a way fix SCSI
> > removal ordering?
> 
> Could someone analyse the actual problem?  We're quite careful even on
> host remove to iterate and remove all the devices, then targets, then
> host (and allied transport objects).  Which removal is inverted?

Actually, I think I have this figured out.  There's a thinko in one of
the scsi_target_reap() cases.  The original (and still existing) problem
with targets is that nothing creates them and nothing destroys them, so,
while we could rely on the refcounting of the device model to preserve
the actual target object, we had no idea when to remove it from
visibility.  That was the job of the reap reference, to track
visibility.  It looks like the reap on device last put is occurring too
late.  I think we should reap immediately after doing the sdev
device_del, so does this fix the warn on? (I'm not sure because no-one
has actually posted a backtrace, but it sounds like this is the
problem).

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 8ff62c2..98d4eb3 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -399,8 +399,6 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
 	/* NULL queue means the device can't be used */
 	sdev->request_queue = NULL;
 
-	scsi_target_reap(scsi_target(sdev));
