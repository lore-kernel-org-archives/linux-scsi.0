From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] refactor tmscsim inititalization code
Date: Tue, 7 Sep 2004 18:29:41 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
References: <20040904130235.GA20552@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pop.gmx.net ([213.165.64.20]:21950 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268248AbUIGQaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2004 12:30:20 -0400
In-Reply-To: <20040904130235.GA20552@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

A couple more things:

Your note on possible problems when using several AM53C974A-based HBA in
one machine - how do other drivers resolve this problem, if those 
adapters need different configuration?

And one thing I didn't understand in your code:

On Sat, 4 Sep 2004, Christoph Hellwig wrote:

> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cd)
> {
> +	u8 carryFlag = 1, j = 0x80, i, bval, regval;
>
> +	for (i = 0; i < 9; i++) {
> +		if (carryFlag) {
> +			bval = 0x40;
> +			regval = 0x80;
> +
> +			pci_write_config_byte(pdev, regval, bval);
> +		} else {
> +			bval = 0;
> +			regval = 0xc0;

 			^^^^^^^^^^^^^^

Where does this come from? The old code seems to always write to 0x80, 
IIUC. I'll look further.

> +		}
>
> +		udelay(160);
> +		pci_write_config_byte(pdev, regval, bval | 0x80);
> +		udelay(160);
> +		pci_write_config_byte(pdev, regval, 0);
> +		udelay(160);
>
> +		carryFlag = (cmd & j) ? 1 : 0;
> +		j >>= 1;
> +	}
> +}

Thanks
Guennadi
---
Guennadi Liakhovetski

