From: Douglas Gilbert <dougg@torque.net>
Subject: Re: /dev/disk/by-id incomplete and unhelpful for SATA drives
Date: Fri, 06 Jan 2006 12:57:50 +1000
Message-ID: <43BDDCAE.7000506@torque.net>
References: <doc5jl$acv$1@sea.gmane.org> <20051221185518.GA9100@vrfy.org> <43A9CFE0.2070103@edesix.com> <20051222043527.GA13175@vrfy.org> <43AA8D0B.10504@edesix.com> <20051222183525.GA17871@devserv.devel.redhat.com> <43AB40E2.1050009@edesix.com> <20060106013640.GA27841@aracnet.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:5352 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S932610AbWAFC5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jan 2006 21:57:34 -0500
In-Reply-To: <20060106013640.GA27841@aracnet.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: patman@aracnet.com
Cc: Chris Paulson-Ellis <chris@edesix.com>, Bill Nottingham <notting@redhat.com>, linux-hotplug-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

patman@aracnet.com wrote:
> On Fri, Dec 23, 2005 at 12:12:18AM +0000, Chris Paulson-Ellis wrote:
> 
> 
>>>Why not just fix the kernel when it's filling in the page 83
>>>data to pull the serial from page 80 instead of putting *that* there?
>>>
>>>Bill
>>
>>Indeed. Here's the patch. Now I have 3 ways to fix this. Any more anyone?
> 
> 
> This is the best approach, I think you could even remove page 0x83 support
> and still be SCSI compliant.

Pat,
Not since 2000/2001 ... The VPD device identification page
(0x83) and the "Supported VPD pages" page (0x0) are
mandatory in SPC-2 (ANSI INCITS 351-2001), SPC-3 (soon
to be a standard) and SPC-4. Recent SCSI to ATA
Translation drafts (e.g. sat-r07a.pdf) define a mapping
for the naa-5 identifier defined in ATA/ATAPI-7 and
ATA/ATAPI-8 (IDENTIFY DEVICE response words 108 to 111)
to VPD page 0x83. There are also moves afoot to get a
similar wwn identifier into the IDENTIFY PACKET DEVICE
response.

SAT defines two device id descriptors for VPD page 0x83:
  - based on WWN naa-5 (described above)
  - based on model number and serial number (IDENTIFY
    DEVICE response words 27-46 and 10-19)

So removing VPD page 0x83 would be a retrograde step
IMO. The libata implementation should be enhanced to
support one or both of the above descriptors as they
have a defined format (unlike serial number VPD page (0x80)).
libata's current approach to yield "Linux ATA-SCSI simulator"
for the loosely formatted ASCII identification descriptor
is just a place holder.

libata should do a lot more work in the VPD 0x83 page
area. For example when SATA disk is connected via SAS
(behind an expander rather that directly connected)
then a "device port" association descriptor should have
the SAS address (also naa-5) of the SATA bridge (in the
expander).

libata is not the only way that the SCSI subsystem
will be seeing SATA disks. There are FC exclosures
out there filled with SATA disks that have a SAT
layer in the enclosure.


Doug Gilbert
cc-ed to linux-ide
