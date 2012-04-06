From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 1/2] sysfs: handle 'parent deleted before child added'
Date: Fri, 6 Apr 2012 14:17:11 -0700
Message-ID: <20120406211711.GA12075@kroah.com>
References: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
 <20120406204514.GA20237@kroah.com>
 <CABE8wwuMyH7nrPZWarWw1Z8=oM_Z4eUcupnsyxA9NF=Y1R_Apw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:52852 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757807Ab2DFVRP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 17:17:15 -0400
Received: by dake40 with SMTP id e40so3119840dak.11
        for <linux-scsi@vger.kernel.org>; Fri, 06 Apr 2012 14:17:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CABE8wwuMyH7nrPZWarWw1Z8=oM_Z4eUcupnsyxA9NF=Y1R_Apw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 06, 2012 at 02:06:50PM -0700, Williams, Dan J wrote:
> On Fri, Apr 6, 2012 at 1:45 PM, Greg KH <gregkh@linuxfoundation.org> =
wrote:
> > On Fri, Apr 06, 2012 at 01:41:06PM -0700, Dan Williams wrote:
> >> In scsi at least two cases of the parent device being deleted befo=
re the
> >> child is added have been observed.
> >>
> >> 1/ scsi is performing async scans and the device is removed prior =
to the
> >> =A0 =A0async can thread running (can happen with an in-opportune /=
 unlikely
> >> =A0 =A0unplug during initial scan).
> >
> > That sounds like a bug in the scsi code, doesn't it?
> >
> >> 2/ libsas discovery event running after the parent port has been t=
orn
> >> =A0 =A0down (this is a bug in libsas).
> >
> > Is this fixed somewhere?
>=20
> Yes, these two issues have pending fixes that are posted to linux-scs=
i:
>=20
> http://marc.info/?l=3Dlinux-scsi&m=3D133239707903443&w=3D2
> http://marc.info/?l=3Dlinux-scsi&m=3D133239709603452&w=3D2
>=20
> > I don't want to paper over bugs like this by changing the sysfs cor=
e.
> > We went through this a lot years ago when scsi changed to use the d=
river
> > core, and I thought we had fixed all of these types of errors prope=
rly.
>=20
> Hotplug lifetime rules are still transport specific.  So in this case
> scsi-core is innocent these are bugs from libsas and
> scsi_transport_sas.

Ok, thanks for the explaination.

> > So, any chance to fix these properly as well?
>=20
> This patch doesn't really paper over anything.  It turns a NULL
> pointer crash into an explicit warning from kobject_add_internal.  Fo=
r
> the libsas/scsi case this device_add() failure is still fatal.
> Regardless of whether sysfs changes the above two fixes are still
> required.
>=20
> Since the -EEXIST case is just a KERN_ERR and not a BUG_ON I figured
> it was worthwhile to post a patch to do the same for this 'parent
> deleted' case.  But if crashing is the expectation then this patch ca=
n
> be dropped.

No, crashing is not the expectation :)

But, without that crash, would the above fixes ever have been noticed
and fixed?  The device_add() most likely would have quietly failed and
no one would have been the wiser.

Or would something else have caused this to be an obvious problem?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
