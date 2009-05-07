From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/3] scsi_dh: rdac handler: Batch up MODE
	SELECTs and send few of them
Date: Wed, 06 May 2009 22:39:54 -0500
Message-ID: <4A02580A.2060704@cs.wisc.edu>
References: <20090428025230.11108.88559.sendpatchset@chandra-ubuntu>
	<20090428025248.11108.38596.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090428025248.11108.38596.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
>  }
>  
> -static int rdac_activate(struct scsi_device *sdev, activate_complete fn, void *data)
> +static int queue_mode_select(struct scsi_device *sdev,
> +				activate_complete fn, void *data)
> +{
> +	struct rdac_queue_data *qdata;
> +	struct rdac_controller *ctlr;
> +
> +	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);


I think you want to use GFP_NOIO or GFP_ATOMIC here. If GFP_NOIO can 
block and screw up other devices using that multipathd workqueue struct 
maybe GFP_ATOMIC would be best since we can have dm-mpath retry later.
