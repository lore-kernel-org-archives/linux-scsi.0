From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v1 3/4] tcmu: Make dev_size configurable via userspace
Date: Mon, 29 May 2017 15:01:17 -0500
Message-ID: <592C7E0D.5060600@redhat.com>
References: <1495808843-40222-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1495808843-40222-4-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1495808843-40222-4-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/26/2017 09:27 AM, Bryant G. Ly wrote:
> Allow tcmu backstores to be able to set the device size
> after it has been configured via set attribute.
> 
> Part of support in userspace to support certain backstores
> changing device size.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_user.c | 59 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index ae91822..c8c84b7 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1548,6 +1548,44 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
>  }
>  CONFIGFS_ATTR(tcmu_, cmd_time_out);
>  
> +static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +
> +	return snprintf(page, PAGE_SIZE, "%zu\n", udev->dev_size);
> +}
> +
> +static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
> +				   size_t count)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +	unsigned long val;
> +	int ret;
> +
> +	ret = kstrtoul(page, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +	udev->dev_size = val;
> +
> +	/* Check if device has been configured before */
> +	if (tcmu_dev_configured(udev)) {
> +		ret = tcmu_netlink_event(TCMU_CMD_RECONFIG_DEVICE,


If we send an event for each attribute changed, maybe we want to add a
type or more info about the attr being changed, so userspace can easily
figure it out and it does not have to rescan everything multiple times.

Or maybe we just want to add a reconfig attr or control opt where after
userspace has reconfigured everything it wanted to runner can rescan
everything and updates itself.
