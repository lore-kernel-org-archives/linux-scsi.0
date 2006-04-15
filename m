From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/7] lpfc 8.1.5 : Fix cleanup code in the lpfc_pci_probe_one() error code path
Date: Sat, 15 Apr 2006 17:40:26 +0100
Message-ID: <20060415164026.GA2939@infradead.org>
References: <1145116391.3795.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:29668 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1030287AbWDOQkr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 12:40:47 -0400
Content-Disposition: inline
In-Reply-To: <1145116391.3795.3.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Sat, Apr 15, 2006 at 11:53:10AM -0400, James Smart wrote:
> @@ -1725,9 +1730,14 @@ static void __devexit
>  lpfc_pci_remove_one(struct pci_dev *pdev)
>  {
>  	struct Scsi_Host   *host = pci_get_drvdata(pdev);
> -	struct lpfc_hba    *phba = (struct lpfc_hba *)host->hostdata;
> +	struct lpfc_hba    *phba;
>  	unsigned long iflag;
>  
> +	if (host == NULL)
> +		return;
> +
> +	phba = (struct lpfc_hba *)host->hostdata;

If this ever happen there's something really badly wrong in lpfc_pci_probe_one,
so please don't put this check in.
