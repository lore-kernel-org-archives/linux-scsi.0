From: Christoph Hellwig <hch@infradead.org>
Subject: Re: PATCH [4/5]  qla2xxx: cleanup DMA mappings...
Date: Wed, 13 Apr 2005 22:34:24 +0100
Message-ID: <20050413213424.GA18061@infradead.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191904.GM9703@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:5599 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S261201AbVDMVe0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 17:34:26 -0400
Content-Disposition: inline
In-Reply-To: <20050413191904.GM9703@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

> +		struct page	*page;
> +		unsigned long	offset;
> +
> +		page = virt_to_page(cmd->request_buffer);
> +		offset = ((unsigned long)cmd->request_buffer & ~PAGE_MASK);
> +		req_dma = pci_map_page(ha->pdev, page, offset,
> +		    cmd->request_bufflen, cmd->sc_data_direction);

Why're you're redoing that code please switch to pci_map_single insted
of these nasty operations to go to the page first, the code will become
a lit simpler too, e.g. the above becomes just:

	req_dma = pci_map_single(ha->pdev, cmd->request_buffer,
			cmd->request_bufflen, cmd->sc_data_direction);

