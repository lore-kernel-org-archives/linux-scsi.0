From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH -next] scsi: libfc: Fix potential NULL pointer dereference
Date: Thu, 7 Mar 2019 13:11:06 +0100
Message-ID: <c2ae320a-e7ab-94e6-7562-a82e2aad0966@suse.de>
References: <20190130101141.20132-1-yuehaibing@huawei.com>
 <09c3242f-9a41-65f4-7dc6-f1c8aa6425f1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
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
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
