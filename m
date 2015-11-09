From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v4 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Mon, 9 Nov 2015 15:59:40 +0100
Message-ID: <5640B4DC.9010706@redhat.com>
References: <1447080465-17858-1-git-send-email-lvivier@redhat.com>
 <1447080465-17858-4-git-send-email-lvivier@redhat.com>
 <5640B2A6.20401@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbbKIO7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Nov 2015 09:59:43 -0500
In-Reply-To: <5640B2A6.20401@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: martin.petersen@oracle.com, brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org



On 09/11/2015 15:50, Hannes Reinecke wrote:
> On 11/09/2015 03:47 PM, Laurent Vivier wrote:
>> This patch allows to define the maximum LUN numbers.
>> As defined in 4.6.9 of SAM-4, the encoding of LUN is
>> on 5 bits (max_lun=32) and the current value is only 8.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 9 ++++++++-
>>  drivers/scsi/ibmvscsi/ibmvscsi.h | 1 +
>>  2 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index 04de287..adcd5e8 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.c
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> @@ -84,6 +84,7 @@
>>   */
>>  static int max_id = 64;
>>  static int max_channel = 3;
>> +static int max_lun = 8;
>>  static int init_timeout = 300;
>>  static int login_timeout = 60;
>>  static int info_timeout = 30;
>> @@ -117,6 +118,9 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
>> +module_param(max_lun, int, S_IRUGO);
>> +MODULE_PARM_DESC(max_lun, "Maximum allowed LUN "
>> +                          "[Default=8,Max="__stringify(IBMVSCSI_MAX_LUN)"]");
>>  
>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>  				struct ibmvscsi_host_data *hostdata);
>> @@ -2289,7 +2293,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  		goto init_pool_failed;
>>  	}
>>  
>> -	host->max_lun = 8;
>> +	host->max_lun = max_lun;
>>  	host->max_id = max_id;
>>  	host->max_channel = max_channel;
>>  	host->max_cmd_len = 16;
>> @@ -2414,6 +2418,9 @@ int __init ibmvscsi_module_init(void)
>>  {
>>  	int ret;
>>  
>> +	if (max_lun > IBMVSCSI_MAX_LUN)
>> +		return -EINVAL;
>> +
>>  	/* Ensure we have two requests to do error recovery */
>>  	driver_template.can_queue = max_requests;
>>  	max_events = max_requests + 2;
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.h b/drivers/scsi/ibmvscsi/ibmvscsi.h
>> index 7d64867..1067367 100644
>> --- a/drivers/scsi/ibmvscsi/ibmvscsi.h
>> +++ b/drivers/scsi/ibmvscsi/ibmvscsi.h
>> @@ -48,6 +48,7 @@ struct Scsi_Host;
>>  #define IBMVSCSI_CMDS_PER_LUN_DEFAULT 16
>>  #define IBMVSCSI_MAX_SECTORS_DEFAULT 256 /* 32 * 8 = default max I/O 32 pages */
>>  #define IBMVSCSI_MAX_CMDS_PER_LUN 64
>> +#define IBMVSCSI_MAX_LUN 32
>>  
>>  /* ------------------------------------------------------------
>>   * Data Structures
>>
> Please set max_lun to 31, and remove everything else.
> As discussed, max_lun is the max number of LUNs supported by the
> hardware/HBA. There is no point in restricting it further.

You mean no module parameter and a simple "host->max_lun = 31" ?

I'm wondering if it should be "host->max_lun = 32". What about this ?

include/scsi/scsi_host.h:

        /*
         * These three parameters can be used to allow for wide scsi,
         * and for host adapters that support multiple busses
         * The last two should be set to 1 more than the actual max id
         * or lun (e.g. 8 for SCSI parallel systems).
         */
        unsigned int max_channel;
        unsigned int max_id;
        u64 max_lun;

As ibmvscsi maximum LUN value is 31, host->max_lun should be 32.

Laurent
