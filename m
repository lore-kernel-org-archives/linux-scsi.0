From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/4] libosd: potential ERR_PTR dereference in osd_initiator.c
Date: Sun, 19 Apr 2009 19:19:19 +0300
Message-ID: <49EB4F07.4030706@panasas.com>
References: <49EB4A42.9030502@panasas.com> <49EB4C53.2000902@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f211.google.com ([209.85.218.211]:54301 "EHLO
	mail-bw0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758919AbZDSQT3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Apr 2009 12:19:29 -0400
Received: by bwz7 with SMTP id 7so833051bwz.37
        for <linux-scsi@vger.kernel.org>; Sun, 19 Apr 2009 09:19:27 -0700 (PDT)
In-Reply-To: <49EB4C53.2000902@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd mailing-list <osd-dev@open-osd.org>
Cc: Dan Carpenter <error27@gmail.com>


Sorry I forgot to put:

From: Dan Carpenter <error27@gmail.com>
On 04/19/2009 07:07 PM, Boaz Harrosh wrote:
> bio_map_kern() returns an ERR_PTR() not NULL.
> 
> Found by smatch (http://repo.or.cz/w/smatch.git).  Compile tested.
> 
> regards,
> dan carpenter
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/osd/osd_initiator.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 2a5f077..76de889 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -612,9 +612,9 @@ static int _osd_req_list_objects(struct osd_request *or,
>  
>  	WARN_ON(or->in.bio);
>  	bio = bio_map_kern(q, list, len, or->alloc_flags);
> -	if (!bio) {
> +	if (IS_ERR(bio)) {
>  		OSD_ERR("!!! Failed to allocate list_objects BIO\n");
> -		return -ENOMEM;
> +		return PTR_ERR(bio);
>  	}
>  
>  	bio->bi_rw &= ~(1 << BIO_RW);

