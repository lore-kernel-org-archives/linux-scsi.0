From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCHv3]scsi: don't fail zero length request too early
Date: Fri, 13 May 2016 06:51:49 -0700
Message-ID: <1463147509.2291.1.camel@linux.vnet.ibm.com>
References: <CAMGffEmZMWSTSP3VRxn8K_ZWG3qvRWeKOjzPJN8V4ZZ8Fa_xGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:41374 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327AbcEMNv7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2016 09:51:59 -0400
Received: from localhost
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Fri, 13 May 2016 07:51:58 -0600
In-Reply-To: <CAMGffEmZMWSTSP3VRxn8K_ZWG3qvRWeKOjzPJN8V4ZZ8Fa_xGA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sebastian Parschauer <s.parschauer@gmx.de>, linux-scsi@vger.kernel.org

On Fri, 2016-05-13 at 10:07 +0200, Jinpu Wang wrote:
> Hi James, and all,
> 
> I guess you're busy on other staff, so I create patch below as you
> suggested, I think we also need this into stable.

No, I'll do it, but I just wanted to verify that we don't get into an
infinite retry loop on any conditions.

James


> From 99eab170653544fa1e1bc9511ec055ba70e183d2 Mon Sep 17 00:00:00
> 2001
> From: Jack Wang <jinpu.wang@profitbricks.com>
> Date: Fri, 13 May 2016 09:53:21 +0200
> Subject: [PATCH] scsi: don't fail zero length request too early
> 
> We hit IO error in our production when SYNC on multipath devices
> during resize
> device on target side, the problem turns out scsi driver passes up as
> IO
> error when sense data is UNIT_ATTENTION and ASC && ASCQ indicate
> Capacity data has changed, even storage side sync the data properly.
> 
> Dig it further turns out we need special case on zero length commands
> (currently only FLUSH), when it fails, we always need to drop down
> into retry code.
> 
> Reported-by: Sebastian Parschauer <s.parschauer@gmx.de>
> Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/scsi/scsi_lib.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 8106515..5a97866 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> unsigned int good_bytes)
>   }
> 
>   /*
> - * If we finished all bytes in the request we are done now.
> + * special case: failed zero length commands always need to
> + * drop down into the retry code. Otherwise, if we finished
> + * all bytes in the request we are done now.
>   */
> - if (!scsi_end_request(req, error, good_bytes, 0))
> + if (!(good_bytes == 0 && blk_rq_bytes(req) == 0 && result != 0) &&
> +    !scsi_end_request(req, error, good_bytes, 0))
>   return;
> 
>   /*
> -- 
> 1.9.1
> 

