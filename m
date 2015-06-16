From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: how to "decode" SG_IO: bad/missing sense data?
Date: Tue, 16 Jun 2015 23:58:39 +0800
Message-ID: <CAGnHSEnqPFyfZxg6-CXxhUHAg=TcNy7qxjbPaSV1qJaGsSOPew@mail.gmail.com>
References: <CAGnHSEkbmVnby-QRs56JRUWCXHYxNZ_jiuE7R4Uard59GOy=Yw@mail.gmail.com>
	<55800767.4080601@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <55800767.4080601@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I knew both sg_decode_sense and the SAT spec, but I didn't think of
using them together to decode this. (Didn't bother to download the
spec as well because it requires a bit of "registration" :P) Thanks
for the pointer.

According to the latest draft, if "CK_COND" is set to 1, the sense
data returned will be:

"No error, successful completion or command in progress. The SATL shall
terminate the command with CHECK CONDITION status with the sense key
set to RECOVERED ERROR with the additional sense code set to ATA
PASS-THROUGH INFORMATION AVAILABLE (see SPC-4)."

though I do not find anything useful to further decode the additional
fields like "status=0x50". (Some google results did tell me that 50
means success.)

The man page of sg_sat_identify also mentioned a bit about it:

       -c, --ck_cond
              sets  the CK_COND bit in the ATA PASS-THROUGH SCSI cdb.
The default setting is clear (i.e. 0). When set the SATL should yield
a sense buffer containing a ATA Result descriptor irrespective of
              whether the command succeeded or failed. When clear the
SATL should only yield a sense buffer containing a ATA Result
descriptor if the command failed.

When I run `sg_sat_identify` with `-c` to my different drives, the
drive which makes hdparm gives the SG_IO error seems to be the only
one actually respond to the "CK_COND" bit:

[tom@localhost ~]$ sudo sg_sat_identify -c /dev/sdb
expected descriptor sense format, response code=0xf0

others simply reacts as if the bit is not set.

Anyway the SG_IO error is given by hdparm, so I guess I should talk to
the hdparm guys now.

On 16 June 2015 at 19:24, Douglas Gilbert <dgilbert@interlog.com> wrote:
> On 15-06-16 01:05 PM, Tom Yan wrote:
>>
>> When I "ATA Secure Erase" a USB Flash Drive, I got:
>>
>> SG_IO: bad/missing sense data, sb[]:  f0 00 01 00 50 40 00 0a 00 00 00
>> 00 00 1d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>
>> While the erase seems to work without bricking the device (multiple
>> trials with shred and hexdump), this message still bothers me a bit.
>> So is there anyway I could "decode" it so that I can know what it
>> actually means?
>
>
> Hi,
> Install the sg3_utils package then copy that hex sequence and place
> it after the sg_decode_sense command. In this case:
>
> $ sg_decode_sense f0 00 01 00 50 40 00 0a 00 00 00 00 00 1d 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00 00
>  Fixed format, current;  Sense key: Recovered Error
>  Additional sense: ATA pass through information available
>   error=0x0, status=0x50, device=0x40, sector_count(7:0)=0x0
>   extend=0, log_index=0x0, lba_high,mid,low(7:0)=0x0,0x0,0x0
>
> So that ATA Secure Erase command is sending a SCSI error back
> through the SAT mechanism. Check the SAT standard (at www.t10.org)
> for details.
>
> Doug Gilbert
>
>
>
