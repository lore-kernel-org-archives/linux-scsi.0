From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] refactor tmscsim inititalization code
Date: Fri, 17 Sep 2004 21:49:38 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409172136450.31193@poirot.grange>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071812550.21209@poirot.grange>
 <20040912113727.GA32682@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:14468 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268957AbUIQTuW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 15:50:22 -0400
In-Reply-To: <20040912113727.GA32682@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

On Sun, 12 Sep 2004, Christoph Hellwig wrote:

> On Tue, Sep 07, 2004 at 06:29:41PM +0200, Guennadi Liakhovetski wrote:
>>> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8
>>> cd)
>>> {
>>> +	u8 carryFlag = 1, j = 0x80, i, bval, regval;
>>>
>>> +	for (i = 0; i < 9; i++) {
>>> +		if (carryFlag) {
>>> +			bval = 0x40;
>>> +			regval = 0x80;
>>> +
>>> +			pci_write_config_byte(pdev, regval, bval);
>>> +		} else {
>>> +			bval = 0;
>>> +			regval = 0xc0;
>>
>> 			^^^^^^^^^^^^^^
>>
>> Where does this come from? The old code seems to always write to 0x80,
>> IIUC. I'll look further.
>
>
> The 0xc0 is set in dc390_EnDisableCE when the first argument is
> ENABLE_CE.
>
> That happens just before the dc390_Prepare call in dc390_ReadEEprom
> which is the only caller of dc390_EEpromOutDI.

Right, but:

static void __devinit dc390_Prepare(struct pci_dev *pdev, u8 *regval, u8 EEpromCmd)
{
     u8 i,j;
     u8 carryFlag;

     carryFlag = 1;
     j = 0x80;
     for(i=0; i<9; i++)
     {
         dc390_EEpromOutDI(pdev, regval, carryFlag);
         carryFlag = (EEpromCmd & j) ? 1 : 0;
         j >>= 1;
     }
}

So, EEpromOutDI is always called for the first time with carryFlag == 1. 
In EEpronOutDI:

static void __devinit dc390_EEpromOutDI(struct pci_dev *pdev, u8 *regval, 
u8 Carry)
{
     u8 bval;

     bval = 0;
     if(Carry)
     {
         bval = 0x40;
         *regval = 0x80;
         pci_write_config_byte(pdev, *regval, bval);
     }
     udelay(160);
     bval |= 0x80;
     pci_write_config_byte(pdev, *regval, bval);
     udelay(160);
     bval = 0;
     pci_write_config_byte(pdev, *regval, bval);
     udelay(160);
}

*regval will be immediately set to 0x80 and never set to anything else. 
Your "else" clause seems simply not to be there. Am I still missing 
anything?

As for me rediffing my patches against the current BK - I'll try to do 
that (after we figure out what to do with your last patch). It won't be 
very easy - I am not using BK. It would be a pain over a 56kbps link:-) 
So, it'll take some time.

Thanks
Guennadi
---
Guennadi Liakhovetski

