From: Sagi Grimberg <sagig@mellanox.com>
Subject: Re: [PATCH 09/14] target/configfs: Expose protection device attributes
Date: Thu, 9 Jan 2014 13:01:15 +0200
Message-ID: <52CE817B.9070203@mellanox.com>
References: <1389212157-14540-1-git-send-email-nab@daterainc.com> <1389212157-14540-10-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1389212157-14540-10-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Or Gerlitz <ogerlitz@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/8/2014 10:36 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds support for exposing DIF protection device
> attributes via configfs.  This includes:
>
>     pi_prot_type: Protection Type (0, 1, 3 currently support)
>     pi_prot_version: Protection Version (DIF v1 currently supported)
>     pi_guard_type: Guard Type (1=DIF CRC, 2=IP CRC)
>
> Within se_dev_set_pi_prot_type() it also adds the se_subsystem_api
> device callbacks to setup per device protection information.

Suggestion, expose pi_prot_format and call transport->init_prot() there. 
It is more explicit
and this routine should be called upon getting FORMAT_UNIT as well.

> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_configfs.c |   12 ++++++
>   drivers/target/target_core_device.c   |   65 +++++++++++++++++++++++++++++++++
>   drivers/target/target_core_internal.h |    2 +
>   3 files changed, 79 insertions(+)
>
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 272755d..0f1101c 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -643,6 +643,15 @@ SE_DEV_ATTR(emulate_caw, S_IRUGO | S_IWUSR);
>   DEF_DEV_ATTRIB(emulate_3pc);
>   SE_DEV_ATTR(emulate_3pc, S_IRUGO | S_IWUSR);
>   
> +DEF_DEV_ATTRIB(pi_prot_type);
> +SE_DEV_ATTR(pi_prot_type, S_IRUGO | S_IWUSR);
> +
> +DEF_DEV_ATTRIB_RO(pi_prot_version);
> +SE_DEV_ATTR_RO(pi_prot_version);
> +
> +DEF_DEV_ATTRIB(pi_guard_type);
> +SE_DEV_ATTR(pi_guard_type, S_IRUGO | S_IWUSR);
> +
>   DEF_DEV_ATTRIB(enforce_pr_isids);
>   SE_DEV_ATTR(enforce_pr_isids, S_IRUGO | S_IWUSR);
>   
> @@ -702,6 +711,9 @@ static struct configfs_attribute *target_core_dev_attrib_attrs[] = {
>   	&target_core_dev_attrib_emulate_tpws.attr,
>   	&target_core_dev_attrib_emulate_caw.attr,
>   	&target_core_dev_attrib_emulate_3pc.attr,
> +	&target_core_dev_attrib_pi_prot_type.attr,
> +	&target_core_dev_attrib_pi_prot_version.attr,
> +	&target_core_dev_attrib_pi_guard_type.attr,
>   	&target_core_dev_attrib_enforce_pr_isids.attr,
>   	&target_core_dev_attrib_is_nonrot.attr,
>   	&target_core_dev_attrib_emulate_rest_reord.attr,
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 207b340..2b59beb 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -918,6 +918,67 @@ int se_dev_set_emulate_3pc(struct se_device *dev, int flag)
>   	return 0;
>   }
>   
> +int se_dev_set_pi_prot_type(struct se_device *dev, int flag)
> +{
> +	int rc, old_prot = dev->dev_attrib.pi_prot_type;
> +
> +	if (flag != 0 && flag != 1 && flag != 2 && flag != 3) {
> +		pr_err("Illegal value %d for pi_prot_type\n", flag);
> +		return -EINVAL;
> +	}
> +	if (flag == 2) {
> +		pr_err("DIF TYPE2 protection currently not supported\n");
> +		return -ENOSYS;
> +	}
> +	if (!dev->transport->init_prot || !dev->transport->free_prot) {
> +		pr_err("DIF protection not supported by backend: %s\n",
> +		       dev->transport->name);
> +		return -ENOSYS;
> +	}
> +	if (!(dev->dev_flags & DF_CONFIGURED)) {
> +		pr_err("DIF protection requires device to be configured\n");
> +		return -ENODEV;
> +	}
> +	if (dev->export_count) {
> +		pr_err("dev[%p]: Unable to change SE Device PROT type while"
> +		       " export_count is %d\n", dev, dev->export_count);
> +		return -EINVAL;
> +	}
> +
> +	dev->dev_attrib.pi_prot_type = flag;
> +
> +	if (flag && !old_prot) {
> +		rc = dev->transport->init_prot(dev);
> +		if (rc) {
> +			dev->dev_attrib.pi_prot_type = old_prot;
> +			return rc;
> +		}
> +	} else if (!flag && old_prot) {
> +		dev->transport->free_prot(dev);
> +	}
> +	pr_debug("dev[%p]: SE Device Protection Type: %d\n", dev, flag);
> +
> +	return 0;
> +}
> +
> +int se_dev_set_pi_guard_type(struct se_device *dev, int flag)
> +{
> +	if (flag != 1 && flag != 2) {
> +		pr_err("Illegal value %d for pi_guard_type\n", flag);
> +		return -EINVAL;
> +	}
> +	if (dev->export_count) {
> +		pr_err("dev[%p]: Unable to change SE Device GUARD type while"
> +		       " export_count is %d\n", dev, dev->export_count);
> +		return -EINVAL;
> +	}
> +
> +	dev->dev_attrib.pi_guard_type = flag;
> +	pr_debug("dev[%p]: SE Device Guard Type: %d\n", dev, flag);
> +
> +	return 0;
> +}
> +
>   int se_dev_set_enforce_pr_isids(struct se_device *dev, int flag)
>   {
>   	if ((flag != 0) && (flag != 1)) {
> @@ -1415,6 +1476,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>   	dev->dev_link_magic = SE_DEV_LINK_MAGIC;
>   	dev->se_hba = hba;
>   	dev->transport = hba->transport;
> +	dev->prot_length = sizeof(struct se_dif_v1_tuple);
>   
>   	INIT_LIST_HEAD(&dev->dev_list);
>   	INIT_LIST_HEAD(&dev->dev_sep_list);
> @@ -1455,6 +1517,9 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>   	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
>   	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
>   	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
> +	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
> +	dev->dev_attrib.pi_prot_version = TARGET_DIF_V1;
> +	dev->dev_attrib.pi_guard_type = TARGET_DIX_GUARD_CRC;
>   	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
>   	dev->dev_attrib.is_nonrot = DA_IS_NONROT;
>   	dev->dev_attrib.emulate_rest_reord = DA_EMULATE_REST_REORD;
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index 47b63b0..79d3bc3 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -35,6 +35,8 @@ int	se_dev_set_emulate_tpu(struct se_device *, int);
>   int	se_dev_set_emulate_tpws(struct se_device *, int);
>   int	se_dev_set_emulate_caw(struct se_device *, int);
>   int	se_dev_set_emulate_3pc(struct se_device *, int);
> +int	se_dev_set_pi_prot_type(struct se_device *, int);
> +int	se_dev_set_pi_guard_type(struct se_device *, int);
>   int	se_dev_set_enforce_pr_isids(struct se_device *, int);
>   int	se_dev_set_is_nonrot(struct se_device *, int);
>   int	se_dev_set_emulate_rest_reord(struct se_device *dev, int);
