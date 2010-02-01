From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 02/11] qla4xxx: added IPv6 support.
Date: Mon, 01 Feb 2010 12:15:16 -0600
Message-ID: <4B671A34.9080300@cs.wisc.edu>
References: <20100130062822.GC10274@linux-qf4p>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38015 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab0BASPp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Feb 2010 13:15:45 -0500
In-Reply-To: <20100130062822.GC10274@linux-qf4p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: James Bottomley <james.bottomley@suse.de>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, Vikas Chaudhary <vikas.chaudhary@qlogic.com>

On 01/30/2010 12:28 AM, Ravi Anand wrote:
> +       uint16_t iscsi_max_burst_len;
> +       uint16_t iscsi_max_outsnd_r2t;
> +       uint16_t iscsi_first_burst_len;
> +       uint16_t iscsi_max_rcv_data_seg_len;
> +       uint16_t iscsi_max_snd_data_seg_len;


Probably do not need those settings above. Did not really see them used.



> +
> +       struct in6_addr remote_ipv6_addr;
> +       struct in6_addr link_local_ipv6_addr;
>   };
>
>   /*
> @@ -275,6 +284,16 @@ struct ddb_entry {
>   #include "ql4_fw.h"
>   #include "ql4_nvram.h"
>
> +/* shortcut to print ISID */
> +#define ISID(addr) \
> +       ((unsigned char *)&addr)[5], \
> +       ((unsigned char *)&addr)[4], \
> +       ((unsigned char *)&addr)[3], \
> +       ((unsigned char *)&addr)[2], \
> +       ((unsigned char *)&addr)[1], \
> +       ((unsigned char *)&addr)[0]
> +#define ISID_FMT "0x%02x%02x%02x%02x%02x%02x"


Also not used. And if you add it, it should go in iscsi_proto.h.


> +       DEBUG2(dev_info(&ha->pdev->dev, "%s: DDB[%d] osIdx = %d "
> +                                       "State %04x ConnErr %08x "
> +                                       NIPQUAD_FMT ":%04d \"%s\"\n",


Do you go down this path for ipv6 (looked like it did and did in other 
places)? NIPQUAD_FMT will not work, and we are trying to not use it 
NIPQUAD_FMT/NIPQUAD. See %pI4 use in qla4xxx_conn_get_param. There is 
also a %pI6 for ipv6.

Also you need to update qla4xxx_conn_get_param and 
qla4xxx_host_get_param ip handling.


> +       if (qla4xxx_mailbox_command(ha, 6, 6, mbox_cmd, mbox_sts)
> +               != QLA_SUCCESS) {


I think we normally put the != on the end of the other line.

