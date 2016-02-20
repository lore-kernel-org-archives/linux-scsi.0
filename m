From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [dm-devel] dm-multipath test scripts
Date: Sat, 20 Feb 2016 07:13:07 -0800
Message-ID: <56C88283.3050704@sandisk.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com> <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com> <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com> <56C834F8.8050604@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0087.outbound.protection.outlook.com ([65.55.169.87]:31872
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751490AbcBTPNU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 Feb 2016 10:13:20 -0500
In-Reply-To: <56C834F8.8050604@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@redhat.com>, Junichi Nomura <j-nomura@ce.jp.nec.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 02/20/16 01:42, Hannes Reinecke wrote:
> ATM the only SCSI driver to support SCSI-mq properly are lpfc, virtio, 
> and fnic. None of the other driver have been modified, and I suspect the 
> performance might be less than stellar.

Hello Hannes,

Before scsi-mq support was added to the above drivers it was added
to the ib_srp driver. Apparently today there are multiple drivers
that support multiple hardware queues:

$ git grep -nH 'nr_hw_queues = [^1]' | grep -vE 'block/blk-mq|scsi/scsi_lib'
drivers/block/null_blk.c:667:		nullb->tag_set.nr_hw_queues = submit_queues;
drivers/block/virtio_blk.c:638:	vblk->tag_set.nr_hw_queues = vblk->num_vqs;
drivers/block/xen-blkfront.c:927:	info->tag_set.nr_hw_queues = info->nr_rings;
drivers/infiniband/ulp/srp/ib_srp.c:3337:	target->scsi_host->nr_hw_queues = target->ch_count;
drivers/nvme/host/pci.c:1680:		dev->tagset.nr_hw_queues = dev->online_queues - 1;
drivers/scsi/lpfc/lpfc_init.c:3318:	shost->nr_hw_queues = phba->cfg_fcp_io_channel;
drivers/scsi/virtio_scsi.c:1008:	shost->nr_hw_queues = num_queues;

Performance data is available in http://events.linuxfoundation.org/sites/events/files/slides/Vault%20-%20scsi-mq%20v2.pdf.

Bart.

