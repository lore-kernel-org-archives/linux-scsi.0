From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] driver core: device: add BUS_ATTR_WO macro
Date: Mon, 1 Oct 2018 14:08:04 -0700
Message-ID: <20181001210804.GA24332@kroah.com>
References: <1538407972-9340-1-git-send-email-ioana.ciornei@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1538407972-9340-1-git-send-email-ioana.ciornei@nxp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ioana Ciornei <ioana.ciornei@nxp.com>
Cc: idryomov@gmail.com, sage@redhat.com, elder@kernel.org, jth@kernel.org, benh@kernel.crashing.org, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 01, 2018 at 06:32:52PM +0300, Ioana Ciornei wrote:
> Add BUS_ATTR_WO macro to make it easier to add attributes without
> auditing the mode settings. Also, use the newly added macro where
> appropriate.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  arch/powerpc/platforms/pseries/ibmebus.c | 12 ++++----
>  drivers/block/rbd.c                      | 48 ++++++++++++++++----------------
>  drivers/scsi/fcoe/fcoe_sysfs.c           |  4 +--
>  drivers/scsi/fcoe/fcoe_transport.c       | 10 +++----
>  include/linux/device.h                   |  2 ++
>  include/scsi/libfcoe.h                   |  8 +++---
>  6 files changed, 43 insertions(+), 41 deletions(-)

Nice!  This duplicates a lot of the work I did back in July but have not
pushed out very far due to the other things that ended up happening
around that time:
	https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/log/?h=bus_cleanup

As the patch series seen at that link shows, you can do this in more
places than just what you did here.

Either way, you should break this up into the individual patches, like I
did or you can take my patches if you want.  Getting the BUS_ATTR_WO()
macro added is good to do now, and then you can go and hit up all of the
different subsystems that should be converted over to it.

thanks,

greg k-h
