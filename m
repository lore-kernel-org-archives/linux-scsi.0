From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 1/3] libosd: osd_dev_info: Unique Identification of an
 OSD device
Date: Thu, 17 Sep 2009 14:28:21 +0300
Message-ID: <4AB21D55.9040000@panasas.com>
References: <4AA4ED94.2050805@panasas.com>	 <1252322784-19390-1-git-send-email-bharrosh@panasas.com> <1253123262.4842.39.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dip-colo-pa.panasas.com ([67.152.220.67]:1194 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752209AbZIQL2W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 07:28:22 -0400
In-Reply-To: <1253123262.4842.39.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, open-osd <osd-dev@open-osd.org>

On 09/16/2009 08:47 PM, James Bottomley wrote:
> On Mon, 2009-09-07 at 14:26 +0300, Boaz Harrosh wrote:
>> Define an osd_dev_info structure that Uniquely identifies an OSD
>> device lun on the network. The identification is built from unique
>> target attributes and is the same for all network/SAN machines.
>>
>> osduld_info_lookup() - NEW
>>     New API that will lookup an osd_dev by its osd_dev_info.
>>     This is used by pNFS-objects for cross network global device
>>     identification.
>>
>> osduld_device_info() - NEW
>>     Given an osd_dev handle returns its associated osd_dev_info.
>>     This is used by exofs to encode the device information for
>>     network clients. (Get-device-info). The ULD fetches this
>>     information at startup and hangs it on each OSD device. (This is
>>     a fast operation that can be called at any condition)
>>
>> osd_auto_detect_ver() - REVISED
>>     Now returns an osd_dev_info structure. Is only called once
>>     by ULD as before. See added comments for how to use.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>> ---
>>  drivers/scsi/osd/osd_initiator.c |   22 +++++++++++----
>>  drivers/scsi/osd/osd_uld.c       |   53 +++++++++++++++++++++++++++++++++++++-
>>  include/scsi/osd_initiator.h     |   37 +++++++++++++++++++++++---
>>  3 files changed, 101 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
>> index 7a117c1..26e1b41 100644
>> --- a/drivers/scsi/osd/osd_initiator.c
>> +++ b/drivers/scsi/osd/osd_initiator.c
>> @@ -73,7 +73,8 @@ static const char *_osd_ver_desc(struct osd_request *or)
>>  
>>  #define ATTR_DEF_RI(id, len) ATTR_DEF(OSD_APAGE_ROOT_INFORMATION, id, len)
>>  
>> -static int _osd_print_system_info(struct osd_dev *od, void *caps)
>> +static int _osd_get_print_system_info(struct osd_dev *od,
>> +	void *caps, struct osd_dev_info *odi)
>>  {
>>  	struct osd_request *or;
>>  	struct osd_attr get_attrs[] = {
>> @@ -137,8 +138,13 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
>>  	OSD_INFO("PRODUCT_SERIAL_NUMBER  [%s]\n",
>>  		(char *)pFirst);
>>  
>> -	pFirst = get_attrs[a].val_ptr;
>> -	OSD_INFO("OSD_NAME               [%s]\n", (char *)pFirst);
>> +	odi->osdname_len = get_attrs[a].len;
>> +	if (odi->osdname_len) {
>> +		odi->osdname = kzalloc(odi->osdname_len + 1, GFP_KERNEL);
>> +		memcpy(odi->osdname, get_attrs[a].val_ptr, odi->osdname_len);
>> +	} else
>> +		odi->osdname = NULL;
>> +	OSD_INFO("OSD_NAME               [%s]\n", odi->osdname);
>>  	a++;
>>  
>>  	pFirst = get_attrs[a++].val_ptr;
>> @@ -171,6 +177,9 @@ static int _osd_print_system_info(struct osd_dev *od, void *caps)
>>  				   sid_dump, sizeof(sid_dump), true);
>>  		OSD_INFO("OSD_SYSTEM_ID(%d)\n"
>>  			 "        [%s]\n", len, sid_dump);
>> +
>> +		odi->systemid_len = len;
>> +		memcpy(odi->systemid, get_attrs[a].val_ptr, len);
>>  		a++;
>>  	}
>>  out:
>> @@ -178,16 +187,17 @@ out:
>>  	return ret;
>>  }
>>  
>> -int osd_auto_detect_ver(struct osd_dev *od, void *caps)
>> +int osd_auto_detect_ver(struct osd_dev *od,
>> +	void *caps, struct osd_dev_info *odi)
>>  {
>>  	int ret;
>>  
>>  	/* Auto-detect the osd version */
>> -	ret = _osd_print_system_info(od, caps);
>> +	ret = _osd_get_print_system_info(od, caps, odi);
>>  	if (ret) {
>>  		osd_dev_set_ver(od, OSD_VER1);
>>  		OSD_DEBUG("converting to OSD1\n");
>> -		ret = _osd_print_system_info(od, caps);
>> +		ret = _osd_get_print_system_info(od, caps, odi);
>>  	}
>>  
>>  	return ret;
>> diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
>> index 0bdef33..8c069f9 100644
>> --- a/drivers/scsi/osd/osd_uld.c
>> +++ b/drivers/scsi/osd/osd_uld.c
>> @@ -87,6 +87,7 @@ struct osd_uld_device {
>>  	struct osd_dev od;
>>  	struct gendisk *disk;
>>  	struct device *class_member;
>> +	struct osd_dev_info odi;
>>  };
>>  
>>  static void __uld_get(struct osd_uld_device *oud);
>> @@ -216,6 +217,48 @@ free_od:
>>  }
>>  EXPORT_SYMBOL(osduld_path_lookup);
>>  
>> +static inline bool _the_same_or_null(const u8 *a1, unsigned a1_len,
>> +				     const u8 *a2, unsigned a2_len)
>> +{
>> +	if (!a2_len) /* User string is Empty means don't care */
>> +		return true;
>> +
>> +	if (a1_len != a2_len)
>> +		return false;
>> +
>> +	return 0 == memcmp(a1, a2, a1_len);
>> +}
>> +
>> +struct osd_dev *osduld_info_lookup(const struct osd_dev_info *odi)
>> +{
>> +	unsigned i;
>> +
>> +	for (i = 0; i < SCSI_OSD_MAX_MINOR; i++) {
>> +		char dev_str[16];
>> +		struct osd_uld_device *oud;
>> +		struct osd_dev *od;
>> +
>> +		sprintf(dev_str, "/dev/osd%d", i);
> 
> Embedding specific forms user device paths into the kernel really looks
> wrong here ... why are you doing this?  What happens if the user uses
> udev to give them different names?
> 
Two things

[1]
These names are created here below, exactly as shown. Now udev usually
creates more links and soft-links, I've never seen a delete?
(I agree that maybe a comment or a define could help readability as this
 format string is repeated twice, though slightly different).
Lets say that "udev can do anything but not delete the primary file created
by Kernel", as a prerequisite.

[2]
I could easily just add a global device list, like all the other parts of
the Kernel are trigger happy to shoot this problem.
But I hate it.
All these devices are already held on a Kernel structure called the name_space.
The life_time rules, locking, reference counting, and visibility, is bug-free and
tried out to the bone. Why should I have to reinvent the wheel? Why introduce all
these subtle corner cases, and sleepless debugging nights?

The way I see it Kernel keeps my devices for me and gives me a "Key" to fetch for
them. The key is the name.

That said. I'll do what people want, it is 5 minutes to put all these on a global
list_head. It's not lack of effort on my part.

>> +		od = osduld_path_lookup(dev_str);
>> +		if (IS_ERR(od))
>> +			continue;
>> +
>> +		oud = od->file->private_data;
>> +		if (_the_same_or_null(oud->odi.systemid, oud->odi.systemid_len,
>> +				      odi->systemid, odi->systemid_len) &&
>> +		    _the_same_or_null(oud->odi.osdname, oud->odi.osdname_len,
>> +				      odi->osdname, odi->osdname_len))
> 
> Why not NULL terminate these strings as you pick them out of the device
> info?  Then you can dispense with the length and use standard kernel
> string comparisons instead of rolling your own.
> 

No! these are, by osd definition, not char-strings they are large-binary signatures.

The system_id is defined by scsi, a 4-byte header + 16-bytes cryptographic key.
I use hex-dump to print it. It is set by the target device at the factory.

The osdname is user settable variable-length binary blob. To be used as a system
policy anyway chosen by the application. We are pushing, and that is what the
mkexofs--format is doing to conveniently store a uuid as generated with the uuidgen
utility in it's string, including "-" form. (36 asci chars). When loaded we allocate
an extra null-terminator (if needed) and print it as string every-where. So when worse
comes to worse and it is not a string, only the print-out is bogus. (But safe)
But when actually compering it for authentication, the pNFS standard mandates binary
blob exact match out.

> James
> 
> 

Thanks
Boaz
