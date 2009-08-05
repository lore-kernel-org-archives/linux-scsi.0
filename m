From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2.6.30.4] Fix for NULL pointer dereference by SRP
 initiator triggered by a SCSI reset after the SRP connection has been closed
Date: Wed, 05 Aug 2009 15:37:44 -0500
Message-ID: <1249504664.4183.45.camel@mulgrave.site>
References: <e2e108260908030621q102437e0ua60aa5bdfacb2e7e@mail.gmail.com>
	 <adafxc8ocst.fsf@cisco.com>
	 <e2e108260908040907l6537c2dcveb64615a664a047e@mail.gmail.com>
	 <adafxc7mtn8.fsf@cisco.com>
	 <e2e108260908041125w730869c0s8d212e2765598c42@mail.gmail.com>
	 <adaljlzl0ne.fsf@cisco.com>
	 <e2e108260908050800p3a6613bbib95fa670248a863@mail.gmail.com>
	 <adaiqh2jgug.fsf@cisco.com>
	 <e2e108260908051054r11262096j3b659de24c820967@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44752 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbZHEUht (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 16:37:49 -0400
In-Reply-To: <e2e108260908051054r11262096j3b659de24c820967@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Roland Dreier <rdreier@cisco.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2009-08-05 at 19:54 +0200, Bart Van Assche wrote:
> On Wed, Aug 5, 2009 at 7:44 PM, Roland Dreier<rdreier@cisco.com> wrote:
> >
> >  > The NULL pointer dereference happens when srp_reset_device() calls
> >  > srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET) with
> >  > req->scmnd->device == NULL. When the sg_reset command issues an
> >  > SG_SCSI_RESET ioctl, scsi_reset_provider() is invoked and allocates an
> >  > scmnd structure and sets scmnd->device to NULL. It is this scmnd
> >  > structure that is passed to srp_reset_device(). What I'm not sure
> >  > about is whether scsi_reset_provider() should set req->scmnd->device
> >  > to a non-NULL value or whether srp_send_tsk_mgmt() should be able to
> >  > handle the condition req->scmnd->device == NULL.
> >
> > Well, I don't see how the reset ioctl can do anything useful unless it
> > passes a device in with the scsi command -- otherwise for example
> > srp_reset_device() has no idea what LUN to try and reset.
> 
> (added linux-scsi in CC)
> 
> I hope one of the SCSI people can tell us whether the behavior that
> scsi_reset_provider()
> passes the value NULL in req->scmnd->device to
> scsi_try_bus_device_reset() is correct ?

Need more information.

cmd->device is supposed to be initialised in scsi_get_command(), which
scsi_reset_provider() calls ... why do you think it got set to null?

James


