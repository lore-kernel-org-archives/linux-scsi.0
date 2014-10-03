From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 16/24] scsi: consolidate opcode lookup in
 scsi_opcode_sa_name()
Date: Fri, 3 Oct 2014 01:44:44 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBE2E@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-17-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:24292 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaJCBqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:46:32 -0400
In-Reply-To: <1412144580-72880-17-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
...
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
...
> @@ -332,21 +340,20 @@ static void print_opcode_name(unsigned char * cdbp, int
> cdb_len)
>  		len = cdb_len;
>  	}
> 
> -	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
> -		if (cdb0 < 0xc0) {
> -			if (ARRAY_SIZE(cdb_byte0_names)) {
> -				name = cdb_byte0_names[cdb0];
> -				if (name)
> -					printk("%s", name);
> -				else
> -					printk("cdb[0]=0x%x (reserved)", cdb0);
> -			} else
> -				printk("cdb[0]=0x%x", cdb0);
> -		} else
> +	if (!scsi_opcode_sa_name(cdb0, sa, &cdb_name, &sa_name)) {
> +		if (cdb_name)
> +			printk("%s", cdb_name);
> +		else if (cdb0 > VENDOR_SPECIFIC_CDB)
>  			printk("cdb[0]=0x%x (vendor)", cdb0);
> +		else if (cdb0 > 0x60 && cdb0 < 0x7e)
> +			printk("cdb[0]=0x%x (reserved)", cdb0);
> +		else
> +			printk("cdb[0]=0x%x", cdb0);

Both of those > need to be >=, since the reserved
range starts at and includes 0x60, and the vendor
specific range starts at and includes 0xc0.

---
Rob Elliott    HP Server Storage



