From: "Quat Le" <Quat.Le@dothill.com>
Subject: RE: ATA Pass-Through support
Date: Wed, 1 Mar 2006 15:51:05 -0800
Message-ID: <DF9C50EF9E8CDA45A06FE8735C68F85E56911A@earthex2.power.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 17.129.dothill.com ([155.254.129.17]:65497 "EHLO
	earthex1.dothill.com") by vger.kernel.org with ESMTP
	id S1750759AbWCAXvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 18:51:08 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Doug,

I cannot tell if the LSI SAS HBA driver uses libata or not. A week ago I
did send LSI tech support a question asking if the SCSI-to-ATA
Translation Layer is done in the HBA driver or in a different layer on
Linux.  So far I have not gotten any response.  That's a good idea to
try this on a SATA disk connected to a SATA HBA.  I will try this.

Best regards,
Quat Le

-----Original Message-----
From: Douglas Gilbert [mailto:dougg@torque.net] 
Sent: Wednesday, March 01, 2006 3:31 PM
To: Quat Le
Cc: linux-scsi@vger.kernel.org
Subject: Re: ATA Pass-Through support

Quat Le wrote:
> Sorry if this is not the right place to ask this question.

This is the right place to ask.

> I wrote some application code to send ATA Pass-Through SCSI commands
via
> SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I
got
> was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
> OPCODE's A1H and 85H. I tried some other SCSI commands and saw that
they
> were translated to ATA commands correctly. I am running Linux kernel
> 2.6.15 and am under the impression that it supports ATA Pass-Through.

I thought support for those two opcodes went into libata
for lk 2.6.15 as well but haven't written discrete code
to test it. Does the lsi SAS HBA use libata on its STP
(or direct connect) path? Eyeballing the libata code,
those opcodes are used internally. I know that
"smartctl -a -d ata /dev/sda" works when /dev/sda is a
SATA disk using libata on a regular SATA HBA. At present I
do not have any hardware nearby to test it. If you can direct
connect a SATA disk to a SATA controller on your motherboard
(i.e. bypassing the SAS HBA) does that make any difference?

Doug Gilbert
