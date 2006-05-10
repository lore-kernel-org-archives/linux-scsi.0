From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 7/8] aic94xx: remove queue implementation comment
Date: Wed, 10 May 2006 00:09:00 -0700 (PDT)
Message-ID: <20060510070900.43730.qmail@web31806.mail.mud.yahoo.com>
References: <1147210782.11847.65.camel@localhost.localdomain>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31806.mail.mud.yahoo.com ([68.142.207.69]:6522 "HELO
	web31806.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1751395AbWEJHJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 May 2006 03:09:01 -0400
In-Reply-To: <1147210782.11847.65.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

--- Alexis Bruemmer <alexisb@us.ibm.com> wrote:

> Remove the long queue implementation comment from sas_event.c that is no
> longer valid
> 
> Signed-off-by: Alexis Bruemmer <alexisb@us.ibm.com>
> Signed-off-by: Mike Anderson <andmike@us.ibm.com>

Are you only removing this comment and leaving the rest of
the file as is, as the patch indicates?

Or has the rest of the file's contents changed?  Where is it?

 
> ---
>  drivers/scsi/sas/sas_event.c |   40 ----------------------------------------
>  1 files changed, 40 deletions(-)
> 
> Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
> ===================================================================
> --- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_event.c
> +++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_event.c
> @@ -22,46 +22,6 @@
>   *
>   */
>  
> -/**
> - * Implementation Of Priority Queue Without Duplication
> - * Luben Tuikov 2005/07/11
> - *
> - * The SAS class implements priority queue without duplication for
> - * handling ha/port/phy/discover events.  That is, we want to process
> - * the last N unique/non-duplicating events, in the order they arrived.
> - *
> - * The requirement is that insertion is O(1), and ordered removal is O(1).
> - *
> - * Suppose events are identified by integers.  Then what is required
> - * is that for a given sequence of any random integers R, to find a
> - * sorted sequence E, where
> - *     a) |E| <= |R|.  If the number of types of events is bounded,
> - *        then E is also bounded by that number, from b).
> - *     b) For all i and k, E[i] != E[k], except when i == k,
> - *        this gives us uniqueness/non duplication.
> - *     c) For all i < k, Order(E[i]) < Order(E[k]), this gives us
> - *        ordering.
> - *     d) If T(R) = E, then O(T) <= |R|, this ensures that insertion
> - *        is O(1), and ordered removal is O(1) trivially, since we
> - *        remove at the head of E.
> - *
> - * Example:
> - * If R = {4, 5, 1, 2, 5, 3, 3, 4, 4, 3, 1}, then
> - *    E = {2, 5, 4, 3, 1}.
> - *
> - * The algorithm, T, makes use of an array of list elements, indexed
> - * by event type, and an event list head which is a linked list of the
> - * elements of the array.  When the next event arrives, we index the
> - * array by the event, and add that event to the tail of the event
> - * list head, deleting it from its previous list position (if it had
> - * one).
> - *
> - * Clearly insertion is O(1).
> - *
> - * E is given by the elements of the event list, traversed from head
> - * to tail.
> - */
> -
>  #include <scsi/scsi_host.h>
>  #include "sas_internal.h"
>  #include "sas_dump.h"
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

