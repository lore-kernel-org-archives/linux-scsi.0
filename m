From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] use spi_transport_class for aic79xx
Date: Thu, 09 Jun 2005 09:11:42 -0400
Message-ID: <1118322702.5041.2.camel@mulgrave>
References: <42A7EAEA.3060302@suse.de> <42A7F5A7.5080401@pobox.com>
	 <42A7FD7A.1050105@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:46549 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262389AbVFINLy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jun 2005 09:11:54 -0400
In-Reply-To: <42A7FD7A.1050105@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-06-09 at 10:27 +0200, Hannes Reinecke wrote:
> Next step is to connect an U320 drive to check it works properly.

That's definitely a requirement.  The sole function of aic79xx over
aic7xxx is u320.  That being said, I have been covertly converting the
transport classes to cope with u320 DV.  I believe now it all works.
However, you need to plug in more transport parameters than you
currently have (even if a lot of them are read only).  You also need to
update the couplings for the period == 8 case (which is u32).

Let me post the patches I used to fusion as an RFC and you can examine
the variable setting routines to see how it's done 

And I have tested this one:

scsi5 : ioc1: LSI53C1030, FwRev=01032700h, Ports=1, MaxQ=255, IRQ=56
  Vendor: HP 36.4G  Model: ST336607LW        Rev: HPC3
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target5:0:1: Beginning Domain Validation
 target5:0:1: Ending Domain Validation
 target5:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS (6.25 ns, offset 127)

James


