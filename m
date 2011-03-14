From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/13] qla4xxx: Prevent other port reinitialization during
 remove_adapter
Date: Mon, 14 Mar 2011 17:07:04 -0500
Message-ID: <4D7E9188.8010606@cs.wisc.edu>
References: <5E4F49720D0BAD499EE1F01232234BA872263B150C@AVEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:43570 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab1CNWHO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Mar 2011 18:07:14 -0400
In-Reply-To: <5E4F49720D0BAD499EE1F01232234BA872263B150C@AVEXMB1.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

On 03/14/2011 12:24 AM, Vikas Chaudhary wrote:
> index 6068f80..59c5552 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -27,6 +27,11 @@ static char qla4xxx_version_str[40];
>   static struct kmem_cache *srb_cachep;
>
>   /*
> + * List of host adapters
> + */
> +static struct klist qla4xxx_hostlist;
> +



>
>   /**
> + * qla4xxx_prevent_other_port_reinit - Mark the other ISP-4xxx port to indicate
> + * that the driver is being removed, so that the other port will not
> + * re-initialize while in the process of removing the ha due to driver unload
> + * or hba hotplug.

For docbook comments you use a one line description on the first line, 
then add more informative stuff after the params.


> + * @ha: pointer to adapter structure
> + **/
> +static void qla4xxx_prevent_other_port_reinit(struct scsi_qla_host *ha)
> +{
> +       struct scsi_qla_host *ha_listp;
> +       struct klist_iter i;
> +       struct klist_node *n;
> +
> +       klist_iter_init(&qla4xxx_hostlist,&i);
> +       while ((n = klist_next(&i)) != NULL) {
> +               ha_listp = container_of(n, struct scsi_qla_host, node);
> +               if (ha == ha_listp)
> +                       continue;
> +
> +               if ((pci_domain_nr(ha->pdev->bus) ==
> +                   pci_domain_nr(ha_listp->pdev->bus))&&
> +                   (ha->pdev->bus->number ==
> +                   ha_listp->pdev->bus->number)&&
> +                   (PCI_SLOT(ha->pdev->devfn) ==
> +                   PCI_SLOT(ha_listp->pdev->devfn))) {
> +

Is there a qla4xxx specific reason why you need to prevent other ports 
from re-initing when removing a port? Does the hardware cause the other 
ports to be disrupted and that causes them to run the re-init code?
