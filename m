From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCHv2] scsi: ibmvscsis: Fix a stringop-overflow warning
Date: Tue, 11 Sep 2018 11:24:39 -0700
Message-ID: <CAGXu5j+R_VLzKxwtqu7yR=vwRBSZNhcjjMtz8OgWRh48Gwisww@mail.gmail.com>
References: <20180911180542.7778-1-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911180542.7778-1-labbott@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2018 at 11:05 AM, Laura Abbott <labbott@redhat.com> wrote:
>
> There's currently a warning about string overflow with strncat:
>
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_probe':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3479:2: error: 'strncat' specified
> bound 64 equals destination size [-Werror=stringop-overflow=]
>   strncat(vscsi->eye, vdev->name, MAX_EYE);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Switch to a single snprintf instead of a strcpy + strcat to handle this
> cleanly.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
> v2: Swtich to using snprintf per suggestion of Kees
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index fac377320158..9305440a00a1 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3474,8 +3474,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>                 vscsi->dds.window[LOCAL].liobn,
>                 vscsi->dds.window[REMOTE].liobn);
>
> -       strcpy(vscsi->eye, "VSCSI ");
> -       strncat(vscsi->eye, vdev->name, MAX_EYE);
> +       snprintf(vscsi->eye, sizeof(vscsi->eye), "VSCSI%s", vdev->name);
>
>         vscsi->dds.unit_id = vdev->unit_address;
>         strncpy(vscsi->dds.partition_name, partition_name,
> --
> 2.17.1
>



-- 
Kees Cook
Pixel Security
