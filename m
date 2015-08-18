From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: Re: [patch] cxlflash: shift wrapping bug in afu_link_reset()
Date: Tue, 18 Aug 2015 10:11:40 -0500
Message-ID: <33315DEB-60C6-4473-91F4-AD06F07A222B@linux.vnet.ibm.com>
References: <20150818085743.GA3965@mwanda>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2102\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:55827 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238AbbHRPLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 11:11:52 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
	Tue, 18 Aug 2015 11:11:51 -0400
In-Reply-To: <20150818085743.GA3965@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Brian King <brking@linux.vnet.ibm.com>, Michael Neuling <mikey@neuling.org>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

> On Aug 18, 2015, at 3:57 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> 
> "port_sel" is a u64 so the shifting should also be a 64 bit shift.
> 
> Fixes: c21e0bbfc485 ('cxlflash: Base support for IBM CXL Flash Adapter')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
> index 0720d2f..f97421d 100644
> --- a/drivers/scsi/cxlflash/main.c
> +++ b/drivers/scsi/cxlflash/main.c
> @@ -1179,7 +1179,7 @@ static void afu_link_reset(struct afu *afu, int port, u64 *fc_regs)
> 
> 	/* first switch the AFU to the other links, if any */
> 	port_sel = readq_be(&afu->afu_map->global.regs.afu_port_sel);
> -	port_sel &= ~(1 << port);
> +	port_sel &= ~(1ULL << port);
> 	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
> 	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
> 
> @@ -1196,7 +1196,7 @@ static void afu_link_reset(struct afu *afu, int port, u64 *fc_regs)
> 		       __func__, port);
> 
> 	/* switch back to include this port */
> -	port_sel |= (1 << port);
> +	port_sel |= (1ULL << port);
> 	writeq_be(port_sel, &afu->afu_map->global.regs.afu_port_sel);
> 	cxlflash_afu_sync(afu, 0, 0, AFU_GSYNC);
> 

Acked-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>

