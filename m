From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [Patch] QLogic qla2x00 driver fixes
Date: Fri, 25 Feb 2005 03:38:40 -0500
Message-ID: <421EE410.7020603@pobox.com>
References: <1109305293.27139.216.camel@compaq-rhel4.xsintricity.com> <1109318231.6290.27.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:15536 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S262651AbVBYIi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2005 03:38:59 -0500
In-Reply-To: <1109318231.6290.27.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: Doug Ledford <dledford@redhat.com>, linux-scsi mailing list <linux-scsi@vger.kernel.org>

Arjan van de Ven wrote:
> On Thu, 2005-02-24 at 23:21 -0500, Doug Ledford wrote:
> 
>>Don't use cmd->request->nr_hw_segments as it may not be initialized
>>(SG_IO in particular bypasses anything that initializes this and just
>>uses scsi_do_req to insert a scsi_request directly on the head of the
>>queue) 
> 
> 
> should we fix that in the SG_IO layer ?

Possibly/probably.

For SCSI drivers specifically, using nr_hw_segments is pointless unless 
cmd->use_sg goes away.  At which point tons of SCSI drivers want 
changing anyway.

	n_sg = dma_map_sg(..., cmd->use_sg, ...)

will always do the right thing, when the cmd contains a scatterlist.

Deviate from the norm and pay the price, really...

	Jeff



