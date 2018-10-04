From: John Garry <john.garry@huawei.com>
Subject: Re: [SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS
 RAID controller
Date: Thu, 4 Oct 2018 12:48:16 +0100
Message-ID: <4910c207-5dc2-0095-7a7f-75bb025b337c@huawei.com>
References: <f512d8fa-e782-0679-8140-0a27dd3b9062@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f512d8fa-e782-0679-8140-0a27dd3b9062@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin Ian King <colin.king@canonical.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 04/10/2018 09:28, Colin Ian King wrote:
> Hi,
>
> Static analysis from CoverityScan (CID#114178 "Operands don't affect
> result") detected an issue in drivers/scsi/pmcraid.c, function
> pmcraid_init_res_table with the following check:
>
>         if (pinstance->cfg_table->flags & MICROCODE_UPDATE_REQUIRED)
>                 pmcraid_err("IOA requires microcode download\n");
>
>
> pinstance->cfg_table->flags is a u8, MICROCODE_UPDATE_REQUIRED is  1 <<
> 31, so the & operation always results in false and the error message is
> never displayed.  From my understanding, flags should be a u8, so there
> is something wrong here with the check.  Any ideas?
>
> Colin
>
>

Maybe MICROCODE_UPDATE_REQUIRED definition is wrong and should be:
  /* config_table.flags value */
-#define MICROCODE_UPDATE_REQUIRED        PMC_BIT32(0)
+#define MICROCODE_UPDATE_REQUIRED        PMC_BIT8(0)

John
