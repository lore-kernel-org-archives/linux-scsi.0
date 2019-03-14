From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH -next] scsi: libfc: Fix potential NULL pointer dereference
Date: Thu, 14 Mar 2019 07:06:59 -0400
Message-ID: <yq1y35hn298.fsf@oracle.com>
References: <20190130101141.20132-1-yuehaibing@huawei.com>
        <09c3242f-9a41-65f4-7dc6-f1c8aa6425f1@huawei.com>
        <c2ae320a-e7ab-94e6-7562-a82e2aad0966@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c2ae320a-e7ab-94e6-7562-a82e2aad0966@suse.de> (Hannes Reinecke's
        message of "Thu, 7 Mar 2019 13:11:06 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: YueHaibing <yuehaibing@huawei.com>, jejb@linux.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Hi Hannes,

>>> There is a potential NULL pointer dereference in case
>>> fc_rport_create() fails and returns NULL.

>>> diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
>>> index ff943f4..e2a3551 100644
>>> --- a/drivers/scsi/libfc/fc_lport.c
>>> +++ b/drivers/scsi/libfc/fc_lport.c
>>> @@ -250,6 +250,10 @@ static void fc_lport_ptp_setup(struct fc_lport *lport,
>>>   	}
>>>   	mutex_lock(&lport->disc.disc_mutex);
>>>   	lport->ptp_rdata = fc_rport_create(lport, remote_fid);
>>> +	if (!lport->ptp_rdata) {
>>> +		mutex_unlock(&lport->disc.disc_mutex);
>>> +		return;
>>> +	}
>>>   	kref_get(&lport->ptp_rdata->kref);
>>>   	lport->ptp_rdata->ids.port_name = remote_wwpn;
>>>   	lport->ptp_rdata->ids.node_name = remote_wwnn;
>>>

> Reviewed-by: Hannes Reinecke <hare@suse.com>

A bit confused. You had originally replied that the patch was not
correct so I closed it in patchwork. And now there's a Reviewed-by:
without any explanation as to why you have changed your mind.

Please clarify, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
