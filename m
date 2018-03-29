From: Hans de Goede <hdegoede@redhat.com>
Subject: aacraid code passes GFP_DMA32 to kmalloc this will not work
Date: Thu, 29 Mar 2018 16:51:28 +0200
Message-ID: <258be5fa-f930-bc5e-d8a0-3d6b5bee0a8b@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, SCSI development list <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi All,

Since I made the same mistake myself I've done a quick grep for
GFP_DMA32 in the kernel and drivers/scsi/aacraid/commctrl.c
came up as a result of this grep, it does:

                                 p = kmalloc(sg_count[i], GFP_KERNEL|GFP_DMA32);

But kmalloc always returns memory from the normal memory-zone,
if you need memory from a specific memory-zone like the
DMA32 zone, you must use the dma allocation functions (which
from a quick glance at the code seems appropriate here) or
directly call alloc_page or __get_free_page.

Regards,

Hans
