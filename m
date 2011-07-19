From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] target: ->map_task_SG conversion to ->map_control_SG
	and ->map_data_SG
Date: Tue, 19 Jul 2011 07:56:08 +0200
Message-ID: <20110719055608.GA7465@lst.de>
References: <1311055210-5686-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:53514 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab1GSF4J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2011 01:56:09 -0400
Content-Disposition: inline
In-Reply-To: <1311055210-5686-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Jul 18, 2011 at 11:00:10PM -0700, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch breaks up the ->map_task_SG() backend call into two seperate
> ->map_control_SG() and ->map_data_SG() in order to better address
> IBLOCK and pSCSI.  IBLOCK only allocates bios for ->map_data_SG(), and
> pSCSI will allocate a struct request for both cases.

In my opnion we should just copy the ->do_task logical, .e.g

	if ((TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) &&
	    (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
		error = transport_emulate_control_cdb(task);
	else
		error = TRANSPORT(dev)->do_task(task);

that is: don't even bother to call the backed unless we have to.

