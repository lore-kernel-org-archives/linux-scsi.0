From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: [PATCH 31/35] qla2xxx: Disable PCI device in shutdown handler.
Date: Wed, 24 Sep 2014 09:48:58 -0400
Message-ID: <20140924094858.1c51718d@jlaw-desktop.mno.stratus.com>
References: <1411542518-2477-1-git-send-email-saurav.kashyap@qlogic.com>
	<1411542518-2477-32-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c11o141.mxlogic.net ([208.65.144.74]:38800 "EHLO
	p02c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbaIXNvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 09:51:09 -0400
In-Reply-To: <1411542518-2477-32-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>, andrew.vasquez@qlogic.com
Cc: jbottomley@parallels.com, hch@lst.de, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Wed, 24 Sep 2014 03:08:34 -0400
Saurav Kashyap <saurav.kashyap@qlogic.com> wrote:

> From: Chad Dupuis <chad.dupuis@qlogic.com>
> 
> Disable the PCI device during shutdown to prevent any races with
> other PCI code such as the AER handling code.
> 
> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
> Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
> ---
>  drivers/scsi/qla2xxx/qla_os.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 08c8e9c..70445bc 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3037,6 +3037,9 @@ qla2x00_shutdown(struct pci_dev *pdev)
>  	qla2x00_free_irqs(vha);
>  
>  	qla2x00_free_fw_dump(ha);
> +
> +	pci_disable_pcie_error_reporting(pdev);
> +	pci_disable_device(pdev);
>  }
>  
>  /* Deletes all the virtual ports for a given ha */

Hi Saurav,

Just curious if there were any bug report instances to go along with
this patch?  (Or a short explanation of the race.)

Thanks,

-- Joe
