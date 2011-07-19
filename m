From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: ->map_task_SG conversion to ->map_control_SG
	and ->map_data_SG
Date: Mon, 18 Jul 2011 22:55:16 -0700
Message-ID: <1311054916.16756.42.camel@haakon2.linux-iscsi.org>
References: <1311055210-5686-1-git-send-email-nab@linux-iscsi.org>
	 <20110719055608.GA7465@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43217 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab1GSGE2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2011 02:04:28 -0400
In-Reply-To: <20110719055608.GA7465@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Andy Grover <agrover@redhat.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-07-19 at 07:56 +0200, Christoph Hellwig wrote:
> On Mon, Jul 18, 2011 at 11:00:10PM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch breaks up the ->map_task_SG() backend call into two seperate
> > ->map_control_SG() and ->map_data_SG() in order to better address
> > IBLOCK and pSCSI.  IBLOCK only allocates bios for ->map_data_SG(), and
> > pSCSI will allocate a struct request for both cases.
> 
> In my opnion we should just copy the ->do_task logical, .e.g
> 
> 	if ((TRANSPORT(dev)->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV) &&
> 	    (!(TASK_CMD(task)->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB)))
> 		error = transport_emulate_control_cdb(task);
> 	else
> 		error = TRANSPORT(dev)->do_task(task);
> 
> that is: don't even bother to call the backed unless we have to.
> 

I thought about this, but think it's slightly cleaner to have
->map_control_SG() and ->map_data_SG() backend callers now that we have
transport_allocate_control_task() and transport_allocate_data_tasks().

I'd like to avoid the TRANSPORT_PLUGIN_PHBA_PDEV usage, as that already
looks kinda ugly..  ;)

