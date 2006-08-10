From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] scsi : megaraid_{mm, mbox} : irq data type fix
Date: Thu, 10 Aug 2006 12:32:51 -0500
Message-ID: <1155231171.3670.32.camel@mulgrave.il.steeleye.com>
References: <1155228887.6698.7.camel@dhcp-65-957.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:64959 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1422642AbWHJRdK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 13:33:10 -0400
In-Reply-To: <1155228887.6698.7.camel@dhcp-65-957.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <sju@lsil.com>
Cc: Andrew Morton <akpm@osdl.org>, ebiederm@xmission.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2006-08-10 at 12:54 -0400, Seokmann Ju wrote:
> This patch fixes incorrect irq data type in the driver which led driver initialization failure in some cases.
> The problem was reported by Eric @. Biederman <ebiederm@xmission.com>.
[...]
> 	uint32_t		unique_id;
> -	uint8_t			irq;
> +	unsigned int		irq;
>  	uint8_t			ito;

This doesn't look right ... you're altering the size of a packed field
within the ioctl body.  This will break the ioctl ABI (and thus all
tools which use it) unless you employ versioning or some other mechanism
to detect the breakage and compensate.  I really don't think you want to
do this.

James


