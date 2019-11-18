Return-Path: <SRS0=r6FR=ZK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A4C0C432C3
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:43:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1390D206CC
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Nov 2019 09:43:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="Q1RJVlz4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfKRJny (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Nov 2019 04:43:54 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:45676 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfKRJny (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Nov 2019 04:43:54 -0500
Received: by mail-io1-f66.google.com with SMTP id v17so6840601iol.12
        for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2019 01:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=seh7igrgqpU8nYmlQX5hl61XoVoKqEsM+xxmEdD+LdU=;
        b=Q1RJVlz4z9h6N1u4yKwTFOESDQseAw9aFIOn5C2wWcmFX0nXE7TA6j1SfoZ/rPuIq7
         7TFRYUUNS6hlmu9fis6YFqh4C+l8V0wxtwIHCvsH93tCZGF7CgN2riQJLr6c29dDSKgJ
         GE/LmyNJIl2NTbfjQiGn8qhdc6C0PmUs/qUg7Zd9k605qX5N9B2nVmymGVef+UwlmZOF
         dkxex8Ox/VlLf5me5xQxkb3EqqH4H6UFDUktUCzro7xsfVUMB+Dt7F2dW2HG56clqsj8
         BDSFnQNRqrZBgTSOnKV4xKOlYvr3qHdYf6yz/Vy97qEvHwP4q+nsiYhdYRuhyctzDjmz
         HTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=seh7igrgqpU8nYmlQX5hl61XoVoKqEsM+xxmEdD+LdU=;
        b=PEW7ShZ53/o6sO55AOBLz6CgeGeRTTXfNfoQi52ZffbGpIoCQxDL4A04eUSjVA+XWp
         vDcigOJrFB5uCt9cSAL96TgDyDT2rBzqcJCZwQLQhKnZqUM8OY+24uF8NTZZV6aGfuHL
         TkenggH9tJKkwCjdpHO006i5GYFNDQtDJ8GCjunzk31tugUn5nBAtL5DYGFWx091d6Fq
         JoAD1eavyME9XT74BJiwtgtQtOC//ovlDKlOULB+QP3Zefjd4SZasb9MClLER6L46tEE
         WMn8zB3+zSgrW6nsJ85G06d69wiZ8WOkuGisJA22REesgncOGunFyCwkCtV16RJOEGKd
         W9SA==
X-Gm-Message-State: APjAAAVHZWnRwir+FMDkYkmyWpHQiE9TpQBCx0pFWRDpJNXmfcYzdkCP
        vcZPO1FeeXbbZJ6mWSUP01S5Xd/P7vp1jPvt9AWSTg==
X-Google-Smtp-Source: APXvYqwtAlu2EFHvmbEiG1W4nl97n7i4FuwowaHnRcLNku5JEk3la/foHI30xw3+5ImvUTHiVmy1Hy9tR9yZAEwBONM=
X-Received: by 2002:a02:9047:: with SMTP id y7mr12369843jaf.13.1574070233250;
 Mon, 18 Nov 2019 01:43:53 -0800 (PST)
MIME-Version: 1.0
References: <20191114100910.6153-1-deepak.ukey@microchip.com> <20191114100910.6153-14-deepak.ukey@microchip.com>
In-Reply-To: <20191114100910.6153-14-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 18 Nov 2019 10:43:42 +0100
Message-ID: <CAMGffEmrY9qb34Nw-C+QxFRB+dW8y=sgaxdHWM1sT2kfpySLEQ@mail.gmail.com>
Subject: Re: [PATCH V2 13/13] pm80xx : Modified the logic to collect fatal dump.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com, Viswas.G@microchip.com,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        jsperbeck@google.com, Vikram Auradkar <auradkar@google.com>,
        ianyar@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Nov 14, 2019 at 11:08 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the correct method to collect the fatal dump.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Reported-by: kbuild test robot <lkp@intel.com>
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_sas.h |   3 +
>  drivers/scsi/pm8001/pm80xx_hwi.c | 251 ++++++++++++++++++++++++++++++---------
>  2 files changed, 195 insertions(+), 59 deletions(-)
>
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index a55b03bca529..93438c8f67da 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -152,6 +152,8 @@ struct pm8001_ioctl_payload {
>  #define MPI_FATAL_EDUMP_TABLE_HANDSHAKE            0x0C     /* FDDHSHK */
>  #define MPI_FATAL_EDUMP_TABLE_STATUS               0x10     /* FDDTSTAT */
>  #define MPI_FATAL_EDUMP_TABLE_ACCUM_LEN            0x14     /* ACCDDLEN */
> +#define MPI_FATAL_EDUMP_TABLE_TOTAL_LEN                   0x18     /* TOTALLEN */
> +#define MPI_FATAL_EDUMP_TABLE_SIGNATURE                   0x1C     /* SIGNITURE */
>  #define MPI_FATAL_EDUMP_HANDSHAKE_RDY              0x1
>  #define MPI_FATAL_EDUMP_HANDSHAKE_BUSY             0x0
>  #define MPI_FATAL_EDUMP_TABLE_STAT_RSVD                 0x0
> @@ -507,6 +509,7 @@ struct pm8001_hba_info {
>         u32                     forensic_last_offset;
>         u32                     fatal_forensic_shift_offset;
>         u32                     forensic_fatal_step;
> +       u32                     forensic_preserved_accumulated_transfer;
>         u32                     evtlog_ib_offset;
>         u32                     evtlog_ob_offset;
>         void __iomem    *msg_unit_tbl_addr;/*Message Unit Table Addr*/
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index 5ca9732f4704..19601138e889 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -76,7 +76,7 @@ void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
>         destination1 = (u32 *)destination;
>
>         for (index = 0; index < dw_count; index += 4, destination1++) {
> -               offset = (soffset + index / 4);
> +               offset = (soffset + index);
>                 if (offset < (64 * 1024)) {
>                         value = pm8001_cr32(pm8001_ha, bus_base_number, offset);
>                         *destination1 =  cpu_to_le32(value);
> @@ -93,9 +93,12 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>         struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
>         void __iomem *fatal_table_address = pm8001_ha->fatal_tbl_addr;
>         u32 accum_len , reg_val, index, *temp;
> +       u32 status = 1;
>         unsigned long start;
>         u8 *direct_data;
>         char *fatal_error_data = buf;
> +       u32 length_to_read;
> +       u32 offset;
>
>         pm8001_ha->forensic_info.data_buf.direct_data = buf;
>         if (pm8001_ha->chip_id == chip_8001) {
> @@ -105,16 +108,35 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
>                         (char *)buf;
>         }
> +       /* initialize variables for very first call from host application */
>         if (pm8001_ha->forensic_info.data_buf.direct_offset == 0) {
>                 PM8001_IO_DBG(pm8001_ha,
>                 pm8001_printk("forensic_info TYPE_NON_FATAL..............\n"));
>                 direct_data = (u8 *)fatal_error_data;
>                 pm8001_ha->forensic_info.data_type = TYPE_NON_FATAL;
>                 pm8001_ha->forensic_info.data_buf.direct_len = SYSFS_OFFSET;
> +               pm8001_ha->forensic_info.data_buf.direct_offset = 0;
>                 pm8001_ha->forensic_info.data_buf.read_len = 0;
> +               pm8001_ha->forensic_preserved_accumulated_transfer = 0;
>
> -               pm8001_ha->forensic_info.data_buf.direct_data = direct_data;
> +               /* Write signature to fatal dump table */
> +               pm8001_mw32(fatal_table_address,
> +                               MPI_FATAL_EDUMP_TABLE_SIGNATURE, 0x1234abcd);
>
> +               pm8001_ha->forensic_info.data_buf.direct_data = direct_data;
> +               PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("ossaHwCB: status1 %d\n", status));
> +               PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("ossaHwCB: read_len 0x%x\n",
> +                       pm8001_ha->forensic_info.data_buf.read_len));
> +               PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("ossaHwCB: direct_len 0x%x\n",
> +                       pm8001_ha->forensic_info.data_buf.direct_len));
> +               PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("ossaHwCB: direct_offset 0x%x\n",
> +                       pm8001_ha->forensic_info.data_buf.direct_offset));
> +       }
> +       if (pm8001_ha->forensic_info.data_buf.direct_offset == 0) {
>                 /* start to get data */
>                 /* Program the MEMBASE II Shifting Register with 0x00.*/
>                 pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
> @@ -127,30 +149,66 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>         /* Read until accum_len is retrived */
>         accum_len = pm8001_mr32(fatal_table_address,
>                                 MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
> -       PM8001_IO_DBG(pm8001_ha, pm8001_printk("accum_len 0x%x\n",
> -                                               accum_len));
> +       /* Determine length of data between previously stored transfer length
> +        * and current accumulated transfer length
> +        */
> +       length_to_read =
> +               accum_len - pm8001_ha->forensic_preserved_accumulated_transfer;
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: accum_len 0x%x\n", accum_len));
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: length_to_read 0x%x\n",
> +               length_to_read));
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: last_offset 0x%x\n",
> +               pm8001_ha->forensic_last_offset));
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: read_len 0x%x\n",
> +               pm8001_ha->forensic_info.data_buf.read_len));
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv:: direct_len 0x%x\n",
> +               pm8001_ha->forensic_info.data_buf.direct_len));
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv:: direct_offset 0x%x\n",
> +               pm8001_ha->forensic_info.data_buf.direct_offset));
> +
> +       /* If accumulated length failed to read correctly fail the attempt.*/
>         if (accum_len == 0xFFFFFFFF) {
>                 PM8001_IO_DBG(pm8001_ha,
>                         pm8001_printk("Possible PCI issue 0x%x not expected\n",
> -                               accum_len));
> -               return -EIO;
> +                       accum_len));
> +               return status;
>         }
> -       if (accum_len == 0 || accum_len >= 0x100000) {
> +       /* If accumulated length is zero fail the attempt */
> +       if (accum_len == 0) {
>                 pm8001_ha->forensic_info.data_buf.direct_data +=
>                         sprintf(pm8001_ha->forensic_info.data_buf.direct_data,
> -                               "%08x ", 0xFFFFFFFF);
> +                       "%08x ", 0xFFFFFFFF);
>                 return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
>                         (char *)buf;
>         }
> +       /* Accumulated length is good so start capturing the first data */
>         temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
>         if (pm8001_ha->forensic_fatal_step == 0) {
>  moreData:
> +               /* If data to read is less than SYSFS_OFFSET then reduce the
> +                * length of dataLen
> +                */
> +               if (pm8001_ha->forensic_last_offset + SYSFS_OFFSET
> +                               > length_to_read) {
> +                       pm8001_ha->forensic_info.data_buf.direct_len =
> +                               length_to_read -
> +                               pm8001_ha->forensic_last_offset;
> +               } else {
> +                       pm8001_ha->forensic_info.data_buf.direct_len =
> +                               SYSFS_OFFSET;
> +               }
>                 if (pm8001_ha->forensic_info.data_buf.direct_data) {
>                         /* Data is in bar, copy to host memory */
> -                       pm80xx_pci_mem_copy(pm8001_ha, pm8001_ha->fatal_bar_loc,
> -                        pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr,
> -                               pm8001_ha->forensic_info.data_buf.direct_len ,
> -                                       1);
> +                       pm80xx_pci_mem_copy(pm8001_ha,
> +                       pm8001_ha->fatal_bar_loc,
> +                       pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr,
> +                       pm8001_ha->forensic_info.data_buf.direct_len, 1);
>                 }
>                 pm8001_ha->fatal_bar_loc +=
>                         pm8001_ha->forensic_info.data_buf.direct_len;
> @@ -161,21 +219,29 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 pm8001_ha->forensic_info.data_buf.read_len =
>                         pm8001_ha->forensic_info.data_buf.direct_len;
>
> -               if (pm8001_ha->forensic_last_offset  >= accum_len) {
> +               if (pm8001_ha->forensic_last_offset  >= length_to_read) {
>                         pm8001_ha->forensic_info.data_buf.direct_data +=
>                         sprintf(pm8001_ha->forensic_info.data_buf.direct_data,
>                                 "%08x ", 3);
> -                       for (index = 0; index < (SYSFS_OFFSET / 4); index++) {
> +                       for (index = 0; index <
> +                               (pm8001_ha->forensic_info.data_buf.direct_len
> +                                / 4); index++) {
>                                 pm8001_ha->forensic_info.data_buf.direct_data +=
> -                                       sprintf(pm8001_ha->
> -                                        forensic_info.data_buf.direct_data,
> -                                               "%08x ", *(temp + index));
> +                               sprintf(
> +                               pm8001_ha->forensic_info.data_buf.direct_data,
> +                               "%08x ", *(temp + index));
>                         }
>
>                         pm8001_ha->fatal_bar_loc = 0;
>                         pm8001_ha->forensic_fatal_step = 1;
>                         pm8001_ha->fatal_forensic_shift_offset = 0;
>                         pm8001_ha->forensic_last_offset = 0;
> +                       status = 0;
> +                       offset = (int)
> +                       ((char *)pm8001_ha->forensic_info.data_buf.direct_data
> +                       - (char *)buf);
> +                       PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("get_fatal_spcv:return1 0x%x\n", offset));
>                         return (char *)pm8001_ha->
>                                 forensic_info.data_buf.direct_data -
>                                 (char *)buf;
> @@ -185,12 +251,20 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                                 sprintf(pm8001_ha->
>                                         forensic_info.data_buf.direct_data,
>                                         "%08x ", 2);
> -                       for (index = 0; index < (SYSFS_OFFSET / 4); index++) {
> -                               pm8001_ha->forensic_info.data_buf.direct_data +=
> -                                       sprintf(pm8001_ha->
> +                       for (index = 0; index <
> +                               (pm8001_ha->forensic_info.data_buf.direct_len
> +                                / 4); index++) {
> +                               pm8001_ha->forensic_info.data_buf.direct_data
> +                                       += sprintf(pm8001_ha->
>                                         forensic_info.data_buf.direct_data,
>                                         "%08x ", *(temp + index));
>                         }
> +                       status = 0;
> +                       offset = (int)
> +                       ((char *)pm8001_ha->forensic_info.data_buf.direct_data
> +                       - (char *)buf);
> +                       PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("get_fatal_spcv:return2 0x%x\n", offset));
>                         return (char *)pm8001_ha->
>                                 forensic_info.data_buf.direct_data -
>                                 (char *)buf;
> @@ -200,63 +274,122 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 pm8001_ha->forensic_info.data_buf.direct_data +=
>                         sprintf(pm8001_ha->forensic_info.data_buf.direct_data,
>                                 "%08x ", 2);
> -               for (index = 0; index < 256; index++) {
> +               for (index = 0; index <
> +                       (pm8001_ha->forensic_info.data_buf.direct_len
> +                        / 4) ; index++) {
>                         pm8001_ha->forensic_info.data_buf.direct_data +=
>                                 sprintf(pm8001_ha->
> -                                       forensic_info.data_buf.direct_data,
> -                                               "%08x ", *(temp + index));
> +                               forensic_info.data_buf.direct_data,
> +                               "%08x ", *(temp + index));
>                 }
>                 pm8001_ha->fatal_forensic_shift_offset += 0x100;
>                 pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
>                         pm8001_ha->fatal_forensic_shift_offset);
>                 pm8001_ha->fatal_bar_loc = 0;
> +               status = 0;
> +               offset = (int)
> +                       ((char *)pm8001_ha->forensic_info.data_buf.direct_data
> +                       - (char *)buf);
> +               PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: return3 0x%x\n", offset));
>                 return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
>                         (char *)buf;
>         }
>         if (pm8001_ha->forensic_fatal_step == 1) {
> -               pm8001_ha->fatal_forensic_shift_offset = 0;
> -               /* Read 64K of the debug data. */
> -               pm8001_cw32(pm8001_ha, 0, MEMBASE_II_SHIFT_REGISTER,
> -                       pm8001_ha->fatal_forensic_shift_offset);
> -               pm8001_mw32(fatal_table_address,
> -                       MPI_FATAL_EDUMP_TABLE_HANDSHAKE,
> +               /* store previous accumulated length before triggering next
> +                * accumulated length update
> +                */
> +               pm8001_ha->forensic_preserved_accumulated_transfer =
> +                       pm8001_mr32(fatal_table_address,
> +                       MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
> +
> +               /* continue capturing the fatal log until Dump status is 0x3 */
> +               if (pm8001_mr32(fatal_table_address,
> +                       MPI_FATAL_EDUMP_TABLE_STATUS) <
> +                       MPI_FATAL_EDUMP_TABLE_STAT_NF_SUCCESS_DONE) {
> +
> +                       /* reset fddstat bit by writing to zero*/
> +                       pm8001_mw32(fatal_table_address,
> +                                       MPI_FATAL_EDUMP_TABLE_STATUS, 0x0);
> +
> +                       /* set dump control value to '1' so that new data will
> +                        * be transferred to shared memory
> +                        */
> +                       pm8001_mw32(fatal_table_address,
> +                               MPI_FATAL_EDUMP_TABLE_HANDSHAKE,
>                                 MPI_FATAL_EDUMP_HANDSHAKE_RDY);
>
> -               /* Poll FDDHSHK  until clear  */
> -               start = jiffies + (2 * HZ); /* 2 sec */
> +                       /*Poll FDDHSHK  until clear */
> +                       start = jiffies + (2 * HZ); /* 2 sec */
>
> -               do {
> -                       reg_val = pm8001_mr32(fatal_table_address,
> +                       do {
> +                               reg_val = pm8001_mr32(fatal_table_address,
>                                         MPI_FATAL_EDUMP_TABLE_HANDSHAKE);
> -               } while ((reg_val) && time_before(jiffies, start));
> +                       } while ((reg_val) && time_before(jiffies, start));
>
> -               if (reg_val != 0) {
> -                       PM8001_FAIL_DBG(pm8001_ha,
> -                       pm8001_printk("TIMEOUT:MEMBASE_II_SHIFT_REGISTER"
> -                       " = 0x%x\n", reg_val));
> -                       return -EIO;
> -               }
> -
> -               /* Read the next 64K of the debug data. */
> -               pm8001_ha->forensic_fatal_step = 0;
> -               if (pm8001_mr32(fatal_table_address,
> -                       MPI_FATAL_EDUMP_TABLE_STATUS) !=
> -                               MPI_FATAL_EDUMP_TABLE_STAT_NF_SUCCESS_DONE) {
> -                       pm8001_mw32(fatal_table_address,
> -                               MPI_FATAL_EDUMP_TABLE_HANDSHAKE, 0);
> -                       goto moreData;
> -               } else {
> -                       pm8001_ha->forensic_info.data_buf.direct_data +=
> -                               sprintf(pm8001_ha->
> -                                       forensic_info.data_buf.direct_data,
> -                                               "%08x ", 4);
> -                       pm8001_ha->forensic_info.data_buf.read_len = 0xFFFFFFFF;
> -                       pm8001_ha->forensic_info.data_buf.direct_len =  0;
> -                       pm8001_ha->forensic_info.data_buf.direct_offset = 0;
> -                       pm8001_ha->forensic_info.data_buf.read_len = 0;
> +                       if (reg_val != 0) {
> +                               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                               "TIMEOUT:MPI_FATAL_EDUMP_TABLE_HDSHAKE 0x%x\n",
> +                               reg_val));
> +                              /* Fail the dump if a timeout occurs */
> +                               pm8001_ha->forensic_info.data_buf.direct_data +=
> +                               sprintf(
> +                               pm8001_ha->forensic_info.data_buf.direct_data,
> +                               "%08x ", 0xFFFFFFFF);
> +                               return((char *)
> +                               pm8001_ha->forensic_info.data_buf.direct_data
> +                               - (char *)buf);
> +                       }
> +                       /* Poll status register until set to 2 or
> +                        * 3 for up to 2 seconds
> +                        */
> +                       start = jiffies + (2 * HZ); /* 2 sec */
> +
> +                       do {
> +                               reg_val = pm8001_mr32(fatal_table_address,
> +                                       MPI_FATAL_EDUMP_TABLE_STATUS);
> +                       } while (((reg_val != 2) || (reg_val != 3)) &&
> +                                       time_before(jiffies, start));
> +
> +                       if (reg_val < 2) {
> +                               PM8001_FAIL_DBG(pm8001_ha, pm8001_printk(
> +                               "TIMEOUT:MPI_FATAL_EDUMP_TABLE_STATUS = 0x%x\n",
> +                               reg_val));
> +                               /* Fail the dump if a timeout occurs */
> +                               pm8001_ha->forensic_info.data_buf.direct_data +=
> +                               sprintf(
> +                               pm8001_ha->forensic_info.data_buf.direct_data,
> +                               "%08x ", 0xFFFFFFFF);
> +                               pm8001_cw32(pm8001_ha, 0,
> +                                       MEMBASE_II_SHIFT_REGISTER,
> +                                       pm8001_ha->fatal_forensic_shift_offset);
> +                       }
> +                       /* Read the next block of the debug data.*/
> +                       length_to_read = pm8001_mr32(fatal_table_address,
> +                       MPI_FATAL_EDUMP_TABLE_ACCUM_LEN) -
> +                       pm8001_ha->forensic_preserved_accumulated_transfer;
> +                       if (length_to_read != 0x0) {
> +                               pm8001_ha->forensic_fatal_step = 0;
> +                               goto moreData;
> +                       } else {
> +                               pm8001_ha->forensic_info.data_buf.direct_data +=
> +                               sprintf(
> +                               pm8001_ha->forensic_info.data_buf.direct_data,
> +                               "%08x ", 4);
> +                               pm8001_ha->forensic_info.data_buf.read_len
> +                                                               = 0xFFFFFFFF;
> +                               pm8001_ha->forensic_info.data_buf.direct_len
> +                                                               =  0;
> +                               pm8001_ha->forensic_info.data_buf.direct_offset
> +                                                               = 0;
> +                               pm8001_ha->forensic_info.data_buf.read_len = 0;
> +                       }
>                 }
>         }
> -
> +       offset = (int)((char *)pm8001_ha->forensic_info.data_buf.direct_data
> +                       - (char *)buf);
> +       PM8001_IO_DBG(pm8001_ha,
> +               pm8001_printk("get_fatal_spcv: return4 0x%x\n", offset));
>         return (char *)pm8001_ha->forensic_info.data_buf.direct_data -
>                 (char *)buf;
>  }
> --
> 2.16.3
>
