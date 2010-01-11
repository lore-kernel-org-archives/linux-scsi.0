From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15001] megaraid_sas fills dmesg with megasas: Failed to copy
 out to user sense data
Date: Mon, 11 Jan 2010 11:12:52 GMT
Message-ID: <201001111112.o0BBCqud017148@demeter.kernel.org>
References: <bug-15001-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:46626 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495Ab0AKLMx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2010 06:12:53 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.2) with ESMTP id o0BBCqvN017149
	for <linux-scsi@vger.kernel.org>; Mon, 11 Jan 2010 11:12:52 GMT
In-Reply-To: <bug-15001-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15001





--- Comment #3 from Alex <mailatgoogl@gmail.com>  2010-01-11 11:12:51 ---
Hello , 
so what I have done  :

I copied megaraid directory from 2.6.33-rc3  and compiled module 

here is my Makefile 
obj-$(CONFIG_MEGARAID_MM)       += megaraid_mm.o
obj-$(CONFIG_MEGARAID_MAILBOX)  += megaraid_mbox.o
obj-$(CONFIG_MEGARAID_SAS)      += megaraid_sas.o
KDIR := /lib/modules/2.6.31.11-grsec/build
PWD := $(shell pwd)
default:
        $(MAKE) -C $(KDIR) SUBDIRS=$(PWD) CONFIG_DEBUG_SECTION_MISMATCH=y
modules

and here is the make's output 

/home/pkg/megaraid/megaraid# make 
make -C /lib/modules/2.6.31.11-grsec/build SUBDIRS=/home/pkg/megaraid/megaraid
CONFIG_DEBUG_SECTION_MISMATCH=y modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.31.11-grsec'
  Building modules, stage 2.
  MODPOST 1 modules
WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x30): Section
mismatch in reference from the variable megasas_pci_driver to the function
.text:megasas_suspend()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x48): Section
mismatch in reference from the variable megasas_pci_driver to the function
.text:megasas_resume()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x50): Section
mismatch in reference from the variable megasas_pci_driver to the function
.text:megasas_shutdown()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0xf8): Section
mismatch in reference from the variable driver_attr_poll_mode_io to the
function .text:megasas_sysfs_show_poll_mode_io()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x100): Section
mismatch in reference from the variable driver_attr_poll_mode_io to the
function .text:megasas_sysfs_set_poll_mode_io()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x128): Section
mismatch in reference from the variable driver_attr_dbg_lvl to the function
.text:megasas_sysfs_show_dbg_lvl()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x130): Section
mismatch in reference from the variable driver_attr_dbg_lvl to the function
.text:megasas_sysfs_set_dbg_lvl()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x158): Section
mismatch in reference from the variable driver_attr_release_date to the
function .text:megasas_sysfs_show_release_date()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x188): Section
mismatch in reference from the variable driver_attr_version to the function
.text:megasas_sysfs_show_version()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x1f8): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_queue_command()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x210): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_reset_device()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x220): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_reset_bus_host()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x228): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_reset_bus_host()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x230): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_slave_alloc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x238): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_slave_configure()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x278): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_bios_param()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x288): Section
mismatch in reference from the variable megasas_template to the function
.text:megasas_reset_timer()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x2f0): Section
mismatch in reference from the variable megasas_instance_template_ppc to the
function .text:megasas_fire_cmd_ppc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x2f8): Section
mismatch in reference from the variable megasas_instance_template_ppc to the
function .text:megasas_enable_intr_ppc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x300): Section
mismatch in reference from the variable megasas_instance_template_ppc to the
function .text:megasas_disable_intr_ppc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x308): Section
mismatch in reference from the variable megasas_instance_template_ppc to the
function .text:megasas_clear_intr_ppc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x310): Section
mismatch in reference from the variable megasas_instance_template_ppc to the
function .text:megasas_read_fw_status_reg_ppc()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x320): Section
mismatch in reference from the variable megasas_instance_template_gen2 to the
function .text:megasas_fire_cmd_gen2()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x328): Section
mismatch in reference from the variable megasas_instance_template_gen2 to the
function .text:megasas_enable_intr_gen2()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x330): Section
mismatch in reference from the variable megasas_instance_template_gen2 to the
function .text:megasas_disable_intr_gen2()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x338): Section
mismatch in reference from the variable megasas_instance_template_gen2 to the
function .text:megasas_clear_intr_gen2()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x340): Section
mismatch in reference from the variable megasas_instance_template_gen2 to the
function .text:megasas_read_fw_status_reg_gen2()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x350): Section
mismatch in reference from the variable megasas_instance_template_skinny to the
function .text:megasas_fire_cmd_skinny()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x358): Section
mismatch in reference from the variable megasas_instance_template_skinny to the
function .text:megasas_enable_intr_skinny()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x360): Section
mismatch in reference from the variable megasas_instance_template_skinny to the
function .text:megasas_disable_intr_skinny()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x368): Section
mismatch in reference from the variable megasas_instance_template_skinny to the
function .text:megasas_clear_intr_skinny()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x370): Section
mismatch in reference from the variable megasas_instance_template_skinny to the
function .text:megasas_read_fw_status_reg_skinny()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x380): Section
mismatch in reference from the variable megasas_instance_template_xscale to the
function .text:megasas_fire_cmd_xscale()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x388): Section
mismatch in reference from the variable megasas_instance_template_xscale to the
function .text:megasas_enable_intr_xscale()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x390): Section
mismatch in reference from the variable megasas_instance_template_xscale to the
function .text:megasas_disable_intr_xscale()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x398): Section
mismatch in reference from the variable megasas_instance_template_xscale to the
function .text:megasas_clear_intr_xscale()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x3a0): Section
mismatch in reference from the variable megasas_instance_template_xscale to the
function .text:megasas_read_fw_status_reg_xscale()

WARNING: /home/pkg/megaraid/megaraid/megaraid_sas.o(.data+0x3c8): Section
mismatch in reference from the variable driver_attr_support_poll_for_event to
the function .text:megasas_sysfs_show_support_poll_for_event()

make[1]: Leaving directory `/usr/src/linux-headers-2.6.31.11-grsec'


than I copied megaraid_sas.ko to modules tree and run update-initramfs -uv

after reboot :
uname -a
Linux mydb 2.6.31.11-grsec #1 SMP Fri Jan 8 10:22:54 CET 2010 x86_64 GNU/Linux

modinfo megaraid_sas
filename:      
/lib/modules/2.6.31.11-grsec/kernel/misc/megaraid/megaraid_sas.ko
description:    LSI MegaRAID SAS Driver
author:         megaraidlinux@lsi.com
version:        00.00.04.12-rc1
license:        GPL
srcversion:     4B304EFDDEF265C4DB3635B
alias:          pci:v00001028d00000015sv*sd*bc*sc*i*
alias:          pci:v00001000d00000413sv*sd*bc*sc*i*
alias:          pci:v00001000d00000071sv*sd*bc*sc*i*
alias:          pci:v00001000d00000073sv*sd*bc*sc*i*
alias:          pci:v00001000d00000079sv*sd*bc*sc*i*
alias:          pci:v00001000d00000078sv*sd*bc*sc*i*
alias:          pci:v00001000d0000007Csv*sd*bc*sc*i*
alias:          pci:v00001000d00000060sv*sd*bc*sc*i*
alias:          pci:v00001000d00000411sv*sd*bc*sc*i*
depends:        scsi_mod
vermagic:       2.6.31.11-grsec SMP mod_unload 
parm:           poll_mode_io:Complete cmds from IO path, (default=0) (int)


I still get this messages 
megasas: Failed to copy out to user sense data

the same was for 4.17 version which I got from dell site .

dmesg is attached .

and what does this message mean ?
is it harmless ? 

Thank you .
Regards , 
Alex

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
