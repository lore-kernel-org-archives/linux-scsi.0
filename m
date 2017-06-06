From: Mike Christie <mchristi@redhat.com>
Subject: Re: [PATCH v2 4/5] tcmu: Make dev_config configurable
Date: Mon, 5 Jun 2017 21:02:30 -0500
Message-ID: <59360D36.3030604@redhat.com>
References: <1496169080-58746-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1496169080-58746-5-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1496169080-58746-5-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 05/30/2017 01:31 PM, Bryant G. Ly wrote:
> This allows for userspace to change the device path after
> it has been created. Thus giving the user the ability to change
> the path. The use case for this is to allow for virtual optical
> to have media change.
> 
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/target/target_core_user.c | 41 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index c8c84b7..7575bc9 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1548,6 +1548,46 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
>  }
>  CONFIGFS_ATTR(tcmu_, cmd_time_out);
>  
> +static ssize_t tcmu_dev_path_show(struct config_item *item, char *page)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +
> +	return snprintf(page, PAGE_SIZE, "%s\n", udev->dev_config);
> +}
> +
> +static ssize_t tcmu_dev_path_store(struct config_item *item, const char *page,
> +				   size_t count)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +	char *copy = NULL;
> +	int ret;
> +
> +	copy = kstrdup(page, GFP_KERNEL);
> +	if (!copy) {
> +		kree(copy);
> +		return -EINVAL;
> +	}
> +	strcpy(udev->dev_config, copy);


I think we need to do strlcpy with TCMU_CONFIG_LEN here.
