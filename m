From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Announce] sg3_utils-1.14 available
Date: Sat, 07 May 2005 10:49:52 +1000
Message-ID: <427C10B0.2000008@torque.net>
References: <66F9227F7417874C8DB3CEB05772741712AC33@MILEX0.Miltope.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:62419 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261417AbVEGAxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2005 20:53:15 -0400
In-Reply-To: <66F9227F7417874C8DB3CEB05772741712AC33@MILEX0.Miltope.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Drew Winstel <DWinstel@Miltope.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Drew Winstel wrote:
> Hello,
> 
> 
>>This version adds sg_rmsn to read media serial number(s).
> 
> 
> It appears that this doesn't quite work as I had hoped.
> 
> Ideally, should it not work upon every drive in which sq_inq reads the serial 
> number?

Drew,
No. sg_rmsn issues a READ MEDIA SERIAL NUMBER SCSI command.
This command (opcode 0xab, service action 1) was added in
SPC-3 revision 11 (12th February 2003) and is not marked as
mandatory. If supported, this command yields a "free format"
media serial number. I have not seen any SCSI device that
supports it (but being in SPC-3 all device types, especially
those with removable media, could support it).

On the other hand the SCSI INQUIRY command is mandatory for
all SCSI devices. Further, recent SPC-3 drafts have made
support for the Device Identification VPD page (0x83)
mandatory. The information in the Device Identification
VPD page is much more structured, supporting multiple
descriptors that indicate _what_ is being identified:
   - target port, or
   - target device, or
   - logical unit
with various types of identifiers supported:
   - EUI-64 based
   - naa
   - SCSI name string (UTF-8 strings used by iSCSI)
   - T10 identifiers
   - vendor

For devices with non removable media, the logical unit
identifier could be viewed as a media serial number.
There seems to be a move away from free format, vendor
specific serial numbers (as provided by the Unit
Serial Number VPD page (0x80)).


Looking for other SCSI command standards that mention
"media serial number" doesn't turn up much. MMC-4
has its "features and profiles", one of which is the
media serial number feature (0x109). These can viewed
with the sg_get_config utility in sg3_utils.

I have updated the sg_rmsn man page to reflect some of
the information above.

Doug Gilbert
