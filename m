From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sct erc does not work with megaraid
Date: Tue, 15 Feb 2011 12:17:14 -0500
Message-ID: <4D5AB51A.2010002@interlog.com>
References: <4D5A5388.3010208@ngs.ru> <4D5A9FE9.9020409@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4D5A9FE9.9020409@interlog.com>
Sender: linux-ide-owner@vger.kernel.org
To: Artem Bokhan <aptem@ngs.ru>
Cc: linux-scsi@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 11-02-15 10:46 AM, Douglas Gilbert wrote:
> On 11-02-15 05:20 AM, Artem Bokhan wrote:
>> Hello!
>>
>> I'm trying to get/set sctserc (SMART Command Transport Error Recovery Control)
>> data from sata disk attached to lsi megaraid controller with smartmontools, but
>> this function does not work.
>>
>> I want to figure out: is this driver or firmware issue? May someone to help to
>> fix this?
>>
>> The issue can be described as follows:
>>
>> The ATA PASS-THROUGH(16) implementation in the SAT layer of the megaraid driver
>> or firmware does not return the ATA output registers if requested. This violates
>> SAT standard (http://www.t10.org/drafts.htm#SAT).
>>
>> Expected: If CK_COND (bit 5 of CDB[2]) is set, ATA PASS-THROUGH(16) (CDB[0] =
>> 0x85) shall return a CHECK CONDITION even if the ATA command completed
>> successfully, and return the ATA output registers in the sense data using ATA
>> return descriptor format (descriptor code 0x09).
>>
>> Observed: If CK_COND is set and the ATA command completed successfully, ATA
>> PASS-THROUGH(16) does not return a CHECK CONDITION or the sense data does not
>> contain an ATA return descriptor.
>>
>> See also the smartmontools SAT implementation
>> (http://sourceforge.net/apps/trac/smartmontools/browser/trunk/smartmontools/scsiata.cpp?rev=3258#L146)
>>
>> for further info.
>
> That code looked familiar but I'm not sure what your
> point was referring to it. Anyway ...
>
> Haven't worked much with Megaraid controllers but mptsas
> controllers implement SAT (or at least did) in their
> firmware. So upgrading the firmware on the controller fixed
> the problems I had (some years back) with SAT compliance.

Just doing some tests comparing SAT compliance in libata
and a LSI SAS 9212-4i4e controller with the latest firmware.
I would expect a Megaraid controller with recent firmware to
behave in the same way as a the 9212 (mpt2sas driver).

The test is to send an ATA IDENTIFY DEVICE command through the
SCSI ATA PASS-THROUGH (16) command with the CK_COND bit set:

First libata:

# sg_sat_identify --ck_cond /dev/sg1 -vvv
open /dev/sg1 with flags=0x802
     ATA pass through (16) cdb: 85 08 2e 00 00 00 01 00 00 00 00 00 00 00 ec 00
       duration=1 ms
ATA pass through:  Descriptor format, current;  Sense key: No Sense
  Additional sense: No additional sense information
   Descriptor type: ATA Status Return
     extend=0  error=0x0  sector_count=0x1
     lba=0x000000
     device=0x0  status=0x50
  Raw sense data (in hex):
         72 00 00 00 00 00 00 0e  09 0c 00 00 00 01 00 00
         00 00 00 00 00 50 00 00  00 00 00 00 00 00 00 00
         00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
Seem to have got ATA Result Descriptor but it was not indicated
#

So libata is broken in its SAT compliance in lk 2.6.37 .


And this is what should happen (SATA disk connected to a
SAS 9212-4i4e controller):

# sg_sat_identify --ck_cond /dev/sg4 -vvv
open /dev/sg4 with flags=0x802
     ATA pass through (16) cdb: 85 08 2e 00 00 00 01 00 00 00 00 00 00 00 ec 00
       duration=2 ms
ATA pass through:  Descriptor format, current;  Sense key: Recovered Error
  Additional sense: ATA pass through information available
   Descriptor type: ATA Status Return
     extend=0  error=0x0  sector_count=0x0
     lba=0x000000
     device=0x0  status=0x50
  Raw sense data (in hex):
         72 01 00 1d 00 00 00 0e  09 0c 00 00 00 00 00 00
         00 00 00 00 00 50 00 00  00 00 00 00 00 00 00 00
         00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
         00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
Response for IDENTIFY DEVICE ATA command:
  00     0c5a 3fff c837 0010 0000 0000 003f 0000     .Z ?. .7 .. .. .. .? ..
  08     0000 0000 2020 2020 2020 2020 2020 2020     .. ..
.....


The sense key of Recovered Error is correct for no error
to report (as per SAT and SAT-2 standards) and of course
the response to the IDENTIFY DEVICE should be forwarded
(libata doesn't do that either).

Doug Gilbert

