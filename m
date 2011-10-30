From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: question about passing physical address to lower level driver
 in scsi
Date: Sun, 30 Oct 2011 13:28:21 +0100
Message-ID: <20111030132821.4df33f1e@stein>
References: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:36549 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933977Ab1J3M2Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Oct 2011 08:28:25 -0400
In-Reply-To: <CADUS3okkKEu_Re1FU_AvVk6agFwrmx0mwzbMSmso6pV8HFfWMA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: yoma sophian <sophian.yoma@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Oct 30 yoma sophian wrote:
> in scsi_init_sgtable, we create sgtable, sdb->table.sgl, and get the
> page from blk_rq_map_sg.
> But when the dma_address of sdb->table.sgl will be calclated out
> before send the scsi command down to the lower level driver?

The low level driver, not SCSI core, is responsible to obtain a DMA
address.

dma_map_sg() maps the scatter-gather list into DMA memory.  Then you can
iterate over the list with for_each_sg and obtain DMA handles and lengths
with sg_dma_address() and sg_dma_len().  E.g.:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/firewire/sbp2.c;h=41841a3e3f99c9acd4c4fc72c972626d8dffdcee;hb=02f8c6aee8df3cdc935e9bdd4f2d020306035dbe#l1398
-- 
Stefan Richter
-=====-==-== =-=- ====-
http://arcgraph.de/sr/
