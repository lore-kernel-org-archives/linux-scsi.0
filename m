From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [PATCH 1 15/25] hpsa: enhance hpsa_get_device_id
Date: Thu, 29 Oct 2015 12:04:23 -0500
Message-ID: <332960E8-ABA9-454E-922C-229EDC56C0BA@linux.vnet.ibm.com>
References: <20151028215206.5323.84194.stgit@brunhilda> <20151028220601.5323.62936.stgit@brunhilda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e18.ny.us.ibm.com ([129.33.205.208]:58748 "EHLO
	e18.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757057AbbJ2RE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Oct 2015 13:04:28 -0400
Received: from localhost
	by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Thu, 29 Oct 2015 13:04:27 -0400
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id B04B938C805C
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:04:25 -0400 (EDT)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t9TH4Pki42336464
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 17:04:25 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t9TH4OLp009567
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 13:04:25 -0400
In-Reply-To: <20151028220601.5323.62936.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>
Cc: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, linux-scsi@vger.kernel.org

> On Oct 28, 2015, at 5:06 PM, Don Brace <don.brace@pmcs.com> wrote:
> 
> use an index into vpd data for SAS/SATA drives
> 
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>
> ---
> drivers/scsi/hpsa.c |   23 ++++++++++++++++++++---
> 1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
> index c1b053f..1361414 100644
> --- a/drivers/scsi/hpsa.c
> +++ b/drivers/scsi/hpsa.c
> @@ -3137,7 +3137,7 @@ out:
> 
> /* Get the device id from inquiry page 0x83 */
> static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
> -	unsigned char *device_id, int buflen)
> +	unsigned char *device_id, int index, int buflen)
> {
> 	int rc;
> 	unsigned char *buf;
> @@ -3149,8 +3149,10 @@ static int hpsa_get_device_id(struct ctlr_info *h, unsigned char *scsi3addr,
> 		return -ENOMEM;
> 	rc = hpsa_scsi_do_inquiry(h, scsi3addr, VPD_PAGE | 0x83, buf, 64);
> 	if (rc == 0)
> -		memcpy(device_id, &buf[8], buflen);
> +		memcpy(device_id, &buf[index], buflen);
> +
> 	kfree(buf);
> +
> 	return rc != 0;
> }
> 
> @@ -3379,6 +3381,18 @@ static int hpsa_device_supports_aborts(struct ctlr_info *h,
> 	return rc;
> }
> 
> +static void sanitize_inquiry_string(unsigned char *s, int len)
> +{
> +	bool terminated = false;
> +
> +	for (; len > 0; (--len, ++s)) {
> +		if (*s == 0)
> +			terminated = true;
> +		if (terminated || *s < 0x20 || *s > 0x7e)
> +			*s = ' ';
> +	}
> +}
> +

Perhaps in a future commit the version in scsi_scan can be exported and this duplication
can be eliminated.

Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

