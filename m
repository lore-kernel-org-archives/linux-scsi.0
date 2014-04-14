From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 14 Apr 2014 21:01:02 +1200
Message-ID: <0ee24dc77b71e282562b794aaa4039cd@gmail.com>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com> <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com> <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net>
Mime-Version: 1.0 (Apple Message framework v624)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20140413.221414.853080853067673824.davem@davemloft.net>
Sender: linux-m68k-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, geert@linux-m68k.org, jongk@linux-m68k.org, tuomas.vainikka@aalto.fi, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Dave,

>>> When this bit is set, the 53CF94/96 can receive 3-byte messages  
>>> during
>>> bus-initiated Select With ATN. This feature is also enabled by  
>>> setting
>>> bit 3 in the Configuration 2 register.
>>
>> My preference would be to set this one (named ESP_CONFIG3_TBMS). Your
>> opinion, Dave?
>
> As seems to be agreed upon here, the SCSI2 bit in the CONFIG2 register
> (ESP_CONFIG2_SCSI2ENAB) is only for when the chip is used in target
> mode.  So it is not relevant for our discussion because this driver is
> for initiator mode operation only.

Agreed. ESP_CONFIG2_SCSI2ENAB might do more than we intend, and have  
unintended side effects. It's just easier to test whether this fixes  
our problem.

>
> But some pieces of documentation seem like they might not agree on
> this point.
>
> With respect to bit 3 in the config3 register, it can take on one of
> two meaning depending upon chip revision.  As per  
> ESP_CONFIG3_{TMS,FCLK}
> it either controls fast SCSI clocking, or it enabled 3 byte message
> recognition.
>
> But oddly in the NCR53CX docs:
>
> 	http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/ 
> NCR53C9X.txt
>
> it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer
> grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB,
> which enables both features.

That's what I understood from the bits Kars quoted, yes. And in the  
Amiga driver cases, it will always be the 3 byte message feature  
controlled by that bit, as far as I can see.

>
> Again I looked at the FreeBSD driver and for all chips after plain
> esp100, they set ESP_CONFIG2_SCSI2ENAB.
>
> Can we try testing the following patch?

That would be even easier than setting it explicitly in the Zorro  
driver, thanks,

	Michael


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
