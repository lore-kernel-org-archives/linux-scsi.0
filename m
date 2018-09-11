From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] scsi: ibmvscsis: Ensure partition name is properly NUL terminated
Date: Tue, 11 Sep 2018 11:25:08 -0700
Message-ID: <CAGXu5jLE3kBFrz-HDfYcUFJU=Up_+q1t1BP6708+Y3RMvO8ivA@mail.gmail.com>
References: <20180911181534.18553-1-labbott@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911181534.18553-1-labbott@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Laura Abbott <labbott@redhat.com>
Cc: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel <target-devel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 11, 2018 at 11:15 AM, Laura Abbott <labbott@redhat.com> wrote:
> While reviewing another part of the code, Kees noticed that the
> strncpy of the partition name might not always be NUL terminated. Switch
> to using strlcpy which does this safely.
>
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
> I realized looking at this that I probably should have made
> this and my previous patch a series given this has context depending on
> the other patch. I can resend if the scsi maintainers want.
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 9305440a00a1..1217bf2a28db 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -3477,7 +3477,7 @@ static int ibmvscsis_probe(struct vio_dev *vdev,
>         snprintf(vscsi->eye, sizeof(vscsi->eye), "VSCSI%s", vdev->name);
>
>         vscsi->dds.unit_id = vdev->unit_address;
> -       strncpy(vscsi->dds.partition_name, partition_name,
> +       strlcpy(vscsi->dds.partition_name, partition_name,

Please use strscpy() in favor of strlcpy().

-Kees

>                 sizeof(vscsi->dds.partition_name));
>         vscsi->dds.partition_num = partition_number;
>
> --
> 2.17.1
>



-- 
Kees Cook
Pixel Security
