From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ATA Pass-Through support
Date: Sat, 03 Jun 2006 15:32:13 -0400
Message-ID: <4481E3BD.9090006@torque.net>
References: <DF9C50EF9E8CDA45A06FE8735C68F85E568F0D@earthex2.power.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36755 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751793AbWFCTcP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Jun 2006 15:32:15 -0400
In-Reply-To: <DF9C50EF9E8CDA45A06FE8735C68F85E568F0D@earthex2.power.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quat Le <Quat.Le@dothill.com>
Cc: linux-scsi@vger.kernel.org

Quat Le wrote:
> Sorry if this is not the right place to ask this question.
> 
> I wrote some application code to send ATA Pass-Through SCSI commands via
> SG_IO ioctl to SATA drives connected to a LSI Logic SAS HBA. What I got
> was ILLEGAL REQUEST (INVALID COMAND OPERATION CODE) for both SCSI
> OPCODE's A1H and 85H. I tried some other SCSI commands and saw that they
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


