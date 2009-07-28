From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_transport_sas: Write outside array bounds
Date: Tue, 28 Jul 2009 16:39:05 +0000
Message-ID: <1248799145.3855.237.camel@mulgrave.site>
References: <4A6ED0ED.1090707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56402 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750841AbZG1QjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Jul 2009 12:39:10 -0400
In-Reply-To: <4A6ED0ED.1090707@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Tue, 2009-07-28 at 12:20 +0200, Roel Kluin wrote:
> SETUP_PORT_ATTRIBUTE increments count, making the write out of bounds (array of
> size 1)
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Credits to Parfait (http://research.sun.com/projects/parfait/)
> 
> I suspect this isn't the only location where count shouldn't be incremented,
> Somebody should review this function.
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 0895d3c..c784ae4 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -1693,9 +1693,10 @@ sas_attach_transport(struct sas_function_template *ft)
>  
>  	count = 0;
>  	SETUP_PORT_ATTRIBUTE(num_phys);
> -	i->host_attrs[count] = NULL;
>  
>  	count = 0;
> +	i->host_attrs[count] = NULL;
> +
>  	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
>  	SETUP_PHY_ATTRIBUTE(target_port_protocols);
>  	SETUP_PHY_ATTRIBUTE(device_type);

If you're going to use mechanical checkers for this type of thing, it
would really help me if you'd actually think about what the code is
trying to do before sending a patch.

In this case, as you can see all of the SETUP_X are using count to step
through an array and when we're finished we add a NULL to the end.  For
the case of SETUP_PORT_ATTR, the array is i->port_attrs, so the bug here
is apparently that the NULL is going in the wrong array.  Trying to put
a NULL at the zero element is manifestly wrong because sas_internal is
zero allocated.

Actually, as a final weirdness, we have a duplicate initialisation of
this anyway, so the correct patch is below.

James

---

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 0895d3c..fd47cb1 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1692,10 +1692,6 @@ sas_attach_transport(struct sas_function_template *ft)
 	i->f = ft;
 
 	count = 0;
-	SETUP_PORT_ATTRIBUTE(num_phys);
-	i->host_attrs[count] = NULL;
-
-	count = 0;
 	SETUP_PHY_ATTRIBUTE(initiator_port_protocols);
 	SETUP_PHY_ATTRIBUTE(target_port_protocols);
 	SETUP_PHY_ATTRIBUTE(device_type);


