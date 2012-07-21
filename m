From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v4 1/3] vhost: Separate vhost-net features from vhost
	features
Date: Sun, 22 Jul 2012 01:26:27 +0300
Message-ID: <20120721222627.GA23153@redhat.com>
References: <1342853738-27682-1-git-send-email-nab@linux-iscsi.org>
	<1342853738-27682-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1342853738-27682-2-git-send-email-nab@linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Jens Axboe <axboe@kernel.dk>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm-devel <kvm@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, lf-virt <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jul 21, 2012 at 06:55:36AM +0000, Nicholas A. Bellinger wrote:
> From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> 
> In order for other vhost devices to use the VHOST_FEATURES bits the
> vhost-net specific bits need to be moved to their own VHOST_NET_FEATURES
> constant.
> 
> (Asias: Update drivers/vhost/test.c to use VHOST_NET_FEATURES)
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Asias He <asias@redhat.com>
> Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>

Applied to vhost-next.

> ---
>  drivers/vhost/net.c   |    4 ++--
>  drivers/vhost/test.c  |    4 ++--
>  drivers/vhost/vhost.h |    3 ++-
>  3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index f82a739..072cbba 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -823,14 +823,14 @@ static long vhost_net_ioctl(struct file *f, unsigned int ioctl,
>  			return -EFAULT;
>  		return vhost_net_set_backend(n, backend.index, backend.fd);
>  	case VHOST_GET_FEATURES:
> -		features = VHOST_FEATURES;
> +		features = VHOST_NET_FEATURES;
>  		if (copy_to_user(featurep, &features, sizeof features))
>  			return -EFAULT;
>  		return 0;
>  	case VHOST_SET_FEATURES:
>  		if (copy_from_user(&features, featurep, sizeof features))
>  			return -EFAULT;
> -		if (features & ~VHOST_FEATURES)
> +		if (features & ~VHOST_NET_FEATURES)
>  			return -EOPNOTSUPP;
>  		return vhost_net_set_features(n, features);
>  	case VHOST_RESET_OWNER:
> diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
> index 3de00d9..91d6f06 100644
> --- a/drivers/vhost/test.c
> +++ b/drivers/vhost/test.c
> @@ -261,14 +261,14 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
>  			return -EFAULT;
>  		return vhost_test_run(n, test);
>  	case VHOST_GET_FEATURES:
> -		features = VHOST_FEATURES;
> +		features = VHOST_NET_FEATURES;
>  		if (copy_to_user(featurep, &features, sizeof features))
>  			return -EFAULT;
>  		return 0;
>  	case VHOST_SET_FEATURES:
>  		if (copy_from_user(&features, featurep, sizeof features))
>  			return -EFAULT;
> -		if (features & ~VHOST_FEATURES)
> +		if (features & ~VHOST_NET_FEATURES)
>  			return -EOPNOTSUPP;
>  		return vhost_test_set_features(n, features);
>  	case VHOST_RESET_OWNER:
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 8de1fd5..07b9763 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -201,7 +201,8 @@ enum {
>  	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
>  			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
>  			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
> -			 (1ULL << VHOST_F_LOG_ALL) |
> +			 (1ULL << VHOST_F_LOG_ALL),
> +	VHOST_NET_FEATURES = VHOST_FEATURES |
>  			 (1ULL << VHOST_NET_F_VIRTIO_NET_HDR) |
>  			 (1ULL << VIRTIO_NET_F_MRG_RXBUF),
>  };
> -- 
> 1.7.2.5
