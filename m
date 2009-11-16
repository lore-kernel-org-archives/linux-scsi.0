From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] libata: add TRIM support
Date: Mon, 16 Nov 2009 16:07:48 +0000
Message-ID: <20091116160748.3c58218e@lxorguk.ukuu.org.uk>
References: <20091116154343.GA6672@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20091116154343.GA6672@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Martin K. Petersen" <mkp@mkp.net>, Matthew Wilcox <willy@wil.cx>
List-Id: linux-scsi@vger.kernel.org

> +	min_io_sectors = 1;
> +	if ((args->id[106] & 0xc000) == 0x4000 && (args->id[106] & (1 << 13)))
> +		min_io_sectors *= args->id[106] & 0xf;

That magic probably wants to be an ata_id_foo helper of some sort but
otherwise all looks sensible enough for ATA. I'm assuming gcc is smart
enough to collapse that into

	id[106] & 0xE000 != 0x6000

anyway

Alan
