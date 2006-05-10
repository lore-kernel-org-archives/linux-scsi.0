From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 6/8] aic94xx: move list_each_entry_reverse_safe from sas_discover.h to list.h
Date: Wed, 10 May 2006 00:07:07 -0700 (PDT)
Message-ID: <20060510070707.44202.qmail@web31801.mail.mud.yahoo.com>
References: <1147210621.11847.60.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31801.mail.mud.yahoo.com ([68.142.207.64]:38002 "HELO
	web31801.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751209AbWEJHHI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 03:07:08 -0400
In-Reply-To: <1147210621.11847.60.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Oh, BTW, the kernel already has that macro but the last two
words are swapped.  It is called:

list_for_each_entry_safe_reverse()

Your lk-2.6 base is too old.




--- Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> Move list_each_entry_reverse_safe from sas_discover.h to the more
> appropriate file list.h
> 
> Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
> Signed-off-by: Mike Anderson <andmike@us.ibm.com>
> 
> ---
>  include/linux/list.h            |    6 ++++++
>  include/scsi/sas/sas_discover.h |    7 -------
>  2 files changed, 6 insertions(+), 7 deletions(-)
> 
> Index: aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
> ===================================================================
> --- aic94xx-sas-2.6-patched.orig/include/scsi/sas/sas_discover.h
> +++ aic94xx-sas-2.6-patched/include/scsi/sas/sas_discover.h
> @@ -115,13 +115,6 @@ struct domain_device {
>  	void *lldd_dev;
>  };
>  
> -#define list_for_each_entry_reverse_safe(pos, n, head, member)		\
> -	for (pos = list_entry((head)->prev, typeof(*pos), member),	\
> -		n = list_entry(pos->member.prev, typeof(*pos), member);	\
> -	     &pos->member != (head); 					\
> -	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> -
> -
>  
>  void sas_init_disc(struct sas_discovery *disc, struct sas_port *port);
>  int  sas_discover_event(struct sas_port *sas_port, enum discover_event ev);
> Index: aic94xx-sas-2.6-patched/include/linux/list.h
> ===================================================================
> --- aic94xx-sas-2.6-patched.orig/include/linux/list.h
> +++ aic94xx-sas-2.6-patched/include/linux/list.h
> @@ -542,6 +542,12 @@ static inline void list_splice_init(stru
>  		prefetch(rcu_dereference((pos))->next), (pos) != (head); \
>          	(pos) = (pos)->next)
>  
> +#define list_for_each_entry_reverse_safe(pos, n, head, member)          \
> +	for (pos = list_entry((head)->prev, typeof(*pos), member),      \
> +		n = list_entry(pos->member.prev, typeof(*pos), member); \
> +		&pos->member != (head);                                    \
> +		pos = n, n = list_entry(n->member.prev, typeof(*n), member))
> +
>  /*
>   * Double linked lists with a single pointer list head.
>   * Mostly useful for hash tables where the two pointer list head is
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

