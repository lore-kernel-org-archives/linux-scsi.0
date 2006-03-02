From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ATA Pass-Through support
Date: Thu, 02 Mar 2006 10:46:05 -0500
Message-ID: <4407133D.1030308@torque.net>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E56911A@earthex2.power.com> <001c01c63dc0$a2f70270$271015ac@ericmoore>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:32953 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751554AbWCBPr2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Mar 2006 10:47:28 -0500
In-Reply-To: <001c01c63dc0$a2f70270$271015ac@ericmoore>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: Quat Le <Quat.Le@dothill.com>, linux-scsi@vger.kernel.org

Moore, Eric wrote:
> On Wednesday, March 01, 2006 4:51 PM,  Quat Le wrote:
> 
>> I cannot tell if the LSI SAS HBA driver uses libata or not. A week ago I
>> did send LSI tech support a question asking if the SCSI-to-ATA
>> Translation Layer is done in the HBA driver or in a different layer on
>> Linux.  So far I have not gotten any response.  That's a good idea to
>> try this on a SATA disk connected to a SATA HBA.  I will try this.
>>
> 
> No, the mptsas driver is not using libata, however we are using
> scsi_transport_sas.
> This is firmware assist implementation, meaning SCSI-to-ATA translation
> is done in firmware; via queue_command entry point, all commands to both
> SAS and SATA devices are sent via SCSI_IO passthru.   Is the SG_IO ATA
> passthru encapsalating an ATA command inside a SCSI CDB?  If so, I don't
> think the firmware folks have not implemented that yet.  When that is
> completed, I expect no change in driver, as its simply passthru, and the
> firmware will handle the request. There is an alternative, you can send
> an IOCTL=MPT_COMMAND IOCTL using the mptctl driver with the function set
> to MPI_FUNCTION_SATA_PASSTHROUGH.

Eric,
Ok, that is the definitive answer when the LSI SAS HBA
driver is in play. Perhaps you could refer the firmware
folks to the SCSI ATA Translation (SAT) draft at:
http://www.t10.org/ftp/t10/drafts/sat/sat-r08.pdf
which is currently in letter ballot at t10 (LSI voted
"no" but judging from their comments that will become
a yes).

You might also point out that SAT layers will
be (or maybe already are) inside FC enclosures that are
full of SATA disks. So applications like smartmontools
that know they are talking to a SATA device via SCSI
Block Commands (SBC) will expect to see those SCSI
ATA pass through commands working (no matter what the
"plumbing").

>> I thought support for those two opcodes went into libata
>> for lk 2.6.15 as well but haven't written discrete code
>> to test it. Does the lsi SAS HBA use libata on its STP
>> (or direct connect) path? Eyeballing the libata code,
>> those opcodes are used internally. I know that
>> "smartctl -a -d ata /dev/sda" works when /dev/sda is a
>> SATA disk using libata on a regular SATA HBA. At present I
>> do not have any hardware nearby to test it. If you can direct
>> connect a SATA disk to a SATA controller on your motherboard
>> (i.e. bypassing the SAS HBA) does that make any difference?
>>
> 
> What is smartctl?  Is that part of Doug's sg_tools, or something else.

smartctl is part of smartmontools. It fetches SMART
information from storage devices. See:
http://smartmontools.sourceforge.net
Bruce Allen is the chief maintainer (and Andre Hedrick should
also get a mention for the earlier smartsuite).

Doug Gilbert
