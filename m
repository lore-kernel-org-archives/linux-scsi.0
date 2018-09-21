From: Sayali Lokhande <sayalil@codeaurora.org>
Subject: Re: [PATCH V13 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Fri, 21 Sep 2018 17:16:17 +0530
Message-ID: <dad90758-04d8-f30e-a456-15217c90ff7c@codeaurora.org>
References: <1536918159-311-1-git-send-email-sayalil@codeaurora.org>
 <1536918159-311-3-git-send-email-sayalil@codeaurora.org>
 <CAE=gft5Hfstqe38daPAGncjZjdnfL-+Fv7QGSvLtBWc7BFzwPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAE=gft5Hfstqe38daPAGncjZjdnfL-+Fv7QGSvLtBWc7BFzwPg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Evan Green <evgreen@chromium.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, stummala@codeaurora.org, adrian.hunter@intel.com, Joel Becker <jlbec@evilplan.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On 9/19/2018 2:26 AM, Evan Green wrote:
> On Fri, Sep 14, 2018 at 2:43 AM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>> This patch adds configfs support to provision UFS device at
>> runtime. This feature can be primarily useful in factory or
>> assembly line as some devices may be required to be configured
>> multiple times during initial system development phase.
>> Configuration Descriptors can be written multiple times until
>> bConfigDescrLock attribute is zero.
>>
>> Configuration descriptor buffer consists of Device and Unit
>> descriptor configurable parameters which are parsed from vendor
>> specific provisioning file and then passed via configfs node at
>> runtime to provision ufs device.
>> CONFIG_CONFIGFS_FS and CONFIG_UFS_PROVISION needs to be enabled
>> for using this feature.
>>
>> Usage:
>> 1) To read current configuration descriptor with index X
>>     (where index X can be 0/1/2/3) :
>>     cat /config/<device_name>/ufs_config_desc_X
>>
>> 2) To write configuration descriptor with index X :
>>     echo <config_desc_buf> > /config/<device_name>/ufs_config_desc_X
>>
>> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
>> ---
> ...
>> diff --git a/drivers/scsi/ufs/ufs-configfs.c b/drivers/scsi/ufs/ufs-configfs.c
>> new file mode 100644
>> index 0000000..84ccb1a
>> --- /dev/null
>> +++ b/drivers/scsi/ufs/ufs-configfs.c
>> @@ -0,0 +1,237 @@
> ...
>> +static ssize_t ufs_config_desc_0_show(struct config_item *item, char *buf)
>> +{
>> +       return ufs_config_desc_show(item, buf, 0);
>> +}
>> +
>> +static ssize_t ufs_config_desc_0_store(struct config_item *item,
>> +                                      const char *buf, size_t count)
>> +{
>> +       return ufshcd_desc_configfs_store(item, buf, count, 0);
>> +}
>> +
>> +static ssize_t ufs_config_desc_1_show(struct config_item *item, char *buf)
>> +{
>> +       return ufs_config_desc_show(item, buf, 1);
>> +}
>> +
>> +static ssize_t ufs_config_desc_1_store(struct config_item *item,
>> +                                      const char *buf, size_t count)
>> +{
>> +       return ufshcd_desc_configfs_store(item, buf, count, 1);
>> +}
>> +
>> +static ssize_t ufs_config_desc_2_show(struct config_item *item, char *buf)
>> +{
>> +       return ufs_config_desc_show(item, buf, 2);
>> +}
>> +
>> +static ssize_t ufs_config_desc_2_store(struct config_item *item,
>> +                                      const char *buf, size_t count)
>> +{
>> +       return ufshcd_desc_configfs_store(item, buf, count, 2);
>> +}
>> +
>> +static ssize_t ufs_config_desc_3_show(struct config_item *item, char *buf)
>> +{
>> +       return ufs_config_desc_show(item, buf, 3);
>> +}
>> +
>> +static ssize_t ufs_config_desc_3_store(struct config_item *item,
>> +                                      const char *buf, size_t count)
>> +{
>> +       return ufshcd_desc_configfs_store(item, buf, count, 3);
>> +}
>> +
> The copypasta above and below is not my favorite, but I suppose it's
> either this or wrap it all up in a macro that you stamp down 4 times.
> I'm not sure if that's really any cleaner, so I guess this is fine.
>
>> +static struct configfs_attribute ufshcd_attr_provision_0 = {
>> +       .ca_name        = "ufs_config_desc_0",
>> +       .ca_mode        = 0644,
>> +       .ca_owner       = THIS_MODULE,
>> +       .show           = ufs_config_desc_0_show,
>> +       .store          = ufs_config_desc_0_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_1 = {
>> +       .ca_name        = "ufs_config_desc_1",
>> +       .ca_mode        = 0644,
>> +       .ca_owner       = THIS_MODULE,
>> +       .show           = ufs_config_desc_1_show,
>> +       .store          = ufs_config_desc_1_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_2 = {
>> +       .ca_name        = "ufs_config_desc_2",
>> +       .ca_mode        = 0644,
>> +       .ca_owner       = THIS_MODULE,
>> +       .show           = ufs_config_desc_2_show,
>> +       .store          = ufs_config_desc_2_store,
>> +};
>> +
>> +static struct configfs_attribute ufshcd_attr_provision_3 = {
>> +       .ca_name        = "ufs_config_desc_3",
>> +       .ca_mode        = 0644,
>> +       .ca_owner       = THIS_MODULE,
>> +       .show           = ufs_config_desc_3_show,
>> +       .store          = ufs_config_desc_3_store,
>> +};
>> +
>> +static struct configfs_attribute *ufshcd_attrs[] = {
>> +       &ufshcd_attr_provision_0,
>> +       &ufshcd_attr_provision_1,
>> +       &ufshcd_attr_provision_2,
>> +       &ufshcd_attr_provision_3,
>> +       NULL,
>> +};
>> +
>> +static struct config_item_type ufscfg_type = {
>> +       .ct_attrs       = ufshcd_attrs,
>> +       .ct_owner       = THIS_MODULE,
>> +};
>> +
>> +void ufshcd_configfs_init(struct ufs_hba *hba, const char *name)
>> +{
>> +       int ret;
>> +       struct config_item *cg_item;
>> +       struct configfs_subsystem *subsys;
>> +
>> +       cg_item = &hba->subsys.su_group.cg_item;
>> +       sprintf(cg_item->ci_namebuf, "%s", name);
> CONFIGFS_ITEM_NAME_LEN is only 20. Is there anything preventing the
> device name passed in here from being longer than that? You'd have a
> nasty overrun on your hands if not. Maybe snprintf here?
Agree. I need to use snprintf here. Will update.
>> +       cg_item->ci_type = &ufscfg_type;
>> +
>> +       subsys = &hba->subsys;
>> +       config_group_init(&subsys->su_group);
>> +       mutex_init(&subsys->su_mutex);
>> +       ret = configfs_register_subsystem(subsys);
>> +       if (ret)
>> +               pr_err("Error %d while registering subsystem %s\n",
>> +                      ret,
>> +                      subsys->su_group.cg_item.ci_namebuf);
>> +}
>> +
>> +void ufshcd_configfs_exit(struct ufs_hba *hba)
>> +{
>> +       configfs_unregister_subsystem(&hba->subsys);
>> +}
