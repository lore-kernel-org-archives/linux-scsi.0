From: Shaun Tancheff <shaun.tancheff@seagate.com>
Subject: Re: [PATCH v5 2/4] fusion: remove iopriority handling
Date: Thu, 13 Oct 2016 18:36:32 -0500
Message-ID: <CAJVOszDaOiDN1nMW7X6pgEkjSkE9+hNE0doUc-hweJc-qtAu3w@mail.gmail.com>
References: <1476399631-5799-1-git-send-email-adam.manzanares@hgst.com> <1476399631-5799-3-git-send-email-adam.manzanares@hgst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-00003501.pphosted.com ([67.231.152.68]:58958 "EHLO
        mx0a-000cda01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755948AbcJMXhq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 19:37:46 -0400
Received: from pps.filterd (m0075034.ppops.net [127.0.0.1])
        by mx0b-00003501.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DNY0TR037664
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 19:36:54 -0400
Received: from mail-yw0-f199.google.com (mail-yw0-f199.google.com [209.85.161.199])
        by mx0b-00003501.pphosted.com with ESMTP id 262kk9846v-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 19:36:54 -0400
Received: by mail-yw0-f199.google.com with SMTP id l84so165729772ywe.5
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 16:36:53 -0700 (PDT)
In-Reply-To: <1476399631-5799-3-git-send-email-adam.manzanares@hgst.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Manzanares <adam.manzanares@hgst.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, Toshi Kani <toshi.kani@hpe.com>, Ming Lei <ming.lei@canonical.com>, Sathya Prakash <sathya.prakash@broadcom.com>, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, linux-block@vger.kernel.org, linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Adam Manzanares <adam.manzanares@wdc.com>

On Thu, Oct 13, 2016 at 6:00 PM, Adam Manzanares
<adam.manzanares@hgst.com> wrote:
> The request priority is now by default coming from the ioc. It was not
> clear what this code was trying to do based upon the iopriority class or
> data. The driver should check that a device supports priorities and use
> them according to the specificiations of ioprio.
>
> Signed-off-by: Adam Manzanares <adam.manzanares@wdc.com>
> ---
>  drivers/message/fusion/mptscsih.c | 5 -----
>  1 file changed, 5 deletions(-)
>
> diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/m=
ptscsih.c
> index 6c9fc11..4740bb6 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1369,11 +1369,6 @@ mptscsih_qcmd(struct scsi_cmnd *SCpnt)
>         if ((vdevice->vtarget->tflags & MPT_TARGET_FLAGS_Q_YES)
>             && (SCpnt->device->tagged_supported)) {
>                 scsictl =3D scsidir | MPI_SCSIIO_CONTROL_SIMPLEQ;
> -               if (SCpnt->request && SCpnt->request->ioprio) {
> -                       if (((SCpnt->request->ioprio & 0x7) =3D=3D 1) ||
> -                               !(SCpnt->request->ioprio & 0x7))
> -                               scsictl |=3D MPI_SCSIIO_CONTROL_HEADOFQ;
> -               }
>         } else
>                 scsictl =3D scsidir | MPI_SCSIIO_CONTROL_UNTAGGED;

Style wise you can further remove the extra parens around
  SCpnt->device->tagged_supported
As well as the now redundant braces.

Regards,
Shaun

> --
> 2.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-block" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  https://urldefense.proofpoint.com/v2/url?u=3Dhttp=
-3A__vger.kernel.org_majordomo-2Dinfo.html&d=3DDQIBAg&c=3DIGDlg0lD0b-nebmJJ=
0Kp8A&r=3DWg5NqlNlVTT7Ugl8V50qIHLe856QW0qfG3WVYGOrWzA&m=3DZE7JzxXeXPEWqk9WY=
m42hZHj8gESRg1QoS5XklfbprM&s=3DC0iMyTgYbYl06F1SQ2DqfdESKBtl3Whp5rSnHSBXOc4&=
e=3D
