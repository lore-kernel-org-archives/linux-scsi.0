From: Jens Axboe <axboe@suse.de>
Subject: Re: Bounce buffer usage
Date: Mon, 4 Nov 2002 09:21:44 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021104082144.GA13587@suse.de>
References: <20021102091256.GC31088@suse.de> <20021103221029.7908.qmail@web80304.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021103221029.7908.qmail@web80304.mail.yahoo.com>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lobo <ntdeveloper2002@yahoo.com>
Cc: linux-scsi@vger.kernel.org

On Sun, Nov 03 2002, Mark Lobo wrote:
> Now in the initiator driver, all what I get is a
> request buffer address. To actually use the above API,
> I need the page address, and that I get from
> virt_to_page ( as described in the bounce buffer patch
> doc) So I dont need a virt_to_page call to get the
> page address? I dont understand how I can use 
> this --> "struct page *page = buffer->page;"? In that
> case, what gets passed down to the initiator in the
> "no scatter gather" case is some kind of structure?
> Dont I need to do "struct page *page =
> virt_to_page(buffer);"?

For drivers that deal with highmem, you are getting sg setup even for a
single segment. It would indeed be possible to send down a virtual
address for non-sg, if the original page didn't reside in highmem. In
that case, yes all you would have to do is

	page = virt_to_page(buf);
	offset = ((unsigned long) buf) & ~PAGE_MASK;

to get the remaining data you need. However, most drivers typically do

	if (command->use_sg)
		nr_entries = pci_map_page() sg list
	else
		pci_map_single() virtual address

-- 
Jens Axboe

