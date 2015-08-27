From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND V2 3/7] scsi: storvsc: Untangle the storage
 protocol negotiation from the vmbus protocol negotiation.
Date: Wed, 26 Aug 2015 18:40:25 -0700
Message-ID: <1440639625.2196.100.camel@HansenPartnership.com>
References: <1439480609-11099-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-3-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1439480632-11144-3-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org, Keith Mange <keith.mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2015-08-13 at 08:43 -0700, K. Y. Srinivasan wrote:
> From: Keith Mange <keith.mange@microsoft.com>
> 
> Currently we are making decisions based on vmbus protocol versions
> that have been negotiated; use storage potocol versions instead.
> 
> Tested-by: Alex Ng <alexng@microsoft.com>
> Signed-off-by: Keith Mange <keith.mange@microsoft.com>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c |  109 +++++++++++++++++++++++++++++++++++---------
>  1 files changed, 87 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 5f9d133..f29871e 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -56,14 +56,18 @@
>   * V1 RC > 2008/1/31:  2.0
>   * Win7: 4.2
>   * Win8: 5.1
> + * Win8.1: 6.0
> + * Win10: 6.2
>   */
>  
>  #define VMSTOR_PROTO_VERSION(MAJOR_, MINOR_)	((((MAJOR_) & 0xff) << 8) | \
>  						(((MINOR_) & 0xff)))
>  
> +#define VMSTOR_PROTO_VERSION_WIN6	VMSTOR_PROTO_VERSION(2, 0)
>  #define VMSTOR_PROTO_VERSION_WIN7	VMSTOR_PROTO_VERSION(4, 2)
>  #define VMSTOR_PROTO_VERSION_WIN8	VMSTOR_PROTO_VERSION(5, 1)
> -
> +#define VMSTOR_PROTO_VERSION_WIN8_1	VMSTOR_PROTO_VERSION(6, 0)
> +#define VMSTOR_PROTO_VERSION_WIN10	VMSTOR_PROTO_VERSION(6, 2)
>  
>  /*  Packet structure describing virtual storage requests. */
>  enum vstor_packet_operation {
> @@ -205,6 +209,46 @@ struct vmscsi_request {
>  
> 
>  /*
> + * The list of storage protocols in order of preference.
> + */
> +struct vmstor_protocol {
> +	int protocol_version;
> +	int sense_buffer_size;
> +	int vmscsi_size_delta;
> +};
> +
> +#define VMSTOR_NUM_PROTOCOLS    5
> +
> +const struct vmstor_protocol vmstor_protocols[VMSTOR_NUM_PROTOCOLS] = {

Sparse doesn't like this not being static:

  CHECK   drivers/scsi/storvsc_drv.c
drivers/scsi/storvsc_drv.c:221:30: warning: symbol 'vmstor_protocols'
was not declared. Should it be static?
 
I fixed it up.

James
