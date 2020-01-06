Return-Path: <SRS0=I90e=23=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C7AC33C8C
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:34:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 477AD208C4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Jan 2020 16:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="eJ6ATWCb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgAFQeo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Jan 2020 11:34:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42855 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbgAFQen (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jan 2020 11:34:43 -0500
Received: by mail-io1-f68.google.com with SMTP id n11so42478976iom.9
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jan 2020 08:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5a3XxGaLvUm+8YfhpgpIQPdZZ4+CVir1jLuHzxR8ak4=;
        b=eJ6ATWCbp4M3J6VYHgshpZ0KEFT2RBHcC5fODW0wjVAcz6Q7Top7xkacjjDrr5Gfsv
         ooMsgatpZFLVaeBixVJod4WcANlUVc7JakIrWtAO0RnQZNngLTdkXWGO4HVmv5hArxuE
         +P12Xjk8TD9YIirnAMu7N1KZa20uA9Z+CoLCECF5W+AQh4vvrw/OOO9vLJI9y7F04IAa
         /69pe+ruiDVW8FwScrWPlJolcvUoSg75nDaLfhQuDJ9ANwoNpUhhjUu7exwmwBvmL7wW
         lbFgpqa1ERAKKojklKaHtGTpawN/tcSVs8gZlSg+M4GgeG/ivSwdwfS8dOCThpFexp8S
         sC4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5a3XxGaLvUm+8YfhpgpIQPdZZ4+CVir1jLuHzxR8ak4=;
        b=A7Qfr+wEZDGGFjKyRB+CCMY9cL26LEbQX46J3Xm8taE+Gh8p+0almBGH9DghueM+5p
         oEIQAdd+VlHGPCuWILGj5AJNK2v6raEizQGoiRi3lRwE6DVjWtpJ4OCqXJWWFFikXKBV
         fiG/NNjJPMbVoaMqftQ1+Fe52qT/t0u5+TWSphiBEZ0E4C9g8n+zbRDx2bitWJPw1dzW
         Qt8ZRqQ/CHW/OdpCwYMZO9AEFjHSqQyxi+V7tgxFmAyCzN+BVL7bjgGikD3wINfFLf5h
         xZe3yJnsApw+AQoLvaDakNL0oidUTHWjV5OH417UcuSQvMUo8IZbIQV6RoKY5utAWz5f
         gEUw==
X-Gm-Message-State: APjAAAVx/t6c4sBCrdb08Ld69hUYeCqsVRn4g24IfyQm6NTysBC1GkxR
        tbBDYGu+9dx/C3m5xUVNpvCI4Bp5AKydcjdAXNzzeA==
X-Google-Smtp-Source: APXvYqxkOBBlDbQimKA4EWQp7khTWeUPcH/75W4ZSzx4Cpu1JnpECkj4VYJpDHKyxaSCuI14uXJOGf77mn1dJN41Evc=
X-Received: by 2002:a05:6602:25d3:: with SMTP id d19mr57875397iop.217.1578328482838;
 Mon, 06 Jan 2020 08:34:42 -0800 (PST)
MIME-Version: 1.0
References: <20191224044143.8178-1-deepak.ukey@microchip.com> <20191224044143.8178-11-deepak.ukey@microchip.com>
In-Reply-To: <20191224044143.8178-11-deepak.ukey@microchip.com>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Mon, 6 Jan 2020 17:34:32 +0100
Message-ID: <CAMGffEkGk5woB0VWu1QFu7eS2NvV+ZDRXgzx=_A-7uKCrhbmiA@mail.gmail.com>
Subject: Re: [PATCH 10/12] pm80xx : sysfs attribute for non fatal dump.
To:     Deepak Ukey <deepak.ukey@microchip.com>
Cc:     Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        Vasanthalakshmi.Tharmarajan@microchip.com,
        Viswas G <Viswas.G@microchip.com>,
        Jack Wang <jinpu.wang@profitbricks.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>, dpf@google.com,
        yuuzheng@google.com, Vikram Auradkar <auradkar@google.com>,
        vishakhavc@google.com, bjashnani@google.com,
        Radha Ramachandran <radha@google.com>, akshatzen@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 24, 2019 at 5:41 AM Deepak Ukey <deepak.ukey@microchip.com> wrote:
>
> From: Deepak Ukey <Deepak.Ukey@microchip.com>
>
> Added the functionality to collect non fatal dump.
Please extend the commit message, what the use case, how to use it.
>
> Signed-off-by: Deepak Ukey <deepak.ukey@microchip.com>
> Signed-off-by: Viswas G <Viswas.G@microchip.com>
> Signed-off-by: Vishakha Channapattan <vishakhavc@google.com>
> Signed-off-by: Bhavesh Jashnani <bjashnani@google.com>
> Signed-off-by: Radha Ramachandran <radha@google.com>
> Signed-off-by: Akshat Jain <akshatzen@google.com>
> Signed-off-by: Yu Zheng <yuuzheng@google.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |  45 +++++++++++++
>  drivers/scsi/pm8001/pm8001_init.c |   1 +
>  drivers/scsi/pm8001/pm8001_sas.h  |   4 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 130 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 180 insertions(+)
>
> diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
> index 3e59b2a7185a..669c60a8d123 100644
> --- a/drivers/scsi/pm8001/pm8001_ctl.c
> +++ b/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -577,6 +577,49 @@ static ssize_t pm8001_ctl_fatal_log_show(struct device *cdev,
>
>  static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
>
> +/**
> + ** non_fatal_log_show - non fatal error logging
> + ** @cdev:pointer to embedded class device
> + ** @buf: the buffer returned
> + **
> + ** A sysfs 'read-only' shost attribute.
> + **/
> +static ssize_t non_fatal_log_show(struct device *cdev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       u32 count;
> +
> +       count = pm80xx_get_non_fatal_dump(cdev, attr, buf);
> +       return count;
> +}
> +static DEVICE_ATTR_RO(non_fatal_log);
I would suggest to use pm8001_ctl_non_fatal_log_show as function name,
or convert remove
the prefix for other functions, it's annoying to have different naming
convention.
> +
> +static ssize_t non_fatal_count_show(struct device *cdev,
> +               struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +
> +       return snprintf(buf, PAGE_SIZE, "%08x",
> +                       pm8001_ha->non_fatal_count);
> +}
> +
> +static ssize_t non_fatal_count_store(struct device *cdev,
> +               struct device_attribute *attr, const char *buf, size_t count)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       int val = 0;
> +
> +       if (kstrtoint(buf, 16, &val) != 0)
> +               return -EINVAL;
> +
> +       pm8001_ha->non_fatal_count = val;
> +       return strlen(buf);
> +}
> +static DEVICE_ATTR_RW(non_fatal_count);
>
>  /**
>   ** pm8001_ctl_gsm_log_show - gsm dump collection
> @@ -853,6 +896,8 @@ struct device_attribute *pm8001_host_attrs[] = {
>         &dev_attr_aap_log,
>         &dev_attr_iop_log,
>         &dev_attr_fatal_log,
> +       &dev_attr_non_fatal_log,
> +       &dev_attr_non_fatal_count,
>         &dev_attr_gsm_log,
>         &dev_attr_max_out_io,
>         &dev_attr_max_devices,
> diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
> index c8414f1b9652..b74282bc1ed0 100644
> --- a/drivers/scsi/pm8001/pm8001_init.c
> +++ b/drivers/scsi/pm8001/pm8001_init.c
> @@ -484,6 +484,7 @@ static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev,
>         pm8001_ha->shost = shost;
>         pm8001_ha->id = pm8001_id++;
>         pm8001_ha->logging_level = logging_level;
> +       pm8001_ha->non_fatal_count = 0;
>         if (link_rate >= 1 && link_rate <= 15)
>                 pm8001_ha->link_rate = (link_rate << 8);
>         else {
> diff --git a/drivers/scsi/pm8001/pm8001_sas.h b/drivers/scsi/pm8001/pm8001_sas.h
> index f95f4d714983..47607a25f819 100644
> --- a/drivers/scsi/pm8001/pm8001_sas.h
> +++ b/drivers/scsi/pm8001/pm8001_sas.h
> @@ -601,6 +601,8 @@ struct pm8001_hba_info {
>         struct                  sgpio_ioctl_resp sgpio_resp;
>         struct  phy_prof_resp   phy_profile_resp;
>         u32                     reset_in_progress;
> +       u32                     non_fatal_count;
> +       u32                     non_fatal_read_length;
>  };
>
>  struct pm8001_work {
> @@ -790,6 +792,8 @@ void pm8001_set_phy_profile_single(struct pm8001_hba_info *pm8001_ha,
>  int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue);
>  ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 struct device_attribute *attr, char *buf);
> +ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
> +               struct device_attribute *attr, char *buf);
>  ssize_t pm8001_get_gsm_dump(struct device *cdev, u32, char *buf);
>  /* ctl shared API */
>  extern struct device_attribute *pm8001_host_attrs[];
> diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
> index bbcdcff5d25b..4923660304aa 100644
> --- a/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ b/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -393,6 +393,136 @@ ssize_t pm80xx_get_fatal_dump(struct device *cdev,
>                 (char *)buf;
>  }
>
> +/* pm80xx_get_non_fatal_dump - dump the nonfatal data from the dma
> + * location by the firmware.
> + */
> +ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
> +       struct device_attribute *attr, char *buf)
> +{
> +       struct Scsi_Host *shost = class_to_shost(cdev);
> +       struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
> +       struct pm8001_hba_info *pm8001_ha = sha->lldd_ha;
> +       void __iomem *nonfatal_table_address = pm8001_ha->fatal_tbl_addr;
> +       u32 accum_len = 0;
> +       u32 total_len = 0;
> +       u32 reg_val = 0;
> +       u32 *temp = NULL;
> +       u32 index = 0;
> +       u32 output_length;
> +       unsigned long start = 0;
> +       char *buf_copy = buf;
> +
> +       temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
> +       if (++pm8001_ha->non_fatal_count == 1) {
> +               if (pm8001_ha->chip_id == chip_8001) {
> +                       snprintf(pm8001_ha->forensic_info.data_buf.direct_data,
> +                               PAGE_SIZE, "Not supported for SPC controller");
> +                       return 0;
> +               }
> +               PM8001_IO_DBG(pm8001_ha,
> +                       pm8001_printk("forensic_info TYPE_NON_FATAL...\n"));
> +               /*
> +                * Step 1: Write the host buffer parameters in the MPI Fatal and
> +                * Non-Fatal Error Dump Capture Table.This is the buffer
> +                * where debug data will be DMAed to.
> +                */
> +               pm8001_mw32(nonfatal_table_address,
> +               MPI_FATAL_EDUMP_TABLE_LO_OFFSET,
> +               pm8001_ha->memoryMap.region[FORENSIC_MEM].phys_addr_lo);
> +
> +               pm8001_mw32(nonfatal_table_address,
> +               MPI_FATAL_EDUMP_TABLE_HI_OFFSET,
> +               pm8001_ha->memoryMap.region[FORENSIC_MEM].phys_addr_hi);
> +
> +               pm8001_mw32(nonfatal_table_address,
> +               MPI_FATAL_EDUMP_TABLE_LENGTH, SYSFS_OFFSET);
> +
> +               /* Optionally, set the DUMPCTRL bit to 1 if the host
> +                * keeps sending active I/Os while capturing the non-fatal
> +                * debug data. Otherwise, leave this bit set to zero
> +                */
> +               pm8001_mw32(nonfatal_table_address,
> +               MPI_FATAL_EDUMP_TABLE_HANDSHAKE, MPI_FATAL_EDUMP_HANDSHAKE_RDY);
> +
> +               /*
> +                * Step 2: Clear Accumulative Length of Debug Data Transferred
> +                * [ACCDDLEN] field in the MPI Fatal and Non-Fatal Error Dump
> +                * Capture Table to zero.
> +                */
> +               pm8001_mw32(nonfatal_table_address,
> +                               MPI_FATAL_EDUMP_TABLE_ACCUM_LEN, 0);
> +
> +               /* initiallize previous accumulated length to 0 */
> +               pm8001_ha->forensic_preserved_accumulated_transfer = 0;
> +               pm8001_ha->non_fatal_read_length = 0;
> +       }
> +
> +       total_len = pm8001_mr32(nonfatal_table_address,
> +                       MPI_FATAL_EDUMP_TABLE_TOTAL_LEN);
> +       /*
> +        * Step 3:Clear Fatal/Non-Fatal Debug Data Transfer Status [FDDTSTAT]
> +        * field and then request that the SPCv controller transfer the debug
> +        * data by setting bit 7 of the Inbound Doorbell Set Register.
> +        */
> +       pm8001_mw32(nonfatal_table_address, MPI_FATAL_EDUMP_TABLE_STATUS, 0);
> +       pm8001_cw32(pm8001_ha, 0, MSGU_IBDB_SET,
> +                       SPCv_MSGU_CFG_TABLE_NONFATAL_DUMP);
> +
> +       /*
> +        * Step 4.1: Read back the Inbound Doorbell Set Register (by polling for
> +        * 2 seconds) until register bit 7 is cleared.
> +        * This step only indicates the request is accepted by the controller.
> +        */
> +       start = jiffies + (2 * HZ); /* 2 sec */
> +       do {
> +               reg_val = pm8001_cr32(pm8001_ha, 0, MSGU_IBDB_SET) &
> +                       SPCv_MSGU_CFG_TABLE_NONFATAL_DUMP;
> +       } while ((reg_val != 0) && time_before(jiffies, start));
> +
> +       /* Step 4.2: To check the completion of the transfer, poll the Fatal/Non
> +        * Fatal Debug Data Transfer Status [FDDTSTAT] field for 2 seconds in
> +        * the MPI Fatal and Non-Fatal Error Dump Capture Table.
> +        */
> +       start = jiffies + (2 * HZ); /* 2 sec */
> +       do {
> +               reg_val = pm8001_mr32(nonfatal_table_address,
> +                               MPI_FATAL_EDUMP_TABLE_STATUS);
> +       } while ((!reg_val) && time_before(jiffies, start));
> +
> +       if ((reg_val == 0x00) ||
> +               (reg_val == MPI_FATAL_EDUMP_TABLE_STAT_DMA_FAILED) ||
> +               (reg_val > MPI_FATAL_EDUMP_TABLE_STAT_NF_SUCCESS_DONE)) {
> +               pm8001_ha->non_fatal_read_length = 0;
> +               buf_copy += snprintf(buf_copy, PAGE_SIZE, "%08x ", 0xFFFFFFFF);
> +               pm8001_ha->non_fatal_count = 0;
> +               return (buf_copy - buf);
> +       } else if (reg_val ==
> +                       MPI_FATAL_EDUMP_TABLE_STAT_NF_SUCCESS_MORE_DATA) {
> +               buf_copy += snprintf(buf_copy, PAGE_SIZE, "%08x ", 2);
> +       } else if ((reg_val == MPI_FATAL_EDUMP_TABLE_STAT_NF_SUCCESS_DONE) ||
> +               (pm8001_ha->non_fatal_read_length >= total_len)) {
> +               pm8001_ha->non_fatal_read_length = 0;
> +               buf_copy += snprintf(buf_copy, PAGE_SIZE, "%08x ", 4);
> +               pm8001_ha->non_fatal_count = 0;
> +       }
> +       accum_len = pm8001_mr32(nonfatal_table_address,
> +                       MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
> +       output_length = accum_len -
> +               pm8001_ha->forensic_preserved_accumulated_transfer;
> +
> +       for (index = 0; index < output_length/4; index++)
> +               buf_copy += snprintf(buf_copy, PAGE_SIZE,
> +                               "%08x ", *(temp+index));
> +
> +       pm8001_ha->non_fatal_read_length += output_length;
> +
> +       /* store current accumulated length to use in next iteration as
> +        * the previous accumulated length
> +        */
> +       pm8001_ha->forensic_preserved_accumulated_transfer = accum_len;
> +       return (buf_copy - buf);
> +}
> +
>  /**
>   * read_main_config_table - read the configure table and save it.
>   * @pm8001_ha: our hba card information
> --
> 2.16.3
>
