From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: myrs: Fix uninitialized variable
Date: Thu, 9 May 2019 17:26:42 +0200
Message-ID: <f57c9744-6208-cbc5-50eb-854d335b4d7f@suse.de>
References: <20190509152247.26164-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190509152247.26164-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, hare@kernel.org, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 5/9/19 5:22 PM, YueHaibing wrote:
> drivers/scsi/myrs.c: In function 'myrs_log_event':
> drivers/scsi/myrs.c:821:24: warning: 'sshdr.sense_key' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    struct scsi_sense_hdr sshdr;
> 
> If ev->ev_code is not 0x1C, sshdr.sense_key may
> be used uninitialized. Fix this by initializing
> variable 'sshdr' to 0.
> 
> Fixes: 77266186397c ("scsi: myrs: Add Mylex RAID controller (SCSI interface)")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/myrs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
> index b8d54ef..eb0dd56 100644
> --- a/drivers/scsi/myrs.c
> +++ b/drivers/scsi/myrs.c
> @@ -818,7 +818,7 @@ static void myrs_log_event(struct myrs_hba *cs, struct myrs_event *ev)
>   	unsigned char ev_type, *ev_msg;
>   	struct Scsi_Host *shost = cs->host;
>   	struct scsi_device *sdev;
> -	struct scsi_sense_hdr sshdr;
> +	struct scsi_sense_hdr sshdr = {0};
>   	unsigned char sense_info[4];
>   	unsigned char cmd_specific[4];
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
