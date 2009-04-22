From: Mark Lord <lkml@rtr.ca>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Wed, 22 Apr 2009 09:09:09 -0400
Message-ID: <49EF16F5.5080909@rtr.ca>
References: <20090422090929.GA14928@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:33068 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752483AbZDVNJK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Apr 2009 09:09:10 -0400
In-Reply-To: <20090422090929.GA14928@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Jeff Garzik wrote:
> Currently, libata creates a Scsi_Host per port.  This was originally
> done to leverage SCSI's infrastructure to arbitrate among master/slave
> devices, but is not needed for most modern SATA controllers.   And I
> _think_ it is not needed for master/slave if done properly, either.
> 
> The patch below converts libata such that there is now a 1:1
> correspondence between struct Scsi_Host and struct ata_host.  ATA ports
> are represented as SCSI layer 'channels', which is more natural.
> 
> This patch is an experiment, and not meant for upstream anytime soon.
..

Could you perhaps explain how error handling would behave in this scheme?

Currently, one SATA port can have failures without any impact whatsoever
on concurrent operation of other ports, in part because each port is treated
as a completely independent SCSI host.

I wonder if that changes with the new (better) scheme proposed here?

