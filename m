From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: esp_scsi QTAG in FAS216
Date: Sat, 29 Oct 2016 08:54:42 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1610281658120.30954@nippy.intranet>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com> <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com> <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com>
 <20140413.221414.853080853067673824.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33256 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S942614AbcJ1Vyv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Oct 2016 17:54:51 -0400
In-Reply-To: <20140413.221414.853080853067673824.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: schmitzmic@gmail.com, jongk@linux-m68k.org, tuomas.vainikka@aalto.fi, geert@linux-m68k.org, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org


On Sun, 13 Apr 2014, David Miller wrote:

> > esp_get_revision but later cleared in the same function. It appears 
> > we'd need to set it after the call to scsi_esp_register() - can you 
> > test whether that obsoletes the zorro_esp_slave_configure hack, 
> > Tuomas?
>  ...
> > > Group 2 Commands
> > > (seems to only be relevant for target mode).
> > >
> > > And about the QTE bit:
> > >
> > > Bit 6 Queue Tag Enable
> > >
> > > When this bit is set, the 53CF94/96 can receive 3-byte messages 
> > > during bus-initiated Select With ATN. This feature is also enabled 
> > > by setting bit 3 in the Configuration 2 register.
> > 
> > My preference would be to set this one (named ESP_CONFIG3_TBMS). Your 
> > opinion, Dave?
> 
> As seems to be agreed upon here, the SCSI2 bit in the CONFIG2 register 
> (ESP_CONFIG2_SCSI2ENAB) is only for when the chip is used in target 
> mode.  So it is not relevant for our discussion because this driver is 
> for initiator mode operation only.
> 
> But some pieces of documentation seem like they might not agree on this 
> point.

I think there is ambiguity, and I see some differences between the 
documentation for ESP236 and that for FAS236 devices. But I don't agree 
that ESP_CONFIG2_SCSI2ENAB is only for target mode.

This bug affects re-selection. So documentation which refers to a "device 
[being] selected" tends to be ambiguous, because re-selection is still 
selection in some sense. E.g. the Am53C94/Am53C96 (preliminary) datasheet 
says this:

    Extended Message Feature: When the S2FE [ESP_CONFIG2_SCSI2ENAB] bit is 
    set and the device is selected with attention, the device will monitor 
    the /ATN signal at the end of the first message byte. If the /ATN 
    signal is active, the device will request two more message bytes 
    before switching to the command phase. If the /ATN signal is inactive 
    the device will switch to the command phase.

But the next part is clear enough and seems to explain the mac_esp 
(ESP236) failure:

    When the S2FE bit is reset the device as a target will request a 
    single message byte. As an initiator, the device will abort the 
    selection sequence if the target does not switch to the command phase 
    after receiving a single message byte.

The document you cited, NCR53C9X.txt, seems unambiguous about the role of 
the initiator. (Just search for "identify message" to see the relevant 
parts.)

Moreover, for reselection, NCR53C9X.txt says the chip will expect 2 tag 
bytes only when tagged queueing is enabled, that is, QTE bit aka 
ESP_CONFIG3_TMS bit is set. The QTE feature "is also enabled by setting 
bit 3 in the Configuration 2 register", aka ESP_CONFIG2_SCSI2ENAB, which 
is what your patch does.

> 
> With respect to bit 3 in the config3 register, it can take on one of
> two meaning depending upon chip revision.  As per ESP_CONFIG3_{TMS,FCLK}
> it either controls fast SCSI clocking, or it enabled 3 byte message
> recognition.
> 
> But oddly in the NCR53CX docs:
> 
> 	http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/NCR53C9X.txt
> 
> it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer
> grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB,
> which enables both features.

Yes, so setting the ESP_CONFIG2_SCSI2ENAB bit is correct. The only problem 
is, doesn't the ESP_CONFIG3_TMS bit get cleared again later, when the 
CONFIG3 register is written to?

> 
> Again I looked at the FreeBSD driver and for all chips after plain 
> esp100, they set ESP_CONFIG2_SCSI2ENAB.
> 
> Can we try testing the following patch?

It could be that this patch would be sufficient to fix mac_esp because 
ESP236 seems to have no ESP_CONFIG3_TMS bit.

We know that this patch didn't work for zorro_esp (FAS236) but it would be 
helpful to know what value the CONFIG3 register took in the end.

-- 

> 
> ====================
> esp_scsi: Set SCSI2 bit in config2 register.
> 
> This should allow proper recognition of 3 byte reselection
> on all esp100a and later chips.
> 
> Reported-by: Kars de Jong <jongk@linux-m68k.org>
> Reported-by: Michael Schmitz <schmitzmic@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 55548dc..16f69e0 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -2160,7 +2160,7 @@ static void esp_get_revision(struct esp *esp)
>  		 */
>  		esp->rev = ESP100;
>  	} else {
> -		esp->config2 = 0;
> +		esp->config2 = ESP_CONFIG2_SCSI2ENAB;
>  		esp_set_all_config3(esp, 5);
>  		esp->prev_cfg3 = 5;
>  		esp_write8(esp->config2, ESP_CFG2);
> @@ -2187,8 +2187,6 @@ static void esp_get_revision(struct esp *esp)
>  			} else {
>  				esp->rev = ESP236;
>  			}
> -			esp->config2 = 0;
> -			esp_write8(esp->config2, ESP_CFG2);
>  		}
>  	}
>  }
