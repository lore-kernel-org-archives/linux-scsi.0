Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7148C636D3
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Feb 2023 19:51:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjBITvO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Feb 2023 14:51:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjBITvN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2023 14:51:13 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BB568AE4
        for <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2023 11:51:10 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id z5so3292041qtn.8
        for <linux-scsi@vger.kernel.org>; Thu, 09 Feb 2023 11:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7FJe5QrjriZZjkC//HZI4/ZTEEHP0Fbc4DNY2/JrfFU=;
        b=NAVnv4pgsQb5PDLFM7SU4HPeJrHz+nAxXwhovGn/Ra5r1ZVAT0BJoIhBiRlzEHllfX
         +7hvcjdksiANcm0DCvlwRltqxBvxHMUEnGW5GzdrtuB0XB8w6Qkl72wvJDs9YS/crbFv
         pocJ+2a4P8lT6YNGf1qWfyY0f/6+tuZdHfbzY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7FJe5QrjriZZjkC//HZI4/ZTEEHP0Fbc4DNY2/JrfFU=;
        b=e1MxQWJUGDEnMqJrk8nZQEpqnDO6TeHFju7QdiELvqPGvMm1L9+Cy2N7Z6q12svW3O
         EnQ4n4u899xPY+zYGo+jOceeumq4MOSddsXWcLDyLt8MLggRWt922d0zKWKeVMNGDqUH
         u4PV6jrX9wLcWB7DEFilU0Iu8ahEfZVkbBbSn8BPrjeZ+wxXrDmoWzu56erEUKyMRB39
         klZAGkkiEtnEOY/0qPe94nmdrZ+cFVkAdRzKImRPy6QpLUDel2JHsEnKCHJ+lwGUW64B
         1KKi82pWmkee1TZrBuIAip7I0sjDeDLa8VGzvdt2LhpOCwayQrvD6f1TSMfFNavdlaF8
         u2kA==
X-Gm-Message-State: AO0yUKXs5J52PAwKM4fDaSH4BuULlU7cfw5IBZrMG+Qu4UYDPVjB+eOK
        5SDLg7nTGjABSwNvYrhugquAIqjsA9NG+/28CtMamBdbuEZU4JpWv028j9Pigzb4TlM8Lgl7FUN
        ze2w52aGo177+AWQYOGl3v2lK9II=
X-Google-Smtp-Source: AK7set+mGsgghUkR4aYpEjnAya4VxYszRHq37DG5zdeocrPq6dLWJVwkJ98ze0cc1IqPYljyIWTYxsuYX7hkoYpBQaI=
X-Received: by 2002:ac8:5e46:0:b0:3b8:50b0:e36 with SMTP id
 i6-20020ac85e46000000b003b850b00e36mr1732610qtx.152.1675972269625; Thu, 09
 Feb 2023 11:51:09 -0800 (PST)
MIME-Version: 1.0
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com> <20230127063500.1278068-5-shinichiro.kawasaki@wdc.com>
In-Reply-To: <20230127063500.1278068-5-shinichiro.kawasaki@wdc.com>
From:   Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Date:   Thu, 9 Feb 2023 12:50:53 -0700
Message-ID: <CAFdVvOw4NmCcqMkGdYtfdXzvuWw5Puw8_2ritWiHBPwzz-YLTQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/5] scsi: mpi3mr: use number of bits to manage bitmap sizes
To:     "Shin'ichiro Kawasaki" <shinichiro.kawasaki@wdc.com>
Cc:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d03d0d05f449b342"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--000000000000d03d0d05f449b342
Content-Type: text/plain; charset="UTF-8"

On Thu, Jan 26, 2023 at 11:35 PM Shin'ichiro Kawasaki
<shinichiro.kawasaki@wdc.com> wrote:
>
> To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using
> byte as unit. However, bitmap helper functions assume that bitmaps are
> allocated using unsigned long as unit. This gap causes memory access
> beyond the bitmap sizes and results in "BUG: KASAN: slab-out-of-bounds".
> The BUG was observed at firmware download to eHBA-9600. Call trace
> indicated that the out-of-bounds access happened in find_first_zero_bit
> called from mpi3mr_send_event_ack for miroc->evtack_cmds_bitmap.
>
> To fix the BUG, do not use bytes to manage bitmap sizes. Instead, use
> number of bits, and call bitmap helper functions which take number of
> bits as arguments. For memory allocation, call bitmap_zalloc instead of
> kzalloc. For zero clear, call bitmap_clear instead of memset. For
> resize, call bitmap_zalloc and bitmap_copy instead of krealloc.
>
> Remove three fields for bitmap byte sizes in struct scmd_priv, which are
> no longer required. Replace the field dev_handle_bitmap_sz with
> dev_handle_bitmap_bits to keep number of bits of removepend_bitmap
> across resize.
>
>>Thanks for getting this changed, can you please change the kfree for the bitmaps to bitmap_free for consistency of the API.
> Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
> Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    | 10 +----
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 68 ++++++++++++++-------------------
>  2 files changed, 30 insertions(+), 48 deletions(-)
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index def4c5e15cd8..8a438f248a82 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -955,19 +955,16 @@ struct scmd_priv {
>   * @chain_buf_count: Chain buffer count
>   * @chain_buf_pool: Chain buffer pool
>   * @chain_sgl_list: Chain SGL list
> - * @chain_bitmap_sz: Chain buffer allocator bitmap size
>   * @chain_bitmap: Chain buffer allocator bitmap
>   * @chain_buf_lock: Chain buffer list lock
>   * @bsg_cmds: Command tracker for BSG command
>   * @host_tm_cmds: Command tracker for task management commands
>   * @dev_rmhs_cmds: Command tracker for device removal commands
>   * @evtack_cmds: Command tracker for event ack commands
> - * @devrem_bitmap_sz: Device removal bitmap size
>   * @devrem_bitmap: Device removal bitmap
> - * @dev_handle_bitmap_sz: Device handle bitmap size
> + * @dev_handle_bitmap_bits: Number of bits in device handle bitmap
>   * @removepend_bitmap: Remove pending bitmap
>   * @delayed_rmhs_list: Delayed device removal list
> - * @evtack_cmds_bitmap_sz: Event Ack bitmap size
>   * @evtack_cmds_bitmap: Event Ack bitmap
>   * @delayed_evtack_cmds_list: Delayed event acknowledgment list
>   * @ts_update_counter: Timestamp update counter
> @@ -1128,7 +1125,6 @@ struct mpi3mr_ioc {
>         u32 chain_buf_count;
>         struct dma_pool *chain_buf_pool;
>         struct chain_element *chain_sgl_list;
> -       u16  chain_bitmap_sz;
>         void *chain_bitmap;
>         spinlock_t chain_buf_lock;
>
> @@ -1136,12 +1132,10 @@ struct mpi3mr_ioc {
>         struct mpi3mr_drv_cmd host_tm_cmds;
>         struct mpi3mr_drv_cmd dev_rmhs_cmds[MPI3MR_NUM_DEVRMCMD];
>         struct mpi3mr_drv_cmd evtack_cmds[MPI3MR_NUM_EVTACKCMD];
> -       u16 devrem_bitmap_sz;
>         void *devrem_bitmap;
> -       u16 dev_handle_bitmap_sz;
> +       u16 dev_handle_bitmap_bits;
>         void *removepend_bitmap;
>         struct list_head delayed_rmhs_list;
> -       u16 evtack_cmds_bitmap_sz;
>         void *evtack_cmds_bitmap;
>         struct list_head delayed_evtack_cmds_list;
>
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 286a44506578..d25cd0382e20 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1128,7 +1128,6 @@ static int mpi3mr_issue_and_process_mur(struct mpi3mr_ioc *mrioc,
>  static int
>  mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
>  {
> -       u16 dev_handle_bitmap_sz;
>         void *removepend_bitmap;
>
>         if (mrioc->facts.reply_sz > mrioc->reply_sz) {
> @@ -1160,25 +1159,24 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
>                     "\tcontroller while sas transport support is enabled at the\n"
>                     "\tdriver, please reboot the system or reload the driver\n");
>
> -       dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
> -       if (mrioc->facts.max_devhandle % 8)
> -               dev_handle_bitmap_sz++;
> -       if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
> -               removepend_bitmap = krealloc(mrioc->removepend_bitmap,
> -                   dev_handle_bitmap_sz, GFP_KERNEL);
> +       if (mrioc->facts.max_devhandle > mrioc->dev_handle_bitmap_bits) {
>>Free the existing removepend_bitmap prior the alloc.
> +               removepend_bitmap = bitmap_zalloc(mrioc->facts.max_devhandle,
> +                                                 GFP_KERNEL);
>                 if (!removepend_bitmap) {
>                         ioc_err(mrioc,
> -                           "failed to increase removepend_bitmap sz from: %d to %d\n",
> -                           mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
> +                               "failed to increase removepend_bitmap bits from %d to %d\n",
> +                               mrioc->dev_handle_bitmap_bits,
> +                               mrioc->facts.max_devhandle);
>                         return -EPERM;
>                 }
> -               memset(removepend_bitmap + mrioc->dev_handle_bitmap_sz, 0,
> -                   dev_handle_bitmap_sz - mrioc->dev_handle_bitmap_sz);
> +               bitmap_copy(removepend_bitmap, mrioc->removepend_bitmap,
> +                           mrioc->dev_handle_bitmap_bits);
>>This copy is not needed as the data in the removepend_bitmap is not valid after reset and the zalloc already cleared the memory.

>                 mrioc->removepend_bitmap = removepend_bitmap;
>                 ioc_info(mrioc,
> -                   "increased dev_handle_bitmap_sz from %d to %d\n",
> -                   mrioc->dev_handle_bitmap_sz, dev_handle_bitmap_sz);
> -               mrioc->dev_handle_bitmap_sz = dev_handle_bitmap_sz;
> +                        "increased bits of dev_handle_bitmap from %d to %d\n",
> +                        mrioc->dev_handle_bitmap_bits,
> +                        mrioc->facts.max_devhandle);
> +               mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
>         }
>
>         return 0;
> @@ -2957,27 +2955,18 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
>         if (!mrioc->pel_abort_cmd.reply)
>                 goto out_failed;
>
> -       mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
> -       if (mrioc->facts.max_devhandle % 8)
> -               mrioc->dev_handle_bitmap_sz++;
> -       mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
> -           GFP_KERNEL);
> +       mrioc->dev_handle_bitmap_bits = mrioc->facts.max_devhandle;
> +       mrioc->removepend_bitmap = bitmap_zalloc(mrioc->dev_handle_bitmap_bits,
> +                                                GFP_KERNEL);
>         if (!mrioc->removepend_bitmap)
>                 goto out_failed;
>
> -       mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
> -       if (MPI3MR_NUM_DEVRMCMD % 8)
> -               mrioc->devrem_bitmap_sz++;
> -       mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
> -           GFP_KERNEL);
> +       mrioc->devrem_bitmap = bitmap_zalloc(MPI3MR_NUM_DEVRMCMD, GFP_KERNEL);
>         if (!mrioc->devrem_bitmap)
>                 goto out_failed;
>
> -       mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
> -       if (MPI3MR_NUM_EVTACKCMD % 8)
> -               mrioc->evtack_cmds_bitmap_sz++;
> -       mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
> -           GFP_KERNEL);
> +       mrioc->evtack_cmds_bitmap = bitmap_zalloc(MPI3MR_NUM_EVTACKCMD,
> +                                                 GFP_KERNEL);
>         if (!mrioc->evtack_cmds_bitmap)
>                 goto out_failed;
>
> @@ -3415,10 +3404,7 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
>                 if (!mrioc->chain_sgl_list[i].addr)
>                         goto out_failed;
>         }
> -       mrioc->chain_bitmap_sz = num_chains / 8;
> -       if (num_chains % 8)
> -               mrioc->chain_bitmap_sz++;
> -       mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
> +       mrioc->chain_bitmap = bitmap_zalloc(num_chains, GFP_KERNEL);
>         if (!mrioc->chain_bitmap)
>                 goto out_failed;
>         return retval;
> @@ -4189,10 +4175,11 @@ void mpi3mr_memset_buffers(struct mpi3mr_ioc *mrioc)
>                 for (i = 0; i < MPI3MR_NUM_EVTACKCMD; i++)
>                         memset(mrioc->evtack_cmds[i].reply, 0,
>                             sizeof(*mrioc->evtack_cmds[i].reply));
> -               memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
> -               memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
> -               memset(mrioc->evtack_cmds_bitmap, 0,
> -                   mrioc->evtack_cmds_bitmap_sz);
> +               bitmap_clear(mrioc->removepend_bitmap, 0,
> +                            mrioc->dev_handle_bitmap_bits);
> +               bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
> +               bitmap_clear(mrioc->evtack_cmds_bitmap, 0,
> +                            MPI3MR_NUM_EVTACKCMD);
>         }
>
>         for (i = 0; i < mrioc->num_queues; i++) {
> @@ -4886,9 +4873,10 @@ int mpi3mr_soft_reset_handler(struct mpi3mr_ioc *mrioc,
>
>         mpi3mr_flush_delayed_cmd_lists(mrioc);
>         mpi3mr_flush_drv_cmds(mrioc);
> -       memset(mrioc->devrem_bitmap, 0, mrioc->devrem_bitmap_sz);
> -       memset(mrioc->removepend_bitmap, 0, mrioc->dev_handle_bitmap_sz);
> -       memset(mrioc->evtack_cmds_bitmap, 0, mrioc->evtack_cmds_bitmap_sz);
> +       bitmap_clear(mrioc->devrem_bitmap, 0, MPI3MR_NUM_DEVRMCMD);
> +       bitmap_clear(mrioc->removepend_bitmap, 0,
> +                    mrioc->dev_handle_bitmap_bits);
> +       bitmap_clear(mrioc->evtack_cmds_bitmap, 0, MPI3MR_NUM_EVTACKCMD);
>         mpi3mr_flush_host_io(mrioc);
>         mpi3mr_cleanup_fwevt_list(mrioc);
>         mpi3mr_invalidate_devhandles(mrioc);
> --
> 2.38.1
>

-- 
This electronic communication and the information and any files transmitted 
with it, or attached to it, are confidential and are intended solely for 
the use of the individual or entity to whom it is addressed and may contain 
information that is confidential, legally privileged, protected by privacy 
laws, or otherwise restricted from disclosure to anyone else. If you are 
not the intended recipient or the person responsible for delivering the 
e-mail to the intended recipient, you are hereby notified that any use, 
copying, distributing, dissemination, forwarding, printing, or copying of 
this e-mail is strictly prohibited. If you received this e-mail in error, 
please return the e-mail to the sender, delete it from your computer, and 
destroy any printed copy of it.

--000000000000d03d0d05f449b342
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQfwYJKoZIhvcNAQcCoIIQcDCCEGwCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3WMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBV4wggRGoAMCAQICDHaunag8W3WF223yXzANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAwOTIyMDdaFw0yNTA5MTAwOTIyMDdaMIGe
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xIzAhBgNVBAMTGlNhdGh5YSBQcmFrYXNoIFZlZXJpY2hldHR5
MSowKAYJKoZIhvcNAQkBFhtzYXRoeWEucHJha2FzaEBicm9hZGNvbS5jb20wggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQDGjy0XuBfehlx6HnXduSKHPlNGD4j6bgOuN0IKSwQe1xZORXYF
87jWyJJGmBB8PX4vyLLa/JUKQpC1NOg8Q2Nl1CccFKkP7lUkeIkmuhshlbWmATKu7XZACMpLT0Kt
BlcuQPUykB6RwKI+DrU5NlUInI49lWiK4BtJPrjpVBPMPrG3mWUrvxRfr9MItFizIIXp/HmLtkt1
v82E+npLwqC8bSHh1m6BJewfpawx72uKM9aFs6SVpLPtN6a5369OCwVeEwkk2FeFU9tZXWBnI4Wu
d1Q4a3vhOColD6PdTWv74Ez2I3ahCkmpeEQ1YMt61TUH3W8NUJJeYN2xkR6OGsA1AgMBAAGjggHc
MIIB2DAOBgNVHQ8BAf8EBAMCBaAwgaMGCCsGAQUFBwEBBIGWMIGTME4GCCsGAQUFBzAChkJodHRw
Oi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAy
MC5jcnQwQQYIKwYBBQUHMAGGNWh0dHA6Ly9vY3NwLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJz
b25hbHNpZ24yY2EyMDIwME0GA1UdIARGMEQwQgYKKwYBBAGgMgEoCjA0MDIGCCsGAQUFBwIBFiZo
dHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAJBgNVHRMEAjAAMEkGA1UdHwRC
MEAwPqA8oDqGOGh0dHA6Ly9jcmwuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJj
YTIwMjAuY3JsMCYGA1UdEQQfMB2BG3NhdGh5YS5wcmFrYXNoQGJyb2FkY29tLmNvbTATBgNVHSUE
DDAKBggrBgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU
VyBc/F5XGkYNCP9Rb96mru8lU4AwDQYJKoZIhvcNAQELBQADggEBACiysbqj0ggjcc9uzOpBkt1Q
nGtvHhd9pbNmshJRUoNL11pQEzupSsUkDoAa6hPrOaJVobIO+yC84D4GXQc13Jk0QZQhRJJRYLwk
vdq704JPh4ULIwofTWqwsiZ1OvINzX9h9KEw/+h+Mc3YUCO7tvKBGLJTUaUhrjxyjLQdEK1Xp/8B
kYd5quZssxYPJ3nl37Moy/U9ZM2F0Ivv4U3wyP5y5cdmBUBAGOd94rH60fVDVogEo5F9gXrZhT/4
jKzCG3LclOOzLinCkK2J5GYngIUHSmnqk909QPG6jkx5RJWwkpTzm+AAVbJ9a+1F/8iR3FiDddEK
8wQJuWG84jqd/9wxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxT
aWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAy
MDIwAgx2rp2oPFt1hdtt8l8wDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPqrwWJr
m5e1fDoVG3+ko3u1N8o5ae//dJFqi/XkyL1bMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTIzMDIwOTE5NTExMFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASow
CwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZI
hvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQB3g1ieFM91IvDVziTCOpJ97VTM
cEeq+WPcO+eVli6R7+dKXHWcokFkYCC2zPO32yaU5qnwiotaddZEQvk8q05SCvlVPQfJPQ9qGWmv
GJzMnG6fDsxX6/Be0d8b6Ua+42qZRY7kPOW/7S5KcjNKQETbMZ/BQnZOlhP/u4TfjthPA3PNx/tS
JcwCZMhFxH2kbIWpWQIFshSGw6lboFWGaMMWSBJx3300p9eXFq1oqQ6CRd+rXXVQovBEcVM1LmQk
W37cmA//yNhSoAVXqWn0RafDCNujXETQhM5wvZy+KT+QT8jUe/jZW43p5T5Oyea3GiJPcqGZc5zg
QtcytJ7qa/rv
--000000000000d03d0d05f449b342--
