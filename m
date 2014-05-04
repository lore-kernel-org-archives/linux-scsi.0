From: Tuomas Vainikka <tuomas.vainikka@aalto.fi>
Subject: Re: esp_scsi QTAG in FAS216
Date: Sun, 4 May 2014 14:41:04 +0300
Message-ID: <53662750.90407@aalto.fi>
References: <CAOmrzkK1hoT72zA4CzajCH2uNwkiVPWi8vJQswB=4Q4uf-kSZQ@mail.gmail.com> <CACz-3rjNixJBjKxzjpneFE8BHKpzR-hvhWsabT_AtrWZZUgvsA@mail.gmail.com> <CAOmrzkJZEZigKEyb5_66H2FNaEX7F_TXyvQNMpMZu1MyuOudBw@mail.gmail.com> <20140413.221414.853080853067673824.davem@davemloft.net> <0ee24dc77b71e282562b794aaa4039cd@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="------------020200090900090108050507"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out-01.aalto.fi ([130.233.228.120]:62510 "EHLO
	smtp-out-01.aalto.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753550AbaEDLlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2014 07:41:08 -0400
In-Reply-To: <0ee24dc77b71e282562b794aaa4039cd@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Schmitz <schmitzmic@gmail.com>, David Miller <davem@davemloft.net>
Cc: linux-m68k@vger.kernel.org, geert@linux-m68k.org, jongk@linux-m68k.org, linux-scsi@vger.kernel.org

--------------020200090900090108050507
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit

On 14.04.2014 12:01, Michael Schmitz wrote:
> Hi Dave,
>
>>>> When this bit is set, the 53CF94/96 can receive 3-byte messages during
>>>> bus-initiated Select With ATN. This feature is also enabled by setting
>>>> bit 3 in the Configuration 2 register.
>>>
>>> My preference would be to set this one (named ESP_CONFIG3_TBMS). Your
>>> opinion, Dave?
>>
>> As seems to be agreed upon here, the SCSI2 bit in the CONFIG2 register
>> (ESP_CONFIG2_SCSI2ENAB) is only for when the chip is used in target
>> mode.  So it is not relevant for our discussion because this driver is
>> for initiator mode operation only.
>
> Agreed. ESP_CONFIG2_SCSI2ENAB might do more than we intend, and have 
> unintended side effects. It's just easier to test whether this fixes 
> our problem.
>
>>
>> But some pieces of documentation seem like they might not agree on
>> this point.
>>
>> With respect to bit 3 in the config3 register, it can take on one of
>> two meaning depending upon chip revision.  As per ESP_CONFIG3_{TMS,FCLK}
>> it either controls fast SCSI clocking, or it enabled 3 byte message
>> recognition.
>>
>> But oddly in the NCR53CX docs:
>>
>>     http://www.ibiblio.org/pub/historic-linux/early-ports/Sparc/NCR/NCR53C9X.txt 
>>
>>
>> it speaks as if ESP_CONFIG3_TMS and ESP_CONFIG3_TENB are merely finer
>> grained versions of config2 register setting ESP_CONFIG2_SCSI2ENAB,
>> which enables both features.
>
> That's what I understood from the bits Kars quoted, yes. And in the 
> Amiga driver cases, it will always be the 3 byte message feature 
> controlled by that bit, as far as I can see.
>
>>
>> Again I looked at the FreeBSD driver and for all chips after plain
>> esp100, they set ESP_CONFIG2_SCSI2ENAB.
>>
>> Can we try testing the following patch?
>
> That would be even easier than setting it explicitly in the Zorro 
> driver, thanks,
>
>     Michael
>
>
>>
>> ====================
>> esp_scsi: Set SCSI2 bit in config2 register.
>>
>> This should allow proper recognition of 3 byte reselection
>> on all esp100a and later chips.
>>
>> Reported-by: Kars de Jong <jongk@linux-m68k.org>
>> Reported-by: Michael Schmitz <schmitzmic@gmail.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
>> index 55548dc..16f69e0 100644
>> --- a/drivers/scsi/esp_scsi.c
>> +++ b/drivers/scsi/esp_scsi.c
>> @@ -2160,7 +2160,7 @@ static void esp_get_revision(struct esp *esp)
>>           */
>>          esp->rev = ESP100;
>>      } else {
>> -        esp->config2 = 0;
>> +        esp->config2 = ESP_CONFIG2_SCSI2ENAB;
>>          esp_set_all_config3(esp, 5);
>>          esp->prev_cfg3 = 5;
>>          esp_write8(esp->config2, ESP_CFG2);
>> @@ -2187,8 +2187,6 @@ static void esp_get_revision(struct esp *esp)
>>              } else {
>>                  esp->rev = ESP236;
>>              }
>> -            esp->config2 = 0;
>> -            esp_write8(esp->config2, ESP_CFG2);
>>          }
>>      }
>>  }
>
Hello,

The patch above doesn't work. I've attached a log. Looks like the same 
problem we've had all along.
The gzipped logs have all esp_scsi debug messages enabled for a 
non-patched and patched versions.

-Tuomas

--------------020200090900090108050507
Content-Type: text/plain; charset="UTF-8"; name="0005_zorroesp.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="0005_zorroesp.txt"

modprobe zorro_esp
zorro_esp: Blizzard 1230 found at address 0xea0000.
esp: esp0, regs[80ea8000:80eb0000] irq[2]
esp: esp0 is a FAS236, 40 MHz (ccf=0), SCSI ID 7
scsi0 : esp
scsi 0:0:2:0: Direct-Access     SEAGATE  ST51080N         0913 PQ: 0 ANSI: 2
scsi target0:0:2: Beginning Domain Validation
scsi target0:0:2: FAST-10 SCSI 10.0 MB/s ST (100 ns, offset 15)
scsi target0:0:2: Domain Validation skipping write tests
scsi target0:0:2: Ending Domain Validation
sd 0:0:2:0: [sda] 2109840 512-byte logical blocks: (1.08 GB/1.00 GiB)
sd 0:0:2:0: [sda] Write Protect is off
sd 0:0:2:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:2:0: Attached scsi generic sg0 type 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
Dev sda: unable to read RDB block 0
 sda: unable to read partition table
sd 0:0:2:0: [sda] Attached SCSI disk
root@amiga:~# esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 00 00 00 08 00
end_request: I/O error, dev sda, sector 2109696
Buffer I/O error on device sda, logical block 263712
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 00 00 00 08 00
end_request: I/O error, dev sda, sector 2109696
Buffer I/O error on device sda, logical block 263712
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 80 00 00 08 00
end_request: I/O error, dev sda, sector 2109824
Buffer I/O error on device sda, logical block 263728
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 80 00 00 08 00
end_request: I/O error, dev sda, sector 2109824
Buffer I/O error on device sda, logical block 263728
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
end_request: I/O error, dev sda, sector 8
Buffer I/O error on device sda, logical block 1
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
end_request: I/O error, dev sda, sector 2109832
Buffer I/O error on device sda, logical block 263729
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 50 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 80 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 20 31 88 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 08 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
blk_update_request: 24 callbacks suppressed
end_request: I/O error, dev sda, sector 0
quiet_error: 24 callbacks suppressed
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 78 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 10 00 00 08 00
blk_update_request: 32 callbacks suppressed
end_request: I/O error, dev sda, sector 16
quiet_error: 32 callbacks suppressed
Buffer I/O error on device sda, logical block 2
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 16
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 16
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 16
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 10 00 00 08 00
end_request: I/O error, dev sda, sector 16
Buffer I/O error on device sda, logical block 2
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 16
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
end_request: I/O error, dev sda, sector 64
Buffer I/O error on device sda, logical block 8
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
end_request: I/O error, dev sda, sector 64
Buffer I/O error on device sda, logical block 8
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
end_request: I/O error, dev sda, sector 64
Buffer I/O error on device sda, logical block 8
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
end_request: I/O error, dev sda, sector 64
Buffer I/O error on device sda, logical block 8
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 40 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 01 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 10 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 10 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 10 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
blk_update_request: 32 callbacks suppressed
end_request: I/O error, dev sda, sector 0
quiet_error: 32 callbacks suppressed
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 08 00 00 08 00
end_request: I/O error, dev sda, sector 8
Buffer I/O error on device sda, logical block 1
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 80 00 00 08 00
end_request: I/O error, dev sda, sector 128
Buffer I/O error on device sda, logical block 16
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
end_request: I/O error, dev sda, sector 0
Buffer I/O error on device sda, logical block 0
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 10 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 18 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 38 00 00 08 00
esp: esp0: Reconnect IRQ2 timeout
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00
sd 0:0:2:0: [sda] Unhandled error code
sd 0:0:2:0: [sda]  
Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
sd 0:0:2:0: [sda] CDB: 
Read(10): 28 00 00 00 00 00 00 00 08 00

root@amiga:~# lsmod
Module                  Size  Used by
sg                     19108  0 
zorro_esp               3338  0 
esp_scsi               21298  1 zorro_esp
nfsd                   67490  0 
ipv6                  229989  24 
evdev                   8390  0 
root@amiga:~# 
--------------020200090900090108050507
Content-Type: application/gzip; name="0009_zorroesp_espscsi_patched.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0009_zorroesp_espscsi_patched.txt.gz"

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
--------------020200090900090108050507
Content-Type: application/gzip; name="0008_zorroesp_espscsi_no_patch.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="0008_zorroesp_espscsi_no_patch.txt.gz"

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
AgA=
--------------020200090900090108050507--
