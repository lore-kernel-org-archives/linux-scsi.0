From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 5/7] be2iscsi: Fix doorbell format for EQ/CQ/RQ s per
 SLI spec.
Date: Fri, 17 Jan 2014 02:53:33 -0600
Message-ID: <52D8EF8D.1090504@cs.wisc.edu>
References: <1389573741-3523-1-git-send-email-jayamohan.kallickal@emulex.com> <1389573741-3523-5-git-send-email-jayamohan.kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47808 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751079AbaAQIxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jan 2014 03:53:44 -0500
In-Reply-To: <1389573741-3523-5-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 01/12/2014 06:42 PM, Jayamohan Kallickal wrote:

> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index b14949a..4e1074a 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -436,10 +436,20 @@ static void beiscsi_cq_notify(struct beiscsi_hba *phba, u16 qid, bool arm,
>  		       u16 num_popped)
>  {
>  	u32 val = 0;
> -	val |= qid & DB_CQ_RING_ID_MASK;
> +
>  	if (arm)
>  		val |= 1 << DB_CQ_REARM_SHIFT;
> +
>  	val |= num_popped << DB_CQ_NUM_POPPED_SHIFT;
> +
> +	/* Setting lower order CQ_ID Bits */
> +	val |= qid & DB_CQ_RING_ID_LOW_MASK;
> +
> +	/* Setting Higher order CQ_ID Bits */
> +	val |= (((qid >> DB_CQ_HIGH_FEILD_SHIFT) &
> +		  DB_CQ_RING_ID_HIGH_MASK)
> +		  << DB_CQ_HIGH_SET_SHIFT);
> +
>  	iowrite32(val, phba->db_va + DB_CQ_OFFSET);



> @@ -1155,10 +1164,20 @@ static void hwi_ring_cq_db(struct beiscsi_hba *phba,
>  			   unsigned char rearm, unsigned char event)
>  {
>  	u32 val = 0;
> -	val |= id & DB_CQ_RING_ID_MASK;
> +
>  	if (rearm)
>  		val |= 1 << DB_CQ_REARM_SHIFT;
> +
>  	val |= num_processed << DB_CQ_NUM_POPPED_SHIFT;
> +
> +	/* Setting lower order CQ_ID Bits */
> +	val |= (id & DB_CQ_RING_ID_LOW_MASK);
> +
> +	/* Setting Higher order CQ_ID Bits */
> +	val |= (((id >> DB_CQ_HIGH_FEILD_SHIFT) &
> +		  DB_CQ_RING_ID_HIGH_MASK)
> +		  << DB_CQ_HIGH_SET_SHIFT);
> +
>  	iowrite32(val, phba->db_va + DB_CQ_OFFSET);
>  }
>  

Are these 2 functions doing the same thing?

I think hwi_ring_cq_db is also doing the same operations, but with
different values. You should make a function.
