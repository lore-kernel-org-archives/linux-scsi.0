From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH 07/12] qla4xxx: add qla4xxx async scan support
Date: Mon, 4 Feb 2008 10:22:29 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC070120BF1F@AVEXCH1.qlogic.org>
References: <12018082174157-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5854 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbYBDSWa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:22:30 -0500
Content-class: urn:content-classes:message
In-Reply-To: <12018082174157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

Mike Christie wrote:
> qla4xxx has the old school startup/probe where it finds 
> presetup sessions
> in its flash and then attempts to log into them before 
> returning from the
> probe. This however, makes it very simple to add a iscsi 
> class scan finished
> helper which the driver can use.
> 
> In future patches Dave or I will rip apart the driver to make it more
> like qla2xxx, but for now this is a very simple two line patch which
> fixes the problem of trying to figure out when the initial sessions
> are done being scanned.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c 
> b/drivers/scsi/qla4xxx/ql4_os.c
> index d4dd149..c3c59d7 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -89,6 +89,8 @@ static struct scsi_host_template 
> qla4xxx_driver_template = {
>  	.slave_alloc		= qla4xxx_slave_alloc,
>  	.slave_destroy		= qla4xxx_slave_destroy,
>  
> +	.scan_finished		= iscsi_scan_finished,
> +
>  	.this_id		= -1,
>  	.cmd_per_lun		= 3,
>  	.use_clustering		= ENABLE_CLUSTERING,
> @@ -1306,7 +1308,7 @@ static int __devinit 
> qla4xxx_probe_adapter(struct pci_dev *pdev,
>  	       qla4xxx_version_str, ha->pdev->device, 
> pci_name(ha->pdev),
>  	       ha->host_no, ha->firmware_version[0], 
> ha->firmware_version[1],
>  	       ha->patch_number, ha->build_number);
> -
> +	scsi_scan_host(host);
>  	return 0;
>  
>  remove_host:
> -- 
> 1.5.2.1
Acked by David Somayajulu <david.somayajulu@qlogic.com>
