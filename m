From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] libfc: fix error handling in
	fc_exch_rrq_resp()
Date: Fri, 22 Oct 2010 11:57:51 -0700
Message-ID: <4CC1DEAF.50403@cisco.com>
References: <AANLkTik3GbuiEGVPigGZp+=RH7qRMarn0cdZJ49Toso7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <AANLkTik3GbuiEGVPigGZp+=RH7qRMarn0cdZJ49Toso7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: devel-s9riP+hp16TNLxjTenLetw@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org



On 10/22/10 8:21 AM, Hillf Danton wrote:
> There seems no cleanup left when FC_EX_CLOSED encountered, which may
> be from fc_exch_reset().

Are you sure?  It seems that the RRQ exchange has a hold on another
exchange, the one that's the subject of the RRQ.  That exchange
still needs to be released.  I could be wrong, it's been a while.

> Signed-off-by: Hillf Danton <dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> 
> --- a/drivers/scsi/libfc/fc_exch.c	2010-09-13 07:07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_exch.c	2010-10-22 23:17:50.000000000 +0800
> @@ -1827,7 +1827,9 @@ static void fc_exch_rrq_resp(struct fc_s
>  	if (IS_ERR(fp)) {
>  		int err = PTR_ERR(fp);
> 
> -		if (err == -FC_EX_CLOSED || err == -FC_EX_TIMEOUT)
> +		if (err == -FC_EX_CLOSED)
> +			return;
> +		if (err == -FC_EX_TIMEOUT)
>  			goto cleanup;
>  		FC_EXCH_DBG(aborted_ep, "Cannot process RRQ, "
>  			    "frame error %d\n", err);
> _______________________________________________
> devel mailing list
> devel-s9riP+hp16TNLxjTenLetw@public.gmane.org
> http://www.open-fcoe.org/mailman/listinfo/devel
