From: "Quat Le" <Quat.Le@dothill.com>
Subject: RE: ATA Pass-Through support
Date: Wed, 7 Jun 2006 10:15:19 -0700
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85EEB6319@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from artecon.dothill.com ([155.254.128.254]:52884 "EHLO dothill.com")
	by vger.kernel.org with ESMTP id S932342AbWFGRPY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jun 2006 13:15:24 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug,
Thanks for the info. I thought LSI SAS HBA is not using libata.  What
SAS HBA were you using?

Best regards,
Quat Le

-----Original Message-----
From: Douglas Gilbert [mailto:dougg@torque.net] 
Sent: Saturday, June 03, 2006 12:32 PM
To: Quat Le
Cc: linux-scsi@vger.kernel.org
Subject: Re: ATA Pass-Through support

Quat Le wrote:
> Sorry if this is not the right place to ask this question.
> 
> I wrote some application code to send ATA Pass-Through SCSI commands
via
> SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I
got
> was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
> OPCODE's A1H and 85H. I tried some other SCSI commands and saw that
they
> were translated to ATA commands correctly. I am running Linux kernel
> 2.6.15 and am under the impression that it supports ATA Pass-Through.

Quat,
I just did some testing in lk 2.6.17-rc5 and the ATA
PASS THROUGH (16) SCSI command in libata (defined by SAT)
worked in my tests.

At http://www.torque.net/sg in the news sections the
sg3_utils-1.21 beta has in its examples subdirectory:
sg_sat_identify and sg_sat_chk_power. The latter one
is interesting because it needs to read back the sector
count register after the command is complete. That
involves decoding the extended ATA status return
(sense data) descriptor.

Doug Gilbert


