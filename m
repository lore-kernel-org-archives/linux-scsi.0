From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [BUG raid1] kernel BUG at drivers/scsi/scsi_lib.c:1113
Date: Wed, 18 Aug 2010 00:13:18 +0200
Message-ID: <4C6B097E.7060505@gmail.com>
References: <20100817220917.GA5268@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51650 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab0HQWNX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2010 18:13:23 -0400
In-Reply-To: <20100817220917.GA5268@Krystal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org

On 08/18/2010 12:09 AM, Mathieu Desnoyers wrote:
> This is with these changes applied:

Hi, these are very wrong. Please use ones from:
http://lkml.org/lkml/2010/8/12/98

(there are three of them)

> --- linux.trees.git.orig/drivers/md/raid1.c	2010-08-17 17:40:52.000000000 -0400
> +++ linux.trees.git/drivers/md/raid1.c	2010-08-17 17:42:59.000000000 -0400
> @@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev,
>  	struct bio_list bl;
>  	struct page **behind_pages = NULL;
>  	const int rw = bio_data_dir(bio);
> -	const bool do_sync = (bio->bi_rw & REQ_SYNC);
> +	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
>  	bool do_barriers;
>  	mdk_rdev_t *blocked_rdev;
>  
...

regards,
-- 
js
