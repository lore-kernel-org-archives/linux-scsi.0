From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Linux v2.5.47
Date: Wed, 13 Nov 2002 00:22:22 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021113002222.B323@infradead.org>
References: <Pine.LNX.4.44.0211101944030.17742-100000@penguin.transmeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211101944030.17742-100000@penguin.transmeta.com>; from torvalds@transmeta.com on Sun, Nov 10, 2002 at 07:46:06PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, Nov 10, 2002 at 07:46:06PM -0800, Linus Torvalds wrote:
> 
> I still have stuff pending, but this is what's currently merged. 

Btw, here's a little headsup for all maintainers of scsi host adapter
drivers.  In 2.5.47 the detect and release methods of the Scsi_Host_Template
have become optional.  If you had an old pci driver with the following
loop in foo_detcect:

	while ((pdev = pci_find_device())) {
		[do basic setup]
		sdev = scsi_register();
		[do more setup]
	}

You can convert it easily into a new-style pci driver with the following
probe routine:

	[do basic setup]
	sdev = scsi_register();
	[do more setup]
	return scsi_add_host();

Similarly a new routine, scsi_remove_host exist to call at the end
of the remove routine.


