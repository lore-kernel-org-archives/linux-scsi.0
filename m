From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: how to "decode" SG_IO: bad/missing sense data?
Date: Tue, 16 Jun 2015 13:24:23 +0200
Message-ID: <55800767.4080601@interlog.com>
References: <CAGnHSEkbmVnby-QRs56JRUWCXHYxNZ_jiuE7R4Uard59GOy=Yw@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CAGnHSEkbmVnby-QRs56JRUWCXHYxNZ_jiuE7R4Uard59GOy=Yw@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 15-06-16 01:05 PM, Tom Yan wrote:
> When I "ATA Secure Erase" a USB Flash Drive, I got:
>
> SG_IO: bad/missing sense data, sb[]:  f0 00 01 00 50 40 00 0a 00 00 00
> 00 00 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>
> While the erase seems to work without bricking the device (multiple
> trials with shred and hexdump), this message still bothers me a bit.
> So is there anyway I could "decode" it so that I can know what it
> actually means?

Hi,
Install the sg3_utils package then copy that hex sequence and place
it after the sg_decode_sense command. In this case:

$ sg_decode_sense f0 00 01 00 50 40 00 0a 00 00 00 00 00 1d 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00
  Fixed format, current;  Sense key: Recovered Error
  Additional sense: ATA pass through information available
   error=0x0, status=0x50, device=0x40, sector_count(7:0)=0x0
   extend=0, log_index=0x0, lba_high,mid,low(7:0)=0x0,0x0,0x0

So that ATA Secure Erase command is sending a SCSI error back
through the SAT mechanism. Check the SAT standard (at www.t10.org)
for details.

Doug Gilbert



