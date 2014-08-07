From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH scsi 1/1] libiscsi : Add T10 Data Integrity Feature support
Date: Wed, 06 Aug 2014 21:25:42 -0500
Message-ID: <53E2E3A6.7010402@cs.wisc.edu>
References: <1407364668-20931-1-git-send-email-anish@chelsio.com> <1407364668-20931-2-git-send-email-anish@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42358 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524AbaHGC0e (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Aug 2014 22:26:34 -0400
In-Reply-To: <1407364668-20931-2-git-send-email-anish@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anish Bhatt <anish@chelsio.com>
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, jbottomley@parallels.com, kxie@chelsio.com, manojmalviya@chelsio.com

 On 08/06/2014 05:37 PM, Anish Bhatt wrote
> @@ -436,12 +473,12 @@ static int iscsi_prep_scsi_cmd_pdu(struct iscsi_task *task)
>  			/* No unsolicit Data-Out's */
>  			hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>  	} else {
> +		unsigned in_len = iscsi_scsi_in_total_length(sc);
>  		hdr->flags |= ISCSI_FLAG_CMD_FINAL;
>  		zero_data(hdr->dlength);
> -		hdr->data_length = cpu_to_be32(scsi_in(sc)->length);
> -
>  		if (sc->sc_data_direction == DMA_FROM_DEVICE)
>  			hdr->flags |= ISCSI_FLAG_CMD_READ;
> +		hdr->data_length = cpu_to_be32(in_len);
>  	}
>  

What tree and branch did you make these over? Have you seen the patches
from Sagi for iser and libiscsi support?

Could you rebuild this over Christoph's tree which has his patches:

git://git.infradead.org/users/hch/scsi-queue.git
