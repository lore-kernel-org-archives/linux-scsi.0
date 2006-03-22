From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] fix sg leak when scsi_execute_async fails
Date: Wed, 22 Mar 2006 18:10:45 -0500
Message-ID: <4421D975.50100@torque.net>
References: <1143065078.2650.3.camel@max>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canuck.infradead.org ([205.233.218.70]:7104 "EHLO
	canuck.infradead.org") by vger.kernel.org with ESMTP
	id S1751434AbWCVXLB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 18:11:01 -0500
In-Reply-To: <1143065078.2650.3.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Doug found a bug where if scsi_execute_async fails, we are leaking
> sg resources. scsi_do_req never failed so we did not have to handle
> that case before.

When a SCSI command request falls foul of the extra
requirements in lk 2.6.16 (e.g. max_sectors), the
resulting ENOMEM leaves unfinished business in
the sg driver's own data structures. This can be
seen with 'cat /proc/scs/sg/debug' .

> Patch was made against scsi-misc. Not sure if this should
> also go to stable?

I think it should. It fixes a bug on an error
path by adding the same cleanup call as found
on other paths.

> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Douglas Gilbert <dougg@torque.net>

Doug Gilbert

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index a8b05ce..71994ea 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -748,6 +748,7 @@ sg_common_write(Sg_fd * sfp, Sg_request 
>  		/*
>  		 * most likely out of mem, but could also be a bad map
>  		 */
> +		sg_finish_rem_req(srp);
>  		return -ENOMEM;
>  	} else
>  		return 0;
> 
> 

