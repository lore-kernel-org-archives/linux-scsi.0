From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [TRIVIAL] 16) request_region check, 11-20
Date: 27 Jun 2003 13:53:08 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1056718387.3174.40.camel@dhcp22.swansea.linux.org.uk>
References: <20030623070136.1F08D2C2E7@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pc2-cwma1-4-cust86.swan.cable.ntl.com ([213.105.254.86]:62852
	"EHLO lxorguk.ukuu.org.uk") by vger.kernel.org with ESMTP
	id S264235AbTF0MmN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Jun 2003 08:42:13 -0400
In-Reply-To: <20030623070136.1F08D2C2E7@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Trivial Russell <rusty@rustcorp.com.au>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, linux-scsi@vger.kernel.org, rmk@arm.linux.org.uk

On Llu, 2003-06-23 at 08:00, Rusty Trivial Russell wrote:
> --- trivial-2.4.22-pre1/drivers/acorn/scsi/oak.c.orig	2003-06-23 16:39:46.000000000 +1000
> +++ trivial-2.4.22-pre1/drivers/acorn/scsi/oak.c	2003-06-23 16:39:46.000000000 +1000
> @@ -134,7 +134,8 @@
>  	ecard_claim(ecs[count]);
>  
>  	instance->n_io_port = 255;
> -	request_region (instance->io_port, instance->n_io_port, "Oak SCSI");
> +	if (!request_region (instance->io_port, instance->n_io_port, "Oak SCSI"))
> +		break;
>  

Doesn't clean up the register etc - so clearly wrong. Actually I suspect
what needs doing is to request_region first, then register then _check_
the scsi_register return (it doesnt) and unregister the region.

