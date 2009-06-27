From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan
 is enabled
Date: Sat, 27 Jun 2009 12:52:07 -0500
Message-ID: <4A465C47.8050100@cs.wisc.edu>
References: <200906262217.n5QMHTXg006358@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60754 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755661AbZF0RwO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Jun 2009 13:52:14 -0400
In-Reply-To: <200906262217.n5QMHTXg006358@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org, kxie@chelsio.com, James.Bottomley@HansenPartnership.com

On 06/26/2009 05:17 PM, kxie@chelsio.com wrote:
> [PATCH 2.6.30-rc] cxgb3i -- fixed connection error when vlan is enabled
>
> From: Karen Xie<kxie@chelsio.com>
>
> There is a bug when VLAN is configured on the cxgb3 interface, the iscsi
> conn. would be denied with message "cxgb3i: NOT going through cxgbi device."
>
> This patch added code to get the real egress net_device when vlan is configured.
>
> Signed-off-by: Karen Xie<kxie@chelsio.com>
> ---
>
>   drivers/scsi/cxgb3i/cxgb3i_iscsi.c |    4 ++++
>   1 files changed, 4 insertions(+), 0 deletions(-)
>
>
> diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> index 04a4374..60013a4 100644
> --- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> +++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
> @@ -13,6 +13,7 @@
>
>   #include<linux/inet.h>
>   #include<linux/crypto.h>
> +#include<linux/if_vlan.h>
>   #include<net/tcp.h>
>   #include<scsi/scsi_cmnd.h>
>   #include<scsi/scsi_device.h>
> @@ -183,6 +184,9 @@ static struct cxgb3i_hba *cxgb3i_hba_find_by_netdev(struct net_device *ndev)
>   	struct cxgb3i_adapter *snic;
>   	int i;
>
> +	if (ndev->priv_flags&  IFF_802_1Q_VLAN)
> +		ndev = vlan_dev_real_dev(ndev);
> +
>   	read_lock(&cxgb3i_snic_rwlock);
>   	list_for_each_entry(snic,&cxgb3i_snic_list, list_head) {
>   		for (i = 0; i<  snic->hba_cnt; i++) {
>

It looks ok, but when touching network stuff you might want to cc the 
netdev list in the future. Well, maybe for non-trivial stuff at least. 
This might be fine.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
