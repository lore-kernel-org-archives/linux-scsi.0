From: Colin Ian King <colin.king@canonical.com>
Subject: Re: [SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS
 RAID controller
Date: Thu, 4 Oct 2018 09:28:19 +0100
Message-ID: <f512d8fa-e782-0679-8140-0a27dd3b9062@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Static analysis from CoverityScan (CID#114178 "Operands don't affect
result") detected an issue in drivers/scsi/pmcraid.c, function
pmcraid_init_res_table with the following check:

        if (pinstance->cfg_table->flags & MICROCODE_UPDATE_REQUIRED)
                pmcraid_err("IOA requires microcode download\n");


pinstance->cfg_table->flags is a u8, MICROCODE_UPDATE_REQUIRED is  1 <<
31, so the & operation always results in false and the error message is
never displayed.  From my understanding, flags should be a u8, so there
is something wrong here with the check.  Any ideas?

Colin
