From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Transport affected timeouts...
Date: Fri, 16 Apr 2004 16:13:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C016A8@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:60386 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S263704AbUDPUNQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 16:13:16 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Friday, April 16, 2004 3:47 PM
> To: Smart, James
> Cc: Linux SCSI Reflector
> Subject: RE: Transport affected timeouts...
> 
> 
> On Fri, 2004-04-16 at 14:39, Smart, James wrote:
> > I had looked at the patch.  I don't think it works as well as the
> > incrementer. But it would be a start. We would need the st 
> driver, and scsi
> > generic to use it as well. It doesn't address the timeout 
> changing post
> > slave_configure. The other thing that bothers me is that it 
> uses an explicit
> > value. As per the thread, it would have been better to know what the
> > original default was and just increment/double it - and 
> there is the issue
> > of different device types needing different defaults.
> 
> I don't think it's a good idea to alter *every* timeout, merely the
> usual ones (hence, really only read and write in the patch).

In general, we're reflecting larger/longer topologies that just induce more
latency in performing an i/o and which can have an aggregate effect overall
to i/o queued in/for the target. Didn't matter whether it was an usual i/o
or not.

> 
> Why do you need it to be variable post slave_configure?

Hmm... the gist of the argument is that the adapter could be replugged to
another fabric that has larger or lower timeouts needed. But - I would
assume a midlayer rescan would have to occur on such a change. New devices
are covered as slave_configure would be called for them. But, is
slave_configure called again on existing devices that change "personality"
as they are now a different physical device?

-- james
 
