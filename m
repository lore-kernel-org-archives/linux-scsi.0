From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] fix dma mapping leak in fusion
Date: Tue, 17 Aug 2004 18:46:14 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040817164614.GA16953@lst.de>
References: <0E3FA95632D6D047BA649F95DAB60E5704DE66BB@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:36075 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S266491AbUHQQqW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Aug 2004 12:46:22 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E5704DE66BB@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, fukuchi.masao@jp.fujitsu.com

On Tue, Aug 17, 2004 at 12:42:06PM -0400, Moore, Eric Dean wrote:
> Ok - your proposed change will Opps the driver.
> 
> Sequence to oops:
> 1.SCSI midlayer detects command timeout and issue abort 
> message to fusion MPT driver.
> 2.Fusion MPT driver issues abort message to IOC and returns 
> SCSI midlayer with FAILED status.
> 3.SCSI midlayer gives up the operation and call 
> scsi_release_buffers()to free buffers; this 
> routine does "cmd->request_buffer=NULL;"
> 4.Fusion MPT driver initiates IOC reset and calls 
> mptscsih_flush_running_cmds() to cancel SCSI command.
> 5.Oops - occurs when calling pci_unmap_sg when request_buffer=NULL.

Then you have a bug lying even deeper.  You must not fail a device to
the midlayer without also unmapping it and removing it from your
internal lookup tables.

