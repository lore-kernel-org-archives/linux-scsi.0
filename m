From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH v2 24/28] libsas: poll for ata device readiness after
 reset
Date: Sun, 19 Feb 2012 16:06:36 -0600
Message-ID: <1329689195.2806.10.camel@dabdike.int.hansenpartnership.com>
References: <20111223025350.21827.85779.stgit@localhost6.localdomain6>
	 <20111223030033.21827.46127.stgit@localhost6.localdomain6>
	 <FD5571266F8C4E5ABC22D51C90F90A79@usish.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51818 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754026Ab2BSWGi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2012 17:06:38 -0500
In-Reply-To: <FD5571266F8C4E5ABC22D51C90F90A79@usish.com.cn>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jack_wang@usish.com>
Cc: 'Dan Williams' <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org, 'Tejun Heo' <tj@kernel.org>, linux-ide@vger.kernel.org

On Thu, 2011-12-29 at 14:18 +0800, Jack Wang wrote:
> > @@ -267,39 +267,84 @@ static bool sas_ata_qc_fill_rtf(struct
> ata_queued_cmd
> > *qc)
> >  	return true;
> >  }
> > 
> > -static int sas_ata_hard_reset(struct ata_link *link, unsigned int *class,
> > -			       unsigned long deadline)
> > +static struct sas_internal *dev_to_sas_internal(struct domain_device
> *dev)
> > +{
> > +	return to_sas_internal(dev->port->ha->core.shost->transportt);
> > +}
> > +
> > +static int smp_ata_check_ready(struct ata_link *link)
> >  {
> > +	int res;
> > +	u8 addr[8];
> >  	struct ata_port *ap = link->ap;
> >  	struct domain_device *dev = ap->private_data;
> > -	struct sas_internal *i
> > -		to_sas_internal(dev->port->ha->core.shost->transportt);
> > -	int res = TMF_RESP_FUNC_FAILED;
> > -	int ret = 0;
> > +	struct domain_device *ex_dev = dev->parent;
> > +	struct sas_phy *phy = sas_find_local_phy(dev);
> > 
> > -	if (i->dft->lldd_I_T_nexus_reset)
> > -		res = i->dft->lldd_I_T_nexus_reset(dev);
> > +	res = sas_get_phy_attached_sas_addr(ex_dev, phy->number, addr);
> > +	/* break the wait early if the expander is unreachable,
> > +	 * otherwise keep polling
> > +	 */
> > +	if (res == -ECOMM)
> > +		return res;
> > +	if (res != SMP_RESP_FUNC_ACC || SAS_ADDR(addr) == 0)
> [Jack Wang] 
> This check may not guarantee the FIS have received by the expander, should
> we
>  Use sas_ex_phy_discover instead, we still need to teach
> sas_ex_phy_discover_helper to return right code.

So the concern seems valid, do we have a fix yet?

James


