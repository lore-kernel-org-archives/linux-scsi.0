From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v4 08/10] scsi: Generate uevents on certain unit
 attention codes
Date: Thu, 08 Aug 2013 18:15:17 -0700
Message-ID: <1376010917.11375.17.camel@dabdike.int.hansenpartnership.com>
References: <1375390659-12495-1-git-send-email-emilne@redhat.com>
	 <1375390659-12495-9-git-send-email-emilne@redhat.com>
	 <1375463172.2062.28.camel@dabdike.int.hansenpartnership.com>
	 <1375978138.3796.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43084 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966943Ab3HIBPY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2013 21:15:24 -0400
In-Reply-To: <1375978138.3796.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-08-08 at 12:08 -0400, Ewan Milne wrote:
> On Fri, 2013-08-02 at 10:06 -0700, James Bottomley wrote:
> > On Thu, 2013-08-01 at 16:57 -0400, Ewan D. Milne wrote:
> > > From: "Ewan D. Milne" <emilne@redhat.com>
> > > + * scsi_report_lun_change - Set flag on all *other* devices on the same target
> > > + *                          to indicate that a UNIT ATTENTION is expected.
> > > + *                          Only do this for SPC-3 devices, however.
> > > + * @sdev:	Device reporting the UNIT ATTENTION
> > > + */
> > > +static void scsi_report_lun_change(struct scsi_device *sdev)
> > > +{
> > > +	struct Scsi_Host *shost = sdev->host;
> > > +	struct scsi_device *tmp_sdev;
> > > +
> > > +	if (sdev->scsi_level == SCSI_SPC_3)
> > 
> > Why the SPC3 check?  We have SPC2 targets that use report luns and
> > presumably work as well.
> 
> Really the check was for SPC-4 and above, which I believe only generates
> a single REPORT LUNS DATA HAS CHANGED unit attention on the first LUN
> accessed.  This was described in T10 06-411r2.  I think it is still
> needed but should be changed to <= SCSI_SPC_3.

Perhaps the check needs to go then.  Just because SPC-4 says one event
per target doesn't mean devices will obey it.  There's no harm if we
guard against repeats even for SPC-4 and above (if they don't do it,
it's just a few extra setting and unsetting of flags) and we'll just
have to remove it again when the first broken device shows up.

> > 
> > > +		shost_for_each_device(tmp_sdev, shost) {
> > > +			if (tmp_sdev->channel == sdev->channel &&
> > > +			    tmp_sdev->id == sdev->id &&
> > > +			    tmp_sdev != sdev)
> > 
> > This should be starget_for_each_device calling a function rather than
> > hand rolling.
> > 
> > > +				tmp_sdev->expecting_cc_ua = 1;
> > 
> > Even with a restricted target loop, this is a bit messy (I think it's my
> > fault: I did ask you to reuse the existing mechanism, but now I see it,
> > a separate mechanism that functions the same way on the target looks a
> > lot cleaner) .  It looks like a struct scsi_target
> > expecting_lun_change:1 flag would work better in this case?  You'd set
> > it in the target at first sight, check it in scsi_report_sense() and
> > clear it on successful REPORT_LUNS command.  There's no need to lock it
> > because operations on a u32 are atomic and we're going to get slop
> > around this and the possibility of extra events anyway.
> 
> I've tried this out, and it seems to work OK, but I'm a little concerned
> about the possibility of losing a subsequent notification.  If a flag is
> used on the target, then multiple 3F 0E UAs from the same device could
> be suppressed, which isn't exactly the correct behavior.  Each LUN is
> only supposed to report 3F 0E once in SPC-3, per change.  If we receive
> another one, then there presumably has been *another* change.
> 
> Perhaps I'm being too picky about this, and I'm not at all sure that
> every storage array has this implemented properly either, so maybe it
> doesn't matter enough.

Well, you're not thinking about it the right way. Even on the per sdev
flag, we don't clear until a successful GOOD status return, so it will
suppress multiple genuine UAs anyway, assuming the lun data changes are
done fast enough.

>From a systems point of view, we receive a UA, trigger and event and
then some user programme tries to work out what changed by issuing a
REPORT LUNS and we suppress all UAs for LUN data changes until the
REPORT LUNS comes down.  Even if we get multiple genuine LUN data
changes in that interval, the user programme is going to read the latest
up to date information anyway, so it doesn't matter in the slightest
that we can lose genuine events.

The actual problem with the new scheme is the reverse: that it doesn't
suppress all the spurious events: given a target with three luns, two of
which are in constant use and one of which in sporadic, we'll suppress
the UAs from the LUNs in constant use, but if the sporadic LUN receives
no I/O until after the REPORT LUNS comes down, then it will trigger
another UA for an event we've already processed.  I think that's a price
worth paying for simplicity, though.

> > > --- a/drivers/scsi/scsi_sysfs.c
> > > +++ b/drivers/scsi/scsi_sysfs.c
> > > @@ -710,6 +710,11 @@ sdev_store_evt_##name(struct device *dev, struct device_attribute *attr,\
> > >  #define REF_EVT(name) &dev_attr_evt_##name.attr
> > >  
> > >  DECLARE_EVT(media_change, MEDIA_CHANGE)
> > > +DECLARE_EVT(inquiry_change_reported, INQUIRY_CHANGE_REPORTED)
> > > +DECLARE_EVT(capacity_change_reported, CAPACITY_CHANGE_REPORTED)
> > > +DECLARE_EVT(soft_threshold_reached, SOFT_THRESHOLD_REACHED_REPORTED)
> > > +DECLARE_EVT(mode_parameter_change_reported, MODE_PARAMETER_CHANGE_REPORTED)
> > > +DECLARE_EVT(lun_change_reported, LUN_CHANGE_REPORTED)
> > >  
> > >  /* Default template for device attributes.  May NOT be modified */
> > >  static struct attribute *scsi_sdev_attrs[] = {
> > > @@ -729,6 +734,11 @@ static struct attribute *scsi_sdev_attrs[] = {
> > >  	&dev_attr_ioerr_cnt.attr,
> > >  	&dev_attr_modalias.attr,
> > >  	REF_EVT(media_change),
> > > +	REF_EVT(inquiry_change_reported),
> > > +	REF_EVT(capacity_change_reported),
> > > +	REF_EVT(soft_threshold_reached),
> > > +	REF_EVT(mode_parameter_change_reported),
> > > +	REF_EVT(lun_change_reported),
> > 
> > This last one should be a property of the target attributes, shouldn't
> > it?  Otherwise the listener receives and event on the target and has to
> > go fishing around trying to find the one LUN we set the flag on.
> > 
> > Either we keep the flag on the sdev and send the event from the sdev or
> > we move the flag to the target and send the event from the target.
> 
> I could go either way on this -- conceptually it seems like the event
> should be reported on the scsi_target object, since the accessible LUNs
> on the target is what has actually changed on the storage, the LUN is
> just the messenger.  However, implementing this required adding a bunch
> of infrastructure for the uevent on the scsi_target object, which made
> the patch bigger, so I took that out in the v4 version.
> 
> Sending the event to the sdev would require a more complicated udev rule
> to handle it, since the logical action to take would be to perform a
> rescan of the target (that's what the last component of the v4 patch was
> designed to handle).
> 
> I'll change it to report the event on the sdev and post a v5 with what
> I have now, including the other things you mentioned.  Comments welcome.

OK, I'm fine either way, so I think we're good to go.

James


