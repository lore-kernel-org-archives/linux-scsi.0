From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v2 1/2] virtio_scsi: Add fc_host definitions
Date: Thu, 26 Jan 2017 23:49:03 +0200
Message-ID: <20170126234414-mutt-send-email-mst@kernel.org>
References: <20170126034109.16144-1-famz@redhat.com>
	<20170126034109.16144-2-famz@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <20170126034109.16144-2-famz@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Fam Zheng <famz@redhat.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, stefanha@redhat.com, Paolo Bonzini <pbonzini@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 26, 2017 at 11:41:08AM +0800, Fam Zheng wrote:
> Signed-off-by: Fam Zheng <famz@redhat.com>
> ---

I pefer combining this with implementation,
hard to reason about interface alone.

>  include/uapi/linux/virtio_scsi.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/virtio_scsi.h b/include/uapi/linux/virtio_scsi.h
> index cc18ef8..a26fb31 100644
> --- a/include/uapi/linux/virtio_scsi.h
> +++ b/include/uapi/linux/virtio_scsi.h
> @@ -113,6 +113,11 @@ struct virtio_scsi_config {
>  	__u16 max_channel;
>  	__u16 max_target;
>  	__u32 max_lun;
> +	__u8  primary_wwpn[8];
> +	__u8  primary_wwnn[8];
> +	__u8  secondary_wwpn[8];
> +	__u8  secondary_wwnn[8];
> +	__u8  primary_active;

Is this in fact a binary value?
Also pls add padding to align on 8 byte boundary.

>  } __attribute__((packed));
>  
>  /* Feature Bits */
> @@ -120,6 +125,7 @@ struct virtio_scsi_config {
>  #define VIRTIO_SCSI_F_HOTPLUG                  1
>  #define VIRTIO_SCSI_F_CHANGE                   2
>  #define VIRTIO_SCSI_F_T10_PI                   3
> +#define VIRTIO_SCSI_F_FC_HOST                  4
>  
>  /* Response codes */
>  #define VIRTIO_SCSI_S_OK                       0
> -- 
> 2.9.3
