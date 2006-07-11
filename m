From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: aic94xx panic on module insertion
Date: Mon, 10 Jul 2006 21:52:06 -0700
Message-ID: <20060711045206.GA7552@us.ibm.com>
References: <1152541373.7275.11.camel@mulgrave.il.steeleye.com> <20060710172950.GE30179@us.ibm.com> <1152565651.4027.11.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:6350 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S965147AbWGKEwI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Jul 2006 00:52:08 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k6B4q7Wo026949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 00:52:07 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.6/NCO/VER7.0) with ESMTP id k6B4q7If269900
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 00:52:07 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k6B4q7Sx011342
	for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2006 00:52:07 -0400
Content-Disposition: inline
In-Reply-To: <1152565651.4027.11.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Mon, 2006-07-10 at 10:29 -0700, Mike Anderson wrote:
> > Yes, since we have not formed a port yet on phy1 it would appear that we
> > could just drop this event if port is null as we are going to do discovery
> > post port forming the port anyway.
> 
> OK, so this is the fix?
> 
> James
> 
> diff --git a/drivers/scsi/sas/sas_port.c b/drivers/scsi/sas/sas_port.c
> index 07415e9..d931478 100644
> --- a/drivers/scsi/sas/sas_port.c
> +++ b/drivers/scsi/sas/sas_port.c
> @@ -199,6 +199,12 @@ void sas_porte_broadcast_rcvd(void *data
>  	u32 prim;
>  	struct asd_sas_phy *phy = data;
>  
> +	/* Broadcast received before port forms.  This is fine, since
> +	 * port formation will trigger a domain discovery (rather than
> +	 * revalidation) */
> +	if (!sas->port)
> +		return;
> +
>  	sas_begin_event(PORTE_BROADCAST_RCVD, &phy->ha->event_lock,
>  			&phy->port_events_pending);
>  

or this is the one I was trying, but I cannot generate the events you
where seeing. I was trying to create fake ones but have not been
successful. Either seems like it would address this event.

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_discover.c	2006-07-10 11:56:43.000000000 -0700
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_discover.c	2006-07-10 15:58:44.000000000 -0700
@@ -717,7 +717,11 @@ static void sas_revalidate_domain(void *
 
 int sas_discover_event(struct asd_sas_port *port, enum discover_event ev)
 {
-	struct sas_discovery *disc = &port->disc;
+	struct sas_discovery *disc;
+
+	if (!port)
+		return;
+	disc = &port->disc;
 
 	BUG_ON(ev >= DISC_NUM_EVENTS);
 
-andmike
--
Michael Anderson
andmike@us.ibm.com
