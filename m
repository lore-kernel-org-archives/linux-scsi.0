From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [PATCH v4 38/42] virtio_scsi: v1.0 support
Date: Wed, 26 Nov 2014 15:51:03 +0100
Message-ID: <20141126155103.1f6725ce.cornelia.huck@de.ibm.com>
References: <1416933600-21398-1-git-send-email-mst@redhat.com>
	<1416933600-21398-39-git-send-email-mst@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1416933600-21398-39-git-send-email-mst@redhat.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-scsi@vger.kernel.org, rusty@au1.ibm.com, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, virtualization@lists.linux-foundation.org, pbonzini@redhat.com, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

On Tue, 25 Nov 2014 18:44:08 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> Note: for consistency, and to avoid sparse errors,
>   convert all fields, even those no longer in use
>   for virtio v1.0.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  include/linux/virtio_scsi.h | 32 +++++++++++++++-------------
>  drivers/scsi/virtio_scsi.c  | 51 ++++++++++++++++++++++++++++-----------------
>  2 files changed, 49 insertions(+), 34 deletions(-)
> 

> @@ -158,7 +158,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>  		sc, resp->response, resp->status, resp->sense_len);
> 
>  	sc->result = resp->status;
> -	virtscsi_compute_resid(sc, resp->resid);
> +	virtscsi_compute_resid(sc, __virtio32_to_cpu(vscsi->vdev, resp->resid));

Confused. Don't you need the non-underscore versions if you pass in a
vdev as first parameter?

>  	switch (resp->response) {
>  	case VIRTIO_SCSI_S_OK:
>  		set_host_byte(sc, DID_OK);
