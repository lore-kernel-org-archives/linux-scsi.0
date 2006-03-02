From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: Re: ATA Pass-Through support
Date: Wed, 1 Mar 2006 23:14:58 -0700
Message-ID: <001c01c63dc0$a2f70270$271015ac@ericmoore>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E56911A@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:19650 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751400AbWCBGY6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2006 01:24:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>, dougg@torque.net
Cc: linux-scsi@vger.kernel.org

On Wednesday, March 01, 2006 4:51 PM,  Quat Le wrote:

> I cannot tell if the LSI SAS HBA driver uses libata or not. A week ago I
> did send LSI tech support a question asking if the SCSI-to-ATA
> Translation Layer is done in the HBA driver or in a different layer on
> Linux.  So far I have not gotten any response.  That's a good idea to
> try this on a SATA disk connected to a SATA HBA.  I will try this.
> 

No, the mptsas driver is not using libata, however we are using
scsi_transport_sas.
This is firmware assist implementation, meaning SCSI-to-ATA translation
is done in firmware; via queue_command entry point, all commands 
to both SAS and SATA devices are sent via SCSI_IO passthru.   Is the SG_IO 
ATA passthru encapsalating an ATA command inside a SCSI CDB?  
If so, I don't think the firmware folks have not implemented that yet.  
When that is completed, I expect no change in driver, as its simply 
passthru, and the firmware will handle the request. There is an alternative, 
you can send an IOCTL=MPT_COMMAND IOCTL using 
the mptctl driver with the function set to 
MPI_FUNCTION_SATA_PASSTHROUGH.


> I thought support for those two opcodes went into libata
> for lk 2.6.15 as well but haven't written discrete code
> to test it. Does the lsi SAS HBA use libata on its STP
> (or direct connect) path? Eyeballing the libata code,
> those opcodes are used internally. I know that
> "smartctl -a -d ata /dev/sda" works when /dev/sda is a
> SATA disk using libata on a regular SATA HBA. At present I
> do not have any hardware nearby to test it. If you can direct
> connect a SATA disk to a SATA controller on your motherboard
> (i.e. bypassing the SAS HBA) does that make any difference?
> 

What is smartctl?  Is that part of Doug's sg_tools, or something else.

Eric Moore
LSI Logic

