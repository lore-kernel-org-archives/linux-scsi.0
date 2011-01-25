From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3] target: Reaquire hba_lock + se_port_lock during
 se_clear_dev_ports continue
Date: Tue, 25 Jan 2011 01:08:17 +0100
Message-ID: <20110125010817.2baee6cf@stein>
References: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
	<1295901446-17089-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:45669 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1AYAIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jan 2011 19:08:25 -0500
In-Reply-To: <1295901446-17089-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>

On Jan 24 Nicholas A. Bellinger wrote:
> From: Fubo Chen <fubo.chen@gmail.com>
> 
> This patch reaquires hba->device_lock and dev->se_port_lock in
> se_clear_dev_ports() if lun->lun_se_dev is NULL and we need
> to continue in dev->dev_sep_list.
> 
> Signed-off-by: Fubo Chen <fubo.chen@gmail.com>
> Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/target/target_core_device.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 95dfe3a..02b835f 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -796,6 +796,8 @@ void se_clear_dev_ports(struct se_device *dev)
>  		spin_lock(&lun->lun_sep_lock);
>  		if (lun->lun_se_dev == NULL) {
>  			spin_unlock(&lun->lun_sep_lock);
> +			spin_lock(&hba->device_lock);
> +			spin_lock(&dev->se_port_lock);
>  			continue;
>  		}
>  		spin_unlock(&lun->lun_sep_lock);

The patch might be OK.  But the code that it fixed is... stunning.

void se_clear_dev_ports(struct se_device *dev)
{
	struct se_hba *hba = dev->se_hba;
	struct se_lun *lun;
	struct se_portal_group *tpg;
	struct se_port *sep, *sep_tmp;

	spin_lock(&dev->se_port_lock);
	list_for_each_entry_safe(sep, sep_tmp, &dev->dev_sep_list, sep_list) {
		spin_unlock(&dev->se_port_lock);
		spin_unlock(&hba->device_lock);

		lun = sep->sep_lun;
		tpg = sep->sep_tpg;
		spin_lock(&lun->lun_sep_lock);
		if (lun->lun_se_dev == NULL) {
			spin_unlock(&lun->lun_sep_lock);
			continue;
		}
		spin_unlock(&lun->lun_sep_lock);

		core_dev_del_lun(tpg, lun->unpacked_lun);

		spin_lock(&hba->device_lock);
		spin_lock(&dev->se_port_lock);
	}
	spin_unlock(&dev->se_port_lock);

	return;
}

Can this mess of releasing and reacquiring locks --- which looks all rather
dangerous --- be cleaned up if you move the logical units (?) to be deleted
over to a secondary list?
-- 
Stefan Richter
-=====-==-== ---= ==--=
http://arcgraph.de/sr/
