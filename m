From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 15/24] scsi: merge print_opcode_name()
Date: Fri, 3 Oct 2014 01:37:03 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958CCBDFF@G4W3202.americas.hpqcorp.net>
References: <1412144580-72880-1-git-send-email-hare@suse.de>
 <1412144580-72880-16-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:5960 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaJCBjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:39:16 -0400
In-Reply-To: <1412144580-72880-16-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



> -----Original Message-----
> From: Hannes Reinecke [mailto:hare@suse.de]
> +struct sa_name_list {
> +	int cmd;
> +	const struct value_name_pair *arr;
> +	int arr_sz;
> +};

The suggestion to rename cmd to opcode in patch 14 would
follow the movements here.

...
> @@ -273,7 +292,7 @@ static bool scsi_opcode_sa_name(int cmd, int
> service_action,
>  	const struct value_name_pair *arr = NULL;
>  	int arr_sz, k;
> 
> -	for (k = 0; sa_name_ptr->arr; ++k, ++sa_name_ptr) {
> +	for (k = 0; k < ARRAY_SIZE(sa_names_arr); ++k, ++sa_name_ptr) {
>  		if (sa_name_ptr->cmd == cmd) {
>  			arr = sa_name_ptr->arr;
>  			arr_sz = sa_name_ptr->arr_sz;
> @@ -315,11 +334,14 @@ static void print_opcode_name(unsigned char * cdbp, int
> cdb_len)
> 
>  	if (!scsi_opcode_sa_name(cdb0, sa, &name)) {
>  		if (cdb0 < 0xc0) {
> -			name = cdb_byte0_names[cdb0];
> -			if (name)
> -				printk("%s", name);
> -			else
> -				printk("cdb[0]=0x%x (reserved)", cdb0);
> +			if (ARRAY_SIZE(cdb_byte0_names)) {
> +				name = cdb_byte0_names[cdb0];
> +				if (name)
> +					printk("%s", name);
> +				else
> +					printk("cdb[0]=0x%x (reserved)", cdb0);
> +			} else
> +				printk("cdb[0]=0x%x", cdb0);

Just ARRAY_SIZE(cdb_byte0_names) is not right - that array 
is always defined and the statement is always true.

Patch 16 replaces that block of code and eliminates that
issue.


---
Rob Elliott    HP Server Storage



