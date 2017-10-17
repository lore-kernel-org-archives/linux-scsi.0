From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] scsi: sg: Re-fix off by one in sg_fill_request_table()
Date: Tue, 17 Oct 2017 09:02:16 -0400
Message-ID: <19e3faa5-f72d-0743-f018-4a0713a21aea@interlog.com>
References: <20171015171633.rphqeyc46uy4l5tx@xylophone.i.decadent.org.uk>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:50694 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758513AbdJQNC0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 09:02:26 -0400
In-Reply-To: <20171015171633.rphqeyc46uy4l5tx@xylophone.i.decadent.org.uk>
Content-Language: en-CA
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Hutchings <ben.hutchings@codethink.co.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org

On 2017-10-15 01:16 PM, Ben Hutchings wrote:
> Commit 109bade9c625 ("scsi: sg: use standard lists for sg_requests")
> introduced an off-by-one error in sg_ioctl(), which was fixed by
> commit bd46fc406b30 ("scsi: sg: off by one in sg_ioctl()").
> 
> Unfortunately commit 4759df905a47 ("scsi: sg: factor out
> sg_fill_request_table()") moved that code, and reintroduced the
> bug (perhaps due to a botched rebase).  Fix it again.
> 
> Fixes: 4759df905a47 ("scsi: sg: factor out sg_fill_request_table()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 0419c2298eab..aa28874e8fb9 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -837,7 +837,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
>   
>   	val = 0;
>   	list_for_each_entry(srp, &sfp->rq_list, entry) {
> -		if (val > SG_MAX_QUEUE)
> +		if (val >= SG_MAX_QUEUE)
>   			break;
>   		rinfo[val].req_state = srp->done + 1;
>   		rinfo[val].problem =
> 
