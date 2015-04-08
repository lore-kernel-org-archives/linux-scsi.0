From: "Narsimhulu Musini (nmusini)" <nmusini@cisco.com>
Subject: Re: [PATCH v3 1/9] snic: snic module infrastructure
Date: Wed, 8 Apr 2015 08:55:35 +0000
Message-ID: <D14AE940.1FFAC%nmusini@cisco.com>
References: <1427965488-12073-1-git-send-email-nmusini@cisco.com>
 <1427965488-12073-2-git-send-email-nmusini@cisco.com>
 <20150402092158.GA6794@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alln-iport-8.cisco.com ([173.37.142.95]:56174 "EHLO
	alln-iport-8.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbbDHIzh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2015 04:55:37 -0400
In-Reply-To: <20150402092158.GA6794@infradead.org>
Content-Language: en-US
Content-ID: <25228C074E320347B98AC39E9E3F17A8@emea.cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "Sesidhar Baddela (sebaddel)" <sebaddel@cisco.com>

Hi Christoph,

Thank you for reviewing the patch. Please find responses inline.
I will incorporate the comments and suggestions in next patch submittal.



On 02/04/15 2:51 pm, "Christoph Hellwig" <hch@infradead.org> wrote:

>> +/*
>> + * Usage of the scsi_cmnd scratchpad.
>> + * These fields are locked by the hashed req_lock.
>> + */
>> +#define CMD_SP(Cmnd)		((Cmnd)->SCp.ptr)
>> +#define CMD_STATE(Cmnd)		((Cmnd)->SCp.phase)
>> +#define CMD_ABTS_STATUS(Cmnd)	((Cmnd)->SCp.Message)
>> +#define CMD_LR_STATUS(Cmnd)	((Cmnd)->SCp.have_data_in)
>> +#define CMD_TAG(Cmnd)		((Cmnd)->SCp.sent_command)
>> +#define CMD_FLAGS(Cmnd)		((Cmnd)->SCp.Status)
>
>Please don't abuse ->SCp for new drivers.  Declare your own structure
>and set .cmd_size in the host template to it's size, then access it
>using scsi_cmd_priv().
Sure, driver will use its own private structure.
 

> That should also avoid the need for the mempool
>that the driver currently creates.
Yes, agreed. For now, I will just consider making changes to replace
scratch buffer usage. And will take up the mempool creation in future
patches.


>
>> +static int
>> +snic_slave_alloc(struct scsi_device *sdev)
>> +{
>> +	u32 qdepth = 0, max_ios = 0;
>> +	struct snic_tgt *tgt = starget_to_tgt(scsi_target(sdev));
>> +
>> +	if (!tgt || snic_tgt_chkready(tgt))
>> +		return -ENXIO;
>> +
>> +	max_ios = snic_max_qdepth;
>> +	max_ios = snic_max_qdepth;
>> +	qdepth = min_t(u32, max_ios, SNIC_MAX_QUEUE_DEPTH);
>> +	scsi_change_queue_depth(sdev, qdepth);
>
>Plase set the queue_depth in ->slave_configure like all other drivers.
Sure, I will move it to ->slave_configure.

>
>> +	.cmd_per_lun = 3,
>
>why so low?
Thanks for pointing this, will set it to default queue depth.


>
>> +
>> +#ifndef PCI_VENDOR_ID_CISCO
>> +#define PCI_VENDOR_ID_CISCO     0x1137
>> +#endif
>
>Just use the numeric value directly.
Sure.
>
>> +
>> +#define SNIC_OS_TYPE	SNIC_OS_LINUX
>> +#define snic_cmd_tag(sc)	(((struct scsi_cmnd *) sc)->request->tag)
>> +
>> +extern struct device_attribute *snic_attrs[];
>> +
>> +static inline struct kmem_cache *
>> +snic_cache_create(const char *cache_name, const int sz)
>> +{
>> +	void *cp;
>> +
>> +	cp = kmem_cache_create(cache_name, sz, SNIC_SG_DESC_ALIGN,
>> +			       SLAB_HWCACHE_ALIGN, NULL);
>> +
>> +	return (struct kmem_cache *) cp;
>> +}
>
>Please remove all the wrappers in the snic_os.h file and use the Linux
>APIs directly.
Sure, I will directly use the APIs, and delete the snic_os.h file.


Thanks
Narsimhulu
>

