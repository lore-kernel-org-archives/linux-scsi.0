Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15967C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 19:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244988AbiBQTH6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 14:07:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbiBQTH5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 14:07:57 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6632B254
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:07:43 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id h18so11400254edb.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 11:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FLAY+EAQbflspuYe8qZrDQ4eBps2DjNlcqEKNZgYy0U=;
        b=DwUVpSxB3AojvQ8cHci7MUiI35quPd8jDOUN8swJ9EsROMUevtEofYn1kPQfazW826
         g4yu2pdSpDsxdNTk0fi33hMNSjCzWOIgeD3ZxtJMcd2mjs6IRVtPkkrk20eaV/vCFa5Y
         UCx45788UtwsY6gvt08BMRc5ejlNGhfWZrn5P11TCKGuaK7nM7mV0txWGjX7kNZ/PaGw
         iaCP8Nom+mggo+V8EsQo/S/Ry2SIr/xT3bK8or0Tb71TTtvVbbjnqJul1w970OVldqLU
         D9BI2m7LKiQd0XrH9yAJXCtUd2+6fMoyJ/VSY9p7vxcFIuIkbWVlNWOeO1UODqflnYfa
         P1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FLAY+EAQbflspuYe8qZrDQ4eBps2DjNlcqEKNZgYy0U=;
        b=7acw6usLUjEpsdKWcwsYdLb9KCJ9lv0paiVnColo6T5kXWdWIfjHMxRcXkPN6NCQHm
         ts0QFf5b9j9yQWHScnLTPdz4LQrBeuOYzHEJGkWjsORKLJwoP/Qoy4iOyEYJq8pFzwkY
         BYflC/hKbdKw/TzlVDcKKhijRFY92wPzHaS+s1yPgpytIXuzarPR8uicFWlWmzq+nIdA
         DYPdQ4hBw3K5YbU3T9lGFYICtkOL2M9eQmd+6CE+EM6/7BryO8H8D3t0/iQddzkk6lfw
         PyaYPBcCcsRbCRqvzP9dhJTN0Qk6AuRkehB425DbAU/uxGec/W49nLPYKGFrz+ZGCxq/
         tvzA==
X-Gm-Message-State: AOAM533T0EhnQ7J6dkXldRZZHTVZZg1ksg2co8ts+siXiAdGWLNgpps9
        0E8+kBJbcBGOxlPdqKMVb5LGEKIhgAuat8HcKqShLNJN0qFx4A==
X-Google-Smtp-Source: ABdhPJwvoyJwFl6uOxUcNOENxYii4gXQ6BLGq3bptpFYkDCp98S01RVNp+q3txbSb5O9E3UUd5CPRiv8r2hjW43Lcwc=
X-Received: by 2002:aa7:c789:0:b0:410:dd40:d458 with SMTP id
 n9-20020aa7c789000000b00410dd40d458mr4397591eds.3.1645124861661; Thu, 17 Feb
 2022 11:07:41 -0800 (PST)
MIME-Version: 1.0
References: <20220217132956.484818-1-damien.lemoal@opensource.wdc.com> <20220217132956.484818-7-damien.lemoal@opensource.wdc.com>
In-Reply-To: <20220217132956.484818-7-damien.lemoal@opensource.wdc.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Thu, 17 Feb 2022 20:07:30 +0100
Message-ID: <CAMGffEmZnp0Yo5RuGYxkgwuD+HrGAkiK055K3YFVE69F56v9Yg@mail.gmail.com>
Subject: Re: [PATCH v4 06/31] scsi: pm8001: Fix command initialization in pm8001_chip_ssp_tm_req()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 17, 2022 at 2:30 PM Damien Le Moal
<damien.lemoal@opensource.wdc.com> wrote:
>
> The ds_ads_m field of struct ssp_ini_tm_start_req has the type __le32.
> Assigning a value to it should thus use cpu_to_le32(). This fixes the
> sparse warning:
>
> warning: incorrect type in assignment (different base types)
>    expected restricted __le32 [addressable] [assigned] [usertype] ds_ads_m
>    got int
>
> Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
thx!
> ---
>  drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
> index 817bba65feb3..e20a1d4db026 100644
> --- a/drivers/scsi/pm8001/pm8001_hwi.c
> +++ b/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -4619,7 +4619,7 @@ int pm8001_chip_ssp_tm_req(struct pm8001_hba_info *pm8001_ha,
>         memcpy(sspTMCmd.lun, task->ssp_task.LUN, 8);
>         sspTMCmd.tag = cpu_to_le32(ccb->ccb_tag);
>         if (pm8001_ha->chip_id != chip_8001)
> -               sspTMCmd.ds_ads_m = 0x08;
> +               sspTMCmd.ds_ads_m = cpu_to_le32(0x08);
>         circularQ = &pm8001_ha->inbnd_q_tbl[0];
>         ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &sspTMCmd,
>                         sizeof(sspTMCmd), 0);
> --
> 2.34.1
>
