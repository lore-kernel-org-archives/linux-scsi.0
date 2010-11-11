From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/2] target: remove dead DF_* flags
Date: Thu, 11 Nov 2010 05:04:48 -0800
Message-ID: <1289480688.2867.119.camel@haakon2.linux-iscsi.org>
References: <20101111104040.GA21472@infradead.org>
	 <20101111104056.GB21472@infradead.org>
	 <1289473630.2867.110.camel@haakon2.linux-iscsi.org>
	 <20101111122159.GA22413@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46987 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455Ab0KKNKA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Nov 2010 08:10:00 -0500
In-Reply-To: <20101111122159.GA22413@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

On Thu, 2010-11-11 at 07:21 -0500, Christoph Hellwig wrote:
> On Thu, Nov 11, 2010 at 03:07:10AM -0800, Nicholas A. Bellinger wrote:
> > This is still required by RAMDISK_DR to allow the backend to perform the
> > se_task->task_sg[] mapping from the ramdisk provided struct scatterlists
> > using se_subsystem_api->allocate_dma()
> 
> It's not actually used anywhere at all.  And if you mean fronted instead
> of backend above and imply not yet merged - I don't think adding special
> cases for the ramdisk driver into frontends is a good idea, as it's not
> really a case worth optimizing for.  And even then it's entirely dead
> and untested code for now.
> 

Whoops sorry, transport_dev_get_mem_SG() is simply checking for valid
se_subsystem_api->allocate_DMA() and ->free_DMA() function pointers for
the special RAMDISK_DR case.   So dropping the unnecessary
DF_TRANSPORT_DMA_ALLOC flag now

Sorry for the extra noise.  ;)

Thanks!


