From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] refactor tmscsim inititalization code
Date: Sun, 12 Sep 2004 13:37:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040912113727.GA32682@lst.de>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:59818 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268710AbUILLh3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2004 07:37:29 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Tue, Sep 07, 2004 at 06:29:41PM +0200, Guennadi Liakhovetski wrote:
> >+static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 
> >cd)
> >{
> >+	u8 carryFlag = 1, j = 0x80, i, bval, regval;
> >
> >+	for (i = 0; i < 9; i++) {
> >+		if (carryFlag) {
> >+			bval = 0x40;
> >+			regval = 0x80;
> >+
> >+			pci_write_config_byte(pdev, regval, bval);
> >+		} else {
> >+			bval = 0;
> >+			regval = 0xc0;
> 
> 			^^^^^^^^^^^^^^
> 
> Where does this come from? The old code seems to always write to 0x80, 
> IIUC. I'll look further.


The 0xc0 is set in dc390_EnDisableCE when the first argument is
ENABLE_CE.

That happens just before the dc390_Prepare call in dc390_ReadEEprom
which is the only caller of dc390_EEpromOutDI.

