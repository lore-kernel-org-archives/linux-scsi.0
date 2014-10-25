From: Anish Bhatt <anish@chelsio.com>
Subject: RE: [PATCH scsi] libcxgbi : support ipv6 address host_param
Date: Sat, 25 Oct 2014 00:06:32 +0000
Message-ID: <525DB349B3FB5444AE057A887CB2A8D8928974@nice.asicdesigners.com>
References: <1413500359-27521-1-git-send-email-anish@chelsio.com>
 <5446AF5D.8010307@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:8205 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbaJYBLL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2014 21:11:11 -0400
In-Reply-To: <5446AF5D.8010307@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "hch@infradead.org" <hch@infradead.org>, "jbottomley@parallels.com" <jbottomley@parallels.com>, Karen Xie <kxie@chelsio.com>, Manoj Malviya <manojmalviya@chelsio.com>

> On 10/16/2014 05:59 PM, Anish Bhatt wrote:
> > libcxgbi was always returning an ipv4 address for
> > ISCSI_HOST_PARAM_IPADDRESS, return appropriate address based on
> > address family
> >
> > Signed-off-by: Anish Bhatt <anish@chelsio.com>
> > Signed-off-by: Karen Xie <kxie@chelsio.com>
> > ---
> >  drivers/scsi/cxgbi/libcxgbi.c | 42
> > +++++++++++++++++++++++++++++++++++++-----
> >  drivers/scsi/cxgbi/libcxgbi.h |  5 -----
> >  2 files changed, 37 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.c
> > b/drivers/scsi/cxgbi/libcxgbi.c index 6a2001d..403330a 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.c
> > +++ b/drivers/scsi/cxgbi/libcxgbi.c
> > @@ -397,6 +397,35 @@ EXPORT_SYMBOL_GPL(cxgbi_hbas_add);
> >   *   If the source port is outside our allocation range, the caller is
> >   *   responsible for keeping track of their port usage.
> >   */
> > +
> > +static struct cxgbi_sock *find_sock_on_port(struct cxgbi_device *cdev,
> > +					    unsigned char port_id)
> > +{
> > +	struct cxgbi_ports_map *pmap = &cdev->pmap;
> > +	unsigned int i;
> > +	unsigned int used;
> > +
> > +	if (!pmap->max_connect || !pmap->used)
> > +		return NULL;
> > +
> > +	spin_lock_bh(&pmap->lock);
> > +	used = pmap->used;
> > +	for (i = 0; used && i < pmap->max_connect; i++) {
> > +		struct cxgbi_sock *csk = pmap->port_csk[i];
> > +
> > +		if (csk) {
> > +			if (csk->port_id == port_id) {
> > +				spin_unlock_bh(&pmap->lock);
> > +				return csk;
> > +			}
> > +			used--;
> > +		}
> > +	}
> > +	spin_unlock_bh(&pmap->lock);
> > +
> > +	return NULL;
> > +}
> > +
> >  static int sock_get_port(struct cxgbi_sock *csk)  {
> >  	struct cxgbi_device *cdev = csk->cdev; @@ -747,6 +776,7 @@ static
> > struct cxgbi_sock *cxgbi_check_route6(struct sockaddr *dst_addr)
> >  	csk->daddr6.sin6_addr = daddr6->sin6_addr;
> >  	csk->daddr6.sin6_port = daddr6->sin6_port;
> >  	csk->daddr6.sin6_family = daddr6->sin6_family;
> > +	csk->saddr6.sin6_family = daddr6->sin6_family;
> >  	csk->saddr6.sin6_addr = pref_saddr;
> >
> >  	neigh_release(n);
> > @@ -2645,12 +2675,14 @@ int cxgbi_get_host_param(struct Scsi_Host
> *shost, enum iscsi_host_param param,
> >  		break;
> >  	case ISCSI_HOST_PARAM_IPADDRESS:
> >  	{
> > -		__be32 addr;
> > -
> > -		addr = cxgbi_get_iscsi_ipv4(chba);
> > -		len = sprintf(buf, "%pI4", &addr);
> > +		struct cxgbi_sock *csk = find_sock_on_port(chba->cdev,
> > +							   chba->port_id);
> > +		if (csk) {
> > +			len = sprintf(buf, "%pIS",
> > +				      (struct sockaddr *)&csk->saddr);
> > +		}
> >  		log_debug(1 << CXGBI_DBG_ISCSI,
> > -			"hba %s, ipv4 %pI4.\n", chba->ndev->name, &addr);
> > +			  "hba %s, addr %s.\n", chba->ndev->name, buf);
> >  		break;
> >  	}
> >  	default:
> > diff --git a/drivers/scsi/cxgbi/libcxgbi.h
> > b/drivers/scsi/cxgbi/libcxgbi.h index 1d98fad..2c7cb1c 100644
> > --- a/drivers/scsi/cxgbi/libcxgbi.h
> > +++ b/drivers/scsi/cxgbi/libcxgbi.h
> > @@ -700,11 +700,6 @@ static inline void cxgbi_set_iscsi_ipv4(struct
> cxgbi_hba *chba, __be32 ipaddr)
> >  			chba->ndev->name);
> >  }
> >
> > -static inline __be32 cxgbi_get_iscsi_ipv4(struct cxgbi_hba *chba) -{
> > -	return chba->ipv4addr;
> > -}
> > -
> >  struct cxgbi_device *cxgbi_device_register(unsigned int, unsigned
> > int);  void cxgbi_device_unregister(struct cxgbi_device *);  void
> > cxgbi_device_unregister_all(unsigned int flag);
> >
> 
> 
> Looks ok.
> 
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Pinging for visibility.
-Anish
