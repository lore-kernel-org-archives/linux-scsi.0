From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 61/86] scsi/qla1280: use uapi/linux/pci_ids.h directly
Date: Sun, 29 Mar 2015 17:52:20 +0300
Message-ID: <1427640740.25464.40.camel@HansenPartnership.com>
References: <1427635734-24786-1-git-send-email-mst@redhat.com>
	 <1427635734-24786-62-git-send-email-mst@redhat.com>
	 <1427637816.25464.27.camel@HansenPartnership.com>
	 <20150329162830-mutt-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51643 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752596AbbC2OwZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 29 Mar 2015 10:52:25 -0400
In-Reply-To: <20150329162830-mutt-send-email-mst@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org

On Sun, 2015-03-29 at 16:36 +0200, Michael S. Tsirkin wrote:
> On Sun, Mar 29, 2015 at 05:03:36PM +0300, James Bottomley wrote:
> > On Sun, 2015-03-29 at 15:42 +0200, Michael S. Tsirkin wrote:
> > > Header moved from linux/pci_ids.h to uapi/linux/pci_ids.h,
> > > use the new header directly so we can drop
> > > the wrapper in include/linux/pci_ids.h.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > ---
> > >  drivers/scsi/qla1280.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
> > > index c68a66e..b2ada21 100644
> > > --- a/drivers/scsi/qla1280.c
> > > +++ b/drivers/scsi/qla1280.c
> > > @@ -348,7 +348,7 @@
> > >  #include <linux/pci.h>
> > >  #include <linux/proc_fs.h>
> > >  #include <linux/stat.h>
> > > -#include <linux/pci_ids.h>
> > > +#include <uapi/linux/pci_ids.h>
> > 
> > This is bogus, isn't it?  There's a -Iuapi somewhere in the kernel
> > compile line so the original include is still valid.  Zorro does this:
> > zorro_ids.h is exclusively in uapi but the include is still
> > 
> > #include <linux/zorro_ids.h>
> > 
> > James
> > 
> 
> 
> Hmm, that's true. I didn't know.  A bunch of files pull in headers from uapi
> explicitly, so I assumed it's a good idea.  Do you think it's better to include
> uapi files using short linux/<x>.h, or the full uapi/linux/<x>.h?  Linux has a
> mix of both.

I prefer the short linux/<x>.h because it's then up to the build system
where they come from (we use the same scheme for asm-generic).  If we
hard code uapi/linux/<x>.h they will be wrong again when we have a new
API split.

However, I'd say the rule I'd adhere to is that if nothing needs doing
(i.e. whether they include linux/<x>.h or uapi/linux/<x>.h) then do
nothing.  It saves churning lots of files for no reason.

James


