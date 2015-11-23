From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Mon, 23 Nov 2015 14:33:05 -0800
Message-ID: <56539421.9050705@sandisk.com>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
 <1447422410-20891-3-git-send-email-hch@lst.de>
 <20151113182513.GB21808@obsidianresearch.com> <564640C4.3000603@sandisk.com>
 <20151113220636.GA32133@obsidianresearch.com> <20151114071344.GE27738@lst.de>
 <20151123203712.GB5640@obsidianresearch.com> <56537F59.4080708@sandisk.com>
 <20151123212822.GE6062@obsidianresearch.com> <56538AFD.9080103@sandisk.com>
 <20151123221806.GA7152@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151123221806.GA7152@obsidianresearch.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sagig@dev.mellanox.co.il" <sagig@dev.mellanox.co.il>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11/23/2015 02:18 PM, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2015 at 01:54:05PM -0800, Bart Van Assche wrote:
> What I don't see is how SRP handles things when the
> sendq fills up, ie the case where __srp_get_tx_iu() == NULL. It looks
> like the driver starts to panic and generates printks. I can't tell if
> it can survive that, but it doesn't look very good..

Hello Jason,

 From srp_cm_rep_handler():

		target->scsi_host->can_queue
			= min(ch->req_lim - SRP_TSK_MGMT_SQ_SIZE,
			      target->scsi_host->can_queue);

In other words, the SCSI core is told to ensure that the number of 
outstanding SCSI commands is one less than the number of elements in the 
ch->free_tx list. And since the SRP initiator serializes task management 
requests it is guaranteed that __srp_get_tx_iu() won't fail due to 
ch->free_tx being empty.

Bart.
