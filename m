From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH -next] scsi: libfc: Fix potential NULL pointer dereference
Date: Wed, 27 Feb 2019 13:51:06 +0100
Message-ID: <33f93c39-3dd5-ef95-0fc2-6fc40f6b3d4b@suse.de>
References: <20190130101141.20132-1-yuehaibing@huawei.com>
 <09c3242f-9a41-65f4-7dc6-f1c8aa6425f1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <09c3242f-9a41-65f4-7dc6-f1c8aa6425f1@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2/27/19 7:09 AM, YueHaibing wrote:
> 
> Friendly ping:
> 
> Who can review or take this, please?
> 
> Thanks
> 
> On 2019/1/30 18:11, YueHaibing wrote:
>> There is a potential NULL pointer dereference in case
>> fc_rport_create() fails and returns NULL.
>>
>> Fixes: 2580064b5ec6 ("scsi: libfc: Replace ->rport_create callback with function call")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>   drivers/scsi/libfc/fc_lport.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
>> index ff943f4..e2a3551 100644
>> --- a/drivers/scsi/libfc/fc_lport.c
>> +++ b/drivers/scsi/libfc/fc_lport.c
>> @@ -250,6 +250,10 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
>>   	}
>>   	mutex_lock(&lport->disc.disc_mutex);
>>   	lport->ptp_rdata = fc_rport_create(lport, remote_fid);
>> +	if (!lport->ptp_rdata) {
>> +		mutex_unlock(&lport->disc.disc_mutex);
>> +		return;
>> +	}
>>   	kref_get(&lport->ptp_rdata->kref);
>>   	lport->ptp_rdata->ids.port_name = remote_wwpn;
>>   	lport->ptp_rdata->ids.node_name = remote_wwnn;
>>
> 
I don't think this is correct.
While it's true that fc_rport_create() might fail, fc_lport_ptp_setup() 
will still assumed to have worked by the caller.
So we should rather return an error code here from fc_lport_ptp_setup() 
and ensure it's handled properly in the caller, too.

Cheers,

Hannes
