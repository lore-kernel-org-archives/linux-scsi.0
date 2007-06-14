From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla4xxx: allow hba to be online when initiator ip	address
 is uninitialized
Date: Thu, 14 Jun 2007 01:54:20 -0400
Message-ID: <4670D80C.2090708@cs.wisc.edu>
References: <1181348961.8711.4.camel@q-iscsi-upstream.site> <1181349436.8711.8.camel@q-iscsi-upstream.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60562 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbXFNGyd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jun 2007 02:54:33 -0400
In-Reply-To: <1181349436.8711.8.camel@q-iscsi-upstream.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David C Somayajulu <david.somayajulu@qlogic.com>
Cc: linux-scsi@vger.kernel.org, David Wagner <david.wagner@qlogic.com>

David C Somayajulu wrote:
> On Fri, 2007-06-08 at 17:29 -0700, David C Somayajulu wrote:
>> This patch provides the following:
>> 1. remove warning ignoring the return value of pci_set_mwi()
>> 2. allows HBA to be online when the initiator ip address is uninitialized.
> Including 
> 
> Signed-off-by: David Somayajulu <david.somayajulu@qlogic.com>
> 
>  drivers/scsi/qla4xxx/ql4_init.c |   23 +++++++++++------------
>  1 files changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
> index d8c064c..1e29f51 100644
> --- a/drivers/scsi/qla4xxx/ql4_init.c
> +++ b/drivers/scsi/qla4xxx/ql4_init.c
> @@ -883,11 +883,12 @@ static int qla4xxx_config_nvram(struct s
>  static void qla4x00_pci_config(struct scsi_qla_host *ha)
>  {
>  	uint16_t w;
> +	int status;
>  
>  	dev_info(&ha->pdev->dev, "Configuring PCI space...\n");
>  
>  	pci_set_master(ha->pdev);
> -	pci_set_mwi(ha->pdev);
> +	status = pci_set_mwi(ha->pdev);


It looks ok, but creating the status variable and setting it like this,
just to quiet the compile warning, and never doing anything else with it
doesn't seem nice.
