From: Nagendra Tomar <tomer_iisc@yahoo.com>
Subject: Re: [PATCH 2.6.23.14] SCSI : scsi_device_lookup/scsi_device_lookup_by_target return NULL for an existent scsi_device
Date: Mon, 28 Jan 2008 14:32:34 -0800 (PST)
Message-ID: <622876.55541.qm@web53702.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web53702.mail.re2.yahoo.com ([206.190.37.23]:23996 "HELO
	web53702.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762435AbYA1Wcf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2008 17:32:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

James,
      I am facing issues with device removal being done when there
are commands outstanding in the LLD. As explained in my original post,
its resulting in effects ranging from the duplicate kobject warnings to
the inability of the scsi subsystem to find a valid device (all symptoms
are related to the fact that two scsi devices with the same HBTL but in 
diff states, SDEV_DEL and SDEV_RUNNING, are in the lists).
      After extensive audit of the code I'm quite certain that the aforementioned
patch is the right thing to do. I'll greatly appreciate if you can highlight
reason(s) why that might not be a good idea. Pls apply o/w.

Thanx,
Tomar

--- Nagendra Tomar <tomer_iisc@yahoo.com> wrote:

> Hello James,
>              My understanding is that the scsi_device in SDEV_DEL state
> is there in the scsi_host->devices/scsi_target->devices queue, just
> because there is some outstanding command holding a reference to it.
> 
> It will need the device when it completes. Apart from this, for all 
> practical purposes the scsi_device is gone from the system. It could
> as well be removed from scsi_host->devices/scsi_target->devices lists
> and be put in some other list, just to hold the scsi_device till
> commands refering to it are completed. 
> 
> The scanning code should not consider these devices to be present 
> in the system. This is correctly handled today, as 
> scsi_device_lookup/scsi_device_lookup_by_target return NULL if there
> is an SDEV_DEL device in the list. 
> 
> Since a scsi_device in SDEV_DEL state is "gone" from the system we 
> should not hold any fresh references on to this device. The current
> scsi_device_lookup/scsi_device_lookup_by_target implementation rightly
> ensures that. And since all the sysfs linkages are also removed (in
> __scsi_remove_device->device_del), user space can also not reference 
> this device. All is good till now.
> 
> The problem happens when we try to add a new scsi_device with the same 
> HBTL. Since we consider the device "gone" (as described above) we should
> allow a new scsi_device with the same HBTL to be added (to the 
> scsi_host->devices/scsi_target->devices list). This part is also correctly
> implemented.
> scsi_add_device->...->scsi_probe_and_add_lun->scsi_device_lookup_by_target
> will _not_ return the device present in the SDEV_DEL state and hence the
> scanning will go ahead and try to add a new scsi_device (this one in 
> SDEV_RUNNING state) to the devices lists.
> 
> All is good even till now.
> 
> The PROBLEM is, now any scsi_device_lookup call trying to lookup this newly
> added scsi_device, fails. This is because, scsi_device_lookup->__scsi_device_lookup
> returns the first device that it finds in the list, which in this case
> is the one in the SDEV_DEL state. Now the scsi_device_get call that 
> scsi_device_lookup makes to get a reference on that device returns ENXIO
> as the device is in SDEV_DEL state, resulting in scsi_device_lookup to 
> return NULL.
> 
> What scsi_device_get does, is right, as we do not want to hold fresh 
> references on scsi_devices in SDEV_DEL state. The problem is because
> of this we fail to lookup the perfectly legitimate device (in SDEV_RUNNING
> state) with the same HBTL sitting in the list.
> 
> One of the side effects of this is that the scsi_probe_and_add_lun()
> goes ahead with the scanning and tries to add this existent device. 
> This is the real problem.
> 
> My patch avoids this problem by not breaking from the __scsi_device_lookup
> loop, if the device is in SDEV_DEL state. After all we should not consider
> these devices to be part of the system. This will allow us to 
> find the right scsi_device and this "trying to add an existent device"
> problem will be avoided. 
> 
> And also why should scsi_device_lookup and __scsi_device_lookup be 
> different in behaviour. One returns devices in SDEV_DEL state, the other
> doesn't. The comments suggest that they can be used interchangibly, but
> for the locking and the extra reference that the scsi_device_lookup holds.
> 
> This is fixed as a side effect of the patch.
> 
> Comments welcome.
> 
> Thanx,
> Tomar
> 
> 
> 
> 
> 
> --- James Smart <James.Smart@Emulex.Com> wrote:
> 
> > 
> > This sounds like a return to the old behavior, where sdevs in SDEV_DEL
> > were ignored. However, it too had lots of bad effects. We'd have to go
> > back to the threads over the last 2 years that justified resurrecting
> > the sdev. Start looking at threads like :
> > http://marc.info/?l=linux-scsi&m=115555788730468&w=2
> > http://marc.info/?l=linux-scsi&m=116837744314913&w=2
> > http://marc.info/?l=linux-scsi&m=117139230702785&w=2
> > http://marc.info/?l=linux-scsi&m=117991046126294&w=2
> > Also, there's multiple parts to this - the sdev struct, and the sysfs objects
> > and thus namespace associated with the struct, etc.
> > 
> > So, in my mind, if this reverts to ignoring sdevs in SDEV_DEL, and creates
> > a duplicate sdev in SDEV_RUNNING, then it's the wrong patch.  What should
> > be considered is where did the resurrection of the sdev go wrong.  I
> > remember that Hannes did some updates
> > http://marc.info/?l=linux-scsi&m=118215727101887&w=2
> > but I don't believe these ever got merged upstream. Perhaps that's a good
> > place to start.
> > 
> > -- james s
> > 
> > 
> > Nagendra Tomar wrote:
> > > __scsi_device_lookup and __scsi_device_lookup_by_target do not 
> > > check for the sdev_state and hence return scsi_devices with 
> > > sdev_state set to SDEV_DEL also. It has the following side effects.
> > > 
> > > We can have two scsi_devices with the same HBTL queued in 
> > > the scsi_host->__devices/scsi_target->devices list, one
> > > in the SDEV_DEL state and the other in, say SDEV_RUNNING state. 
> > >     If the one in the SDEV_DEL state is before the one in SDEV_RUNNING 
> > > state, (which will almost always be the case) the scsi_device_lookup and 
> > > scsi_device_lookup_by_target will never find the totally legitimate
> > > scsi_device (the one in the SDEV_RUNNING state).
> > > 
> > > This is because __scsi_device_lookup/__scsi_device_lookup_by_target 
> > > always returns the first one in the list (which in our case is the 
> > > one with the SDEV_DEL state) and the scsi_device_get() which is called by 
> > > scsi_device_lookup/scsi_device_lookup_by_target will return -ENXIO 
> > > for this scsi_device, resulting in scsi_device_lookup and 
> > > scsi_device_lookup_by_target to return NULL.
> > > 
> > >         So we _cannot_ lookup a perfectly valid device present in the
> > > list of scsi_devices. 
> > > 
> > >         The right thing to do is to not have __scsi_device_lookup
> > > and __scsi_device_lookup_by_target match a device if the scsi_device
> > > state is SDEV_DEL. This will also make these functions similar in 
> > > behaviour to their scsi_device_lookup/scsi_device_lookup_by_target
> > > counterparts, as the comments in the code suggest.
> > > 
> > >         One way by which we can have two scsi_devices in the list is 
> > > as follows.        
> > >         Suppose a scsi_device has some outstanding command(s) when 
> > > scsi_remove_device is called for it. Due to the extra ref being held
> > > by the command in flight, the __scsi_remove_device->put_device call 
> > > will not actually free the scsi_device and it will remain in the 
> > > scsi_device list albeit in the SDEV_DEL state. Now if we do a 
> > > scsi_add_device for the same HBTL, a new device with the same HBTL
> > > (this one in SDEV_RUNNING state) gets added to the scsi_device list. 
> > >         
> > >         Infact if we call scsi_add_device one more time, it happily 
> > > goes ahead and tries to add it once more, as 
> > > scsi_probe_and_add_lun->scsi_device_lookup_by_target does not return
> > > the already existing device. This will though result in the kobject 
> > > EEXIST warning dump.
> > > 
> > >         The patch below solves the problem described here by not
> > > returning scsi_devices in SDEV_DEL state, thus allowing scsi_device
> > > in SDEV_RUNNING state (if any) to be correctly returned, instead.
> > > 
> > > 
> > > Thanx,
> > > Tomar
> > > 
> > > 
> > > Signed-off-by: Nagendra Singh Tomar <nagendra_tomar@adaptec.com>
> > > ---
> > > 
> > > --- linux-2.6.23.14/drivers/scsi/scsi.c.orig	2008-01-23 18:06:02.000000000 +0530
> > > +++ linux-2.6.23.14/drivers/scsi/scsi.c	2008-01-23 19:17:35.000000000 +0530
> > > @@ -951,7 +951,7 @@ struct scsi_device *__scsi_device_lookup
> > >  	struct scsi_device *sdev;
> > >  
> > >  	list_for_each_entry(sdev, &starget->devices, same_target_siblings) {
> > > -		if (sdev->lun ==lun)
> > > +		if (sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
> > >  			return sdev;
> > >  	}
> > >  
> > > @@ -1008,7 +1008,7 @@ struct scsi_device *__scsi_device_lookup
> > >  
> > >  	list_for_each_entry(sdev, &shost->__devices, siblings) {
> > >  		if (sdev->channel == channel && sdev->id == id &&
> > > -				sdev->lun ==lun)
> > > +			sdev->lun == lun && sdev->sdev_state != SDEV_DEL)
> > >  			return sdev;
> > >  	}
> > > 
> > > 
> > > 
> > >       ___________________________________________________________
> > > Support the World Aids Awareness campaign this month with Yahoo! For Good
> > http://uk.promotions.yahoo.com/forgood/
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> 
> 
> 
>       __________________________________________________________
> Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com
> 
> 



      __________________________________________________________
Sent from Yahoo! Mail - a smarter inbox http://uk.mail.yahoo.com

