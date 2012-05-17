From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [patch] iscsi-target: remove some dead code
Date: Thu, 17 May 2012 00:39:42 -0700
Message-ID: <1337240382.32217.196.camel@haakon2.linux-iscsi.org>
References: <20120517070814.GD14660@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43374 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761281Ab2EQHju (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2012 03:39:50 -0400
In-Reply-To: <20120517070814.GD14660@elgon.mountain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andy Grover <agrover@redhat.com>, Jesper Juhl <jj@chaosbits.net>, Joern Engel <joern@logfs.org>, Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

Hello DanC,

On Thu, 2012-05-17 at 10:08 +0300, Dan Carpenter wrote:
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
> -			if (!acceptor_values || !proposer_values) {
> -				if (tmp1)
> -					*tmp1 = ',';
> -				if (tmp2)
> -					*tmp2 = ',';
> -				return NULL;
> -			}

Mmmmm, I seem to remember this code being some manner of bugfix when
these two NULL checks for IS_TYPE_VALUE_LIST() type login parameters
where originally added into iscsi-target code (circa 2004)..

Looking at iscsi_check_valuelist_for_support() now in modern usage I
think it's fine to go ahead and drop these checks..  

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

<nod>, looks harmless to drop as well.

Applied to lio-core, and queuing into for-next.

Thanks Dan!

--nab

