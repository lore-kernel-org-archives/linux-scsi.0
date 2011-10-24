From: "Sampathkumar, Kishore" <Kishore.SampathKumar@lsi.com>
Subject: RE: No linkage from /sys entries for a given scsi_host to its PCI
 device details?
Date: Mon, 24 Oct 2011 13:20:17 +0530
Message-ID: <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1B@inbmail02.lsi.com>
References: <S932680Ab1INNeE/20110914133404Z+1759@vger.kernel.org>
  <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1A@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:46874 "EHLO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab1JXHuW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2011 03:50:22 -0400
In-Reply-To: <E4D7778E36CF944ABD2F7E18D2DB9666271B897A1A@inbmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Same text as before; but properly formatted.

[root@host26 /]# ls -l /dev/disk/by-id/wwn-0x5000c5000f8f4583
lrwxrwxrwx. 1 root root 9 Oct 19 11:14 wwn-0x5000c5000f8f4583 -> ../../sdg

[root@host26 /]# ls /sys/block/sdg/device/scsi_disk
3:0:5:0

The above is the host{number} for the SCSI Host controller (in the above case "host3").

[root@host26 /]# ls /sys/class/scsi_host/host3
active_mode     device            io_delay           scan            unchecked_isa_dma       version_nvdata_persistent
board_assembly  device_delay      logging_level      sg_tablesize    unique_id               version_product
board_name      fw_queue_depth    power              state           version_bios
board_tracer    fwfault_debug     proc_name          subsystem       version_fw
can_queue       host_busy         prot_capabilities  supported_mode  version_mpi
cmd_per_lun     host_sas_address  prot_guard_type    uevent          version_nvdata_default

>From the above, there is no linkage to the PCI device corresponding to the above host controller. The only way I could establish the linkage was to actually start from the PCI device ID for this controller, and then, doing the following:

[root@host26 /]# ls /sys/class/pci_bus/0000:0c/device/0000:0c:00.0
broken_parity_status  host3          numa_node  resource   subsystem_device
class                 irq            pools      resource0  subsystem_vendor
config                local_cpulist  power      resource1  uevent
device                local_cpus     remove     resource3  vendor
driver                modalias       rescan     rom        vpd
enable                msi_bus        reset      subsystem

I think it is very useful to have the necessary linkage to get to the PCI device from the /sys/class/scsi_host/host3 entries.

Thanks,
-	Kishore
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
