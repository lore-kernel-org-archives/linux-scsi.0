From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/4] scsi: 64-bit LUN support
Date: Mon, 25 Feb 2013 11:02:18 -0500
Message-ID: <512B8B0A.6080708@interlog.com>
References: <1361261883-41467-1-git-send-email-hare@suse.de>  <94D0CD8314A33A4D9D801C0FE68B402950D7A4E0@G9W0745.americas.hpqcorp.net> <1361464328.2389.65.camel@dabdike.int.hansenpartnership.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:49011 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721Ab3BYQCY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Feb 2013 11:02:24 -0500
In-Reply-To: <1361464328.2389.65.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jeremy Linton <jlinton@tributary.com>, Bart Van Assche <bvanassche@acm.org>

On 13-02-21 11:32 AM, James Bottomley wrote:
> On Thu, 2013-02-21 at 16:15 +0000, Elliott, Robert (Server Storage)
> wrote:
>> Regarding changes like this:
>> -			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%d] "
>> +			printk(MYIOC_s_NOTE_FMT "[%d:%d:%d:%llu] "
>>   			"FCP_ResponseInfo=%08xh\n", ioc->name,
>>   			sc->device->host->host_no, sc->device->channel,
>>   			sc->device->id, sc->device->lun,
>>
>> It might be preferable to print the LUN values in hex rather than
>> decimal, particularly if they are large values.  SAM-5 includes some
>> guidance for displaying LUNs, shown below.
>
> We can't really change from decimal to hex without causing confusion and
> possibly breaking ABIs.  All the existing SCSI references look like
> h:c:t:l and all expect l to be a simple decimal.  It's not just in the
> logs, we have active use of this form in all the /sys/class/scsi_*/
> directories and some tools may parse this value.
>
>> One important goal is to match the format, if any, that the user must
>> use in a configuration file or command line argument, so
>> cutting-and-pasting the LUN value works.  So, the answer might differ
>> for prints from different drivers.  If a driver expects decimal input
>> values, then print decimal.
>>
>> SAM-5 excerpt:
>> 4.7.2 Logical unit representation format
> [...]
>
> We're a bit bound by kernel convention here as well.  To retain
> compatibility with SPI and flat addressing schemes, we really need to
> show the 8 and 16 bit flat addresses as simple decimal numerics.
> However, we *might* be free to move to a more hierarchical scheme with
> the multi-level luns, since I don't think there's to many people who've
> got arrays that output them (yet).

For those of you that don't remember, back when the Linux
OS was born, a SCSI READ(6) command looked like this:

==============================================================================
   Bit|   7    |   6    |   5    |   4    |   3    |   2    |   1    |   0    |
Byte |        |        |        |        |        |        |        |        |
==============================================================================
  0   |                           Operation Code (08h)                        |
-----|-----------------------------------------------------------------------|
  1   | Logical Unit Number      | (MSB)                                      |
-----|------------------------------                                      ---|
  2   |                           Logical Block Address                       |
-----|---                                                                 ---|
  3   |                                                                 (LSB) |
-----|-----------------------------------------------------------------------|
  4   |                           Transfer Length                             |
-----|-----------------------------------------------------------------------|
  5   |                           Control                                     |
==============================================================================

Notice that 3 bit LUN field tucked into byte 1 of the cdb.
There may be still remnants of code in the Linux SCSI
subsystem to support that. Since then LUNs have grown to 16,
32 and now 64 bits. Will they keep expanding?
My point is that a T10 sanctioned LUN representation
can be a hard act for an OS to follow.

Fixing Linux's broken 32 bit "word-flipped" LUN
should be done as a matter of urgency, IMO. Here I am
referring to Hannes Reinecke patch:
    [PATCH 1/4] scsi_scan: Fixup scsilun_to_int()

Extending Linux's 32 bit word-flipped LUN to a 64 bit
word-flipped LUN seems like the least disruptive change
for the Linux user space. Existing small LUN formats
would continue to yield the same sysfs and bsg
file/directory names. And my lsscsi utility would
continue to work.

lsscsi will still need some work to support 64 bit
word-flipped LUNs. The simple one is to expand the LUN
decoding (currently expecting a 32 bit signed integer)
to accept uint64_t . Also I would like to add a
--lunhex option ('-x' as the more obvious short option
letters are already used) to show the LUN in hex along
the lines of what Robert Elliott (and SAM-5) propose.

As an example showing the REPORT LUNS well known LUNS
as a non-trivial LUN:

# lsscsi
[0:0:0:0]    disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda
[6:0:0:1]    disk    Linux    scsi_debug       0004  /dev/sdb
[6:0:0:49409]wlun    Linux    scsi_debug       0004  -

# lsscsi -x
[0:0:0:0x0000]              disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda
[6:0:0:0x0001]              disk    Linux    scsi_debug       0004  /dev/sdb
[6:0:0:0xc101]              wlun    Linux    scsi_debug       0004  -

# lsscsi -xx
[0:0:0:0x0000000000000000]  disk    ATA      INTEL SSDSC2CW12 400i  /dev/sda
[6:0:0:0x0001000000000000]  disk    Linux    scsi_debug       0004  /dev/sdb
[6:0:0:0xc101000000000000]  wlun    Linux    scsi_debug       0004  -


Also, given an hierarchical LUN like 02 3a 00 4b 00 00 00 00
the 'lsscsi -x' representation would be something like:
[6:0:0:0x023a_004b]

Doug Gilbert





