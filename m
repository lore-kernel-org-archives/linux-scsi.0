From: walter harms <wharms@bfs.de>
Subject: Re: [patch] iscsi-target: remove some dead code
Date: Thu, 17 May 2012 11:58:40 +0200
Message-ID: <4FB4CBD0.8000503@bfs.de>
References: <20120517070814.GD14660@elgon.mountain>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx01.sz.bfs.de ([194.94.69.103]:14779 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756049Ab2EQJ6m (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 May 2012 05:58:42 -0400
In-Reply-To: <20120517070814.GD14660@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Andy Grover <agrover@redhat.com>, Jesper Juhl <jj@chaosbits.net>, Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org



Am 17.05.2012 09:08, schrieb Dan Carpenter:
> Neither "acceptor_values" nor "proposer_values" can be NULL here.
> Smatch complains because we are not allowed to pass NULL pointers to
> strchr().
> 
> Also I removed a second later check for "!acceptor_values" because it
> gets checked on the next line in the do while condition.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> Compile tested only.  Please review carefully.
> 
> diff --git a/drivers/target/iscsi/iscsi_target_parameters.c b/drivers/target/iscsi/iscsi_target_parameters.c
> index ad3b3c1..ed5241e 100644
> --- a/drivers/target/iscsi/iscsi_target_parameters.c
> +++ b/drivers/target/iscsi/iscsi_target_parameters.c
> @@ -1037,13 +1037,6 @@ static char *iscsi_check_valuelist_for_support(
>  			tmp2 = strchr(acceptor_values, ',');
>  			if (tmp2)
>  				*tmp2 = '\0';
this looks like strchrnul(). I realy do not know is this supported inside the kernel ?



> -			if (!acceptor_values || !proposer_values) {
> -				if (tmp1)
> -					*tmp1 = ',';
> -				if (tmp2)
> -					*tmp2 = ',';
> -				return NULL;
> -			}
>  			if (!strcmp(acceptor_values, proposer_values)) {
>  				if (tmp2)
>  					*tmp2 = ',';
> @@ -1053,8 +1046,6 @@ static char *iscsi_check_valuelist_for_support(
>  				*tmp2++ = ',';
>  
>  			acceptor_values = tmp2;
> -			if (!acceptor_values)
> -				break;
>  		} while (acceptor_values);
>  		if (tmp1)
>  			*tmp1++ = ',';


the changes look reasonable but to be fair the code should have an explanation
what it is supposed to do. I do not have the feeling that i did understand the
purpose completely.

just my 2 cents,
 wh

