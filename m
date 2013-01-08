From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v11 3/9] libata: identify and init ZPODD devices
Date: Tue, 08 Jan 2013 17:07:46 +0800
Message-ID: <50EBE1E2.5080406@intel.com>
References: <1357440509-28108-1-git-send-email-aaron.lu@intel.com> <1357440509-28108-4-git-send-email-aaron.lu@intel.com> <20130107182052.GP3926@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20130107182052.GP3926@htj.dyndns.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Aaron Lu <aaron.lwe@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 01/08/2013 02:20 AM, Tejun Heo wrote:
> On Sun, Jan 06, 2013 at 10:48:23AM +0800, Aaron Lu wrote:
>> diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
>> index ef01ac0..5aa7322 100644
>> --- a/drivers/ata/libata-acpi.c
>> +++ b/drivers/ata/libata-acpi.c
>> @@ -1063,6 +1063,8 @@ void ata_acpi_bind(struct ata_device *dev)
>>  
>>  void ata_acpi_unbind(struct ata_device *dev)
>>  {
>> +	if (zpodd_dev_enabled(dev))
>> +		zpodd_exit(dev);
>>  	ata_acpi_remove_pm_notifier(dev);
>>  	ata_acpi_unregister_power_resource(dev);
>>  }
> 
> Wouldn't it make more sense to invoke zpodd_exit() from
> ata_scsi_remove_dev() which is approximate counterpart of
> dev_configure?

Yes, I agree.

> 
>> +struct zpodd {
>> +	bool slot:1;
>> +	bool drawer:1;
>> +
>> +	struct ata_device *dev;
>> +};
> 
> Field names are usually indented.  It would be nice to have a comment

checkscript.sh doesn't seem like this if I put a tab around the ':'

ERROR: spaces prohibited around that ':' (ctx:VxW)
#222: FILE: include/uapi/linux/cdrom.h:915:
+	__u8 reserved1:		2;
 	              ^

Which style should I follow?

> explaining synchronization.  Bitfields w/ their implicit RMW ops tend
> to make people wonder about what the access rules are.

The slot and drawer bit field is assigned only once during ata probe
time in EH context, and accessed later in PM's callback context.
Not sure what access rule should I describe...

> 
>> +static int run_atapi_cmd(struct ata_device *dev, const char *cdb,
>> +		unsigned short cdb_len, char *buf, unsigned int buf_len)
>> +{
>> +	struct ata_taskfile tf = {0};
> 
> No need for 0.  { } is enough and more generic.

Thanks for the info.

> 
>> +
>> +	tf.flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
>> +	tf.command = ATA_CMD_PACKET;
>> +
>> +	if (buf) {
>> +		tf.protocol = ATAPI_PROT_PIO;
>> +		tf.lbam = buf_len;
>> +	} else {
>> +		tf.protocol = ATAPI_PROT_NODATA;
>> +	}
>> +
>> +	return ata_exec_internal(dev, &tf, cdb,
>> +			buf ? DMA_FROM_DEVICE : DMA_NONE, buf, buf_len, 0);
>> +}
> 
> So, the function name is a bit of misnomer given that ATAPI commands
> are not limited to PIO or DMA_FROM_DEVICE.  Also, this function ends
> up being used twice - once w/ read buffer and once w/o.  Do we really
> want this function?  It's not like exec_internal is difficult to use.

Then I'll remove this function.

> 
>> +/*
>> + * Per the spec, only slot type and drawer type ODD can be supported
>> + *
>> + * Return 0 for slot type, 1 for drawer, -ENODEV for other types or on error.
>> + */
> 
> Maybe bool odd_has_drawer() is better?

There are other types of ODD other than slot and drawer, and both slot
and drawer type ODDs can be supported for ZPODD. So a bool can't convey
such information :-)

> 
>> +static int check_loading_mechanism(struct ata_device *dev)
>> +{
>> +	char buf[16];
>> +	unsigned int ret;
>> +	struct rm_feature_desc *desc = (void *)(buf + 8);
>> +
>> +	char cdb[] = {  GPCMD_GET_CONFIGURATION,
>> +			2,      /* only 1 feature descriptor requested */
>> +			0, 3,   /* 3, removable medium feature */
>> +			0, 0, 0,/* reserved */
>> +			0, sizeof(buf),
>> +			0, 0, 0,
>> +	};
>> +
>> +	ret = run_atapi_cmd(dev, cdb, sizeof(cdb), buf, sizeof(buf));
>> +	if (ret)
>> +		return -ENODEV;
>> +
>> +	if (be16_to_cpu(desc->feature_code) != 3)
>> +		return -ENODEV;
>> +
>> +	if (desc->mech_type == 0 && desc->load == 0 && desc->eject == 1)
>> +		return 0; /* slot */
>> +	else if (desc->mech_type == 1 && desc->load == 0 && desc->eject == 1)
>> +		return 1; /* drawer */
>> +	else
>> +		return -ENODEV;
>> +}
>> +
>> +static bool odd_can_poweroff(struct ata_device *ata_dev)
>> +{
>> +	acpi_handle handle;
>> +	acpi_status status;
>> +	struct acpi_device *acpi_dev;
>> +
>> +	handle = ata_dev_acpi_handle(ata_dev);
>> +	if (!handle)
>> +		return false;
>> +
>> +	status = acpi_bus_get_device(handle, &acpi_dev);
>> +	if (ACPI_FAILURE(status))
>> +		return false;
>> +
>> +	return acpi_device_can_poweroff(acpi_dev);
>> +}
>> +
>> +void zpodd_init(struct ata_device *dev)
>> +{
>> +	int ret;
>> +	struct zpodd *zpodd;
>> +
>> +	if (dev->zpodd)
>> +		return;
>> +
>> +	if (!odd_can_poweroff(dev))
>> +		return;
>> +
>> +	if ((ret = check_loading_mechanism(dev)) == -ENODEV)
>> +		return;
>> +
>> +	zpodd = kzalloc(sizeof(struct zpodd), GFP_KERNEL);
>> +	if (!zpodd)
>> +		return;
>> +
>> +	if (ret)
>> +		zpodd->drawer = true;
>> +	else
>> +		zpodd->slot = true;
>> +
>> +	zpodd->dev = dev;
>> +	dev->zpodd = zpodd;
>> +}
>> +
>> +void zpodd_exit(struct ata_device *dev)
>> +{
>> +	kfree(dev->zpodd);
>> +	dev->zpodd = NULL;
>> +}
>> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
>> index 7148a58..8cb4372 100644
>> --- a/drivers/ata/libata.h
>> +++ b/drivers/ata/libata.h
>> @@ -230,4 +230,18 @@ static inline void ata_sff_exit(void)
>>  { }
>>  #endif /* CONFIG_ATA_SFF */
>>  
>> +/* libata-zpodd.c */
>> +#ifdef CONFIG_SATA_ZPODD
>> +void zpodd_init(struct ata_device *dev);
>> +void zpodd_exit(struct ata_device *dev);
>> +static inline bool zpodd_dev_enabled(struct ata_device *dev)
>> +{
>> +	return dev->zpodd ? true : false;
> 
> 	return dev->zpodd or return dev->zpodd != NULL?
> 
> Other than the above nits, looks okay to me.

Thanks a lot for the review.

-Aaron
