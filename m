From: Martin Hicks <mort@bork.org>
Subject: Re: Transport Attributes -- attempt#3
Date: Fri, 16 Jan 2004 11:40:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116164003.GH27591@localhost>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost> <20040114233457.GA23840@praka.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:62100 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S265695AbUAPQkE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 11:40:04 -0500
Content-Disposition: inline
In-Reply-To: <20040114233457.GA23840@praka.local.home>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <praka@users.sourceforge.net>, linux-scsi@vger.kernel.org



On Wed, Jan 14, 2004 at 03:34:57PM -0800, Andrew Vasquez wrote:
> On Wed, 14 Jan 2004, Martin Hicks wrote:
> 
> > +
> > +/* the FiberChannel Tranport Attributes: */
> > +fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
> > +fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
> > +fc_transport_rd_attr(port_id, "0x%x\n");
> > +
> 
> Purely aesthetics : PortIDs are typically viewed as three hex bytes
> padded with zeros, i.e. 010203.  Perhaps this may be more appropriate:
> 
> 	fc_transport_rd_attr(port_id, "0x%06x\n");

Okay.  Will do.

> 
> [snip]
> > +	attrs = (struct fc_transport_attrs *)sdev->transport_attr_values;
> > +	list_for_each_entry(fc, &ha->fcports, list) {
> > +		if (fc->os_target_id == sdev->id) {
> > +			attrs->port_name = __be64_to_cpu(*(uint64_t *)fc->port_name);
> > +			attrs->node_name = __be64_to_cpu(*(uint64_t *)fc->node_name);
> > +			attrs->port_id = fc->d_id.b24;
> 
> This port_id assignment will not give you what you expect on
> big-endian machines.  Given the previous port_id example value
> (010203), on BE machines, the attribute will read as 030201 when
> displayed.  A more endian safe way if you want to continue with the
> pure-type usages (uint64_t/int) rather than byte arrays would be:
> 
> 	attrs->port_id = fc->d_id.b.domain << 16 |
> 		fc->d_id.b.area << 8 |
> 		fc->d_id.b.al_pa;

I'll fix that up.

Thanks,
mh

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE
