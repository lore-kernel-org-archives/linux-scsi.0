From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH 1/2] megaraid_sas: Fix for IO failing post OCR in SRIOV
 environment
Date: Mon, 8 Feb 2016 13:57:03 +0100
Message-ID: <56B8909F.90006@redhat.com>
References: <1453995866-25097-1-git-send-email-sumit.saxena@avagotech.com>
 <1453995866-25097-2-git-send-email-sumit.saxena@avagotech.com>
 <56AB9083.5060304@redhat.com>
 <a0b3432aef90520fb4989748238b9565@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbcBHM5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Feb 2016 07:57:07 -0500
In-Reply-To: <a0b3432aef90520fb4989748238b9565@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit Saxena <sumit.saxena@broadcom.com>, Sumit Saxena <sumit.saxena@avagotech.com>, jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

On 5.2.2016 13:24, Sumit Saxena wrote:
>> -----Original Message-----
>> From: Tomas Henzl [mailto:thenzl@redhat.com]
>> Sent: Friday, January 29, 2016 9:47 PM
>> To: Sumit Saxena; jbottomley@parallels.com; hch@infradead.org;
>> martin.petersen@oracle.com
>> Cc: linux-scsi@vger.kernel.org; kashyap.desai@avagotech.com; Uday
> Lingala
>> Subject: Re: [PATCH 1/2] megaraid_sas: Fix for IO failing post OCR in
> SRIOV
>> environment
>>
>> On 28.1.2016 16:44, Sumit Saxena wrote:
>>> Driver assumes that VFs always have peers present whenever they have
> same
>> LD IDs. But this is not the case.
>>> This patch handles the above mentioned by explicitly checking for a
> peer
>> before making HA/non-HA path decision.
>>> Signed-off-by: Uday Lingala <uday.lingala@avagotech.com>
>>> Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
>>>
>>> ---
>>>  drivers/scsi/megaraid/megaraid_sas.h        | 13 ++++++---
>>>  drivers/scsi/megaraid/megaraid_sas_base.c   |  6 +++--
>>>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 42
>>> ++++++++++++++++++-----------
>>>  3 files changed, 39 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>>> b/drivers/scsi/megaraid/megaraid_sas.h
>>> index b6fdb48..4484e63 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>>> @@ -393,6 +393,7 @@ enum MR_EVT_ARGS {
>>>
>>>
>>>  #define SGE_BUFFER_SIZE	4096
>>> +#define MEGASAS_CLUSTER_ID_SIZE	16
>>>  /*
>>>   * define constants for device list query options
>>>   */
>>> @@ -1227,7 +1228,8 @@ struct megasas_ctrl_info {
>>>  	*/
>>>  	struct {
>>>  #if defined(__BIG_ENDIAN_BITFIELD)
>>> -		u32     reserved:26;
>>> +		u32     reserved:25;
>>> +		u32     passive:1;
>>>  		u32     premiumFeatureMismatch:1;
>>>  		u32     ctrlPropIncompatible:1;
>>>  		u32     fwVersionMismatch:1;
>>> @@ -1241,11 +1243,12 @@ struct megasas_ctrl_info {
>>>  		u32     fwVersionMismatch:1;
>>>  		u32     ctrlPropIncompatible:1;
>>>  		u32     premiumFeatureMismatch:1;
>>> -		u32     reserved:26;
>>> +		u32     passive:1;
>>> +		u32     reserved:25;
>>>  #endif
>>>  	} cluster;
>>>
>>> -	char clusterId[16];                     /*7D4h */
>>> +	char clusterId[MEGASAS_CLUSTER_ID_SIZE]; /*0x7D4 */
>>>  	struct {
>>>  		u8  maxVFsSupported;            /*0x7E4*/
>>>  		u8  numVFsEnabled;              /*0x7E5*/
>>> @@ -2126,7 +2129,9 @@ struct megasas_instance {
>>>  	char skip_heartbeat_timer_del;
>>>  	u8 requestorId;
>>>  	char PlasmaFW111;
>>> -	char mpio;
>>> +	char clusterId[MEGASAS_CLUSTER_ID_SIZE];
>>> +	u8 peerIsPresent;
>>> +	u8 passive;
>>>  	u16 throttlequeuedepth;
>>>  	u8 mask_interrupts;
>>>  	u16 max_chain_frame_sz;
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> index 54922e5..52f3419 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>>> @@ -1943,7 +1943,7 @@ void megaraid_sas_kill_hba(struct
>> megasas_instance *instance)
>>>  		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
>>>  		/* Flush */
>>>  		readl(&instance->reg_set->doorbell);
>>> -		if (instance->mpio && instance->requestorId)
>>> +		if (instance->requestorId && instance->peerIsPresent)
>>>  			memset(instance->ld_ids, 0xff,
>> MEGASAS_MAX_LD_IDS);
>>>  	} else {
>>>  		writel(MFI_STOP_ADP,
>>> @@ -5182,7 +5182,9 @@ static int megasas_init_fw(struct
>>> megasas_instance *instance)
>>>
>>>  	tmp_sectors = min_t(u32, max_sectors_1, max_sectors_2);
>>>
>>> -	instance->mpio = ctrl_info->adapterOperations2.mpio;
>>> +	instance->peerIsPresent = ctrl_info->cluster.peerIsPresent;
>>> +	instance->passive = ctrl_info->cluster.passive;
>>> +	memcpy(instance->clusterId, ctrl_info->clusterId,
>>> +sizeof(instance->clusterId));
>>>  	instance->UnevenSpanSupport =
>>>  		ctrl_info->adapterOperations2.supportUnevenSpans;
>>>  	if (instance->UnevenSpanSupport) {
>>> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> index be9c3f1..d9d0029 100644
>>> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
>>> @@ -3325,27 +3325,37 @@ out:
>>>  	return ret;
>>>  }
>>>
>>> +/*SRIOV get other instance in cluster if any*/ struct
>>> +megasas_instance *megasas_get_peer_instance(struct megasas_instance
>>> +*instance) {
>>> +	int i;
>>> +
>>> +	for (i = 0; i < MAX_MGMT_ADAPTERS; i++) {
>>> +		if (megasas_mgmt_info.instance[i] &&
>>> +			(megasas_mgmt_info.instance[i] != instance) &&
>>> +			 megasas_mgmt_info.instance[i]->requestorId &&
>>> +			 megasas_mgmt_info.instance[i]->peerIsPresent &&
>>> +
> (memcmp((megasas_mgmt_info.instance[i]->clusterId),
>>> +			instance->clusterId, MEGASAS_CLUSTER_ID_SIZE) ==
> 0))
>>> +			return megasas_mgmt_info.instance[i];
>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>>  /* Check for a second path that is currently UP */  int
>>> megasas_check_mpio_paths(struct megasas_instance *instance,
>>>  	struct scsi_cmnd *scmd)
>>>  {
>>> -	int i, j, retval = (DID_RESET << 16);
>>> -
>>> -	if (instance->mpio && instance->requestorId) {
>> Seems to me that you've removed this test (instance->requestorId) maybe
> it is
>> not needed, is it removed intentionally ?
> Sorry for delay in response. This is removed intentionally.

ok, thanks,

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

