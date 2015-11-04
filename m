From: Laurent Vivier <lvivier@redhat.com>
Subject: Re: [PATCH v2 3/3] ibmvscsi: Allow to configure maximum LUN
Date: Wed, 4 Nov 2015 12:46:40 +0100
Message-ID: <5639F020.4010308@redhat.com>
References: <1446632451-22365-1-git-send-email-lvivier@redhat.com>
 <1446632451-22365-4-git-send-email-lvivier@redhat.com>
 <5639E904.1070100@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5639E904.1070100@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, martin.petersen@oracle.com
Cc: brking@linux.vnet.ibm.com, tyreld@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 04/11/2015 12:16, Hannes Reinecke wrote:
> On 11/04/2015 11:20 AM, Laurent Vivier wrote:
>> QEMU allows until 32 LUNs.
>>
>> Signed-off-by: Laurent Vivier <lvivier@redhat.com>
>> ---
>>  drivers/scsi/ibmvscsi/ibmvscsi.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
>> index 04de287..4480d3e 100644
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
>> @@ -117,6 +118,8 @@ module_param_named(fast_fail, fast_fail, int, S_IRUGO | S_IWUSR);
>>  MODULE_PARM_DESC(fast_fail, "Enable fast fail. [Default=1]");
>>  module_param_named(client_reserve, client_reserve, int, S_IRUGO );
>>  MODULE_PARM_DESC(client_reserve, "Attempt client managed reserve/release");
>> +module_param(max_lun, int, S_IRUGO);
>> +MODULE_PARM_DESC(max_lun, "Maximum LUN value [Default=8]");
>>  
>>  static void ibmvscsi_handle_crq(struct viosrp_crq *crq,
>>  				struct ibmvscsi_host_data *hostdata);
>> @@ -2289,7 +2292,7 @@ static int ibmvscsi_probe(struct vio_dev *vdev, const struct vio_device_id *id)
>>  		goto init_pool_failed;
>>  	}
>>  
>> -	host->max_lun = 8;
>> +	host->max_lun = max_lun;
>>  	host->max_id = max_id;
>>  	host->max_channel = max_channel;
>>  	host->max_cmd_len = 16;
>>
> Please, don't do this.
> 
> 'max_lun' should only be set if the HBA / transport has some hard
> limitations on the number of bytes it can use.
> Otherwise the scanning algorithm in scsi_scan.c should do the
> correct thing, independent on the 'max_lun' setting.

So you are saying we can remove the line ?

> If qemu has some issues here someone should rather fix qemu ...

There is no issue with QEMU. QEMU can manage more than "8" LUNs, and
we'd like to.

Laurent
