From: Tuomas Vainikka <tuomas.vainikka@aalto.fi>
Subject: Re: esp_scsi QTAG in FAS216
Date: Mon, 14 Apr 2014 08:05:34 +0300
Message-ID: <534B6C9E.3070307@aalto.fi>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com>	<CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com>	<CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-m68k-owner@vger.kernel.org>
In-Reply-To: <20140413.221414.853080853067673824.davem@davemloft.net>
Sender: linux-m68k-owner@vger.kernel.org
To: David Miller <davem@davemloft.net>, schmitzmic@gmail.com
Cc: jongk@linux-m68k.org, geert@linux-m68k.org, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 14.04.2014 05:14, David Miller wrote:
> From: Michael Schmitz <schmitzmic@gmail.com>
> Date: Mon, 14 Apr 2014 10:38:09 +1200
>
>> That appears to be our problem if I recall correctly Tuomas' debugging
>> report. (reselection, not selection as initiator). As
>> esp_slave_configure() enables queue tags regardless of chip config,
>> we'd best make certain the chip is configured correctly.
>>
>> The SCSI2 bit is used to test for presence of config register 2 in
>> esp_get_revision but later cleared in the same function. It appears
>> we'd need to set it after the call to scsi_esp_register() - can you
>> test whether that obsoletes the zorro_esp_slave_configure hack,
>> Tuomas?
>   ...
>>> Group 2 Commands
>>> (seems to only be relevant for target mode).
>>>
>>> And about the QTE bit:
>>>
>>> Bit 6 Queue Tag Enable
>>>
>>> When this bit is set, the 53CF94/96 can receive 3-byte messages during
>>> bus-initiated Select With ATN. This feature is also enabled by setting
>>> bit 3 in the Configuration 2 register.
>> My preference would be to set this one (named ESP_CONFIG3_TBMS). Your
>> opinion, Dave?
> As seems to be agreed upon here, the SCSI2 bit in the CONFIG2 register
> (ESP_CONFIG2_SCSI2ENAB) is only for when the chip is used in target
> mode.  So it is not relevant for our discussion because this driver is
> for initiator mode operation only.
>
> But some pieces of documentation seem like they might not agree on
> this point.
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
>
> Again I looked at the FreeBSD driver and for all chips after plain
> esp100, they set ESP_CONFIG2_SCSI2ENAB.
>
> Can we try testing the following patch?
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
>   		 */
>   		esp->rev = ESP100;
>   	} else {
> -		esp->config2 = 0;
> +		esp->config2 = ESP_CONFIG2_SCSI2ENAB;
>   		esp_set_all_config3(esp, 5);
>   		esp->prev_cfg3 = 5;
>   		esp_write8(esp->config2, ESP_CFG2);
> @@ -2187,8 +2187,6 @@ static void esp_get_revision(struct esp *esp)
>   			} else {
>   				esp->rev = ESP236;
>   			}
> -			esp->config2 = 0;
> -			esp_write8(esp->config2, ESP_CFG2);
>   		}
>   	}
>   }

I'll test these out soon.

Michael, where can I pull the latest version of zorro_esp?

-Tuomas
