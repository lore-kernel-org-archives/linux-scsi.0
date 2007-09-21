From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 21 Sep 2007 16:05:11 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20EA@aime2k302.adaptec.com>
References: <1190407202.3333.55.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:46497 "HELO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763134AbXIUXFM convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-scsi@vger.kernel.org>); Fri, 21 Sep 2007 19:05:12 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1190407202.3333.55.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: dougg@torque.net, Linux-scsi@vger.kernel.org

Hi James,

   We want to find the root cause and make sure this problem will happen
on STA device certain commands. If it does not affect SATA device then
we can adopt the workaround.

Thanks!
Gilbert

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Friday, September 21, 2007 1:40 PM
To: Wu, Gilbert
Cc: dougg@torque.net; Linux-scsi@vger.kernel.org
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem

On Fri, 2007-09-21 at 11:53 -0700, Wu, Gilbert wrote:
>    I can reproduce the problem on my machine. Most likely, the
Sequencer
> (Firmware) has bug on handling ATA output register for ATAPI device. I
> am still working on this issue with Sequencer engineer.

But, since you already vet the commands we can simply work around this
by not asking for the ATA output register on packet commands (i.e. just
add ATA_CMD_PACKET to the is_ata_rw_command() switch statement.

James


