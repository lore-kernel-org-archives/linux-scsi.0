From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH][sas] Fix potential NULL pointer dereference bug in
	sas_smp_get_phy_events()
Date: Fri, 27 Jul 2007 19:02:52 -0400
Message-ID: <1185577372.3434.29.camel@localhost.localdomain>
References: <200707272327.57356.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47076 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680AbXG0XCy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 19:02:54 -0400
In-Reply-To: <200707272327.57356.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-scsi@vger.kernel.org, Luben Tuikov <luben_tuikov@adaptec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Fri, 2007-07-27 at 23:27 +0200, Jesper Juhl wrote:
> In sas_smp_get_phy_events() we never test if the call to 
> alloc_smp_req(RPEL_REQ_SIZE) succeeds or fails. That means we run 
> the risk of dereferencing a NULL pointer if it does fail. Far 
> better to test if we got NULL back and in that case return -ENOMEM 
> just as we already do for the other memory allocation in that 
> function.
> This patch reworks the memory allocation a bit to deal with it 
> (compile tested only).
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
>  drivers/scsi/libsas/sas_expander.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index b500f0c..85f5145 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -507,14 +507,21 @@ static int sas_dev_present_in_domain(struct asd_sas_port *port,
>  int sas_smp_get_phy_events(struct sas_phy *phy)
>  {
>  	int res;
> +	u8 *req;
> +	u8 *resp;
>  	struct sas_rphy *rphy = dev_to_rphy(phy->dev.parent);
>  	struct domain_device *dev = sas_find_dev_by_rphy(rphy);
> -	u8 *req = alloc_smp_req(RPEL_REQ_SIZE);
> -	u8 *resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);
>  
> +	resp = kzalloc(RPEL_RESP_SIZE, GFP_KERNEL);

Actually, this should be alloc_smp_resp(RPEL_RESP_SIZE);

>  	if (!resp)
>  		return -ENOMEM;
>  
> +	req = alloc_smp_req(RPEL_REQ_SIZE);
> +	if (!req) {
> +        	res = -ENOMEM;
> +		goto out;
> +	}

Just for the sake of being the same as all the rest of the code, the
sequence should be

	req = alloc_smp_req(xxx_REQ_SIZE);
	if (!req)
		return -ENOMEM;

	resp = alloc_smp_resp(xxx_RESP_SIZE);
	if (!resp) {
		kfree(req);
		return -ENOMEM;
	}

(allocate request then response).

It looks like disc_resp could use a little love too (it's using the req
alloc routines).

James

