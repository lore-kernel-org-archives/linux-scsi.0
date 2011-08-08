From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] /drivers/scsi/lpfc/lpfc_debugfs.c (3.0.1) - the frame
 size of 1048 bytes is larger than 1024 bytes
Date: Mon, 8 Aug 2011 15:54:29 -0400
Message-ID: <4E403EF5.2060604@emulex.com>
References: <1312749297.37983.YahooMailNeo@web45812.mail.sp1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:36951 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750868Ab1HHTyz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2011 15:54:55 -0400
In-Reply-To: <1312749297.37983.YahooMailNeo@web45812.mail.sp1.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Poyo VL <poyo_vl@yahoo.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Already corrected by the patch:
http://marc.info/?l=3Dlinux-scsi&m=3D131137432401391&w=3D2

Which is part of the lpfc 8.3.25 patchset.

-- james s



On 8/7/2011 4:34 PM, Poyo VL wrote:
> Hy,
>
> When I tried to compile the 3.0.1 kernel, I got the following warning=
:
>
> drivers/scsi/lpfc/lpfc_debugfs.c: In function =E2=80=98T.1107=E2=80=99=
:
> drivers/scsi/lpfc/lpfc_debugfs.c:411: warning: the frame size of 1048=
 bytes is
> larger than 1024 bytes
>
> But I think if the buffer is dinamically allocated, there is no probl=
em.
>
> So, a simple patch would be:
>
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c 2011-08-05 07:59:21.000000000 =
+0300
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c 2011-08-07 15:25:52.021158413 =
+0300
> @@ -378,7 +378,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> int len =3D 0;
> int i, off;
> uint32_t *ptr;
> - char buffer[1024];
> + char *buffer =3D kmalloc(1024, GFP_KERNEL);
>
> off =3D 0;
> spin_lock_irq(&phba->hbalock);
> @@ -387,7 +387,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> lpfc_memcpy_from_slim(buffer,
> phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
>
> - ptr =3D (uint32_t *)&buffer[0];
> + ptr =3D (uint32_t *)buffer;
> off =3D lpfc_debugfs_last_hba_slim_off;
>
> /* Set it up for the next time */
> @@ -407,6 +407,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> }
>
> spin_unlock_irq(&phba->hbalock);
> + kfree(buffer);
> return len;
> }
>
> Or, better, with an allocation check:
>
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c 2011-08-05 07:59:21.000000000 =
+0300
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c 2011-08-07 15:45:48.007088993 =
+0300
> @@ -378,7 +378,12 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> int len =3D 0;
> int i, off;
> uint32_t *ptr;
> - char buffer[1024];
> + char *buffer =3D kmalloc(1024, GFP_KERNEL);
> +
> + if(!buffer) {
> + printk(KERN_WARNING "lpfc_debugfs_dumpHBASlim_data: Unable to alloc=
ate
> memory\n");
> + return -ENOMEM;
> + }
>
> off =3D 0;
> spin_lock_irq(&phba->hbalock);
> @@ -387,7 +392,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> lpfc_memcpy_from_slim(buffer,
> phba->MBslimaddr + lpfc_debugfs_last_hba_slim_off, 1024);
>
> - ptr =3D (uint32_t *)&buffer[0];
> + ptr =3D (uint32_t *)buffer;
> off =3D lpfc_debugfs_last_hba_slim_off;
>
> /* Set it up for the next time */
> @@ -407,6 +412,7 @@ lpfc_debugfs_dumpHBASlim_data(struct lpf
> }
>
> spin_unlock_irq(&phba->hbalock);
> + kfree(buffer);
> return len;
> }
>
> Signed-off-by: Ionut Gabriel Popescu <poyo_vl@yahoo.com>
>
> Also, buffer is a pointer, so it is not necessary a &buffer[0], it al=
ready
> points to the first element.
>
> Hope this is usefull...
>
> Have a nice day,
> Ionut Popescu
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
