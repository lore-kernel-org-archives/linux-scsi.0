From: Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCHv2 1/2] target: make target db location configurable
Date: Thu, 14 Apr 2016 17:04:57 -0700
Message-ID: <57103029.80007@suse.com>
References: <cover.1460577841.git.lduncan@suse.com>
 <5f4f1bc2ac2177a37432f0afd22f16ddf65e9e9b.1460577841.git.lduncan@suse.com>
 <570F3458.8010109@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752316AbcDOAJq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Apr 2016 20:09:46 -0400
In-Reply-To: <570F3458.8010109@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org, agrover@redhat.com, jxm@netiant.com

On 04/13/2016 11:10 PM, Hannes Reinecke wrote:
> On 04/13/2016 10:25 PM, Lee Duncan wrote:
>> This commit adds the read-write attribute "dbroot",
>> in the top-level CONFIGFS (core) target directory,
>> normally /sys/kernel/config/target. This attribute
>> defaults to "/var/target" but can be changed by
>> writing a new pathname string to it. Changing this
>> attribute is only allowed when no fabric drivers
>> are loaded and the supplied value specifies an
>> existing directory.
>>
>> Target modules that care about the target database
>> root directory will be modified to use this
>> attribute in a future commit.
>>
>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>> ---
>>  drivers/target/target_core_configfs.c | 51 +++++++++++++++++++++++++++++++++++
>>  drivers/target/target_core_internal.h |  6 +++++
>>  2 files changed, 57 insertions(+)
>>
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
>> index 713c63d9681b..bfedbd92b77f 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -99,6 +99,56 @@ static ssize_t target_core_item_version_show(struct config_item *item,
>>  
>>  CONFIGFS_ATTR_RO(target_core_item_, version);
>>  
>> +char db_root[DB_ROOT_LEN] = DB_ROOT_DEFAULT;
>> +static char db_root_stage[DB_ROOT_LEN];
>> +
>> +static ssize_t target_core_item_dbroot_show(struct config_item *item,
>> +					    char *page)
>> +{
>> +	return sprintf(page, "%s\n", db_root);
>> +}
>> +
>> +static ssize_t target_core_item_dbroot_store(struct config_item *item,
>> +					const char *page, size_t count)
>> +{
>> +	ssize_t read_bytes;
>> +	struct file *fp;
>> +
>> +	if (!list_empty(&g_tf_list)) {
>> +		pr_err("db_root: cannot be changed: target drivers registered");
>> +		return -EINVAL;
>> +	}
> Locking?

Doh. I will resubmit with locking shortly.

> 
> Cheers,
> 
> Hannes
> 

-- 
Lee Duncan

