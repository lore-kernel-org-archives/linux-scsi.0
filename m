From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: ibmvscsis: Fix a stringop-overflow warning
Date: Mon, 10 Sep 2018 16:30:46 -0700
Message-ID: <CAGXu5j+-RNeEr+FUc6maamvzYpY7W0VJ-yYGDHnFTuNPeOUMFw@mail.gmail.com>
References: <20180910223723.25357-1-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180910223723.25357-1-labbott@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Prarit Bhargava <prarit@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Sep 10, 2018 at 3:37 PM, Laura Abbott <labbott@redhat.com> wrote:
> There's currently a warning about string overflow with strncat:
>
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_probe':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:3479:2: error: 'strncat' specified
> bound 64 equals destination size [-Werror=stringop-overflow=]
>   strncat(vscsi->eye, vdev->name, MAX_EYE);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> Switch to using strlcat which correctly accounts for lengths that
> are equal to the destination buffer.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index fac377320158..53d344d8dc43 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3475,7 +3475,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>                 vscsi->dds.window[REMOTE].liobn);
>
>         strcpy(vscsi->eye, "VSCSI ");
> -       strncat(vscsi->eye, vdev->name, MAX_EYE);
> +       strlcat(vscsi->eye, vdev->name, MAX_EYE);

Can this just get switched to snprintf() instead?

snprintf(vscsi->eye, sizeof(vscsi->eye), "VSCSI%s", vdev->name);

>         vscsi->dds.unit_id = vdev->unit_address;
>         strncpy(vscsi->dds.partition_name, partition_name,

And does this strncpy need a NUL-termination and/or trailing padding?

-Kees

-- 
Kees Cook
Pixel Security
