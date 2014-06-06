From: Michael Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/1] be2iscsi: remove potential junk pointer free
Date: Fri, 6 Jun 2014 12:08:27 -0500
Message-ID: <547C4D6C-7E34-484D-9439-FE57096E5796@cs.wisc.edu>
References: <5391B294.5020104@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58851 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaFFRIi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2014 13:08:38 -0400
In-Reply-To: <5391B294.5020104@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, jayamohank@gmail.com, sony.john-n@emulex.com


On Jun 6, 2014, at 7:22 AM, Tomas Henzl <thenzl@redhat.com> wrote:

> commit 0e7c60c [SCSI] be2iscsi: fix memory leak in error path
> fixed an potential junk pointer free if  mgmt_get_if_info() returned an error
> 
> fix it on one more place
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
> diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
> index 6045aa7..07934b0 100644
> --- a/drivers/scsi/be2iscsi/be_mgmt.c
> +++ b/drivers/scsi/be2iscsi/be_mgmt.c
> @@ -1008,10 +1008,8 @@ int mgmt_set_ip(struct beiscsi_hba *phba,
> 		BE2_IPV6 : BE2_IPV4 ;
> 
> 	rc = mgmt_get_if_info(phba, ip_type, &if_info);
> -	if (rc) {
> -		kfree(if_info);
> +	if (rc)
> 		return rc;
> -	}
> 
> 	if (boot_proto == ISCSI_BOOTPROTO_DHCP) {
> 		if (if_info->dhcp_state) {

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

