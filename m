From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [patch] zfcp: spin_lock_irqsave() is not nestable
Date: Thu, 13 Oct 2016 12:49:18 +0200
Message-ID: <409dfaed-85eb-01ba-539d-df95f008a6bf@linux.vnet.ibm.com>
References: <20161013085358.GH16198@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161013085358.GH16198@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, linux-scsi@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, =?UTF-8?Q?Hendrik_Br=c3=bcckner?= <brueckner@linux.vnet.ibm.com>, Gerald Schaefer <gerald.schaefer@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Dan, many thanks for catching this! Sparse did not notice, is there 
other tooling that would find such things?

James, Martin, could you please queue this as fix for one of my patches 
that went into the 4.9 merge window, so for 4.9-rc I guess?
https://lkml.kernel.org/r/20161013085358.GH16198@mwanda
or
https://lkml.org/lkml/2016/10/13/94

On 10/13/2016 10:53 AM, Dan Carpenter wrote:
> We accidentally overwrite the original saved value of "flags" so that
> we can't re-enable IRQs at the end of the function.  Presumably this
> function is mostly called with IRQs disabled or it would be obvious in
> testing.
>
> Fixes: aceeffbb59bb ("zfcp: trace full payload of all SAN records (req,resp,iels)")

Cc: <stable@vger.kernel.org> #2.6.38+

> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>

>
> diff --git a/drivers/s390/scsi/zfcp_dbf.c b/drivers/s390/scsi/zfcp_dbf.c
> index 637cf89..5810019 100644
> --- a/drivers/s390/scsi/zfcp_dbf.c
> +++ b/drivers/s390/scsi/zfcp_dbf.c
> @@ -384,7 +384,7 @@ void zfcp_dbf_san(char *tag, struct zfcp_dbf *dbf,
>  	/* if (len > rec_len):
>  	 * dump data up to cap_len ignoring small duplicate in rec->payload
>  	 */
> -	spin_lock_irqsave(&dbf->pay_lock, flags);
> +	spin_lock(&dbf->pay_lock);
>  	memset(payload, 0, sizeof(*payload));
>  	memcpy(payload->area, paytag, ZFCP_DBF_TAG_LEN);
>  	payload->fsf_req_id = req_id;
>

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
