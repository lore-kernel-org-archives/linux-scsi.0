From: =?iso-8859-1?Q?Thomas_Lang=E5s?= <tlan@stud.ntnu.no>
Subject: Weird Qlogic 2200 FC HBA / CNSI G7324  problem
Date: Fri, 12 Jul 2002 01:08:44 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020712010844.A19115@stud.ntnu.no>
Reply-To: linux-scsi@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from localhost (localhost [127.0.0.1])
	by due.stud.ntnu.no (Postfix) with ESMTP id 989D012B2C8
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2002 01:09:25 +0200 (CEST)
Received: from puma.stud.ntnu.no (puma.stud.ntnu.no [129.241.56.183])
	by due.stud.ntnu.no (Postfix) with ESMTP id D3F5512AF10
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2002 01:09:19 +0200 (CEST)
Received: (from tlan@localhost)
	by puma.stud.ntnu.no (8.11.6/8.10.0.Beta12) id g6BN8s400471
	for linux-scsi@vger.kernel.org; Fri, 12 Jul 2002 01:08:54 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


We have an installation that constists of:
* 2x2 CNSI G7324 (active-active) 
* Each CNSI G7324 has 2x270GB RAID-partitions
* Servers with Qlogic 2200 FC HBAs

Today this is a 8 server, 1 HBA pr server config, so
there's one partition pr server. We're however trying to
change this now, to a 4 server, 2 HBA pr. server config
which will mean 2 partitions pr server. And now we bumped
into a problem; we can't get more than one partition
pr CNSI detected on each server, it doesn't matter how
many HBAs we insert, only one of the HBAs find a 
partition from that one CNSI-controller.

test3:/usr/src/linux-2.4/drivers/scsi# uname -a
Linux test3.stud.ntnu.no 2.4.18-3smp #1 SMP Thu Apr 18 07:27:31 EDT 2002 i686 unknown

(Output from dmesg)
scsi1 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 1 device 6 irq 16
        Firmware version:  2.02.03, Driver version 6.1b2
scsi2 : QLogic QLA2200 PCI to Fibre Channel Host Adapter: bus 1 device 8 irq 20
        Firmware version:  2.02.03, Driver version 6.1b2

Anyone has any idea where we should start searching for
a solution to this problem?  


Another problem, which I don't think is serious, is this:

(also from dmesg)

scsi1: Host table full.
scsi2: Host table full.

I get this on all our newly installed servers, never seen 
this one before, actually. But looking through the driver
code, it didn't seem that it was something to care about:

test3:/usr/src/qlogic# grep -B 18 -A 13 "Host table" qla2x00.c 
                } else if (status[0] == 0x4000) {
                        if (status[1] & 0x0001) {
                                /*
                                 * This is an initiator only device. Save
                                 * some info to host_db and ignore it.
                                 */
                                if (ha->next_host_slot < 8) {
                                        BCOPY(device->wwn, ha->phost_db
                                            [ha->next_host_slot].wwn, 8);
                                        BCOPY(device->name, ha->phost_db
                                            [ha->next_host_slot].name, 8);
                                        ha->phost_db[ha->next_host_slot].
                                            d_id.b24 = device->d_id.b24;
                                        ha->phost_db[ha->next_host_slot].
                                            loop_id = device->loop_id;
                                        ha->next_host_slot++;
                                } else {
                                        printk(KERN_INFO
                                            "scsi%ld: Host table full.\n",
                                            ha->host_no);
                                }
                                return 2;
                        }

                        /* This is target capable device */
                        qla2x00_get_port_database(ha, device, 0);

                        DEBUG(printk("scsi%d: Fabric Login OK. loop id=0x%04x, "
                            "port Id=%06x\n",
                            (int)ha->host_no, 
                            device->loop_id, device->d_id.b24);)
                        return 0;


So, any help at all would be greatly appreciated.
In advance, thanks!

-- 
Thomas
