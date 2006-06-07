From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ATA Pass-Through support
Date: Wed, 07 Jun 2006 14:22:12 -0400
Message-ID: <44871954.8060701@torque.net>
References: <DF9C50EF9E8CDA45A06FE8735C68F85EEB6319@earthex2.power.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:63708 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751203AbWFGSWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jun 2006 14:22:21 -0400
In-Reply-To: <DF9C50EF9E8CDA45A06FE8735C68F85EEB6319@earthex2.power.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>
Cc: linux-scsi@vger.kernel.org

Quat Le wrote:
> Doug,
> Thanks for the info. I thought LSI SAS HBA is not using libata.  What
> SAS HBA were you using?

The interesting part of libata for this discussion is
its SCSI to ATA Translation Layer (SATL). Since about
lk 2.6.15 it has implemented the ATA PASS THROUGH SCSI
commands (see sat-r08.pdf at www.t10.org).

My example code only assumed a SCSI pass through
(SG_IO in this case) and a SATL ** that implements
the ATA PASS THROUGH SCSI commands. The MPT Fusion SAS
HBAs have their own SATL (not libata based) but unfortunately
don't implement the ATA pass through commands. My information
is that they will in the future. They do have a proprietary
ATA command passthrough.

I also use an adaptec 48300 SAS HBA. There are several Linux
drivers for the the 94xx chipset inside the 48300. At least
one supports a working SATL with an ATA pass through.
Others may follow soon (or my information may be a little
out of date).


** the SATL doesn't have to be in the OS proper (like libata),
   it could be in the HBA firmware, a FC switch or even on
   the device. Some aspects of a SATL are transport dependent
   so there may be advantages of having it somewhere other than
   in libata.

Doug Gilbert

> Best regards,
> Quat Le
> 
> -----Original Message-----
> From: Douglas Gilbert [mailto:dougg@torque.net] 
> Sent: Saturday, June 03, 2006 12:32 PM
> To: Quat Le
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: ATA Pass-Through support
> 
> Quat Le wrote:
> 
>>Sorry if this is not the right place to ask this question.
>>
>>I wrote some application code to send ATA Pass-Through SCSI commands
> 
> via
> 
>>SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I
> 
> got
> 
>>was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
>>OPCODE's A1H and 85H. I tried some other SCSI commands and saw that
> 
> they
> 
>>were translated to ATA commands correctly. I am running Linux kernel
>>2.6.15 and am under the impression that it supports ATA Pass-Through.
> 
> 
> Quat,
> I just did some testing in lk 2.6.17-rc5 and the ATA
> PASS THROUGH (16) SCSI command in libata (defined by SAT)
> worked in my tests.
> 
> At http://www.torque.net/sg in the news sections the
> sg3_utils-1.21 beta has in its examples subdirectory:
> sg_sat_identify and sg_sat_chk_power. The latter one
> is interesting because it needs to read back the sector
> count register after the command is complete. That
> involves decoding the extended ATA status return
> (sense data) descriptor.
> 
> Doug Gilbert
> 
> 

