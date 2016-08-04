From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 04/22] libfc: spurious I/O error under high load
Date: Thu, 4 Aug 2016 13:15:10 +0200
Message-ID: <20160804111510.a5yxzrf5jtqgps5n@c203.arch.suse.de>
References: <1470230002-37737-1-git-send-email-hare@suse.de>
 <1470230002-37737-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44066 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbcHDLPo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2016 07:15:44 -0400
Content-Disposition: inline
In-Reply-To: <1470230002-37737-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Chad Dupuis <chad.dupuis@qlogic.com>

On Wed, Aug 03, 2016 at 03:13:04PM +0200, Hannes Reinecke wrote:
> If a command times out libfc is sending an REC, which also
> might fail (due to frames being lost or something).
> If no data has been transferred we can simply retry
> the command, but the current code sets a state of FC_ERROR,
> which then is being translated into DID_ERROR, resulting
> in an I/O error.
> So to handle this properly we need to set a separate
> state FC_TRANS_RESET and mapping it onto DID_SOFT_RETRY.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---

Can you try to get that message into one line?

>  	case FC_HRD_ERROR:
>  		FC_FCP_DBG(fsp, "Returning DID_NO_CONNECT to scsi-ml "
>  			   "due to FC_HRD_ERROR\n");

Otherwise:

Acked-by: Johannes Thumshirn <jth@kernel.org>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
