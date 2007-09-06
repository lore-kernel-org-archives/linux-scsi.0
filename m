From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Thu, 6 Sep 2007 06:06:02 -0400
Message-ID: <20070906100602.GA22773@havoc.gtf.org>
References: <1189031155.6108.8.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:36702 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754117AbXIFKGE (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Thu, 6 Sep 2007 06:06:04 -0400
Content-Disposition: inline
In-Reply-To: <1189031155.6108.8.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

On Wed, Sep 05, 2007 at 03:25:55PM -0700, Gilbert Wu wrote:
>    Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does not work on SATA device.
>    ( The smartctl v5.38 does need "-d ata" option.)
>    The root cause is the aic94xx driver does not return ATA output register due to performance reason.
>    The aic94xx need check ATA command which need ATA output register and turn on internal flag to
>    enable firmware to return ATA output register to top layer.
>    It also add new ATA commands to ata.h sush as ATA_CMD_CHK_MEDIA_TYPE and ATA_CMD_SMART.
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

All commands except for hot path READ/WRITE should be returning ATA
output registers.

Additionally, READ/WRITE should be returning ATA output registers,
if the READ/WRITE command did not succeed.

Any code that requires an "accepted list of commands" is problematic,
because it does not take into account vendor-specific commands.

	Jeff



