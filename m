From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH 14/18] scsi: remove __scsi_alloc_queue
Date: Fri, 27 Jan 2017 17:58:02 +0000
Message-ID: <1485539862.4267.17.camel@sandisk.com>
References: <1485365126-23210-1-git-send-email-hch@lst.de>
	<1485365126-23210-15-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1485365126-23210-15-git-send-email-hch@lst.de>
Content-Language: en-US
Content-ID: <B88FD6E8335BBC46B28A23BC2253C310@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "j-nomura@ce.jp.nec.com" <j-nomura@ce.jp.nec.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-01-25 at 18:25 +0100, Christoph Hellwig wrote:
> diff --git a/include/scsi/scsi_transport.h b/include/scsi/scsi_transport.h
> index 8129239..b6e07b5 100644
> --- a/include/scsi/scsi_transport.h
> +++ b/include/scsi/scsi_transport.h
> @@ -119,4 +119,6 @@ scsi_transport_device_data(struct scsi_device *sdev)
>  		+ shost->transportt->device_private_offset;
>  }
>  
> +void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q);
> +
>  #endif /* SCSI_TRANSPORT_H */

Hello Christoph,

Since __scsi_init_queue() modifies data in the Scsi_Host structure, have you
considered to add the declaration for this function to <scsi/scsi_host.h>?
If you want to keep this declaration in <scsi/scsi_transport.h> please add a
direct include of that header file to drivers/scsi/scsi_lib.c such that the
declaration remains visible to the compiler if someone would minimize the
number of #include directives in SCSI header files.

Thanks,

Bart.
