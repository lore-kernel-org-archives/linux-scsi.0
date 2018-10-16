From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] driver core: device: add BUS_ATTR_WO macro
Date: Tue, 16 Oct 2018 12:48:14 +0200
Message-ID: <20181016104814.GA4768@kroah.com>
References: <1538407972-9340-1-git-send-email-ioana.ciornei@nxp.com>
 <20181001210804.GA24332@kroah.com>
 <HE1PR0401MB236354F325B7A56355068E35E0E80@HE1PR0401MB2363.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <HE1PR0401MB236354F325B7A56355068E35E0E80@HE1PR0401MB2363.eurprd04.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: "idryomov@gmail.com" <idryomov@gmail.com>, "sage@redhat.com" <sage@redhat.com>, "elder@kernel.org" <elder@kernel.org>, "jth@kernel.org" <jth@kernel.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 02, 2018 at 09:43:35AM +0000, Ioana Ciornei wrote:
> > > Add BUS_ATTR_WO macro to make it easier to add attributes without
> > > auditing the mode settings. Also, use the newly added macro where
> > > appropriate.
> > >
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> > >  arch/powerpc/platforms/pseries/ibmebus.c | 12 ++++----
> > >  drivers/block/rbd.c                      | 48 ++++++++++++++++----------------
> > >  drivers/scsi/fcoe/fcoe_sysfs.c           |  4 +--
> > >  drivers/scsi/fcoe/fcoe_transport.c       | 10 +++----
> > >  include/linux/device.h                   |  2 ++
> > >  include/scsi/libfcoe.h                   |  8 +++---
> > >  6 files changed, 43 insertions(+), 41 deletions(-)
> > 
> > Nice!  This duplicates a lot of the work I did back in July but have not pushed out
> > very far due to the other things that ended up happening around that time:
> > 	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/log/?h=bus_cleanup 
> > 
> > As the patch series seen at that link shows, you can do this in more places than
> > just what you did here.
> > 
> > Either way, you should break this up into the individual patches, like I did or you
> > can take my patches if you want.  Getting the BUS_ATTR_WO() macro added is
> > good to do now, and then you can go and hit up all of the different subsystems
> > that should be converted over to it.
> 
> I can of course split my patch into individual ones and resubmit them, but as you already have the entire patch set ready, I feel like we can just push those. I looked through your changes and it seems like you covered all the subsystems. Please let me know if there is something else I should do.
> 
> My intention here was to first add the _WO attribute so that afterwards I can add a new bus attribute in the fsl-mc bus.

Ok, I've queued up the patch that adds the _WO attribute now, so that
you should be able to use this after 4.20-rc1.  I'll work on getting my
other patches merged in that series at that time as well.

thanks,

greg k-h
