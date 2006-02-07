From: Christoph Hellwig <hch@infradead.org>
Subject: Re: In-kernel QLE2462 driver LU enumeration bug?
Date: Tue, 7 Feb 2006 09:17:16 +0000
Message-ID: <20060207091716.GB11691@infradead.org>
References: <1138279741.1318.76.camel@echo.e.linpro.no> <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:19945 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932187AbWBGJRZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Feb 2006 04:17:25 -0500
Content-Disposition: inline
In-Reply-To: <20060206231150.GG9044@andrew-vasquezs-powerbook-g4-15.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Tore Anderson <tore@linpro.no>, linux-scsi@vger.kernel.org

>  
>  	int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
> +	host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));

this looks rather odd to me.  first and minor cmd_pkt->lun now gets
values in different endianesses asigned, which doesn't help static
typechecking, aka getting the qla2xxx driver sparse clean.  Second the
host_to_fcp_swap function looks more than fishy to me.  It's doing a loop
of unconditional byteswaps.  that can't be right on BE hardware, can it?


