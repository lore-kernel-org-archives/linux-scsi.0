From: Rabeeh Khoury <rabeeh@il.marvell.com>
Subject: Re: [RFR] a new SCSI driver
Date: Mon, 26 May 2003 18:16:12 +0300
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <3ED22FBC.50405@il.marvell.com>
References: <20030524195123.GA8394@gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20030524195123.GA8394@gtf.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A small correction to the code -
While translating the GET_CAPACITY to ATA, you are returning the number of sectors the ATA drive but the GET_CAPACITY requests the last addressable sector.
So you should return (n_sectors-1).


static void ata_scsiop_read_cap(struct ata_scsi_args *args, u8 *reqbuf,
			        unsigned int buflen)
{
	u64 n_sectors = args->dev->n_sectors;
	u32 tmp;
+++ n_sectors --;
	VPRINTK("ENTER\n");
