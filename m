From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH] dm mpath: Try recover from I/O failure by
 re-initializing the PG if device is running on one path
Date: Tue, 21 Apr 2009 10:06:12 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF466A66DD4@cosmail01.lsi.com>
References: <E463DF2B2E584B4A82673F53D62C2EF466A0E4DA@cosmail01.lsi.com>
 <49ED1C24.9090303@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chip3og54.obsmtp.com ([64.18.14.173]:54807 "EHLO
	chip3og54.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZDURGd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2009 13:06:33 -0400
In-Reply-To: <49ED1C24.9090303@ct.jp.nec.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: "'dm-devel@redhat.com'" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "'sekharan@us.ibm.com'" <sekharan@us.ibm.com>

Hi Kiyoshi,

   Thanks for your comment.


> -----Original Message-----
> From: Kiyoshi Ueda [mailto:k-ueda@ct.jp.nec.com]
> Sent: Monday, April 20, 2009 8:07 PM
> To: Moger, Babu
> Cc: 'dm-devel@redhat.com'; linux-scsi@vger.kernel.org; Chauhan, Vijay;
> 'sekharan@us.ibm.com'
> Subject: Re: [PATCH] dm mpath: Try recover from I/O failure by re-
> initializing the PG if device is running on one path
> 
> Hi Babu,
> 
> On 2009/04/21 3:05 +0900, Moger, Babu wrote:
> > This patch introduces the mechanism to recover from I/O failures by
> > re-initializing the path if the device is running on only one path.
> >
> > Problem: Device mapper fails the path for every I/O error. It does not
> > care about the type of error. There are certain errors which can be
> > recovered by re-initializing the path again. I have seen this problem
> > during my testing on rdac device handler. I have observed I/O errors
> > when there is a change in Lun ownership. When Lun ownership changes
> > device will return back with check condition with
> > sense 0x05/0x94/0x01(SK/ASC/ASCQ -meaning Lun ownership changed).
> > Currently, device mapper fails the path for this error and eventually
> > this will lead to I/O error. We don't want to see I/O error for this
> reason.
> 
> Shouldn't we handle this type of device error inside device handler?

The current error in question requires re-activation of the path. We already have a code to handle this scenario in device handler. But, the problem is the return status does not go to DM layer. The return status gets lost in scsi layer. For DM layer all the errors are -EIO. Any thoughts from your side.

> > The patch will set the flag pg_init_required if the device is running
> > on single path. The process_queued_ios will re-initialize path if
> required.
> > I have tested this patch on LSI rdac handler.
> >
> > Signed-off-by: Babu Moger <babu.moger@lsi.com>
> > ---
> >
> > --- linux-2.6.30-rc2/drivers/md/dm-mpath.c.orig	2009-04-17
> 16:49:33.000000000 -0500
> > +++ linux-2.6.30-rc2/drivers/md/dm-mpath.c	2009-04-17
> 17:09:51.000000000 -0500
> > @@ -1152,6 +1152,15 @@ static int do_end_io(struct multipath *m
> >  		return error;
> >
> >  	spin_lock_irqsave(&m->lock, flags);
> > +	/*
> > +	 * If this is the only path left, then lets try to
> > +	 * re-initialize the PG one last time..
> > +	 */
> > +	if (m->nr_valid_paths == 1 && m->hw_handler_name) {
> > +		m->pg_init_required = 1;
> > +		spin_unlock_irqrestore(&m->lock, flags);
> > +		goto requeue;
> > +	}
> >  	if (!m->nr_valid_paths) {
> >  		if (__must_push_back(m)) {
> >  			spin_unlock_irqrestore(&m->lock, flags);
> 
> What happens in case of a real I/O error (e.g. I/O to a broken sector)?
> Is it correctly handled and returned to upper layer at last?
> I'm asking that because the change looks dm retries such errors forever.
> Or am I missing anything?
> 
  Yes, you are right. There are chances of that happening. I will investigate and get back.

> Thanks,
> Kiyoshi Ueda
