From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan
 is enabled
Date: Sat, 27 Jun 2009 12:55:25 -0500
Message-ID: <1246125325.3990.29.camel@mulgrave.site>
References: <200906262217.n5QMHTXg006358@localhost.localdomain>
	 <4A465C47.8050100@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51567 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbZF0Rz1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 13:55:27 -0400
In-Reply-To: <4A465C47.8050100@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org, kxie@chelsio.com

On Sat, 2009-06-27 at 12:52 -0500, Mike Christie wrote:
> On 06/26/2009 05:17 PM, kxie@chelsio.com wrote:
> > [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is enabled
> >
> > From: Karen Xie<kxie@chelsio.com>
> >
> > There is a bug when VLAN is configured on the cxgb3 interface, the iscsi
> > conn. would be denied with message "cxgb3i: NOT going through cxgbi device."
> >
> > This patch added code to get the real egress net_device when vlan is configured.
> >
> > Signed-off-by: Karen Xie<kxie@chelsio.com>
> > ---
> >
> >   drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    4 ++++
> >   1 files changed, 4 insertions(+), 0 deletions(-)
> >
> >
> > diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> > index 04a4374..60013a4 100644
> > --- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> > +++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> > @@ -13,6 +13,7 @@
> >
> >   #include<linux/inet.h>
> >   #include<linux/crypto.h>
> > +#include<linux/if_vlan.h>
> >   #include<net/tcp.h>
> >   #include<scsi/scsi_cmnd.h>
> >   #include<scsi/scsi_device.h>
> > @@ -183,6 +184,9 @@ static struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
> >   	struct cxgb3i_adapter *snic;
> >   	int i;
> >
> > +	if (ndev->priv_flags&  IFF_802_1Q_VLAN)
> > +		ndev = vlan_dev_real_dev(ndev);
> > +
> >   	read_lock(&cxgb3i_snic_rwlock);
> >   	list_for_each_entry(snic,&cxgb3i_snic_list, list_head) {
> >   		for (i = 0; i<  snic->hba_cnt; i++) {
> >
> 
> It looks ok, but when touching network stuff you might want to cc the 
> netdev list in the future. Well, maybe for non-trivial stuff at least. 
> This might be fine.
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Thanks, but actually this patch gives a rejection here because of a
commit made by Herbert Xu which is already in mainline:

commit f00a3328bf9ecff46abd68a421693ba71cd16fc8
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sat May 30 13:40:04 2009 +1000

    [SCSI] cxgb3i: Include net/dst.h for struct dst_cache

It's simple enough to fix up, so I did it, but next time could you
(Karen) check your patches against the relevant trees to make sure
they're up to date.

James


