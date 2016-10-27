From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] advansys: fix build warning for PCI=n
Date: Wed, 26 Oct 2016 21:42:51 -0400
Message-ID: <yq1a8dq7ejo.fsf@sermon.lab.mkp.net>
References: <20161024155207.3027347-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161024155207.3027347-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 24 Oct 2016 17:51:55 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.com>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Arnd" == Arnd Bergmann <arnd@arndb.de> writes:

Arnd> The advansys probe function tries to handle both ISA and PCI
Arnd> cases, each hidden in an #ifdef when unused. This leads to a
Arnd> warning indicating that when PCI is disabled we could be using
Arnd> uninitialized data:

Arnd> drivers/scsi/advansys.c: In function ‘advansys_board_found’:
Arnd> drivers/scsi/advansys.c:11036:5: error: ‘ret’ may be used
Arnd> uninitialized in this function [-Werror=maybe-uninitialized]
Arnd> drivers/scsi/advansys.c:10928:28: note: ‘ret’ was declared here
Arnd> drivers/scsi/advansys.c:11309:8: error: ‘share_irq’ may be used
Arnd> uninitialized in this function [-Werror=maybe-uninitialized]
Arnd> drivers/scsi/advansys.c:10928:6: note: ‘share_irq’ was declared
Arnd> here

Arnd> This cannot happen in practice because the hardware in question
Arnd> only exists for PCI, but changing the code to just error out here
Arnd> is better for consistency and avoids the warning.

Applied to 4.10/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
