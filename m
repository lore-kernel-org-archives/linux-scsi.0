From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [RFTesters] Re: [PATCH] refactor tmscsim inititalization code
Date: Fri, 17 Sep 2004 21:05:01 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.60.0409172052230.31193@poirot.grange>
References: <20040904130235.GA20552@lst.de> <Pine.LNX.4.60.0409071040120.2966@poirot.grange>
 <20040910133254.GB32530@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imap.gmx.net ([213.165.64.20]:65225 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S268961AbUIQTuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Sep 2004 15:50:24 -0400
In-Reply-To: <20040910133254.GB32530@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

Hi

Sorry for a delay - was away for a week.

On Fri, 10 Sep 2004, Christoph Hellwig wrote:

>> 1) My big problem with this patch is, that I don't have any AM53C7974
>> based hardware with EEPROM, and you re-write the EEPROM handling
>> functions. Although, it does look like you just inlined some of them and
>> removed redundant code. Do you have the hardware to test it? If not - I
>> guess, we'd have to ask for volunteers to test it. Your patch is a bit
>> less than trivial:-) If nobody volunteers, well, I'll have to try to prove
>> the equivalence myself:-)
>
> I'll do a new patch with that part excluded (and ontop of all the
> patches currently pending for tmscsim)

Ok, now, that the patch has been applied, and, as Christoph informed me, 
it would be difficult (impossible?) to undo it, we have to fix it. I'll 
explain my doubts separately as a reply to another Christoph's email. Or 
would it still be possible to get a patch in, reverting the EEPROM rework?

>> 2) I just realised - we have 2 possibilities to pass parameters to
>> tmscsim, if it is compiled into the kernel - with tmscsim.tmscsim=...
>> and with tmscsim=... I guess, breaking scripts by removing one of them now
>> wouldn't be good... But we could put a warning printk() in dc390_setup
>> "Deprecated! Use tmscsim.tmscsim=... This will be removed real soon
>> now!\n" should we?
>
> I think we should deprecated both and use an easy to understand
> module_param-based interface.

Right, this is what is used ATM:

module_param_array(tmscsim, int, tmscsim_paramnum, 0);

, and this is where tmscsim.tmscsim=... comes from. Similar to 
scsi_mod.scsi_logging_level, etc. What I meant is, that removing 
dc390_setup might break people's setups.

>> 3) There's a typo:
>>
>>> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8
>>> cd)
>>
>> should be
>>
>>> +static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, u8
>>> cmd)
>
> thanks.

Thanks to Andrew for fixing this.

Thanks
Guennadi
---
Guennadi Liakhovetski

