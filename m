From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 14 Sep 2007 14:14:46 -0400
Message-ID: <46EACF96.7010501@garzik.org>
References: <1189792710.6030.3.camel@linux.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:60437 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756602AbXINSOs (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2007 14:14:48 -0400
In-Reply-To: <1189792710.6030.3.camel@linux.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gilbert Wu <Gilbert_Wu@adaptec.com>
Cc: Linux-scsi@vger.kernel.org

Gilbert Wu wrote:
> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> option.)
>   The aic94xx need to return ATA output register for all ATA commands
> except ATA Read/Write commands.
>   The aic94xx also mark out the DRQ bit from status register which is
> treated as AC_ERR_HSM (host state machine violation) error by top layer
> if it set to one.
>  The firmware of aic94xx chip handle all ATA handshaking, data transfer
> and return ATA output register which is sent by the device.  So the DRQ
> bit may not reflect the last state of device when the command finished
> and it is no meaning for the caller.
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

ACK


