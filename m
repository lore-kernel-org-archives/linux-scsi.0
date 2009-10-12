From: "Ulrich Windl" <ulrich.windl-LOEJiUoeGm199bV2EpccEXqWYbMAw+HU@public.gmane.org>
Subject: Re: SD Driver incrementing on every snapshot.
Date: Mon, 12 Oct 2009 13:21:10 +0200
Message-ID: <4AD32D48.4809.1268D55@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
References: <4AC29F0F.9000601@aptalaska.net>, <4AC38295.9010200@cs.wisc.edu>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Return-path: <grbounce-FC1hwAUAAAA0O9VQcsxVj1UPjHD9r3x_=glio-open-iscsi=m.gmane.org-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-reply-to: <4AC38295.9010200-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Content-description: Mail message body
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Post: <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://googlegroups.com/group/open-iscsi/subscribe>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org


I wonder:
a SCSI host is allocated when a device connects, and it's deallocated if a device 
disconnects. While (IMHO) the first step is necessary, the second isn't (the 
device may be there, but any attempt to use it could return "no such device" or 
EIO). If device deallocation were delayed and some information about the device 
remembered, it would be possible to assign the same scsi host if the same device 
re-connects (my theory). So when repeatedly connecting and disconecting a specific 
USB stick, one could use the same SCSI device. That would sound kind of nice.
To get rid of garbage, on could recycle "old unused SCSI hosts" after a specific 
number of new connects.

Regards,
Ulrich


On 30 Sep 2009 at 11:08, Mike Christie wrote:

> 
> On 09/29/2009 06:58 PM, Matthew Schumacher wrote:
> > Group,
> >
> > I'm using linux to backup an ISCSI target.  My backup script calls the
> > snapshot function on my iscsi server, then uses open-iscsi to connect to
> > a snapshot target on that server.  The target is backed up, then I
> > logoff the target until the next backup.
> >
> > The problem is that the scsi device number in linux keeps incrementing:
> >
> > scsi13 : iSCSI Initiator over TCP/IP
> > scsi14 : iSCSI Initiator over TCP/IP
> > scsi15 : iSCSI Initiator over TCP/IP
> >
> > Is this cause for concern?  Will it quit on me at some point?  Is there
> 
> It is expected behavior. The X in scsiX is a host number. The linux scsi 
> layer will increment it every time we create a new host. We end up doing 
> a host per session and in your case it looks like your target is doing a 
> session device.
> 
> It will quit at some point. The host number is a unsigned 32 bit int, so 
> once you go through 2^32, the scsi layer will roll over. When that 
> happens the scsi layer's host number allocation algorithm is not very 
> smart and could fail.
> 
> So in practice you probably would not login/logout a of a target 2^32 
> times. But it is possible if you just did loop test and let it run over 
> night.
> 
> 
> > a way to make open-iscsi reuse an old scsi device number?
> >
> 
> No.
> 
> > 
