From: "Eddie Wai" <eddie.wai-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/8] Added bug fixes and several features for BNX2I
Date: Wed, 5 Jan 2011 16:42:01 -0800
Message-ID: <1294274522.1988.115.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1294260267-17413-1-git-send-email-eddie.wai@broadcom.com>
 <1294260724.16957.29.camel@mulgrave.site>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <open-iscsi+bncCKiEw6yjEhC7npTpBBoENKibZA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
In-Reply-To: <1294260724.16957.29.camel-0iu6Cu4xQGLYCGPCin2YbQ@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>, <mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
 <mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: James Bottomley <James.Bottomley-l3A5Bk7waGM@public.gmane.org>
Cc: Eddie Wai <waie-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>, open-iscsi <open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Chan <mchan-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Anil Veerabhadrappa <anilgv-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Benjamin Li <benli-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org


On Wed, 2011-01-05 at 12:52 -0800, James Bottomley wrote:
> On Wed, 2011-01-05 at 12:44 -0800, Eddie Wai wrote:
> > Hello,
> >     
> > This patch set contains two fixes and added various features as titled.
> > The two fixes are:
> > 1 - connection cleanup fix which fixes a chip panic issue
> > 2 - nopout LUN field fix which fixes nopout timeouts
> 
> So the immediate question is do these need backporting to earlier
> kernels via the stable tree (in which case a cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org tag
> would be needed)?
Both bugs have been present in the code for quite a while.  I think its
just recently that they got exposed.  The severity of the chip panic is
higher as the chip will need to be reset to recover.  But it's not easy
to trigger this and was found only by our PQA doing extraordinary tests.
The nopout LUN bug is more common and will hamper I/O performance if the
nopout LUN field is not 32-bit symmetric.  But the result is not
catastrophic.

I would recommend having these be backported to the stable tree if
possible.  Let me know if you want to move forward with the stable tree
patch.  Thanks.
> 
> James
> 
> 
> > The features added includes TCP timestamp, jumbo MTU, text pdu support
> > for discovery offload, and 57712(E) support.
> > 
> > Please review.  Thanks.
> > Eddie
> > 
> > Eddie Wai (8):
> >   BNX2I: Allow ep CONNECT_FAILED condition to go through proper cleanup
> >   BNX2I: Fixed the 32-bit swapping of the LUN field for nopouts for
> >     5771X
> >   BNX2I: Added handling for unsupported iSCSI offload hba
> >   BNX2I: Added support for the 57712(E) devices
> >   BNX2I: Added TCP timestamps option support
> >   BNX2I: Added jumbo MTU support for the no shost case
> >   BNX2I: Added iSCSI text pdu support for iSCSI offload
> >   BNX2I: Updated to version 2.6.2.3
> > 
> >  drivers/net/bnx2x/bnx2x_main.c   |    7 --
> >  drivers/scsi/bnx2i/bnx2i.h       |    5 +-
> >  drivers/scsi/bnx2i/bnx2i_hwi.c   |  122 +++++++++++++++++++++++++++++++++++++-
> >  drivers/scsi/bnx2i/bnx2i_init.c  |   33 ++++++++--
> >  drivers/scsi/bnx2i/bnx2i_iscsi.c |   10 +++-
> >  include/linux/pci_ids.h          |    2 +
> >  6 files changed, 160 insertions(+), 19 deletions(-)
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 


-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
