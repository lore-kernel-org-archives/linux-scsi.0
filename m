From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: pulling failover out of qla2xxx
Date: Fri, 16 Jan 2004 18:39:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040116233929.GA30969@gtf.org>
References: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org> <20040116233328.GB24093@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([63.247.75.124]:40088 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S265955AbUAPXj3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 18:39:29 -0500
Content-Disposition: inline
In-Reply-To: <20040116233328.GB24093@devserv.devel.redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjanv@redhat.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Sat, Jan 17, 2004 at 12:33:28AM +0100, Arjan van de Ven wrote:
> Another approach could be separate modules which ONLY have firmware, one
> module per firmware file (but that gets you really close to
> request_firmare() api)

That's what the upstream tree has right now...  here's the complete
contents of ql2100.c...


/*
 * QLogic ISP2100 device driver for Linux 2.6.x
 * Copyright (C) 2003 Christoph Hellwig.
 * Copyright (C) 2003 QLogic Corporation (www.qlogic.com)
 *
 * Released under GPL v2.
 */

#include <linux/init.h>
#include <linux/module.h>
#include <linux/pci.h>

#include "qla_os.h"
#include "qla_def.h"

static char qla_driver_name[] = "qla2100";

extern unsigned char  fw2100tp_version[];
extern unsigned char  fw2100tp_version_str[];
extern unsigned short fw2100tp_addr01;
extern unsigned short fw2100tp_code01[];
extern unsigned short fw2100tp_length01;

static struct qla_fw_info qla_fw_tbl[] = {
	{
		.addressing	= FW_INFO_ADDR_NORMAL,
		.fwcode		= &fw2100tp_code01[0],
		.fwlen		= &fw2100tp_length01,
		.fwstart	= &fw2100tp_addr01,
	},

	{ FW_INFO_ADDR_NOMORE, },
};

static struct qla_board_info qla_board_tbl = {
	.drv_name	= qla_driver_name,

	.isp_name	= "ISP2100",
	.fw_info	= qla_fw_tbl,
};

static struct pci_device_id qla2100_pci_tbl[] = {
	{
		.vendor		= PCI_VENDOR_ID_QLOGIC,
		.device		= PCI_DEVICE_ID_QLOGIC_ISP2100,
		.subvendor	= PCI_ANY_ID,
		.subdevice	= PCI_ANY_ID,
		.driver_data	= (unsigned long)&qla_board_tbl,
	},

	{0, 0},
};
MODULE_DEVICE_TABLE(pci, qla2100_pci_tbl);

static int __devinit
qla2100_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
{
	return qla2x00_probe_one(pdev,
	    (struct qla_board_info *)id->driver_data);
}

static void __devexit
qla2100_remove_one(struct pci_dev *pdev)
{
	qla2x00_remove_one(pdev);
}

static struct pci_driver qla2100_pci_driver = {
	.name		= "qla2100",
	.id_table	= qla2100_pci_tbl,
	.probe		= qla2100_probe_one,
	.remove		= __devexit_p(qla2100_remove_one),
};

static int __init
qla2100_init(void)
{
	return pci_module_init(&qla2100_pci_driver);
}

static void __exit
qla2100_exit(void)
{
	pci_unregister_driver(&qla2100_pci_driver);
}

module_init(qla2100_init);
module_exit(qla2100_exit);

MODULE_AUTHOR("QLogic Corporation");
MODULE_DESCRIPTION("QLogic ISP21xx FC-SCSI Host Bus Adapter driver");
MODULE_LICENSE("GPL");
