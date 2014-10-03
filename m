From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 17/24] scsi: remove last argument from
 print_opcode_name()
Date: Fri, 3 Oct 2014 02:02:36 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBE69@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-18-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:33502 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaJCCEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 22:04:07 -0400
In-Reply-To: <1412144580-72880-18-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> Sent: Wednesday, 01 October, 2014 1:23 AM
> To: James Bottomley
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org; Elliott, Robert (Server
> Storage); Hannes Reinecke
> Subject: [PATCH 17/24] scsi: remove last argument from print_opcode_name()
> 
> print_opcode_name() was only ever called with a '0' argument
> from LLDDs and ULDs which were _not_ supporting variable length
> CDBs, so the 'if' clause was never triggered.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/constants.c | 21 +++++++--------------
>  1 file changed, 7 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 2110d61..713e1e0 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -320,25 +320,21 @@ static bool scsi_opcode_sa_name(int cmd, int
> service_action,
>  	return true;
>  }
> 
> -/* attempt to guess cdb length if cdb_len==0 . No trailing linefeed. */
> -static void print_opcode_name(unsigned char * cdbp, int cdb_len)
> +static void print_opcode_name(unsigned char *cdbp)

Add const since what cdbp points to is not modified.

>  {
> -	int sa, len, cdb0;
> +	int sa, cdb0;
>  	const char *cdb_name = NULL, *sa_name = NULL;
> 
>  	cdb0 = cdbp[0];
>  	if (cdb0 == VARIABLE_LENGTH_CMD) {
> -		len = scsi_varlen_cdb_length(cdbp);
> +		int len = scsi_varlen_cdb_length(cdbp);

cdbp must point to a buffer containing at least 8 valid
bytes for that to be safe. Is that guaranteed?

>  		if (len < 10) {
> -			printk("short variable length command, "
> -			       "len=%d ext_len=%d", len, cdb_len);
> +			printk("short variable length command, len=%d", len);
>  			return;
>  		}
>  		sa = (cdbp[8] << 8) + cdbp[9];
> -	} else {
> +	} else
>  		sa = cdbp[1] & 0x1f;

cdbp must point to a buffer containing at least 2 valid
bytes for that to be safe. Is that guaranteed?

> -		len = cdb_len;
> -	}
> 
>  	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
>  		if (cdb_name)
> @@ -356,9 +352,6 @@ static void print_opcode_name(unsigned char * cdbp, int
> cdb_len)
>  			printk("%s, sa=0x%x", cdb_name, sa);
>  		else
>  			printk("cdb[0]=0x%x, sa=0x%x", cdb0, sa);
> -
> -		if (cdb_len > 0 && len != cdb_len)
> -			printk(", in_cdb_len=%d, ext_len=%d", len, cdb_len);
>  	}
>  }
> 
> @@ -366,7 +359,7 @@ void __scsi_print_command(unsigned char *cdb)
...
> @@ -383,7 +376,7 @@ void scsi_print_command(struct scsi_cmnd *cmd)

Add const to each of those, since what cdbp and cmd point 
to is not modified.

---
Rob Elliott    HP Server Storage




