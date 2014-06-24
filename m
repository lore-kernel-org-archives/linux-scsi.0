From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/3] scsi_cmnd: Introduce scsi_transfer_length helper
Date: Tue, 24 Jun 2014 12:31:17 -0400
Message-ID: <yq1fviugtgq.fsf@sermon.lab.mkp.net>
References: <1402477799-24610-1-git-send-email-sagig@mellanox.com>
	<1402477799-24610-2-git-send-email-sagig@mellanox.com>
	<53A920B2.9060503@cs.wisc.edu> <yq1mwd2h3ju.fsf@sermon.lab.mkp.net>
	<28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48971 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756665AbaFXQdX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jun 2014 12:33:23 -0400
In-Reply-To: <28678EBD-1AE9-48F9-B9E2-E6A61B042BB1@cs.wisc.edu> (Michael
	Christie's message of "Tue, 24 Jun 2014 11:08:54 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, nab@linux-iscsi.org, roland@kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

>>>>> "Mike" == Michael Christie <michaelc@cs.wisc.edu> writes:

Mike> Do we need to check for the data direction. Something like

Mike> if (scmd->sc_data_direction == DMA_TO_DEVICE)
Mike> 	xfer_len = scsi_out(scmnd)->length;
Mike> else
Mike> 	xfer_len = scsi_in(scmnd)->length;

I guess that depends on the context the wrapper is called in. I think
iscsi is the only place where there's a distinction thanks to bidi.

Looks like there are several places where that's done. In that case I
wonder if we should have explicit scsi_in_transfer_length() and
scsi_out_transfer_length() wrappers?

-- 
Martin K. Petersen	Oracle Linux Engineering
