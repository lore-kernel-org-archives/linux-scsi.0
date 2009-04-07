From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_transport_fc.c : .29 merge fix for FC passthru
	patch
Date: Tue, 07 Apr 2009 17:58:02 +0000
Message-ID: <1239127083.29492.8.camel@mulgrave.int.hansenpartnership.com>
References: <1239126522.8975.2.camel@ogier>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38643 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759554AbZDGR6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 13:58:04 -0400
In-Reply-To: <1239126522.8975.2.camel@ogier>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

On Tue, 2009-04-07 at 13:48 -0400, James Smart wrote:
> James,
> 
> It appears that the latest merge of scsi-misc-2.6 picked up a kernel change
> that killed the bus_id element from struct device.
> 
> Here's a quick patch to resolve the inconsistency.  I assumed this was easier
> than regen-ing the fc pass-thru patch.
> 
> This patch to be applied on top of the fc-pass-thru patch.
> 
> -- james s
> 
> 
>  Signed-off-by: James Smart <james.smart@emulex.com>
> 
>  ---
> 
>  scsi_transport_fc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> 
> diff -upNr a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> --- a/drivers/scsi/scsi_transport_fc.c	2009-04-07 13:38:38.000000000 -0400
> +++ b/drivers/scsi/scsi_transport_fc.c	2009-04-07 13:39:18.000000000 -0400
> @@ -3920,7 +3920,7 @@ fc_bsg_rportadd(struct Scsi_Host *shost,
>  	if (!q) {
>  		printk(KERN_ERR "%s: bsg interface failed to "
>  				"initialize - no request queue\n",
> -				 dev->bus_id);
> +				 dev->kobj.name);

This actually needs to be dev_name(dev), which is where all the bus_id
things went.

James


