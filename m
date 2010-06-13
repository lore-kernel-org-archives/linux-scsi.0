From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 11/15] iscsi_transport: Added new iscsi_host_param for
 iSCSI transport
Date: Sun, 13 Jun 2010 14:40:08 -0500
Message-ID: <4C153418.5000705@cs.wisc.edu>
References: <20100611074819.GA27808@sles11sp1b1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:44999 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754223Ab0FMThx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Jun 2010 15:37:53 -0400
In-Reply-To: <20100611074819.GA27808@sles11sp1b1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: james.bottomley@suse.de, linux-scsi@vger.kernel.org, ravi.anand@qlogic.com

On 06/11/2010 02:48 AM, Vikas Chaudhary wrote:
> +	case ISCSI_HOST_PARAM_IF_TYPE:
> +		len = sprintf(buf, "%s\n", ((ha->addl_fw_state&
> +		    FW_ADDSTATE_OPTICAL_MEDIA) != 0) ?
> +		    "Optical" : "Copper");

I think it is best to add a table that maps some enum ISCSI_IF_TYPE to a 
string in scsi_transport_iscsi.c, then have the driver set the type on 
the iscsi_cls_host struct. scsi_tranpoort_iscsi.c would then just do the 
work of concerting and printing. This way we can make sure all the 
drivers print out their values in the same format. It would be like 
scsi_transport_fc.c's fc_port_speed_names or cos.
