From: Chris J Arges <chris.j.arges@canonical.com>
Subject: Re: [PATCH v2] mptfusion: enable no_write_same for vmware scsi disks
Date: Mon, 22 Sep 2014 15:54:51 -0500
Message-ID: <54208C9B.9000504@canonical.com>
References: <20140922181929.GA11319@infradead.org> <1411418701-25025-1-git-send-email-chris.j.arges@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:37777 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbaIVUyw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Sep 2014 16:54:52 -0400
In-Reply-To: <1411418701-25025-1-git-send-email-chris.j.arges@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: bruce.lucas@mongodb.com, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, adam.radford@avagotech.com, kashyap.desai@avagotech.com

On 09/22/2014 03:44 PM, Chris J Arges wrote:
> When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
> data can be improperly zeroed out using the mptfusion driver. This patch
> disables write_same for this driver and the vmware subsystem_vendor which
> ensures that manual zeroing out is used instead.
> 
> BugLink: http://bugs.launchpad.net/bugs/1371591
> Reported-by: Bruce Lucas <bruce.lucas@mongodb.com>
> Tested-by: Chris J Arges <chris.j.arges@canonical.com>
> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> ---
>  drivers/message/fusion/mptspi.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 787933d..fca1594 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -1409,6 +1409,12 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  		return 0;
>  	}
>  
> +	/* Fix for vmware guests that do not implement write_same
> +         */
> +	if (pdev->subsystem_vendor == 0x15AD) {
> +		mptspi_driver_template.no_write_same = 1;
> +	}
> +
>  	sh = scsi_host_alloc(&mptspi_driver_template, sizeof(MPT_SCSI_HOST));
>  
>  	if (!sh) {
> 

This is a do-no-harm patch, with a case to check for vmware
subsystem_vendor as suggested by Christoph. Let me know if there are
issues with this patch (do I need a define for the vendor ID? Is the
comment a little too vague or unnecessary?)

Adding those that were CC'ed in the other part of the thread.

Thanks,
--chris j arges
