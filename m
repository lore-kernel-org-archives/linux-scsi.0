From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 31 Oct 2016 21:03:44 +1300
Message-ID: <50ffb9f6-ebe0-9e87-1244-25dfb2ec01d2@gmail.com>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>
 <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>
 <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com>
 <20140413.221414.853080853067673824.davem@davemloft.net>
 <alpine.LNX.2.00.1610281658120.30954@nippy.intranet>
 <alpine.LNX.2.00.1610301331301.20114@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1610301331301.20114@nippy.intranet>
Sender: linux-m68k-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, David Miller <davem@davemloft.net>
Cc: jongk@linux-m68k.org, tuomas.vainikka@aalto.fi, geert@linux-m68k.org, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Finn,

Am 30.10.2016 um 15:33 schrieb Finn Thain:
> 
> On Sat, 29 Oct 2016, I wrote:
> 
>>
>> On Sun, 13 Apr 2014, David Miller wrote:
>>
>>>
>>> But oddly in the NCR53CX docs:
>>>
>>> 	http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/NCR53C9X.txt
>>>
>>> it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer 
>>> grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB, 
>>> which enables both features.
>>
>> Yes, so setting the ESP_CONFIG2_SCSI2ENAB bit is correct. The only 
>> problem is, doesn't the ESP_CONFIG3_TMS bit get cleared again later, 
>> when the CONFIG3 register is written to?
>>
> 
> Nevermind my question. To falsify my own theory, I see that 
> ESP_CONFIG3_TMS == ESP_CONFIG3_FCLK, and thus esp_scsi does actually set 
> the relevant bit, and therefore "the FSC can receive 3-byte messages 
> during businitiated select with ATN."

>From my reading of the quoted docs,ESP_CONFIG3_TMS is valid for FAS100A
(and later?). What esp_scsi sets (for FAS236 chips) is fast SCSI clock
mode. The relevant bit for three byte message support for Mac and Amiga
ESP hardware should be ESP_CONFIG3_TENB.

I had tried to set that bit in zorro_esp_slave_configure but had not
done a proper job of it - I'd only set esp->config3 and forgot to set
tp->esp_config3. Time to retest this ...

Cheers,

	Michael
