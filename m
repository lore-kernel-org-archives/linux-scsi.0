From: "Smart, James" <James.Smart@Emulex.com>
Subject: RE: Transport affected timeouts...
Date: Fri, 16 Apr 2004 15:39:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3356669BBE90C448AD4645C843E2BF2802C016A7@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:48094 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S262434AbUDPTkB
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Apr 2004 15:40:01 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Reflector <linux-scsi@vger.kernel.org>

I had looked at the patch.  I don't think it works as well as the
incrementer. But it would be a start. We would need the st driver, and scsi
generic to use it as well. It doesn't address the timeout changing post
slave_configure. The other thing that bothers me is that it uses an explicit
value. As per the thread, it would have been better to know what the
original default was and just increment/double it - and there is the issue
of different device types needing different defaults.

-- james


> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
> Sent: Friday, April 16, 2004 3:24 PM
> To: Smart, James
> Cc: Linux SCSI Reflector
> Subject: Re: Transport affected timeouts...
> 
> 
> On Fri, 2004-04-16 at 10:40, Smart, James wrote:
> > One issue that we're wrestling with in our driver is 
> timeout values. In the
> > past, we've encountered large configurations where the 
> timeouts from the
> > midlayer are insufficient. In general - we'd like the scsi 
> host to be able
> > to add a transport/topology increment time to the base 
> timeout values.  The
> > methodology would have to be dynamic as it may change as 
> link connectivity
> > changes.
> > 
> > Obviously, an hba driver mucking with the timeout values 
> handed to it is
> > frowned upon. Is there a recommendation on how we should 
> handle this ?
> 
> There's no currently agreed upon framework, but would
> 
> http://www-124.ibm.com/storageio/ipr/patch-2.6.5-sd_timeout_mod
> 
> Do for what you want?
> 
> James
> 
> 
