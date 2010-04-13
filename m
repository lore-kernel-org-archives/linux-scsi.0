From: Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
Subject: Re: [PATCH 2/2] RFC: iscsi ibft: convert iscsi_ibft module to iscsi
 boot lib
Date: Mon, 12 Apr 2010 21:32:33 -0500
Message-ID: <4BC3D7C1.90307@cs.wisc.edu>
References: <1271095578-4212-1-git-send-email-michaelc@cs.wisc.edu> <1271095578-4212-2-git-send-email-michaelc@cs.wisc.edu> <201004122221.05326.konrad@darnok.org>
Reply-To: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Return-path: <38tfDSwgLCtkHD7C59G77N.RDN7.98PJK9I-DN7NDBJJBG9BMJPKN.7JH-WNnxsJb2WYALHLMFiseIBxPsWskHk0ljAL8bYrjMMd8@public.gmane.org>
In-Reply-To: <201004122221.05326.konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
List-Post: <http://groups.google.com/group/open-iscsi/post?hl=en_US>,
	<mailto:open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/?hl=en_US>, <mailto:open-iscsi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/open-iscsi?hl=en_US>
Sender: open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/open-iscsi/subscribe?hl=en_US>,
	<mailto:open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
To: Konrad Rzeszutek Wilk <konrad-Gq0aWv8utHQdnm+yROfE0A@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, open-iscsi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On 04/12/2010 09:21 PM, Konrad Rzeszutek Wilk wrote:
>> + * Helper routiners to check to determine if the entry is valid
>> + * in the proper iBFT structure.
>> + */
>> +static mode_t ibft_check_nic_for(void *data, int type)
>> +{
>> +	struct ibft_kobject *entry = data;
>> +	struct ibft_nic *nic = entry->nic;
>> +	mode_t rc = 0;
>> +
>> +	switch (type) {
>> +	case ISCSI_BOOT_ETH_INDEX:
>> +	case ISCSI_BOOT_ETH_FLAGS:
>> +		rc = 1;
>
> Did you mean for that value?
>> +		break;
>> +	case ISCSI_BOOT_ETH_IP_ADDR:
>> +		if (memcmp(nic->ip_addr, nulls, sizeof(nic->ip_addr)))
>> +			rc = S_IRUGO;
>> +		break;
>> +	case ISCSI_BOOT_ETH_SUBNET_MASK:
>> +		if (nic->subnet_mask_prefix)
>> +			rc = S_IRUGO;
>> +		break;
>> +	case ISCSI_BOOT_ETH_ORIGIN:
>> +		rc = 1;
>
> and this one as well?

I did not. They should be S_IRUGO. Do you want me to resubmit the 
patches or are you just going to edit those two lines if you merge them?

-- 
You received this message because you are subscribed to the Google Groups "open-iscsi" group.
To post to this group, send email to open-iscsi-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
To unsubscribe from this group, send email to open-iscsi+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit this group at http://groups.google.com/group/open-iscsi?hl=en.
