From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: RE: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery prematurely terminates
Date: Thu, 15 Jun 2006 09:22:43 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D70199836@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:39880 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1030648AbWFOPWq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:22:46 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Thursday, June 15, 2006 8:51 AM, Michael Reed wrote: 

> > What overhead?  We don't read config pages on every I/O.  James
> > patch only effects the reading of config pages when there is
> > a host reset.
> 
> I think you're mistaken about James' patch.
> 
> Doesn't every i/o use a message frame?  James' patch to sleep on frame
> exhaustion requires a wakeup every time a msg frame is released,
> which is performed at the end of mpt_put_msg_frame().  Am I missing
> something?
> 
> 

Ok, my mistake.  I overlooked the wake_up() at the end of
mpt_put_msg_frame().

BTW, this is incorrect.  The wake_up() should been in
mpt_free_msg_frame(), 
instead of mpt_put_msg_frame().   The _put_ function is sending the mf
to 
the firmware.   The mf is not freed untill the command is completd by
firmware,
and the _free_function is called.  Meaning this issue can be solved by
moving 
wake_up() to mpt_free_msg_frame(), and only calling wake_up() when the
list_empty(&ioc->FreeQ) was empty going into this call.

Eric Moore
