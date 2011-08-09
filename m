From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: RE: [PATCH 2/2] qla2xxx: Add __attribute__((format(printf... and
 fix fallout
Date: Tue, 9 Aug 2011 15:55:17 -0500
Message-ID: <1FB7DC5E34DADB499463B6EA89DF40A466A513A7DE@MNEXMB1.qlogic.org>
References: <cover.1312067036.git.joe@perches.com>
 <78b07ee25e54ac4577a4def49188417ae0c8a8fa.1312067036.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <78b07ee25e54ac4577a4def49188417ae0c8a8fa.1312067036.git.joe@perches.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux Driver <Linux-Driver@qlogic.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Acked by: Saurav Kashyap <saurav.kashyap@qlogic.com>

Thanks,
~Saurav

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Joe Perches
> Sent: 30 July 2011 16:05
> To: Andrew Vasquez; Linux Driver
> Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-kernel
> Subject: [PATCH 2/2] qla2xxx: Add __attribute__((format(printf... and
> fix fallout
>
> Make the local logging functions verify their arguments
> and fixup the current broken uses as appropriate.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/qla2xxx/qla_attr.c |    4 ++--
>  drivers/scsi/qla2xxx/qla_dbg.h  |    8 ++++----
>  drivers/scsi/qla2xxx/qla_init.c |    3 ++-
>  drivers/scsi/qla2xxx/qla_iocb.c |    2 +-
>  drivers/scsi/qla2xxx/qla_isr.c  |    2 +-
>  drivers/scsi/qla2xxx/qla_nx.c   |   12 ++++++------
>  drivers/scsi/qla2xxx/qla_os.c   |   12 ++++++------
>  drivers/scsi/qla2xxx/qla_sup.c  |    5 +++--
>  8 files changed, 25 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c
> b/drivers/scsi/qla2xxx/qla_attr.c
> index 7836eb0..dc57471 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -634,7 +634,7 @@ qla2x00_sysfs_write_edc(struct file *filp, struct
> kobject *kobj,
>           dev, adr, len, opt);
>       if (rval != QLA_SUCCESS) {
>               ql_log(ql_log_warn, vha, 0x7074,
> -                 "Unable to write EDC (%x) %02x:%04x:%02x:%02x\n",
> +                 "Unable to write EDC (%x) %02x:%04x:%02x:%02x:%02x\n",
>                   rval, dev, adr, opt, len, buf[8]);
>               return 0;
>       }
> @@ -691,7 +691,7 @@ qla2x00_sysfs_write_edc_status(struct file *filp,
> struct kobject *kobj,
>                       dev, adr, len, opt);
>       if (rval != QLA_SUCCESS) {
>               ql_log(ql_log_info, vha, 0x7075,
> -                 "Unable to write EDC status (%x) %02x:%04x:%02x.\n",
> +                 "Unable to write EDC status (%x)
> %02x:%04x:%02x:%02x.\n",
>                   rval, dev, adr, opt, len);
>               return 0;
>       }
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.h
> b/drivers/scsi/qla2xxx/qla_dbg.h
> index 0692814..29a7822 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.h
> +++ b/drivers/scsi/qla2xxx/qla_dbg.h
> @@ -244,14 +244,14 @@ struct qla2xxx_fw_dump {
>
>  extern int ql_errlev;
>
> -void
> +void __attribute__((format (printf, 4, 5)))
>  ql_dbg(uint32_t, scsi_qla_host_t *vha, int32_t, const char *fmt, ...);
> -void
> +void __attribute__((format (printf, 4, 5)))
>  ql_dbg_pci(uint32_t, struct pci_dev *pdev, int32_t, const char *fmt,
> ...);
>
> -void
> +void __attribute__((format (printf, 4, 5)))
>  ql_log(uint32_t, scsi_qla_host_t *vha, int32_t, const char *fmt, ...);
> -void
> +void __attribute__((format (printf, 4, 5)))
>  ql_log_pci(uint32_t, struct pci_dev *pdev, int32_t, const char *fmt,
> ...);
>
>  /* Debug Levels */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c
> b/drivers/scsi/qla2xxx/qla_init.c
> index def6942..351b1ec 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -4186,7 +4186,8 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
>               spin_unlock_irqrestore(&ha->vport_slock, flags);
>
>       } else {
> -             ql_log(ql_log_warn, vha, 0x8023, "%s **** FAILED ****.\n");
> +             ql_log(ql_log_warn, vha, 0x8023, "%s **** FAILED ****.\n",
> +                    __func__);
>       }
>
>       return(status);
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c
> b/drivers/scsi/qla2xxx/qla_iocb.c
> index 49d6906..f8bac2c 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -858,7 +858,7 @@ qla24xx_walk_and_build_sglist(struct qla_hw_data
> *ha, srb_t *sp, uint32_t *dsd,
>               sle_dma = sg_dma_address(sg);
>               ql_dbg(ql_dbg_io, vha, 0x300a,
>                   "sg entry %d - addr=0x%x 0x%x, " "len=%d for
> cmd=%p.\n",
> -                 cur_dsd, i, LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg),
> +                 i, LSD(sle_dma), MSD(sle_dma), sg_dma_len(sg),
>                   sp->cmd);
>               *cur_dsd++ = cpu_to_le32(LSD(sle_dma));
>               *cur_dsd++ = cpu_to_le32(MSD(sle_dma));
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c
> b/drivers/scsi/qla2xxx/qla_isr.c
> index b16b772..0eac872 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -298,7 +298,7 @@ qla81xx_idc_event(scsi_qla_host_t *vha, uint16_t
> aen, uint16_t descr)
>               return;
>
>       ql_dbg(ql_dbg_async, vha, 0x5022,
> -         "Inter-Driver Commucation %s -- ACK timeout=%d.\n",
> +         "%lu Inter-Driver Communication %s -- ACK timeout=%d.\n",
>           vha->host_no, event[aen & 0xff], timeout);
>
>       rval = qla2x00_post_idc_ack_work(vha, mb);
> diff --git a/drivers/scsi/qla2xxx/qla_nx.c
> b/drivers/scsi/qla2xxx/qla_nx.c
> index 5cbf33a..42a0992 100644
> --- a/drivers/scsi/qla2xxx/qla_nx.c
> +++ b/drivers/scsi/qla2xxx/qla_nx.c
> @@ -362,7 +362,7 @@ qla82xx_pci_set_crbwindow_2M(struct qla_hw_data
> *ha, ulong *off)
>               ql_dbg(ql_dbg_p3p, vha, 0xb000,
>                   "%s: Written crbwin (0x%x) "
>                   "!= Read crbwin (0x%x), off=0x%lx.\n",
> -                 ha->crb_win, win_read, *off);
> +                 __func__, ha->crb_win, win_read, *off);
>       }
>       *off = (*off & MASK(16)) + CRB_INDIRECT_2M + ha->nx_pcibase;
>  }
> @@ -402,7 +402,7 @@ qla82xx_pci_set_crbwindow(struct qla_hw_data *ha,
> u64 off)
>       }
>       /* strange address given */
>       ql_dbg(ql_dbg_p3p, vha, 0xb001,
> -         "%x: Warning: unm_nic_pci_set_crbwindow "
> +         "%s: Warning: unm_nic_pci_set_crbwindow "
>           "called with an unknown address(%llx).\n",
>           QLA2XXX_DRIVER_NAME, off);
>       return off;
> @@ -1704,12 +1704,12 @@ qla82xx_iospace_config(struct qla_hw_data *ha)
>       ql_dbg_pci(ql_dbg_multiq, ha->pdev, 0xc006,
>           "nx_pci_base=%p iobase=%p "
>           "max_req_queues=%d msix_count=%d.\n",
> -         ha->nx_pcibase, ha->iobase,
> +         (void *)ha->nx_pcibase, ha->iobase,
>           ha->max_req_queues, ha->msix_count);
>       ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0010,
>           "nx_pci_base=%p iobase=%p "
>           "max_req_queues=%d msix_count=%d.\n",
> -         ha->nx_pcibase, ha->iobase,
> +         (void *)ha->nx_pcibase, ha->iobase,
>           ha->max_req_queues, ha->msix_count);
>       return 0;
>
> @@ -1737,7 +1737,7 @@ qla82xx_pci_config(scsi_qla_host_t *vha)
>       ret = pci_set_mwi(ha->pdev);
>       ha->chip_revision = ha->pdev->revision;
>       ql_dbg(ql_dbg_init, vha, 0x0043,
> -         "Chip revision:%ld.\n",
> +         "Chip revision:%d.\n",
>           ha->chip_revision);
>       return 0;
>  }
> @@ -3939,7 +3939,7 @@ int
> qla2x00_wait_for_fcoe_ctx_reset(scsi_qla_host_t *vha)
>               }
>       }
>       ql_dbg(ql_dbg_p3p, vha, 0xb027,
> -         "%s status=%d.\n", status);
> +            "%s: status=%d.\n", __func__, status);
>
>       return status;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c
> b/drivers/scsi/qla2xxx/qla_os.c
> index e02df27..16cadc9 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1041,7 +1041,7 @@ __qla2xxx_eh_generic_reset(char *name, enum
> nexus_wait_type type,
>  eh_reset_failed:
>       ql_log(ql_log_info, vha, 0x800f,
>           "%s RESET FAILED: %s for id %d lun %d cmd=%p.\n", name,
> -         reset_errors[err], cmd->device->id, cmd->device->lun);
> +         reset_errors[err], cmd->device->id, cmd->device->lun, cmd);
>       return FAILED;
>  }
>
> @@ -1856,7 +1856,7 @@ qla2x00_set_isp_flags(struct qla_hw_data *ha)
>               ha->flags.port0 = 0;
>       ql_dbg_pci(ql_dbg_init, ha->pdev, 0x000b,
>           "device_type=0x%x port=%d fw_srisc_address=%p.\n",
> -         ha->device_type, ha->flags.port0, ha->fw_srisc_address);
> +         ha->device_type, ha->flags.port0, (void *)ha-
> >fw_srisc_address);
>  }
>
>  static int
> @@ -1896,8 +1896,8 @@ qla2x00_iospace_config(struct qla_hw_data *ha)
>       }
>       ha->pio_address = pio;
>       ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0014,
> -         "PIO address=%p.\n",
> -         ha->pio_address);
> +         "PIO address=%llu.\n",
> +         (unsigned long long)ha->pio_address);
>
>  skip_pio:
>       /* Use MMIO operations for all accesses. */
> @@ -2263,7 +2263,7 @@ qla2x00_probe_one(struct pci_dev *pdev, const
> struct pci_device_id *id)
>       ql_dbg(ql_dbg_init, base_vha, 0x0033,
>           "max_id=%d this_id=%d "
>           "cmd_per_len=%d unique_id=%d max_cmd_len=%d max_channel=%d "
> -         "max_lun=%d transportt=%p, vendor_id=%d.\n", host->max_id,
> +         "max_lun=%d transportt=%p, vendor_id=%llu.\n", host->max_id,
>           host->this_id, host->cmd_per_lun, host->unique_id,
>           host->max_cmd_len, host->max_channel, host->max_lun,
>           host->transportt, sht->vendor_id);
> @@ -2864,7 +2864,7 @@ qla2x00_mem_alloc(struct qla_hw_data *ha,
> uint16_t req_len, uint16_t rsp_len,
>               if (!ha->sns_cmd)
>                       goto fail_dma_pool;
>               ql_dbg_pci(ql_dbg_init, ha->pdev, 0x0026,
> -                 "sns_cmd.\n", ha->sns_cmd);
> +                 "sns_cmd: %p.\n", ha->sns_cmd);
>       } else {
>       /* Get consistent memory allocated for MS IOCB */
>               ha->ms_iocb = dma_pool_alloc(ha->s_dma_pool, GFP_KERNEL,
> diff --git a/drivers/scsi/qla2xxx/qla_sup.c
> b/drivers/scsi/qla2xxx/qla_sup.c
> index eff1356..16bc728 100644
> --- a/drivers/scsi/qla2xxx/qla_sup.c
> +++ b/drivers/scsi/qla2xxx/qla_sup.c
> @@ -904,8 +904,9 @@ no_flash_data:
>       }
>  done:
>       ql_dbg(ql_dbg_init, vha, 0x004d,
> -         "FDT[%x]: (0x%x/0x%x) erase=0x%x "
> -         "pr=%x upro=%x wrtd=0x%x blk=0x%x.\n", loc, mid, fid,
> +         "FDT[%s]: (0x%x/0x%x) erase=0x%x "
> +         "pr=%x wrtd=0x%x blk=0x%x.\n",
> +         loc, mid, fid,
>           ha->fdt_erase_cmd, ha->fdt_protect_sec_cmd,
>           ha->fdt_wrt_disable, ha->fdt_block_size);
>
> --
> 1.7.6.131.g99019
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
