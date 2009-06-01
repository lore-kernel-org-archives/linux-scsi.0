From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_devinfo: update Hitachi entries
Date: Mon, 01 Jun 2009 15:06:16 -0500
Message-ID: <1243886776.4203.33.camel@mulgrave.int.hansenpartnership.com>
References: <4A2405FD.3000901@redhat.com>
	 <1243875275.4203.19.camel@mulgrave.int.hansenpartnership.com>
	 <4A241229.5050009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54740 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbZFAUGT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Jun 2009 16:06:19 -0400
In-Reply-To: <4A241229.5050009@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Takahiro Yasui <tyasui@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2009-06-01 at 13:38 -0400, Takahiro Yasui wrote:
> James Bottomley wrote:
> > On Mon, 2009-06-01 at 12:46 -0400, Takahiro Yasui wrote:
> >>  	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> >> -	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
> >> +	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
> > 
> > Can we drop the BLIST_ATTACH_PQ3?  It was there for not only to get the
> > sequential scan to work, but also so LUN0 would be registered with the
> > OS (I think for some control purpose) which would no longer happen.
> 
> BLIST_ATTACH_PQ3 was added to "OPEN-E" in the following commit:
>   commit: 13f7e5acc8b329080672c13f05f252ace5b79825
> 
> ---
> Unfortunately, SANs exist that are SCSI-2 and do NOT support REPORT_LUNS, but
> report a unknown device with PQ 3 on LUN 0. We still need to scan them, and
> most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the bug
> reference for an infamous example.
> ---
> 
> According to the commit, "OPEN-E" does not support REPORT_LUNS, but
> "OPEN-E" can handle REPORT_LUNS. In addition, other "OPEN-" models
> can do as well.
> 
> I would like to know in which case BLIST_ATTACH_PQ3 is required.

That, I believe is the question I asked you.  If you don't know the
answer, just leave the BLIST_ATTACH_PQ3 in. it's harmless for the report
luns case and it will still attach a PQ disconnected LUN0, which was the
original behaviour.

James


