From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: DEFINE_IDA causing memory leaks? (was  Re: [PATCH 1/2] virtio: fix
	memory leak of virtio ida cache layers)
Date: Thu, 17 Sep 2015 08:33:33 +0300
Message-ID: <20150917082425-mutt-send-email-mst@redhat.com>
References: <1442449758-14594-1-git-send-email-s-anna@ti.com>
	<1442449758-14594-2-git-send-email-s-anna@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1442449758-14594-2-git-send-email-s-anna@ti.com>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Suman Anna <s-anna@ti.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@Odin.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, open-iscsi@googlegroups.com
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 16, 2015 at 07:29:17PM -0500, Suman Anna wrote:
> The virtio core uses a static ida named virtio_index_ida for
> assigning index numbers to virtio devices during registration.
> The ida core may allocate some internal idr cache layers and
> an ida bitmap upon any ida allocation, and all these layers are
> truely freed only upon the ida destruction. The virtio_index_ida
> is not destroyed at present, leading to a memory leak when using
> the virtio core as a module and atleast one virtio device is
> registered and unregistered.
> 
> Fix this by invoking ida_destroy() in the virtio core module
> exit.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Signed-off-by: Suman Anna <s-anna@ti.com>

Interesting.
Will the same apply to e.g. sd_index_ida in drivers/scsi/sd.c
or iscsi_sess_ida in drivers/scsi/scsi_transport_iscsi.c?

If no, why not?

One doesn't generally expect to have to free global variables.
Maybe we should forbid DEFINE_IDA in modules?

James, could you comment on this please?

> ---
>  drivers/virtio/virtio.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/virtio/virtio.c b/drivers/virtio/virtio.c
> index b1877d73fa56..7062bb0975a5 100644
> --- a/drivers/virtio/virtio.c
> +++ b/drivers/virtio/virtio.c
> @@ -412,6 +412,7 @@ static int virtio_init(void)
>  static void __exit virtio_exit(void)
>  {
>  	bus_unregister(&virtio_bus);
> +	ida_destroy(&virtio_index_ida);
>  }
>  core_initcall(virtio_init);
>  module_exit(virtio_exit);
> -- 
> 2.5.0
