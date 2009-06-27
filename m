From: "Karen Xie" <kxie@chelsio.com>
Subject: RE: [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is enabled
Date: Sat, 27 Jun 2009 11:13:18 -0700
Message-ID: <8A71B368A89016469F72CD08050AD33403F4AFA9@maui.asicdesigners.com>
References: <200906262217.n5QMHTXg006358@localhost.localdomain><4A465C47.8050100@cs.wisc.edu> <1246125325.3990.29.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:32343 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZF0SPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Jun 2009 14:15:38 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Christie <michaelc@cs.wisc.edu>
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org

James & Mike,

Yes, I will cc netdev list next time if there is anything related to the networking.

James, thanks for fixing up the patch. I was using a older tree sorry about it.

Thanks,
Karen


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com]
Sent: Sat 6/27/2009 10:55 AM
To: Mike Christie
Cc: open-iscsi@googlegroups.com; linux-scsi@vger.kernel.org; Karen Xie
Subject: Re: [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is enabled
 
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



