From: Zhi Yong Wu <zwu.kernel@gmail.com>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
Date: Wed, 18 Apr 2012 22:01:57 +0800
Message-ID: <CAEH94LjBG8R5Jr=Foqg1a9Zw4GUBth7S1ZvbXvQoisWm8McGFA@mail.gmail.com>
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1334756761-12312-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Hu Tao <hutao@cn.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Apr 18, 2012 at 9:46 PM, Paolo Bonzini <pbonzini@redhat.com> wr=
ote:
> Fix a race in TMF path, where cmd may have been already freed
> by virtscsi_complete_free after waking up from the completion.
>
> Cc: James Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> =A0drivers/scsi/virtio_scsi.c | =A0 24 +++++++++++++-----------
> =A01 file changed, 13 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index efccd72..1b38431 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
>
> =A0 =A0 =A0 =A0if (cmd->comp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0complete_all(cmd->comp);
> - =A0 =A0 =A0 mempool_free(cmd, virtscsi_cmd_pool);
> + =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mempool_free(cmd, virtscsi_cmd_pool);
good catch
> =A0}
>
> =A0static void virtscsi_ctrl_done(struct virtqueue *vq)
> @@ -311,21 +312,22 @@ out:
> =A0static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_s=
csi_cmd *cmd)
> =A0{
> =A0 =A0 =A0 =A0DECLARE_COMPLETION_ONSTACK(comp);
> - =A0 =A0 =A0 int ret;
> + =A0 =A0 =A0 int ret =3D FAILED;
>
> =A0 =A0 =A0 =A0cmd->comp =3D &comp;
> - =A0 =A0 =A0 ret =3D virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sizeof c=
md->req.tmf, sizeof cmd->resp.tmf,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_NOIO=
);
> - =A0 =A0 =A0 if (ret < 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FAILED;
> + =A0 =A0 =A0 if (virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sizeof cmd-=
>req.tmf, sizeof cmd->resp.tmf,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_NOIO) <=
 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out;
>
> =A0 =A0 =A0 =A0wait_for_completion(&comp);
> - =A0 =A0 =A0 if (cmd->resp.tmf.response !=3D VIRTIO_SCSI_S_OK &&
> - =A0 =A0 =A0 =A0 =A0 cmd->resp.tmf.response !=3D VIRTIO_SCSI_S_FUNCT=
ION_SUCCEEDED)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return FAILED;
> + =A0 =A0 =A0 if (cmd->resp.tmf.response =3D=3D VIRTIO_SCSI_S_OK ||
> + =A0 =A0 =A0 =A0 =A0 cmd->resp.tmf.response =3D=3D VIRTIO_SCSI_S_FUN=
CTION_SUCCEEDED)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D SUCCESS;
>
> - =A0 =A0 =A0 return SUCCESS;
> +out:
> + =A0 =A0 =A0 mempool_free(cmd, virtscsi_cmd_pool);
> + =A0 =A0 =A0 return ret;
> =A0}
>
> =A0static int virtscsi_device_reset(struct scsi_cmnd *sc)
> --
> 1.7.9.3

Reviewed-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
Regards,

Zhi Yong Wu
