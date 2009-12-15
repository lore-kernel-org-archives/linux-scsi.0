From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Remove capping from dev_loss_tmo
Date: Tue, 15 Dec 2009 02:54:09 -0600
Message-ID: <4B274EB1.50500@cs.wisc.edu>
References: <20091215082606.A45B037AD2@ochil.suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091215082606.A45B037AD2@ochil.suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
> index 573ce21..6f39bf4 100644
> --- a/drivers/scsi/scsi_transport_fc.c
> +++ b/drivers/scsi/scsi_transport_fc.c
> @@ -475,7 +475,8 @@ MODULE_PARM_DESC(dev_loss_tmo,
>  		 "Maximum number of seconds that the FC transport should"
>  		 " insulate the loss of a remote port. Once this value is"
>  		 " exceeded, the scsi target is removed. Value should be"
> -		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
> +		 " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT if"
> +		 " fast_io_fail_tmo is not set.");
>  

What was the largest timeout value you tried? I think I am hitting a bug 
with iscsi where if you pass queue_delayed_work a large enough value it 
will overflow and instead of getting 100 minutes you get 1.
