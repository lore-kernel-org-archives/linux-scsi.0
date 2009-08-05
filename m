From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 2.6.30.4] Fix for NULL pointer dereference by SRP
	initiator triggered by a SCSI reset after the SRP connection has been closed
Date: Wed, 5 Aug 2009 19:54:17 +0200
Message-ID: <e2e108260908051054r11262096j3b659de24c820967@mail.gmail.com>
References: <e2e108260908030621q102437e0ua60aa5bdfacb2e7e@mail.gmail.com>
	 <adafxc8ocst.fsf@cisco.com>
	 <e2e108260908040907l6537c2dcveb64615a664a047e@mail.gmail.com>
	 <adafxc7mtn8.fsf@cisco.com>
	 <e2e108260908041125w730869c0s8d212e2765598c42@mail.gmail.com>
	 <adaljlzl0ne.fsf@cisco.com>
	 <e2e108260908050800p3a6613bbib95fa670248a863@mail.gmail.com>
	 <adaiqh2jgug.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:46539 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZHERyR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2009 13:54:17 -0400
Received: by ey-out-2122.google.com with SMTP id 9so205817eyd.37
        for <linux-scsi@vger.kernel.org>; Wed, 05 Aug 2009 10:54:17 -0700 (PDT)
In-Reply-To: <adaiqh2jgug.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, OpenIB <general@lists.openfabrics.org>, Vladislav Bolkhovitin <vst@vlnb.net>, linux-scsi <linux-scsi@vger.kernel.org>

On Wed, Aug 5, 2009 at 7:44 PM, Roland Dreier<rdreier@cisco.com> wrote:
>
> =A0> The NULL pointer dereference happens when srp_reset_device() cal=
ls
> =A0> srp_send_tsk_mgmt(target, req, SRP_TSK_LUN_RESET) with
> =A0> req->scmnd->device =3D=3D NULL. When the sg_reset command issues=
 an
> =A0> SG_SCSI_RESET ioctl, scsi_reset_provider() is invoked and alloca=
tes an
> =A0> scmnd structure and sets scmnd->device to NULL. It is this scmnd
> =A0> structure that is passed to srp_reset_device(). What I'm not sur=
e
> =A0> about is whether scsi_reset_provider() should set req->scmnd->de=
vice
> =A0> to a non-NULL value or whether srp_send_tsk_mgmt() should be abl=
e to
> =A0> handle the condition req->scmnd->device =3D=3D NULL.
>
> Well, I don't see how the reset ioctl can do anything useful unless i=
t
> passes a device in with the scsi command -- otherwise for example
> srp_reset_device() has no idea what LUN to try and reset.

(added linux-scsi in CC)

I hope one of the SCSI people can tell us whether the behavior that
scsi_reset_provider()
passes the value NULL in req->scmnd->device to
scsi_try_bus_device_reset() is correct ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
