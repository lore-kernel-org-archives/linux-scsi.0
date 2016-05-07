From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/3] libata-scsi: Fix SCSI INQUIRY version descriptor
Date: Sat, 7 May 2016 17:19:35 +0800
Message-ID: <CAGnHSEn+UdzR8sgceCybqHF41n1wHpVSsmdWnC4AuqWLZ1sWcA@mail.gmail.com>
References: <5727b4ec.c923620a.641f4.17aa@mx.google.com>
	<5728EBAE.2080200@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:35993 "EHLO
	mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbcEGJTh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 7 May 2016 05:19:37 -0400
In-Reply-To: <5728EBAE.2080200@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: tj@kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, hare@suse.de

FWIW, the version descriptors you suggested (and the "compatibility
version") is updated for ZAC drives in:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/ata/libata-scsi.c?id=f9ca5ab832e7ac5bc2b6fe0e82ad46d536f436f9
I have no idea why the versions for other devices are held back.

Certainly it seems right to have them updated as well. But my goal was
just to fix the typo, at least.

Not sure about the SAT version descriptor. FYR I have a few SATA/UASP
adapters (from ASMedia and JMicron), they only have the SPC-4, SBC-3
and UAS descriptor, but not a SAT one.
However unlike libata, neither of them have the "ai" VPD:
[tom@localhost ~]$ sudo sg_vpd -p ai /dev/sda
ATA information VPD page:
  SAT Vendor identification: linux
  SAT Product identification: libata
  SAT Product revision level: 3.00
  Device signature indicates SATA transport
  ATA command IDENTIFY DEVICE response summary:
    model: INTEL SSDSC2BW240A4
    serial number: CVDA339603M02403GN
    firmware revision: DC32

On 4 May 2016 at 02:19, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 2016-05-02 04:13 PM, tom.ty89@gmail.com wrote:
>>
>> From: Tom Yan <tom.ty89@gmail.com>
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=106931
>> Signed-off-by: Tom Yan <tom.ty89@gmail.com>
>>
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index cd30f11..0295c38 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
>> @@ -1985,8 +1985,8 @@ static unsigned int ata_scsiop_inq_std(struct
>> ata_scsi_args *args, u8 *rbuf)
>>                 0x03,
>>                 0x20,   /* SBC-2 (no version claimed) */
>>
>> -               0x02,
>> -               0x60    /* SPC-3 (no version claimed) */
>> +               0x03,
>> +               0x00    /* SPC-3 (no version claimed) */
>>         };
>>         const u8 versions_zbc[] = {
>>                 0x00,
>>
>
> SPC-3 was standardized in 2005 (ANSI INCITS 408-2005) and there
> is a more recent standard: SPC-4 (ANSI INCITS 513-2015). And
> my guess is that libata-scsi supports many things introduced
> in SPC-4 . If you switch to SPC-4 then the "version" field in
> the standard INQUIRY response (byte 2) should be changed to 6.
>
> Also SBC-2 is old (ANSI INCITS 405-2005) and should be updated
> to SBC-3 (ANSI INCITS 514-2014). Again many features supported
> by libata-scsi didn't exist in SBC-2.
>
> And libata-scsi is a SCSI to ATA Translation (SAT) layer and
> there are standards for that, take your pick: SAT (ANSI INCITS
> 431-2007), SAT-2 (ANSI INCITS 465-2010) or SAT-3 (ANSI INCITS
> 517-2015).
>
>
> Suggestion:
>   Version descriptors             value
> ----------------------------------------
>     SAM-5 (no version claimed)    0x00a0
>     SPC-4 (no version claimed)    0x0460
>     SBC-3 (no version claimed)    0x04c0
>     SAT-3 (no version claimed)    0x1ee0
>
> Plus byte 2 of INQUIRY response: 0x6
>
> Doug Gilbert
>
>
> BTW in lk 4.6.0-rc5 I see this for a directly connected SATA SSD:
>
> # sg_inq -d /dev/sg0
> standard INQUIRY:
>   PQual=0  Device_type=0  RMB=0  LU_CONG=0  version=0x05  [SPC-3]
>   [AERC=0]  [TrmTsk=0]  NormACA=0  HiSUP=0  Resp_data_format=2
>   SCCS=0  ACC=0  TPGS=0  3PC=0  Protect=0  [BQue=0]
>   EncServ=0  MultiP=0  [MChngr=0]  [ACKREQQ=0]  Addr16=0
>   [RelAdr=0]  WBus16=0  Sync=0  [Linked=0]  [TranDis=0]  CmdQue=0
>   [SPI: Clocking=0x0  QAS=0  IUS=0]
>     length=96 (0x60)   Peripheral device type: disk
>  Vendor identification: ATA
>  Product identification: INTEL SSDSC2BW18
>  Product revision level: DC32
>  Unit serial number:
>
>   Version descriptors:
>     SAM-3 (no version claimed)
>     SBC-2 (no version claimed)
>     SPC-2 (no version claimed)
>
>
