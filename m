Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E4FFC07E99
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 108FF610C7
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 05:10:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhGLFNb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 01:13:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230114AbhGLFNa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 01:13:30 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CD5C0613DD
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jul 2021 22:10:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w14so14332446edc.8
        for <linux-scsi@vger.kernel.org>; Sun, 11 Jul 2021 22:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=i6Uh3FO+lDhHLJ6UbhAHZVIS1HZWC17RHQAYR3L2Vvo=;
        b=B1JHcO9bZ7pvVf8UBj7xaOYcvrcetcG8hsxoxolYVLgOnAYpGxrGz3oRv7msNcVa68
         aLxraH1KbE9EvVyKthY8B0cXGI+I295MwVinEyCH+wRJrKJGplciJroPAs2KAGKPniCL
         waGxwovWeDogFLCxIqMAOfDNKBeVBrK4T2wlN59v6Q9VGvvmJNf4HD+Q531gOU4HJe+R
         pY4snmS4Me9MI14oWKguCOnohmfa1JeGuviHK4ZqEDuNNGSRfEJHudZEjIHKhqMAUtD9
         d+uJ/TBAl+44JRvdK9gB9In+CWJgC7uQKKRIodZKggFyIQlh5Kcca68c96XWUzOvNbC6
         O2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=i6Uh3FO+lDhHLJ6UbhAHZVIS1HZWC17RHQAYR3L2Vvo=;
        b=NDZaJR7HFkgdaJPseKW0zmAzrDbBJxH3+4IEar0ZTRfHrv5yr06odx6u1gEvpp4V8m
         xwd4T/Awu/SFPfa0aT/KRWVDbBGOXT6YSrJw+kMaJfMZkBiVxf42fTCQWf++xiEUdBmN
         Og+PDQ6s24u8yhTPMozJ47Ttt7gWQU6z/dPb6IqOZMN6f02oOY/BOyzXo8pwovMvR8Fc
         6LHO1A7VfiS3Y8q3g9gTWGrkPp4nJcyKj6V+Gh4ybgo5+fAN3V7D2qXMXRzX1kD5MsG2
         49/xynsdyS2JrxJ42mzomWzwbg2W3v9CucZ5G5b15KJ+BO2dym3lKbC061X27FbQbtg7
         r+iA==
X-Gm-Message-State: AOAM5337ll1xywyWYpKF7qNTLn7TKgq6nU/EGxei6LAkKwEcx8hz5cWy
        olNOWwXvn9ZlZhs+G78oMk63Wq4otZOnburQV01XvQ==
X-Google-Smtp-Source: ABdhPJxEr/i7QB8L8G4oT2zsbQ+KHOLH3NM2nOrfISf5c67ErhhvbBD2VJKHpy0y9Y0k5H+IjYwk+0rTXRz4i/9TrKQ=
X-Received: by 2002:a05:6402:ca6:: with SMTP id cn6mr26621301edb.252.1626066640855;
 Sun, 11 Jul 2021 22:10:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210708165723.8594-1-rdunlap@infradead.org>
In-Reply-To: <20210708165723.8594-1-rdunlap@infradead.org>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 12 Jul 2021 07:10:29 +0200
Message-ID: <CAMGffEkHaxgRpoTjOrkyTqPcQ9LsWAAgu-uOLsP+hHcRgu7MOw@mail.gmail.com>
Subject: Re: [PATCH] scsi: pm8001: clean up kernel-doc and comments
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 8, 2021 at 6:57 PM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> Fix kernel-doc warnings then test again, wash, rinse, find more, then
> repeat more/again.
> Also fix spellos, some grammar, and some punctuation.
>
> ../drivers/scsi/pm8001/pm8001_ctl.c:557: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  ** pm8001_ctl_fatal_log_show - fatal error logging
> ../drivers/scsi/pm8001/pm8001_ctl.c:577: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  ** non_fatal_log_show - non fatal error logging
> ../drivers/scsi/pm8001/pm8001_ctl.c:622: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  ** pm8001_ctl_gsm_log_show - gsm dump collection
>
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Looks good to me.
Acked-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/scsi/pm8001/pm8001_ctl.c  |   48 ++++++++++++++------------
>  drivers/scsi/pm8001/pm8001_hwi.c  |   18 +++++-----
>  drivers/scsi/pm8001/pm8001_init.c |   29 ++++++++--------
>  drivers/scsi/pm8001/pm8001_sas.c  |   41 ++++++++++++----------
>  drivers/scsi/pm8001/pm80xx_hwi.c  |   50 ++++++++++++++--------------
>  5 files changed, 97 insertions(+), 89 deletions(-)
>
> --- linux-next-20210707.orig/drivers/scsi/pm8001/pm8001_ctl.c
> +++ linux-next-20210707/drivers/scsi/pm8001/pm8001_ctl.c
> @@ -77,7 +77,7 @@ DEVICE_ATTR(interface_rev, S_IRUGO, pm80
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
>   *
> - * A sysfs 'read only' shost attribute.
> + * A sysfs 'read-only' shost attribute.
>   */
>  static ssize_t controller_fatal_error_show(struct device *cdev,
>                 struct device_attribute *attr, char *buf)
> @@ -149,7 +149,7 @@ static ssize_t pm8001_ctl_ila_version_sh
>  static DEVICE_ATTR(ila_version, 0444, pm8001_ctl_ila_version_show, NULL);
>
>  /**
> - * pm8001_ctl_inactive_fw_version_show - Inacative firmware version number
> + * pm8001_ctl_inactive_fw_version_show - Inactive firmware version number
>   * @cdev: pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
> @@ -396,6 +396,7 @@ static DEVICE_ATTR(aap_log, S_IRUGO, pm8
>   * @cdev:pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
> + *
>   * A sysfs 'read-only' shost attribute.
>   */
>  static ssize_t pm8001_ctl_ib_queue_log_show(struct device *cdev,
> @@ -430,6 +431,7 @@ static DEVICE_ATTR(ib_log, S_IRUGO, pm80
>   * @cdev:pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf: the buffer returned
> + *
>   * A sysfs 'read-only' shost attribute.
>   */
>
> @@ -464,6 +466,7 @@ static DEVICE_ATTR(ob_log, S_IRUGO, pm80
>   * @cdev:pointer to embedded class device
>   * @attr: device attribute (unused)
>   * @buf:the buffer returned
> + *
>   * A sysfs 'read-only' shost attribute.
>   */
>  static ssize_t pm8001_ctl_bios_version_show(struct device *cdev,
> @@ -555,13 +558,13 @@ static ssize_t pm8001_ctl_iop_log_show(s
>  static DEVICE_ATTR(iop_log, S_IRUGO, pm8001_ctl_iop_log_show, NULL);
>
>  /**
> - ** pm8001_ctl_fatal_log_show - fatal error logging
> - ** @cdev:pointer to embedded class device
> - ** @attr: device attribute
> - ** @buf: the buffer returned
> - **
> - ** A sysfs 'read-only' shost attribute.
> - **/
> + * pm8001_ctl_fatal_log_show - fatal error logging
> + * @cdev:pointer to embedded class device
> + * @attr: device attribute
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
>
>  static ssize_t pm8001_ctl_fatal_log_show(struct device *cdev,
>         struct device_attribute *attr, char *buf)
> @@ -575,13 +578,13 @@ static ssize_t pm8001_ctl_fatal_log_show
>  static DEVICE_ATTR(fatal_log, S_IRUGO, pm8001_ctl_fatal_log_show, NULL);
>
>  /**
> - ** non_fatal_log_show - non fatal error logging
> - ** @cdev:pointer to embedded class device
> - ** @attr: device attribute
> - ** @buf: the buffer returned
> - **
> - ** A sysfs 'read-only' shost attribute.
> - **/
> + * non_fatal_log_show - non fatal error logging
> + * @cdev:pointer to embedded class device
> + * @attr: device attribute
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
>  static ssize_t non_fatal_log_show(struct device *cdev,
>         struct device_attribute *attr, char *buf)
>  {
> @@ -620,12 +623,13 @@ static ssize_t non_fatal_count_store(str
>  static DEVICE_ATTR_RW(non_fatal_count);
>
>  /**
> - ** pm8001_ctl_gsm_log_show - gsm dump collection
> - ** @cdev:pointer to embedded class device
> - ** @attr: device attribute (unused)
> - ** @buf: the buffer returned
> - ** A sysfs 'read-only' shost attribute.
> - **/
> + * pm8001_ctl_gsm_log_show - gsm dump collection
> + * @cdev:pointer to embedded class device
> + * @attr: device attribute (unused)
> + * @buf: the buffer returned
> + *
> + * A sysfs 'read-only' shost attribute.
> + */
>  static ssize_t pm8001_ctl_gsm_log_show(struct device *cdev,
>         struct device_attribute *attr, char *buf)
>  {
> --- linux-next-20210707.orig/drivers/scsi/pm8001/pm80xx_hwi.c
> +++ linux-next-20210707/drivers/scsi/pm8001/pm80xx_hwi.c
> @@ -140,7 +140,7 @@ ssize_t pm80xx_get_fatal_dump(struct dev
>                 pm8001_ha->fatal_bar_loc = 0;
>         }
>
> -       /* Read until accum_len is retrived */
> +       /* Read until accum_len is retrieved */
>         accum_len = pm8001_mr32(fatal_table_address,
>                                 MPI_FATAL_EDUMP_TABLE_ACCUM_LEN);
>         /* Determine length of data between previously stored transfer length
> @@ -1011,7 +1011,7 @@ static int mpi_init_check(struct pm8001_
>                            value);
>                 return -EBUSY;
>         }
> -       /* check the MPI-State for initialization upto 100ms*/
> +       /* check the MPI-State for initialization up to 100ms*/
>         max_wait_count = 5;/* 100 msec */
>         do {
>                 msleep(FW_READY_INTERVAL);
> @@ -1093,7 +1093,7 @@ static int init_pci_device_addresses(str
>
>         value = pm8001_cr32(pm8001_ha, 0, MSGU_SCRATCH_PAD_0);
>
> -       /**
> +       /*
>          * lower 26 bits of SCRATCHPAD0 register describes offset within the
>          * PCIe BAR where the MPI configuration table is present
>          */
> @@ -1101,7 +1101,7 @@ static int init_pci_device_addresses(str
>
>         pm8001_dbg(pm8001_ha, DEV, "Scratchpad 0 Offset: 0x%x value 0x%x\n",
>                    offset, value);
> -       /**
> +       /*
>          * Upper 6 bits describe the offset within PCI config space where BAR
>          * is located.
>          */
> @@ -1109,7 +1109,7 @@ static int init_pci_device_addresses(str
>         pcibar = get_pci_bar_index(pcilogic);
>         pm8001_dbg(pm8001_ha, INIT, "Scratchpad 0 PCI BAR: %d\n", pcibar);
>
> -       /**
> +       /*
>          * Make sure the offset falls inside the ioremapped PCI BAR
>          */
>         if (offset > pm8001_ha->io_mem[pcibar].memsize) {
> @@ -1121,7 +1121,7 @@ static int init_pci_device_addresses(str
>         pm8001_ha->main_cfg_tbl_addr = base_addr =
>                 pm8001_ha->io_mem[pcibar].memvirtaddr + offset;
>
> -       /**
> +       /*
>          * Validate main configuration table address: first DWord should read
>          * "PMCS"
>          */
> @@ -1385,7 +1385,7 @@ pm80xx_get_encrypt_info(struct pm8001_hb
>  }
>
>  /**
> - * pm80xx_encrypt_update - update flash with encryption informtion
> + * pm80xx_encrypt_update - update flash with encryption information
>   * @pm8001_ha: our hba card information.
>   */
>  static int pm80xx_encrypt_update(struct pm8001_hba_info *pm8001_ha)
> @@ -1422,7 +1422,7 @@ static int pm80xx_encrypt_update(struct
>  }
>
>  /**
> - * pm80xx_chip_init - the main init function that initialize whole PM8001 chip.
> + * pm80xx_chip_init - the main init function that initializes whole PM8001 chip.
>   * @pm8001_ha: our hba card information
>   */
>  static int pm80xx_chip_init(struct pm8001_hba_info *pm8001_ha)
> @@ -1541,7 +1541,7 @@ static int mpi_uninit_check(struct pm800
>  }
>
>  /**
> - * pm80xx_fatal_errors - returns non zero *ONLY* when fatal errors
> + * pm80xx_fatal_errors - returns non-zero *ONLY* when fatal errors
>   * @pm8001_ha: our hba card information
>   *
>   * Fatal errors are recoverable only after a host reboot.
> @@ -1576,8 +1576,8 @@ pm80xx_fatal_errors(struct pm8001_hba_in
>  }
>
>  /**
> - * pm80xx_chip_soft_rst - soft reset the PM8001 chip, so that the clear all
> - * the FW register status to the originated status.
> + * pm80xx_chip_soft_rst - soft reset the PM8001 chip, so that all
> + * FW register status are reset to the originated status.
>   * @pm8001_ha: our hba card information
>   */
>
> @@ -1895,13 +1895,13 @@ static void pm80xx_send_read_log(struct
>  }
>
>  /**
> - * mpi_ssp_completion- process the event that FW response to the SSP request.
> + * mpi_ssp_completion - process the event that FW response to the SSP request.
>   * @pm8001_ha: our hba card information
>   * @piomb: the message contents of this outbound message.
>   *
>   * When FW has completed a ssp request for example a IO request, after it has
> - * filled the SG data with the data, it will trigger this event represent
> - * that he has finished the job,please check the coresponding buffer.
> + * filled the SG data with the data, it will trigger this event representing
> + * that he has finished the job; please check the corresponding buffer.
>   * So we will tell the caller who maybe waiting the result to tell upper layer
>   * that the task has been finished.
>   */
> @@ -3217,7 +3217,7 @@ mpi_smp_completion(struct pm8001_hba_inf
>  }
>
>  /**
> - * pm80xx_hw_event_ack_req- For PM8001,some events need to acknowage to FW.
> + * pm80xx_hw_event_ack_req- For PM8001, some events need to acknowledge to FW.
>   * @pm8001_ha: our hba card information
>   * @Qnum: the outbound queue message number.
>   * @SEA: source of event to ack
> @@ -3275,7 +3275,7 @@ static void hw_event_port_recover(struct
>  }
>
>  /**
> - * hw_event_sas_phy_up -FW tells me a SAS phy up event.
> + * hw_event_sas_phy_up - FW tells me a SAS phy up event.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> @@ -3353,7 +3353,7 @@ hw_event_sas_phy_up(struct pm8001_hba_in
>  }
>
>  /**
> - * hw_event_sata_phy_up -FW tells me a SATA phy up event.
> + * hw_event_sata_phy_up - FW tells me a SATA phy up event.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> @@ -3400,7 +3400,7 @@ hw_event_sata_phy_up(struct pm8001_hba_i
>  }
>
>  /**
> - * hw_event_phy_down -we should notify the libsas the phy is down.
> + * hw_event_phy_down - we should notify the libsas the phy is down.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> @@ -3500,7 +3500,7 @@ static int mpi_phy_start_resp(struct pm8
>  }
>
>  /**
> - * mpi_thermal_hw_event -The hw event has come.
> + * mpi_thermal_hw_event - a thermal hw event has come.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> @@ -3530,7 +3530,7 @@ static int mpi_thermal_hw_event(struct p
>  }
>
>  /**
> - * mpi_hw_event -The hw event has come.
> + * mpi_hw_event - The hw event has come.
>   * @pm8001_ha: our hba card information
>   * @piomb: IO message buffer
>   */
> @@ -4025,7 +4025,7 @@ static void process_one_iomb(struct pm80
>         case OPC_OUB_SET_DEV_INFO:
>                 pm8001_dbg(pm8001_ha, MSG, "OPC_OUB_SET_DEV_INFO\n");
>                 break;
> -       /* spcv specifc commands */
> +       /* spcv specific commands */
>         case OPC_OUB_PHY_START_RESP:
>                 pm8001_dbg(pm8001_ha, MSG,
>                            "OPC_OUB_PHY_START_RESP opcode:%x\n", opc);
> @@ -4186,7 +4186,7 @@ static void build_smp_cmd(u32 deviceID,
>  }
>
>  /**
> - * pm80xx_chip_smp_req - send a SMP task to FW
> + * pm80xx_chip_smp_req - send an SMP task to FW
>   * @pm8001_ha: our hba card information.
>   * @ccb: the ccb information this request used.
>   */
> @@ -4346,7 +4346,7 @@ static int check_enc_sat_cmd(struct sas_
>  }
>
>  /**
> - * pm80xx_chip_ssp_io_req - send a SSP task to FW
> + * pm80xx_chip_ssp_io_req - send an SSP task to FW
>   * @pm8001_ha: our hba card information.
>   * @ccb: the ccb information this request used.
>   */
> @@ -4750,13 +4750,13 @@ pm80xx_chip_phy_start_req(struct pm8001_
>         payload.ase_sh_lm_slr_phyid = cpu_to_le32(SPINHOLD_DISABLE |
>                         LINKMODE_AUTO | pm8001_ha->link_rate | phy_id);
>         /* SSC Disable and SAS Analog ST configuration */
> -       /**
> +       /*
>         payload.ase_sh_lm_slr_phyid =
>                 cpu_to_le32(SSC_DISABLE_30 | SAS_ASE | SPINHOLD_DISABLE |
>                 LINKMODE_AUTO | LINKRATE_15 | LINKRATE_30 | LINKRATE_60 |
>                 phy_id);
>         Have to add "SAS PHY Analog Setup SPASTI 1 Byte" Based on need
> -       **/
> +       */
>
>         payload.sas_identify.dev_type = SAS_END_DEVICE;
>         payload.sas_identify.initiator_bits = SAS_PROTOCOL_ALL;
> --- linux-next-20210707.orig/drivers/scsi/pm8001/pm8001_sas.c
> +++ linux-next-20210707/drivers/scsi/pm8001/pm8001_sas.c
> @@ -98,14 +98,16 @@ void pm8001_tag_init(struct pm8001_hba_i
>                 pm8001_tag_free(pm8001_ha, i);
>  }
>
> - /**
> -  * pm8001_mem_alloc - allocate memory for pm8001.
> -  * @pdev: pci device.
> -  * @virt_addr: the allocated virtual address
> -  * @pphys_addr_hi: the physical address high byte address.
> -  * @pphys_addr_lo: the physical address low byte address.
> -  * @mem_size: memory size.
> -  */
> +/**
> + * pm8001_mem_alloc - allocate memory for pm8001.
> + * @pdev: pci device.
> + * @virt_addr: the allocated virtual address
> + * @pphys_addr: DMA address for this device
> + * @pphys_addr_hi: the physical address high byte address.
> + * @pphys_addr_lo: the physical address low byte address.
> + * @mem_size: memory size.
> + * @align: requested byte alignment
> + */
>  int pm8001_mem_alloc(struct pci_dev *pdev, void **virt_addr,
>         dma_addr_t *pphys_addr, u32 *pphys_addr_hi,
>         u32 *pphys_addr_lo, u32 mem_size, u32 align)
> @@ -339,7 +341,7 @@ static int pm8001_task_prep_ssp_tm(struc
>  }
>
>  /**
> -  * pm8001_task_prep_ssp - the dispatcher function,prepare ssp data for ssp task
> +  * pm8001_task_prep_ssp - the dispatcher function, prepare ssp data for ssp task
>    * @pm8001_ha: our hba card information
>    * @ccb: the ccb which attached to ssp task
>    */
> @@ -554,10 +556,10 @@ void pm8001_ccb_task_free(struct pm8001_
>         pm8001_tag_free(pm8001_ha, ccb_idx);
>  }
>
> - /**
> -  * pm8001_alloc_dev - find a empty pm8001_device
> -  * @pm8001_ha: our hba card information
> -  */
> +/**
> + * pm8001_alloc_dev - find a empty pm8001_device
> + * @pm8001_ha: our hba card information
> + */
>  static struct pm8001_device *pm8001_alloc_dev(struct pm8001_hba_info *pm8001_ha)
>  {
>         u32 dev;
> @@ -705,7 +707,7 @@ static void pm8001_tmf_timedout(struct t
>    * @parameter: ssp task parameter.
>    *
>    * when errors or exception happened, we may want to do something, for example
> -  * abort the issued task which result in this execption, it is done by calling
> +  * abort the issued task which result in this exception, it is done by calling
>    * this function, note it is also with the task execute interface.
>    */
>  static int pm8001_exec_internal_tmf_task(struct domain_device *dev,
> @@ -984,11 +986,12 @@ void pm8001_open_reject_retry(
>  }
>
>  /**
> - * pm8001_I_T_nexus_reset()
> -  * Standard mandates link reset for ATA  (type 0) and hard reset for
> -  * SSP (type 1) , only for RECOVERY
> -  * @dev: the device structure for the device to reset.
> -  */
> + * pm8001_I_T_nexus_reset() - reset the initiator/target connection
> + * @dev: the device structure for the device to reset.
> + *
> + * Standard mandates link reset for ATA (type 0) and hard reset for
> + * SSP (type 1), only for RECOVERY
> + */
>  int pm8001_I_T_nexus_reset(struct domain_device *dev)
>  {
>         int rc = TMF_RESP_FUNC_FAILED;
> --- linux-next-20210707.orig/drivers/scsi/pm8001/pm8001_hwi.c
> +++ linux-next-20210707/drivers/scsi/pm8001/pm8001_hwi.c
> @@ -384,7 +384,7 @@ static void update_outbnd_queue_table(st
>
>  /**
>   * pm8001_bar4_shift - function is called to shift BAR base address
> - * @pm8001_ha : our hba card infomation
> + * @pm8001_ha : our hba card information
>   * @shiftValue : shifting value in memory bar.
>   */
>  int pm8001_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shiftValue)
> @@ -1151,7 +1151,7 @@ static void pm8001_hw_chip_rst(struct pm
>  }
>
>  /**
> - * pm8001_chip_iounmap - which maped when initialized.
> + * pm8001_chip_iounmap - which mapped when initialized.
>   * @pm8001_ha: our hba card information
>   */
>  void pm8001_chip_iounmap(struct pm8001_hba_info *pm8001_ha)
> @@ -1187,10 +1187,10 @@ pm8001_chip_intx_interrupt_enable(struct
>         pm8001_cw32(pm8001_ha, 0, MSGU_ODCR, ODCR_CLEAR_ALL);
>  }
>
> - /**
> -  * pm8001_chip_intx_interrupt_disable- disable PM8001 chip interrupt
> -  * @pm8001_ha: our hba card information
> -  */
> +/**
> + * pm8001_chip_intx_interrupt_disable - disable PM8001 chip interrupt
> + * @pm8001_ha: our hba card information
> + */
>  static void
>  pm8001_chip_intx_interrupt_disable(struct pm8001_hba_info *pm8001_ha)
>  {
> @@ -1876,8 +1876,8 @@ static void pm8001_send_read_log(struct
>   * @piomb: the message contents of this outbound message.
>   *
>   * When FW has completed a ssp request for example a IO request, after it has
> - * filled the SG data with the data, it will trigger this event represent
> - * that he has finished the job,please check the coresponding buffer.
> + * filled the SG data with the data, it will trigger this event representing
> + * that he has finished the job; please check the corresponding buffer.
>   * So we will tell the caller who maybe waiting the result to tell upper layer
>   * that the task has been finished.
>   */
> @@ -3522,7 +3522,7 @@ hw_event_phy_down(struct pm8001_hba_info
>   *
>   * when sas layer find a device it will notify LLDD, then the driver register
>   * the domain device to FW, this event is the return device ID which the FW
> - * has assigned, from now,inter-communication with FW is no longer using the
> + * has assigned, from now, inter-communication with FW is no longer using the
>   * SAS address, use device ID which FW assigned.
>   */
>  int pm8001_mpi_reg_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
> --- linux-next-20210707.orig/drivers/scsi/pm8001/pm8001_init.c
> +++ linux-next-20210707/drivers/scsi/pm8001/pm8001_init.c
> @@ -233,7 +233,7 @@ static irqreturn_t pm8001_interrupt_hand
>  /**
>   * pm8001_interrupt_handler_intx - main INTx interrupt handler.
>   * @irq: interrupt number
> - * @dev_id: sas_ha structure. The HBA is retrieved from sas_has structure.
> + * @dev_id: sas_ha structure. The HBA is retrieved from sas_ha structure.
>   */
>
>  static irqreturn_t pm8001_interrupt_handler_intx(int irq, void *dev_id)
> @@ -439,9 +439,9 @@ err_out:
>  }
>
>  /**
> - * pm8001_ioremap - remap the pci high physical address to kernal virtual
> + * pm8001_ioremap - remap the pci high physical address to kernel virtual
>   * address so that we can access them.
> - * @pm8001_ha:our hba structure.
> + * @pm8001_ha: our hba structure.
>   */
>  static int pm8001_ioremap(struct pm8001_hba_info *pm8001_ha)
>  {
> @@ -652,7 +652,7 @@ static void  pm8001_post_sas_ha_init(str
>   * pm8001_init_sas_add - initialize sas address
>   * @pm8001_ha: our ha struct.
>   *
> - * Currently we just set the fixed SAS address to our HBA,for manufacture,
> + * Currently we just set the fixed SAS address to our HBA, for manufacture,
>   * it should read from the EEPROM
>   */
>  static void pm8001_init_sas_add(struct pm8001_hba_info *pm8001_ha)
> @@ -790,7 +790,7 @@ struct pm8001_mpi3_phy_pg_trx_config {
>  };
>
>  /**
> - * pm8001_get_internal_phy_settings : Retrieves the internal PHY settings
> + * pm8001_get_internal_phy_settings - Retrieves the internal PHY settings
>   * @pm8001_ha : our adapter
>   * @phycfg : PHY config page to populate
>   */
> @@ -810,7 +810,7 @@ void pm8001_get_internal_phy_settings(st
>  }
>
>  /**
> - * pm8001_get_external_phy_settings : Retrieves the external PHY settings
> + * pm8001_get_external_phy_settings - Retrieves the external PHY settings
>   * @pm8001_ha : our adapter
>   * @phycfg : PHY config page to populate
>   */
> @@ -830,7 +830,7 @@ void pm8001_get_external_phy_settings(st
>  }
>
>  /**
> - * pm8001_get_phy_mask : Retrieves the mask that denotes if a PHY is int/ext
> + * pm8001_get_phy_mask - Retrieves the mask that denotes if a PHY is int/ext
>   * @pm8001_ha : our adapter
>   * @phymask : The PHY mask
>   */
> @@ -868,7 +868,7 @@ void pm8001_get_phy_mask(struct pm8001_h
>  }
>
>  /**
> - * pm8001_set_phy_settings_ven_117c_12G() : Configure ATTO 12Gb PHY settings
> + * pm8001_set_phy_settings_ven_117c_12G() - Configure ATTO 12Gb PHY settings
>   * @pm8001_ha : our adapter
>   */
>  static
> @@ -903,7 +903,7 @@ int pm8001_set_phy_settings_ven_117c_12G
>  }
>
>  /**
> - * pm8001_configure_phy_settings : Configures PHY settings based on vendor ID.
> + * pm8001_configure_phy_settings - Configures PHY settings based on vendor ID.
>   * @pm8001_ha : our hba.
>   */
>  static int pm8001_configure_phy_settings(struct pm8001_hba_info *pm8001_ha)
> @@ -1053,8 +1053,8 @@ intx:
>   * @ent: pci device id
>   *
>   * This function is the main initialization function, when register a new
> - * pci driver it is invoked, all struct an hardware initilization should be done
> - * here, also, register interrupt
> + * pci driver it is invoked, all struct and hardware initialization should be
> + * done here, also, register interrupt.
>   */
>  static int pm8001_pci_probe(struct pci_dev *pdev,
>                             const struct pci_device_id *ent)
> @@ -1172,10 +1172,11 @@ err_out_enable:
>         return rc;
>  }
>
> -/*
> +/**
>   * pm8001_init_ccb_tag - allocate memory to CCB and tag.
>   * @pm8001_ha: our hba card information.
>   * @shost: scsi host which has been allocated outside.
> + * @pdev: pci device.
>   */
>  static int
>  pm8001_init_ccb_tag(struct pm8001_hba_info *pm8001_ha, struct Scsi_Host *shost,
> @@ -1270,7 +1271,7 @@ static void pm8001_pci_remove(struct pci
>   * pm8001_pci_suspend - power management suspend main entry point
>   * @dev: Device struct
>   *
> - * Returns 0 success, anything else error.
> + * Return: 0 on success, anything else on error.
>   */
>  static int __maybe_unused pm8001_pci_suspend(struct device *dev)
>  {
> @@ -1315,7 +1316,7 @@ static int __maybe_unused pm8001_pci_sus
>   * pm8001_pci_resume - power management resume main entry point
>   * @dev: Device struct
>   *
> - * Returns 0 success, anything else error.
> + * Return: 0 on success, anything else on error.
>   */
>  static int __maybe_unused pm8001_pci_resume(struct device *dev)
>  {
