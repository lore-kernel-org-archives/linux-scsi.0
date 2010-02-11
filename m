From: Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.
Date: Thu, 11 Feb 2010 03:09:10 -0800
Message-ID: <20100211110910.GD8237@linux-qf4p>
References: <20100130062822.GC10274@linux-qf4p> <4B671A34.9080300@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:54010 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab0BKLH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Feb 2010 06:07:59 -0500
Content-Disposition: inline
In-Reply-To: <4B671A34.9080300@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On Mon, 01 Feb 2010, Mike Christie wrote:
> On 01/30/2010 12:28 AM, Ravi Anand wrote:
> > +       uint16_t iscsi_max_burst_len;
> > +       uint16_t iscsi_max_outsnd_r2t;
> > +       uint16_t iscsi_first_burst_len;
> > +       uint16_t iscsi_max_rcv_data_seg_len;
> > +       uint16_t iscsi_max_snd_data_seg_len;
> 
> 
> Probably do not need those settings above. Did not really see them used.

Sorry for the late reply as I was sick. 

Currently we are caching it in the DDB struct from the F/W database
and the goal is to export it to user space.
> 
> 
> 
> > +
> > +       struct in6_addr remote_ipv6_addr;
> > +       struct in6_addr link_local_ipv6_addr;
> >   };
> >
> >   /*
> > @@ -275,6 +284,16 @@ struct ddb_entry {
> >   #include "ql4_fw.h"
> >   #include "ql4_nvram.h"
> >
> > +/* shortcut to print ISID */
> > +#define ISID(addr) \
> > +       ((unsigned char *)&addr)[5], \
> > +       ((unsigned char *)&addr)[4], \
> > +       ((unsigned char *)&addr)[3], \
> > +       ((unsigned char *)&addr)[2], \
> > +       ((unsigned char *)&addr)[1], \
> > +       ((unsigned char *)&addr)[0]
> > +#define ISID_FMT "0x%02x%02x%02x%02x%02x%02x"
> 
> 
> Also not used. And if you add it, it should go in iscsi_proto.h.

We will remvoe it. 
> 
> 
> > +       DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
> > +                                       "State %04x ConnErr %08x "
> > +                                       NIPQUAD_FMT ":%04d \"%s\"\n",
> 
> 
> Do you go down this path for ipv6 (looked like it did and did in other 
> places)?

IPV4 and IPV6.

> NIPQUAD_FMT will not work, and we are trying to not use it 
> NIPQUAD_FMT/NIPQUAD. See %pI4 use in qla4xxx_conn_get_param. There is 
> also a %pI6 for ipv6.

OK. We will modify it to use %pI4 or %pI4.
> 
> Also you need to update qla4xxx_conn_get_param and 
> qla4xxx_host_get_param ip handling.

Will do. Missed it.
> 
> 
> > +       if (qla4xxx_mailbox_command(ha, 6, 6, mbox_cmd, mbox_sts)
> > +               != QLA_SUCCESS) {
> 
> 
> I think we normally put the != on the end of the other line.

OK.

Thanks
Ravi
