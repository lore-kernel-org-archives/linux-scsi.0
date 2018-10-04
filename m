From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 2/7] mpt3sas: Convert uses of pr_<level> with MPT3SAS_FMT
 to ioc_<level>
Date: Thu, 4 Oct 2018 15:58:28 +0530
Message-ID: <CA+RiK64YOOL67YvUEo1qEyecbADF-aMfBwoWFhuU=hN7FHQ-Wg@mail.gmail.com>
References: <cover.1537183087.git.joe@perches.com> <655173f778ba869547843881fff7a8862639c387.1537183088.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <655173f778ba869547843881fff7a8862639c387.1537183088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks.
On Mon, Sep 17, 2018 at 8:31 PM Joe Perches <joe@perches.com> wrote:
>
> Use a more common logging style.
>
> Done using the perl script below and some typing
>
> $ git grep --name-only -w MPT3SAS_FMT -- "*.c" | \
>   xargs perl -i -e 'local $/; while (<>) { s/\bpr_(info|err|notice|warn)\s*\(\s*MPT3SAS_FMT\s*("[^"]+"(?:\s*\\?\s*"[^"]+"\s*){0,5}\s*),\s*ioc->name\s*/ioc_\1(ioc, \2/g; print;}'
>
> Miscellanea for these conversions:
>
> o Coalesce formats
> o Realign arguments
> o Remove unnecessary parentheses
> o Use casts to u64 instead of unsigned long long where appropriate
> o Convert broken pr_info uses to pr_cont
> o Fix broken format string concatenation with line continuations and
>   excess whitespace
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c         | 1065 +++++++++-----------
>  drivers/scsi/mpt3sas/mpt3sas_config.c       |   48 +-
>  drivers/scsi/mpt3sas/mpt3sas_ctl.c          |  493 ++++-----
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c        | 1425 ++++++++++++---------------
>  drivers/scsi/mpt3sas/mpt3sas_transport.c    |  313 +++---
>  drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |  101 +-
>  drivers/scsi/mpt3sas/mpt3sas_warpdrive.c    |   70 +-
>  7 files changed, 1533 insertions(+), 1982 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 59d7844ee022..5c6634b7ca74 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -122,8 +122,8 @@ mpt3sas_base_check_cmd_timeout(struct MPT3SAS_ADAPTER *ioc,
>         if (!(status & MPT3_CMD_RESET))
>                 issue_reset = 1;
>
> -       pr_err(MPT3SAS_FMT "Command %s\n", ioc->name,
> -           ((issue_reset == 0) ? "terminated due to Host Reset" : "Timeout"));
> +       ioc_err(ioc, "Command %s\n",
> +               issue_reset == 0 ? "terminated due to Host Reset" : "Timeout");
>         _debug_dump_mf(mpi_request, sz);
>
>         return issue_reset;
> @@ -336,9 +336,7 @@ _base_get_chain_buffer_dma_to_chain_buffer(struct MPT3SAS_ADAPTER *ioc,
>                                 return ct->chain_buffer;
>                 }
>         }
> -       pr_info(MPT3SAS_FMT
> -           "Provided chain_buffer_dma address is not in the lookup list\n",
> -           ioc->name);
> +       ioc_info(ioc, "Provided chain_buffer_dma address is not in the lookup list\n");
>         return NULL;
>  }
>
> @@ -394,7 +392,7 @@ static void _clone_sg_entries(struct MPT3SAS_ADAPTER *ioc,
>                 /* Get scsi_cmd using smid */
>                 scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>                 if (scmd == NULL) {
> -                       pr_err(MPT3SAS_FMT "scmd is NULL\n", ioc->name);
> +                       ioc_err(ioc, "scmd is NULL\n");
>                         return;
>                 }
>
> @@ -566,8 +564,7 @@ _base_fault_reset_work(struct work_struct *work)
>
>         doorbell = mpt3sas_base_get_iocstate(ioc, 0);
>         if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_MASK) {
> -               pr_err(MPT3SAS_FMT "SAS host is non-operational !!!!\n",
> -                   ioc->name);
> +               ioc_err(ioc, "SAS host is non-operational !!!!\n");
>
>                 /* It may be possible that EEH recovery can resolve some of
>                  * pci bus failure issues rather removing the dead ioc function
> @@ -600,13 +597,11 @@ _base_fault_reset_work(struct work_struct *work)
>                 p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
>                     "%s_dead_ioc_%d", ioc->driver_name, ioc->id);
>                 if (IS_ERR(p))
> -                       pr_err(MPT3SAS_FMT
> -                       "%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
> -                       ioc->name, __func__);
> +                       ioc_err(ioc, "%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
> +                               __func__);
>                 else
> -                       pr_err(MPT3SAS_FMT
> -                       "%s: Running mpt3sas_dead_ioc thread success !!!!\n",
> -                       ioc->name, __func__);
> +                       ioc_err(ioc, "%s: Running mpt3sas_dead_ioc thread success !!!!\n",
> +                               __func__);
>                 return; /* don't rearm timer */
>         }
>
> @@ -614,8 +609,8 @@ _base_fault_reset_work(struct work_struct *work)
>
>         if ((doorbell & MPI2_IOC_STATE_MASK) != MPI2_IOC_STATE_OPERATIONAL) {
>                 rc = mpt3sas_base_hard_reset_handler(ioc, FORCE_BIG_HAMMER);
> -               pr_warn(MPT3SAS_FMT "%s: hard reset: %s\n", ioc->name,
> -                   __func__, (rc == 0) ? "success" : "failed");
> +               ioc_warn(ioc, "%s: hard reset: %s\n",
> +                        __func__, rc == 0 ? "success" : "failed");
>                 doorbell = mpt3sas_base_get_iocstate(ioc, 0);
>                 if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
>                         mpt3sas_base_fault_info(ioc, doorbell &
> @@ -657,8 +652,7 @@ mpt3sas_base_start_watchdog(struct MPT3SAS_ADAPTER *ioc)
>         ioc->fault_reset_work_q =
>                 create_singlethread_workqueue(ioc->fault_reset_work_q_name);
>         if (!ioc->fault_reset_work_q) {
> -               pr_err(MPT3SAS_FMT "%s: failed (line=%d)\n",
> -                   ioc->name, __func__, __LINE__);
> +               ioc_err(ioc, "%s: failed (line=%d)\n", __func__, __LINE__);
>                 return;
>         }
>         spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
> @@ -700,8 +694,7 @@ mpt3sas_base_stop_watchdog(struct MPT3SAS_ADAPTER *ioc)
>  void
>  mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc , u16 fault_code)
>  {
> -       pr_err(MPT3SAS_FMT "fault_state(0x%04x)!\n",
> -           ioc->name, fault_code);
> +       ioc_err(ioc, "fault_state(0x%04x)!\n", fault_code);
>  }
>
>  /**
> @@ -728,8 +721,7 @@ mpt3sas_halt_firmware(struct MPT3SAS_ADAPTER *ioc)
>                 mpt3sas_base_fault_info(ioc , doorbell);
>         else {
>                 writel(0xC0FFEE00, &ioc->chip->Doorbell);
> -               pr_err(MPT3SAS_FMT "Firmware is halted due to command timeout\n",
> -                       ioc->name);
> +               ioc_err(ioc, "Firmware is halted due to command timeout\n");
>         }
>
>         if (ioc->fwfault_debug == 2)
> @@ -956,8 +948,8 @@ _base_sas_ioc_info(struct MPT3SAS_ADAPTER *ioc, MPI2DefaultReply_t *mpi_reply,
>                 break;
>         }
>
> -       pr_warn(MPT3SAS_FMT "ioc_status: %s(0x%04x), request(0x%p),(%s)\n",
> -               ioc->name, desc, ioc_status, request_hdr, func_str);
> +       ioc_warn(ioc, "ioc_status: %s(0x%04x), request(0x%p),(%s)\n",
> +                desc, ioc_status, request_hdr, func_str);
>
>         _debug_dump_mf(request_hdr, frame_sz/4);
>  }
> @@ -1003,9 +995,9 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
>         {
>                 Mpi2EventDataSasDiscovery_t *event_data =
>                     (Mpi2EventDataSasDiscovery_t *)mpi_reply->EventData;
> -               pr_info(MPT3SAS_FMT "Discovery: (%s)", ioc->name,
> -                   (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
> -                   "start" : "stop");
> +               ioc_info(ioc, "Discovery: (%s)",
> +                        event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED ?
> +                        "start" : "stop");
>                 if (event_data->DiscoveryStatus)
>                         pr_cont(" discovery_status(0x%08x)",
>                             le32_to_cpu(event_data->DiscoveryStatus));
> @@ -1059,14 +1051,13 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
>         {
>                 Mpi26EventDataPCIeEnumeration_t *event_data =
>                         (Mpi26EventDataPCIeEnumeration_t *)mpi_reply->EventData;
> -               pr_info(MPT3SAS_FMT "PCIE Enumeration: (%s)", ioc->name,
> -                          (event_data->ReasonCode ==
> -                               MPI26_EVENT_PCIE_ENUM_RC_STARTED) ?
> -                               "start" : "stop");
> +               ioc_info(ioc, "PCIE Enumeration: (%s)",
> +                        event_data->ReasonCode == MPI26_EVENT_PCIE_ENUM_RC_STARTED ?
> +                        "start" : "stop");
>                 if (event_data->EnumerationStatus)
> -                       pr_info("enumeration_status(0x%08x)",
> -                                  le32_to_cpu(event_data->EnumerationStatus));
> -               pr_info("\n");
> +                       pr_cont("enumeration_status(0x%08x)",
> +                               le32_to_cpu(event_data->EnumerationStatus));
> +               pr_cont("\n");
>                 return;
>         }
>         case MPI2_EVENT_PCIE_TOPOLOGY_CHANGE_LIST:
> @@ -1077,7 +1068,7 @@ _base_display_event_data(struct MPT3SAS_ADAPTER *ioc,
>         if (!desc)
>                 return;
>
> -       pr_info(MPT3SAS_FMT "%s\n", ioc->name, desc);
> +       ioc_info(ioc, "%s\n", desc);
>  }
>
>  /**
> @@ -1128,11 +1119,9 @@ _base_sas_log_info(struct MPT3SAS_ADAPTER *ioc , u32 log_info)
>                 break;
>         }
>
> -       pr_warn(MPT3SAS_FMT
> -               "log_info(0x%08x): originator(%s), code(0x%02x), sub_code(0x%04x)\n",
> -               ioc->name, log_info,
> -            originator_str, sas_loginfo.dw.code,
> -            sas_loginfo.dw.subcode);
> +       ioc_warn(ioc, "log_info(0x%08x): originator(%s), code(0x%02x), sub_code(0x%04x)\n",
> +                log_info,
> +                originator_str, sas_loginfo.dw.code, sas_loginfo.dw.subcode);
>  }
>
>  /**
> @@ -1152,8 +1141,8 @@ _base_display_reply_info(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
>
>         mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>         if (unlikely(!mpi_reply)) {
> -               pr_err(MPT3SAS_FMT "mpi_reply not valid at %s:%d/%s()!\n",
> -                   ioc->name, __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "mpi_reply not valid at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 return;
>         }
>         ioc_status = le16_to_cpu(mpi_reply->IOCStatus);
> @@ -1249,9 +1238,9 @@ _base_async_event(struct MPT3SAS_ADAPTER *ioc, u8 msix_index, u32 reply)
>                 delayed_event_ack->EventContext = mpi_reply->EventContext;
>                 list_add_tail(&delayed_event_ack->list,
>                                 &ioc->delayed_event_ack_list);
> -               dewtprintk(ioc, pr_info(MPT3SAS_FMT
> -                               "DELAYED: EVENT ACK: event (0x%04x)\n",
> -                               ioc->name, le16_to_cpu(mpi_reply->Event)));
> +               dewtprintk(ioc,
> +                          ioc_info(ioc, "DELAYED: EVENT ACK: event (0x%04x)\n",
> +                                   le16_to_cpu(mpi_reply->Event)));
>                 goto out;
>         }
>
> @@ -2598,9 +2587,8 @@ _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
>
>   out:
>         si_meminfo(&s);
> -       pr_info(MPT3SAS_FMT
> -               "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
> -               ioc->name, ioc->dma_mask, convert_to_kb(s.totalram));
> +       ioc_info(ioc, "%d BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (%ld kB)\n",
> +                ioc->dma_mask, convert_to_kb(s.totalram));
>
>         return 0;
>  }
> @@ -2639,8 +2627,7 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>
>         base = pci_find_capability(ioc->pdev, PCI_CAP_ID_MSIX);
>         if (!base) {
> -               dfailprintk(ioc, pr_info(MPT3SAS_FMT "msix not supported\n",
> -                       ioc->name));
> +               dfailprintk(ioc, ioc_info(ioc, "msix not supported\n"));
>                 return -EINVAL;
>         }
>
> @@ -2658,9 +2645,8 @@ _base_check_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>                 pci_read_config_word(ioc->pdev, base + 2, &message_control);
>                 ioc->msix_vector_count = (message_control & 0x3FF) + 1;
>         }
> -       dinitprintk(ioc, pr_info(MPT3SAS_FMT
> -               "msix is supported, vector_count(%d)\n",
> -               ioc->name, ioc->msix_vector_count));
> +       dinitprintk(ioc, ioc_info(ioc, "msix is supported, vector_count(%d)\n",
> +                                 ioc->msix_vector_count));
>         return 0;
>  }
>
> @@ -2702,8 +2688,8 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
>
>         reply_q =  kzalloc(sizeof(struct adapter_reply_queue), GFP_KERNEL);
>         if (!reply_q) {
> -               pr_err(MPT3SAS_FMT "unable to allocate memory %d!\n",
> -                   ioc->name, (int)sizeof(struct adapter_reply_queue));
> +               ioc_err(ioc, "unable to allocate memory %zu!\n",
> +                       sizeof(struct adapter_reply_queue));
>                 return -ENOMEM;
>         }
>         reply_q->ioc = ioc;
> @@ -2761,8 +2747,8 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
>                         const cpumask_t *mask = pci_irq_get_affinity(ioc->pdev,
>                                                         reply_q->msix_index);
>                         if (!mask) {
> -                               pr_warn(MPT3SAS_FMT "no affinity for msi %x\n",
> -                                       ioc->name, reply_q->msix_index);
> +                               ioc_warn(ioc, "no affinity for msi %x\n",
> +                                        reply_q->msix_index);
>                                 continue;
>                         }
>
> @@ -2857,9 +2843,9 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>         r = pci_alloc_irq_vectors(ioc->pdev, 1, ioc->reply_queue_count,
>                                   irq_flags);
>         if (r < 0) {
> -               dfailprintk(ioc, pr_info(MPT3SAS_FMT
> -                       "pci_alloc_irq_vectors failed (r=%d) !!!\n",
> -                       ioc->name, r));
> +               dfailprintk(ioc,
> +                           ioc_info(ioc, "pci_alloc_irq_vectors failed (r=%d) !!!\n",
> +                                    r));
>                 goto try_ioapic;
>         }
>
> @@ -2882,9 +2868,9 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
>         ioc->reply_queue_count = 1;
>         r = pci_alloc_irq_vectors(ioc->pdev, 1, 1, PCI_IRQ_LEGACY);
>         if (r < 0) {
> -               dfailprintk(ioc, pr_info(MPT3SAS_FMT
> -                       "pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
> -                       ioc->name, r));
> +               dfailprintk(ioc,
> +                           ioc_info(ioc, "pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
> +                                    r));
>         } else
>                 r = _base_request_irq(ioc, 0);
>
> @@ -2939,13 +2925,11 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>         phys_addr_t chip_phys = 0;
>         struct adapter_reply_queue *reply_q;
>
> -       dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n",
> -           ioc->name, __func__));
> +       dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
>
>         ioc->bars = pci_select_bars(pdev, IORESOURCE_MEM);
>         if (pci_enable_device_mem(pdev)) {
> -               pr_warn(MPT3SAS_FMT "pci_enable_device_mem: failed\n",
> -                       ioc->name);
> +               ioc_warn(ioc, "pci_enable_device_mem: failed\n");
>                 ioc->bars = 0;
>                 return -ENODEV;
>         }
> @@ -2953,8 +2937,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>
>         if (pci_request_selected_regions(pdev, ioc->bars,
>             ioc->driver_name)) {
> -               pr_warn(MPT3SAS_FMT "pci_request_selected_regions: failed\n",
> -                       ioc->name);
> +               ioc_warn(ioc, "pci_request_selected_regions: failed\n");
>                 ioc->bars = 0;
>                 r = -ENODEV;
>                 goto out_fail;
> @@ -2967,8 +2950,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>
>
>         if (_base_config_dma_addressing(ioc, pdev) != 0) {
> -               pr_warn(MPT3SAS_FMT "no suitable DMA mask for %s\n",
> -                   ioc->name, pci_name(pdev));
> +               ioc_warn(ioc, "no suitable DMA mask for %s\n", pci_name(pdev));
>                 r = -ENODEV;
>                 goto out_fail;
>         }
> @@ -2991,8 +2973,7 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>         }
>
>         if (ioc->chip == NULL) {
> -               pr_err(MPT3SAS_FMT "unable to map adapter memory! "
> -                       " or resource not found\n", ioc->name);
> +               ioc_err(ioc, "unable to map adapter memory! or resource not found\n");
>                 r = -EINVAL;
>                 goto out_fail;
>         }
> @@ -3058,10 +3039,10 @@ mpt3sas_base_map_resources(struct MPT3SAS_ADAPTER *ioc)
>                     "IO-APIC enabled"),
>                     pci_irq_vector(ioc->pdev, reply_q->msix_index));
>
> -       pr_info(MPT3SAS_FMT "iomem(%pap), mapped(0x%p), size(%d)\n",
> -           ioc->name, &chip_phys, ioc->chip, memap_sz);
> -       pr_info(MPT3SAS_FMT "ioport(0x%016llx), size(%d)\n",
> -           ioc->name, (unsigned long long)pio_chip, pio_sz);
> +       ioc_info(ioc, "iomem(%pap), mapped(0x%p), size(%d)\n",
> +                &chip_phys, ioc->chip, memap_sz);
> +       ioc_info(ioc, "ioport(0x%016llx), size(%d)\n",
> +                (unsigned long long)pio_chip, pio_sz);
>
>         /* Save PCI configuration state for recovery from PCI AER/EEH errors */
>         pci_save_state(pdev);
> @@ -3176,8 +3157,7 @@ mpt3sas_base_get_smid(struct MPT3SAS_ADAPTER *ioc, u8 cb_idx)
>         spin_lock_irqsave(&ioc->scsi_lookup_lock, flags);
>         if (list_empty(&ioc->internal_free_list)) {
>                 spin_unlock_irqrestore(&ioc->scsi_lookup_lock, flags);
> -               pr_err(MPT3SAS_FMT "%s: smid not available\n",
> -                   ioc->name, __func__);
> +               ioc_err(ioc, "%s: smid not available\n", __func__);
>                 return 0;
>         }
>
> @@ -3545,89 +3525,85 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
>                 case MPI2_MFGPAGE_DEVID_SAS2008:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT2SAS_INTEL_RMS2LL080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS2LL080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS2LL080_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS2LL040_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS2LL040_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS2LL040_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_SSD910_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_SSD910_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_SSD910_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                "Intel(R) Controller: Subsystem ID: 0x%X\n",
> -                                ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                 case MPI2_MFGPAGE_DEVID_SAS2308_2:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT2SAS_INTEL_RS25GB008_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RS25GB008_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RS25GB008_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25JB080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25JB080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25JB080_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25JB040_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25JB040_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25JB040_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25KB080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25KB080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25KB080_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25KB040_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25KB040_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25KB040_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25LB040_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25LB040_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25LB040_BRANDING);
>                                 break;
>                         case MPT2SAS_INTEL_RMS25LB080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_INTEL_RMS25LB080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_INTEL_RMS25LB080_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                "Intel(R) Controller: Subsystem ID: 0x%X\n",
> -                                ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                 case MPI25_MFGPAGE_DEVID_SAS3008:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT3SAS_INTEL_RMS3JC080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_INTEL_RMS3JC080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_INTEL_RMS3JC080_BRANDING);
>                                 break;
>
>                         case MPT3SAS_INTEL_RS3GC008_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_INTEL_RS3GC008_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_INTEL_RS3GC008_BRANDING);
>                                 break;
>                         case MPT3SAS_INTEL_RS3FC044_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_INTEL_RS3FC044_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_INTEL_RS3FC044_BRANDING);
>                                 break;
>                         case MPT3SAS_INTEL_RS3UC080_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_INTEL_RS3UC080_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_INTEL_RS3UC080_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                "Intel(R) Controller: Subsystem ID: 0x%X\n",
> -                                ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                         break;
>                 default:
> -                       pr_info(MPT3SAS_FMT
> -                        "Intel(R) Controller: Subsystem ID: 0x%X\n",
> -                        ioc->name, ioc->pdev->subsystem_device);
> +                       ioc_info(ioc, "Intel(R) Controller: Subsystem ID: 0x%X\n",
> +                                ioc->pdev->subsystem_device);
>                         break;
>                 }
>                 break;
> @@ -3636,57 +3612,54 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
>                 case MPI2_MFGPAGE_DEVID_SAS2008:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT2SAS_DELL_6GBPS_SAS_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_6GBPS_SAS_HBA_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_PERC_H200_ADAPTER_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_PERC_H200_ADAPTER_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_PERC_H200_INTEGRATED_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_PERC_H200_INTEGRATED_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_PERC_H200_MODULAR_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_PERC_H200_MODULAR_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_PERC_H200_EMBEDDED_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_PERC_H200_EMBEDDED_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_PERC_H200_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_PERC_H200_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_PERC_H200_BRANDING);
>                                 break;
>                         case MPT2SAS_DELL_6GBPS_SAS_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_DELL_6GBPS_SAS_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_DELL_6GBPS_SAS_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                  "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
> -                                  ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Dell 6Gbps HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                         break;
>                 case MPI25_MFGPAGE_DEVID_SAS3008:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT3SAS_DELL_12G_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_DELL_12G_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_DELL_12G_HBA_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                  "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
> -                                  ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Dell 12Gbps HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                         break;
>                 default:
> -                       pr_info(MPT3SAS_FMT
> -                          "Dell HBA: Subsystem ID: 0x%X\n", ioc->name,
> -                          ioc->pdev->subsystem_device);
> +                       ioc_info(ioc, "Dell HBA: Subsystem ID: 0x%X\n",
> +                                ioc->pdev->subsystem_device);
>                         break;
>                 }
>                 break;
> @@ -3695,46 +3668,42 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
>                 case MPI25_MFGPAGE_DEVID_SAS3008:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT3SAS_CISCO_12G_8E_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_CISCO_12G_8E_HBA_BRANDING);
>                                 break;
>                         case MPT3SAS_CISCO_12G_8I_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_CISCO_12G_8I_HBA_BRANDING);
>                                 break;
>                         case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                       MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                 "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> -                                 ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                         break;
>                 case MPI25_MFGPAGE_DEVID_SAS3108_1:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT3SAS_CISCO_12G_AVILA_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                               MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_CISCO_12G_AVILA_HBA_BRANDING);
>                                 break;
>                         case MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                               MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING
> -                               );
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT3SAS_CISCO_12G_COLUSA_MEZZANINE_HBA_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> -                                ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "Cisco 12Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                         break;
>                 default:
> -                       pr_info(MPT3SAS_FMT
> -                          "Cisco SAS HBA: Subsystem ID: 0x%X\n",
> -                          ioc->name, ioc->pdev->subsystem_device);
> +                       ioc_info(ioc, "Cisco SAS HBA: Subsystem ID: 0x%X\n",
> +                                ioc->pdev->subsystem_device);
>                         break;
>                 }
>                 break;
> @@ -3743,43 +3712,40 @@ _base_display_OEMs_branding(struct MPT3SAS_ADAPTER *ioc)
>                 case MPI2_MFGPAGE_DEVID_SAS2004:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_HP_DAUGHTER_2_4_INTERNAL_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                  "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
> -                                  ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                 case MPI2_MFGPAGE_DEVID_SAS2308_2:
>                         switch (ioc->pdev->subsystem_device) {
>                         case MPT2SAS_HP_2_4_INTERNAL_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_HP_2_4_INTERNAL_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_HP_2_4_INTERNAL_BRANDING);
>                                 break;
>                         case MPT2SAS_HP_2_4_EXTERNAL_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_HP_2_4_EXTERNAL_BRANDING);
>                                 break;
>                         case MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_HP_1_4_INTERNAL_1_4_EXTERNAL_BRANDING);
>                                 break;
>                         case MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_SSDID:
> -                               pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                                   MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
> +                               ioc_info(ioc, "%s\n",
> +                                        MPT2SAS_HP_EMBEDDED_2_4_INTERNAL_BRANDING);
>                                 break;
>                         default:
> -                               pr_info(MPT3SAS_FMT
> -                                  "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
> -                                  ioc->name, ioc->pdev->subsystem_device);
> +                               ioc_info(ioc, "HP 6Gbps SAS HBA: Subsystem ID: 0x%X\n",
> +                                        ioc->pdev->subsystem_device);
>                                 break;
>                         }
>                 default:
> -                       pr_info(MPT3SAS_FMT
> -                          "HP SAS HBA: Subsystem ID: 0x%X\n",
> -                          ioc->name, ioc->pdev->subsystem_device);
> +                       ioc_info(ioc, "HP SAS HBA: Subsystem ID: 0x%X\n",
> +                                ioc->pdev->subsystem_device);
>                         break;
>                 }
>         default:
> @@ -3806,12 +3772,10 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
>         u16 smid, ioc_status;
>         size_t data_length;
>
> -       dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
> -                               __func__));
> +       dinitprintk(ioc, ioc_info(ioc, "%s\n", __func__));
>
>         if (ioc->base_cmds.status & MPT3_CMD_PENDING) {
> -               pr_err(MPT3SAS_FMT "%s: internal command already in use\n",
> -                               ioc->name, __func__);
> +               ioc_err(ioc, "%s: internal command already in use\n", __func__);
>                 return -EAGAIN;
>         }
>
> @@ -3819,15 +3783,14 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
>         fwpkg_data = pci_alloc_consistent(ioc->pdev, data_length,
>                         &fwpkg_data_dma);
>         if (!fwpkg_data) {
> -               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -                               ioc->name, __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "failure at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 return -ENOMEM;
>         }
>
>         smid = mpt3sas_base_get_smid(ioc, ioc->base_cb_idx);
>         if (!smid) {
> -               pr_err(MPT3SAS_FMT "%s: failed obtaining a smid\n",
> -                               ioc->name, __func__);
> +               ioc_err(ioc, "%s: failed obtaining a smid\n", __func__);
>                 r = -EAGAIN;
>                 goto out;
>         }
> @@ -3846,11 +3809,9 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
>         /* Wait for 15 seconds */
>         wait_for_completion_timeout(&ioc->base_cmds.done,
>                         FW_IMG_HDR_READ_TIMEOUT*HZ);
> -       pr_info(MPT3SAS_FMT "%s: complete\n",
> -                       ioc->name, __func__);
> +       ioc_info(ioc, "%s: complete\n", __func__);
>         if (!(ioc->base_cmds.status & MPT3_CMD_COMPLETE)) {
> -               pr_err(MPT3SAS_FMT "%s: timeout\n",
> -                               ioc->name, __func__);
> +               ioc_err(ioc, "%s: timeout\n", __func__);
>                 _debug_dump_mf(mpi_request,
>                                 sizeof(Mpi25FWUploadRequest_t)/4);
>                 r = -ETIME;
> @@ -3864,13 +3825,11 @@ _base_display_fwpkg_version(struct MPT3SAS_ADAPTER *ioc)
>                         if (ioc_status == MPI2_IOCSTATUS_SUCCESS) {
>                                 FWImgHdr = (Mpi2FWImageHeader_t *)fwpkg_data;
>                                 if (FWImgHdr->PackageVersion.Word) {
> -                                       pr_info(MPT3SAS_FMT "FW Package Version"
> -                                       "(%02d.%02d.%02d.%02d)\n",
> -                                       ioc->name,
> -                                       FWImgHdr->PackageVersion.Struct.Major,
> -                                       FWImgHdr->PackageVersion.Struct.Minor,
> -                                       FWImgHdr->PackageVersion.Struct.Unit,
> -                                       FWImgHdr->PackageVersion.Struct.Dev);
> +                                       ioc_info(ioc, "FW Package Version (%02d.%02d.%02d.%02d)\n",
> +                                                FWImgHdr->PackageVersion.Struct.Major,
> +                                                FWImgHdr->PackageVersion.Struct.Minor,
> +                                                FWImgHdr->PackageVersion.Struct.Unit,
> +                                                FWImgHdr->PackageVersion.Struct.Dev);
>                                 }
>                         } else {
>                                 _debug_dump_mf(&mpi_reply,
> @@ -3900,18 +3859,17 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
>
>         bios_version = le32_to_cpu(ioc->bios_pg3.BiosVersion);
>         strncpy(desc, ioc->manu_pg0.ChipName, 16);
> -       pr_info(MPT3SAS_FMT "%s: FWVersion(%02d.%02d.%02d.%02d), "\
> -          "ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
> -           ioc->name, desc,
> -          (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
> -          (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
> -          (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
> -          ioc->facts.FWVersion.Word & 0x000000FF,
> -          ioc->pdev->revision,
> -          (bios_version & 0xFF000000) >> 24,
> -          (bios_version & 0x00FF0000) >> 16,
> -          (bios_version & 0x0000FF00) >> 8,
> -           bios_version & 0x000000FF);
> +       ioc_info(ioc, "%s: FWVersion(%02d.%02d.%02d.%02d), ChipRevision(0x%02x), BiosVersion(%02d.%02d.%02d.%02d)\n",
> +                desc,
> +                (ioc->facts.FWVersion.Word & 0xFF000000) >> 24,
> +                (ioc->facts.FWVersion.Word & 0x00FF0000) >> 16,
> +                (ioc->facts.FWVersion.Word & 0x0000FF00) >> 8,
> +                ioc->facts.FWVersion.Word & 0x000000FF,
> +                ioc->pdev->revision,
> +                (bios_version & 0xFF000000) >> 24,
> +                (bios_version & 0x00FF0000) >> 16,
> +                (bios_version & 0x0000FF00) >> 8,
> +                bios_version & 0x000000FF);
>
>         _base_display_OEMs_branding(ioc);
>
> @@ -3920,82 +3878,81 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
>                 i++;
>         }
>
> -       pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
> +       ioc_info(ioc, "Protocol=(");
>
>         if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
> -               pr_info("Initiator");
> +               pr_cont("Initiator");
>                 i++;
>         }
>
>         if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_TARGET) {
> -               pr_info("%sTarget", i ? "," : "");
> +               pr_cont("%sTarget", i ? "," : "");
>                 i++;
>         }
>
>         i = 0;
> -       pr_info("), ");
> -       pr_info("Capabilities=(");
> +       pr_cont("), Capabilities=(");
>
>         if (!ioc->hide_ir_msg) {
>                 if (ioc->facts.IOCCapabilities &
>                     MPI2_IOCFACTS_CAPABILITY_INTEGRATED_RAID) {
> -                       pr_info("Raid");
> +                       pr_cont("Raid");
>                         i++;
>                 }
>         }
>
>         if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_TLR) {
> -               pr_info("%sTLR", i ? "," : "");
> +               pr_cont("%sTLR", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_MULTICAST) {
> -               pr_info("%sMulticast", i ? "," : "");
> +               pr_cont("%sMulticast", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities &
>             MPI2_IOCFACTS_CAPABILITY_BIDIRECTIONAL_TARGET) {
> -               pr_info("%sBIDI Target", i ? "," : "");
> +               pr_cont("%sBIDI Target", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities & MPI2_IOCFACTS_CAPABILITY_EEDP) {
> -               pr_info("%sEEDP", i ? "," : "");
> +               pr_cont("%sEEDP", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities &
>             MPI2_IOCFACTS_CAPABILITY_SNAPSHOT_BUFFER) {
> -               pr_info("%sSnapshot Buffer", i ? "," : "");
> +               pr_cont("%sSnapshot Buffer", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities &
>             MPI2_IOCFACTS_CAPABILITY_DIAG_TRACE_BUFFER) {
> -               pr_info("%sDiag Trace Buffer", i ? "," : "");
> +               pr_cont("%sDiag Trace Buffer", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities &
>             MPI2_IOCFACTS_CAPABILITY_EXTENDED_BUFFER) {
> -               pr_info("%sDiag Extended Buffer", i ? "," : "");
> +               pr_cont("%sDiag Extended Buffer", i ? "," : "");
>                 i++;
>         }
>
>         if (ioc->facts.IOCCapabilities &
>             MPI2_IOCFACTS_CAPABILITY_TASK_SET_FULL_HANDLING) {
> -               pr_info("%sTask Set Full", i ? "," : "");
> +               pr_cont("%sTask Set Full", i ? "," : "");
>                 i++;
>         }
>
>         iounit_pg1_flags = le32_to_cpu(ioc->iounit_pg1.Flags);
>         if (!(iounit_pg1_flags & MPI2_IOUNITPAGE1_NATIVE_COMMAND_Q_DISABLE)) {
> -               pr_info("%sNCQ", i ? "," : "");
> +               pr_cont("%sNCQ", i ? "," : "");
>                 i++;
>         }
>
> -       pr_info(")\n");
> +       pr_cont(")\n");
>  }
>
>  /**
> @@ -4028,21 +3985,21 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
>             sizeof(Mpi2SasIOUnit1PhyData_t));
>         sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
>         if (!sas_iounit_pg1) {
> -               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -                   ioc->name, __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "failure at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 goto out;
>         }
>         if ((mpt3sas_config_get_sas_iounit_pg1(ioc, &mpi_reply,
>             sas_iounit_pg1, sz))) {
> -               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -                   ioc->name, __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "failure at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 goto out;
>         }
>         ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
>             MPI2_IOCSTATUS_MASK;
>         if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
> -               pr_err(MPT3SAS_FMT "failure at %s:%d/%s()!\n",
> -                   ioc->name, __FILE__, __LINE__, __func__);
> +               ioc_err(ioc, "failure at %s:%d/%s()!\n",
> +                       __FILE__, __LINE__, __func__);
>                 goto out;
>         }
>
> @@ -4074,11 +4031,11 @@ mpt3sas_base_update_missing_delay(struct MPT3SAS_ADAPTER *ioc,
>                 else
>                         dmd_new =
>                     dmd & MPI2_SASIOUNIT1_REPORT_MISSING_TIMEOUT_MASK;
> -               pr_info(MPT3SAS_FMT "device_missing_delay: old(%d), new(%d)\n",
> -                       ioc->name, dmd_orignal, dmd_new);
> -               pr_info(MPT3SAS_FMT "ioc_missing_delay: old(%d), new(%d)\n",
> -                       ioc->name, io_missing_delay_original,
> -                   io_missing_delay);
> +               ioc_info(ioc, "device_missing_delay: old(%d), new(%d)\n",
> +                        dmd_orignal, dmd_new);
> +               ioc_info(ioc, "ioc_missing_delay: old(%d), new(%d)\n",
> +                        io_missing_delay_original,
> +                        io_missing_delay);
>                 ioc->device_missing_delay = dmd_new;
>                 ioc->io_missing_delay = io_missing_delay;
>         }
> @@ -4189,33 +4146,32 @@ _base_release_memo
