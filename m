From: Krishna Gudipati <kgudipat@Brocade.com>
Subject: RE: [PATCH] bfa: avoid buffer overrun for 12-byte model name
Date: Mon, 20 Aug 2012 12:42:19 -0700
Message-ID: <B5EE62D80D50B84BB9E5174F7FCCE80A2839ABC2C4@HQ1-EXCH02.corp.brocade.com>
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
 <1345481724-30108-5-git-send-email-jim@meyering.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:38930 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753425Ab2HTTmp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Aug 2012 15:42:45 -0400
In-Reply-To: <1345481724-30108-5-git-send-email-jim@meyering.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jim Meyering <jim@meyering.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jim Meyering <meyering@redhat.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Jim Meyering [mailto:jim@meyering.net]
> Sent: Monday, August 20, 2012 9:55 AM
> To: linux-kernel@vger.kernel.org
> Cc: Jim Meyering; Jing Huang; Krishna Gudipati; James E.J. Bottomley; linux-
> scsi@vger.kernel.org
> Subject: [PATCH] bfa: avoid buffer overrun for 12-byte model name
> 
> From: Jim Meyering <meyering@redhat.com>
> 
> we use strncpy to copy a model name of length up to 15 (16, if you count the
> NUL), into a buffer of size 12 (BFA_FCS_PORT_SYMBNAME_MODEL_SZ).
> However, strncpy does not always NUL-terminate, so whenever the original
> model string has strlen >= 12, the following strncat reads beyond end of the -
> >sym_name buffer as it attempts to find end of string.
> 
> bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s *fabric) {
> 	bfa_ioc_get_adapter_model(&fabric->fcs->bfa->ioc, model);
> 	...
> 	strncpy((char *)&port_cfg->sym_name, model,
> 		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> 	strncat((char *)&port_cfg->sym_name,
> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
> 		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));
> 	...
> 
> bfa_ioc_get_adapter_model(struct bfa_ioc_s *ioc, char *model) {
> 	struct bfi_ioc_attr_s	*ioc_attr;
> 
> 	WARN_ON(!model);
> 	memset((void *)model, 0, BFA_ADAPTER_MODEL_NAME_LEN);
> 
> BFA_ADAPTER_MODEL_NAME_LEN = 16
> 
> Signed-off-by: Jim Meyering <meyering@redhat.com>
> ---
>  drivers/scsi/bfa/bfa_fcs.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c index
> eaac57e..3329493 100644
> --- a/drivers/scsi/bfa/bfa_fcs.c
> +++ b/drivers/scsi/bfa/bfa_fcs.c
> @@ -713,6 +713,7 @@ bfa_fcs_fabric_psymb_init(struct bfa_fcs_fabric_s
> *fabric)
>  	/* Model name/number */
>  	strncpy((char *)&port_cfg->sym_name, model,
>  		BFA_FCS_PORT_SYMBNAME_MODEL_SZ);
> +	port_cfg->sym_name[BFA_FCS_PORT_SYMBNAME_MODEL_SZ - 1]
> = 0;
>  	strncat((char *)&port_cfg->sym_name,
> BFA_FCS_PORT_SYMBNAME_SEPARATOR,
>  		sizeof(BFA_FCS_PORT_SYMBNAME_SEPARATOR));

Nacked-by: Krishna Gudipati <kgudipat@brocade.com>

Hi Jim,

This model number is of length 12 bytes and the logic added here will reset the model last byte.
In addition strncat does not need the src to be null terminated, the change does not compile even.
NACK to this change.

Thanks,
Krishna
