From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: swiotlb default size (64 MB) too small?
Date: Wed, 28 Jan 2009 08:57:43 +0900
Message-ID: <20090128085825W.fujita.tomonori@lab.ntt.co.jp>
References: <tkrat.9e61b4a2f7087aca@s5r6.in-berlin.de>
	<20090128083135Y.fujita.tomonori@lab.ntt.co.jp>
	<497F9CC5.8080807@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <497F9CC5.8080807@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: stefanr@s5r6.in-berlin.de
Cc: fujita.tomonori@lab.ntt.co.jp, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 28 Jan 2009 00:46:13 +0100
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 27 Jan 2009 18:03:40 +0100 (CET)
> > Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> +static void sbp2_unmap_scatterlist(struct device *card_device,
> >> +				   struct sbp2_command_orb *orb)
> >> +{
> >> +	if (scsi_sg_count(orb->cmd))
> >> +		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> >> +			     scsi_sg_count(orb->cmd),
> >> +			     orb->cmd->sc_data_direction);
> >> +
> >> +	if (orb->page_table_bus)
> >> +		dma_unmap_single(card_device, orb->page_table_bus,
> >> +				 sizeof(orb->page_table), DMA_TO_DEVICE);
> > 
> > Well, this does not look correct since zero can be a valid dma
> > address.
> 
> Hmm.
> 
> > static void sbp2_unmap_scatterlist(struct device *card_device,
> > 				   struct sbp2_command_orb *orb)
> > {
> > 	if (scsi_sg_count(orb->cmd))
> > 		dma_unmap_sg(card_device, scsi_sglist(orb->cmd),
> > 			     scsi_sg_count(orb->cmd),
> > 			     orb->cmd->sc_data_direction);
> > 
> > 	if (scsi_sg_count(orb->cmd) > 1)
> > 		dma_unmap_single(card_device, orb->page_table_bus,
> > 				 sizeof(orb->page_table), DMA_TO_DEVICE);
> > 
> > 
> > Well, looks cranky a bit but firewire is cranky for me :)
> 
> Even if scsi_sg_count(cmd) > 1, the outcome of dma_map_sg() could have
> been 1, couldn't it?  So I need to take note of that in another way.

Oops, right. Probably, you need to store the return value of
dma_map_sg in orb.

------------------------------------------------------------------------------
This SF.net email is sponsored by:
SourcForge Community
SourceForge wants to tell your story.
http://p.sf.net/sfu/sf-spreadtheword
