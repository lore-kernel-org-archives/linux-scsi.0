From: dann frazier <dann.frazier@canonical.com>
Subject: Re: [PATCH] scsi: libsas: Fix rphy phy_identifier for PHYs with end
 devices attached
Date: Fri, 15 Feb 2019 13:44:15 -0700
Message-ID: <20190215204415.GA1006@xps13.dannf>
References: <1550162277-17615-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1550162277-17615-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, yanaijie@huawei.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 15, 2019 at 12:37:57AM +0800, John Garry wrote:
> The sysfs phy_identifier attribute for a sas_end_device comes
> from the rphy phy_identifier value.
> 
> Currently this is not being set for rphys with an end device attached,
> so we see incorrect symlinks from systemd disk/by-path:
> 
> root@localhost:~# ls -l /dev/disk/by-path/
> total 0
> lrwxrwxrwx 1 root root  9 Feb 13 12:26 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy0-lun-0 -> ../../sdb
> lrwxrwxrwx 1 root root 10 Feb 13 12:26 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy0-lun-0-part1 -> ../../sdb1
> lrwxrwxrwx 1 root root 10 Feb 13 12:26 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy0-lun-0-part2 -> ../../sdb2
> lrwxrwxrwx 1 root root 10 Feb 13 12:26 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy0-lun-0-part3 -> ../../sdc3
> 
> Indeed, each sas_end_device phy_identifier value is 0:
> 
> root@localhost:/# more sys/class/sas_device/end_device-0\:0\:2/phy_identifier
> 0
> root@localhost:/# more sys/class/sas_device/end_device-0\:0\:10/phy_identifier
> 0
> 
> This patch fixes the discovery code to set the phy_identifier.
> With this, we now get proper symlinks:
> 
> root@localhost:~# ls -l /dev/disk/by-path/
> total 0
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy10-lun-0 -> ../../sdg
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy11-lun-0 -> ../../sdh
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy2-lun-0 -> ../../sda
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy2-lun-0-part1 -> ../../sda1
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy3-lun-0 -> ../../sdb
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy3-lun-0-part1 -> ../../sdb1
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy3-lun-0-part2 -> ../../sdb2
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy4-lun-0 -> ../../sdc
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy4-lun-0-part1 -> ../../sdc1
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy4-lun-0-part2 -> ../../sdc2
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy4-lun-0-part3 -> ../../sdc3
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy5-lun-0 -> ../../sdd
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy7-lun-0 -> ../../sde
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy7-lun-0-part1 -> ../../sde1
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy7-lun-0-part2 -> ../../sde2
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy7-lun-0-part3 -> ../../sde3
> lrwxrwxrwx 1 root root  9 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy8-lun-0 -> ../../sdf
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy8-lun-0-part1 -> ../../sdf1
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy8-lun-0-part2 -> ../../sdf2
> lrwxrwxrwx 1 root root 10 Feb 13 11:53 platform-HISI0162:01-sas-exp0x500e004aaaaaaa1f-phy8-lun-0-part3 -> ../../sdf3
> 
> Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
> Reported-by: dann frazier <dann.frazier@canonical.com>

Thanks John. Solves the problem for me as well.

Tested-by: dann frazier <dann.frazier@canonical.com>

  -dann

> Signed-off-by: John Garry <john.garry@huawei.com>
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 17eb4185f29d..f21c93bbb35c 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -828,6 +828,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>  		rphy = sas_end_device_alloc(phy->port);
>  		if (!rphy)
>  			goto out_free;
> +		rphy->identify.phy_identifier = phy_id;
>  
>  		child->rphy = rphy;
>  		get_device(&rphy->dev);
> @@ -854,6 +855,7 @@ static struct domain_device *sas_ex_discover_end_dev(
>  
>  		child->rphy = rphy;
>  		get_device(&rphy->dev);
> +		rphy->identify.phy_identifier = phy_id;
>  		sas_fill_in_rphy(child, rphy);
>  
>  		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
