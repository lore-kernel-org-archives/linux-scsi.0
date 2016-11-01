From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: esp_scsi QTAG in FAS216
Date: Tue, 1 Nov 2016 18:23:06 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1611011816520.3174@nippy.intranet>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com> <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com> <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net>
 <alpine.LNX.2.00.1610281658120.30954@nippy.intranet> <alpine.LNX.2.00.1610301331301.20114@nippy.intranet> <50ffb9f6-ebe0-9e87-1244-25dfb2ec01d2@gmail.com> <CAOmrzkKPsFKvgvHzPJKCP-Vm9EYnFoy+Gq0C=Ly9zAA3D_zDaA@mail.gmail.com> <alpine.LNX.2.00.1611011017470.23137@nippy.intranet>
 <83f2bc09-3e29-1c3d-46d8-0ee009a7c67e@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:44420 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034089AbcKAHXN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2016 03:23:13 -0400
In-Reply-To: <83f2bc09-3e29-1c3d-46d8-0ee009a7c67e@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>
Cc: David Miller <davem@davemloft.net>, Kars de Jong <jongk@linux-m68k.org>, Tuomas Vainikka <tuomas.vainikka@aalto.fi>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux/m68k <linux-m68k@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>


On Tue, 1 Nov 2016, Michael Schmitz wrote:

> Hi Finn,
> 
> Am 01.11.2016 um 12:47 schrieb Finn Thain:
> > 
> > On Tue, 1 Nov 2016, Michael Schmitz wrote:
> > 
> >>> I had tried to set that bit in zorro_esp_slave_configure but had not 
> >>> done a proper job of it - I'd only set esp->config3 and forgot to 
> >>> set tp->esp_config3. Time to retest this ...
> >>
> >> I don't think it's quite that easy - the ESP_CONFIG3_TENB bit needs 
> >> to be set for all targets if at least one SCSI-2 target is on the bus 
> >> and we allow dosconnecting, no?
> > 
> > I think ESP_CONFIG3_TENB is for FAS100A and FASHME. The bug here is on 
> > ESP236 and FAS236, so ESP_CONFIG3_TBMS would be the relevant bit.
> 
> I stand corrected. Err... confused.
> 
> When setting ESP_CONFIG3_TBMS, should we set ESP_CONFIG3_GTM as well?

I think that depends entirely on the target. But it isn't relevant to the 
bug at hand AFAICS.

-- 

> 
> > The bit gets set when ESP_CONFIG2_SCSI2ENAB gets set (as in David's 
> > patch) so we then need to avoid clobbering it, since ESP_CONFIG3_TBMS 
> > == ESP_CONFIG3_EWIDE. I think we have to test for HME to avoid this 
> > clash.
> 
> I'd want to set these bits for ESP236 and FAS236 only, so no clash with 
> HME. As you found out, ESP_CONFIG3_TBMS aka ESP_CONFIG3_EWIDE gets 
> clobbered on bus reset cleanup unconditionally.
> 
> Cheers,
> 
> 	Michael
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
