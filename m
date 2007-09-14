From: "Wu, Gilbert" <Gilbert_Wu@adaptec.com>
Subject: RE: [PATCH] aic94xx: fix smartctl utility problem
Date: Fri, 14 Sep 2007 10:30:23 -0700
Message-ID: <BC382691D59EC94C8E57543C47EF8ED55B20DD@aime2k302.adaptec.com>
References: <46EAC446.7010509@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:53445 "HELO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751896AbXINRaZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Sep 2007 13:30:25 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46EAC446.7010509@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

HI Jeff,
  
Oops! I missed that one and will resend again.

Thanks!
Gilbert

-----Original Message-----
From: Jeff Garzik [mailto:jeff@garzik.org] 
Sent: Friday, September 14, 2007 10:27 AM
To: Wu, Gilbert
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic94xx: fix smartctl utility problem

Gilbert Wu wrote:
> Fixed the problem that "smartctl -a /dev/some_sata_disk -d ata"  does
> not work on SATA device. ( The smartctl v5.38 does need "-d ata"
> option.)
>   The aic94xx need to return ATA output register for all ATA commands
> except ATA Read/Write commands.
>   The aic94xx also mark out the DRQ bit from status register which is
> treated as AC_ERR_HSM (host state machine violation) error by top
layer
> if it set to one.
>  The firmware of aic94xx chip handle all ATA handshaking, data
transfer
> and return ATA output register which is sent by the device.  So the
DRQ
> bit may not reflect the last state of device when the command finished
> and it is no meaning for the caller.
> 
> Signed-off-by: Gilbert Wu <gilbert_wu@adaptec.com>

ACK, thanks for your patience


> @@ -427,6 +459,9 @@
>  			flags |= STP_AFFIL_POLICY;
>  		scb->ata_task.flags = flags;
>  	}
> +	if (!is_ata_rw_cmd(scb->ata_task.fis.command))
> +		scb->ata_task.ata_flags|=CSMI_TASK;

Minor style complaint:  add spaces around "|="

Regards,

	Jeff


