From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: Re: Transport Attributes -- attempt#3
Date: Wed, 14 Jan 2004 15:34:57 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040114233457.GA23840@praka.local.home>
References: <20040107185420.GA30627@localhost> <20040108131717.A9700@infradead.org> <20040114181241.GK27591@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-02-qfe0.socal.rr.com ([66.75.162.134]:3285 "EHLO
	ms-smtp-02-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S266428AbUANXp4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Jan 2004 18:45:56 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-02-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i0ENjsNR027376
	for <linux-scsi@vger.kernel.org>; Wed, 14 Jan 2004 15:45:55 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20040114181241.GK27591@localhost>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, 14 Jan 2004, Martin Hicks wrote:

> Here is round#3 of the patch.  I think I've addressed all of the points
> that were brought up by Christoph last time.
> 
> Once again, three patches:  core, qla1280 and qla2xxx.  The core patch
> expects to be applied on top of the patch that I sent recently to
> linux-scsi:
> 

Just a few comments below:

[snip]

> +
> +/* the FiberChannel Tranport Attributes: */
> +fc_transport_rd_attr_cast(node_name, "0x%llx\n", unsigned long long);
> +fc_transport_rd_attr_cast(port_name, "0x%llx\n", unsigned long long);
> +fc_transport_rd_attr(port_id, "0x%x\n");
> +

Purely aesthetics : PortIDs are typically viewed as three hex bytes
padded with zeros, i.e. 010203.  Perhaps this may be more appropriate:

	fc_transport_rd_attr(port_id, "0x%06x\n");

[snip]
> +	attrs = (struct fc_transport_attrs *)sdev->transport_attr_values;
> +	list_for_each_entry(fc, &ha->fcports, list) {
> +		if (fc->os_target_id == sdev->id) {
> +			attrs->port_name = __be64_to_cpu(*(uint64_t *)fc->port_name);
> +			attrs->node_name = __be64_to_cpu(*(uint64_t *)fc->node_name);
> +			attrs->port_id = fc->d_id.b24;

This port_id assignment will not give you what you expect on
big-endian machines.  Given the previous port_id example value
(010203), on BE machines, the attribute will read as 030201 when
displayed.  A more endian safe way if you want to continue with the
pure-type usages (uint64_t/int) rather than byte arrays would be:

	attrs->port_id = fc->d_id.b.domain << 16 |
		fc->d_id.b.area << 8 |
		fc->d_id.b.al_pa;


Regards, 
Andrew Vasquez
