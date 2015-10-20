From: Willy Tarreau <w@1wt.eu>
Subject: Re: [patch] ses: tighten range checks in ses_intf_add()
Date: Tue, 20 Oct 2015 08:38:20 +0200
Message-ID: <20151020063820.GC1005@1wt.eu>
References: <----An------QYmAn$10b010ca-f710-44aa-8ea3-3b65a3c21286@alibaba-inc.com> <20151019134820.GA28752@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:64695 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbbJTGjC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Oct 2015 02:39:02 -0400
Content-Disposition: inline
In-Reply-To: <20151019134820.GA28752@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, "??????(??????)" <chengmiao.cj@alibaba-inc.com>, throber3 <throber3@gmail.com>, security@kernel.org

Hi Dan,

On Mon, Oct 19, 2015 at 04:48:20PM +0300, Dan Carpenter wrote:
> We test that "type_ptr" is within the buffer but then we read from
> "type_ptr[3]" so we could be reading beyond the end of the buffer.
> 
> Reported-by: "Berry Cheng ??????(??????)" <chengmiao.cj@alibaba-inc.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This isn't a complete fix because we still need more range checking in
> all the other places which use type_ptr like ses_get_page2_descriptor().
> We record len as page1_len but we don't use it anywhere...
> 
> I wonder if someone knew the expected format we could make reject too
> short lengths earlier.
> 
> diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
> index dcb0d76..39f69b0 100644
> --- a/drivers/scsi/ses.c
> +++ b/drivers/scsi/ses.c
> @@ -641,7 +641,7 @@ static int ses_intf_add(struct device *cdev,
>  	/* begin at the enclosure descriptor */
>  	type_ptr = buf + 8;
>  	/* skip all the enclosure descriptors */
> -	for (i = 0; i < num_enclosures && type_ptr < buf + len; i++) {
> +	for (i = 0; i < num_enclosures && type_ptr + 4 < buf + len; i++) {
>  		types += type_ptr[2];
>  		type_ptr += type_ptr[3] + 4;


why "type_ptr + 4 < buf + len" here ? You're using type_ptr[3] only,
so it's either "type_ptr + 4 <= buf + len" or "type_ptr + 3 < buf + len".

> @@ -649,7 +649,7 @@ static int ses_intf_add(struct device *cdev,
>  	ses_dev->page1_types = type_ptr;
>  	ses_dev->page1_num_types = types;
>  
> -	for (i = 0; i < types && type_ptr < buf + len; i++, type_ptr += 4) {
> +	for (i = 0; i < types && type_ptr + 2 < buf + len; i++, type_ptr += 4) {
>  		if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
>  		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
>  			components += type_ptr[1];

Same here where I'd expect "type_ptr + 1 < buf + len"

Regards,
Willy

