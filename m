From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH] scsi: qla2xxx: fix unused function warning
Date: Mon, 10 Dec 2018 13:01:06 -0800
Message-ID: <1544475666.185366.378.camel@acm.org>
References: <20181210205215.2703138-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181210205215.2703138-1-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Laurence Oberman <loberman@redhat.com>, Himanshu Madhani <himanshu.madhani@cavium.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Himanshu Madhani <hmadhani@marvell.com>, Quinn Tran <quinn.tran@cavium.com>, Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>, Darren Trapp <darren.trapp@cavium.com>, Bill Kuzeja <William.Kuzeja@stratus.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, 2018-12-10 at 21:51 +-0100, Arnd Bergmann wrote:
+AD4 In what seems to be a mismatch between the scsi-fixes branch and
+AD4 the scsi-mkp/for-next branch, a newly introduced variable from
+AD4 one patch got obsoleted in another one:
+AD4 
+AD4 drivers/scsi/qla2xxx/qla+AF8-os.c: In function '+AF8AXw-qla2x00+AF8-abort+AF8-all+AF8-cmds':
+AD4 drivers/scsi/qla2xxx/qla+AF8-os.c:1791:11: error: unused variable 'status' +AFs--Werror+AD0-unused-variable+AF0
+AD4 
+AD4 Remove the variable again.
+AD4 
+AD4 Fixes: c4e521b654e1 (+ACI-scsi: qla2xxx: Split the +AF8AXw-qla2x00+AF8-abort+AF8-all+AF8-cmds() function+ACI)
+AD4 Fixes: f2ffd4e5bc7b (+ACI-scsi: qla2xxx: Timeouts occur on surprise removal of QLogic adapter+ACI)
+AD4 Signed-off-by: Arnd Bergmann +ADw-arnd+AEA-arndb.de+AD4
+AD4 ---
+AD4 Maybe check carefully that the merge in linux-next is otherwise correct
+AD4 ---
+AD4  drivers/scsi/qla2xxx/qla+AF8-os.c +AHw 2 +--
+AD4  1 file changed, 1 insertion(+-), 1 deletion(-)
+AD4 
+AD4 diff --git a/drivers/scsi/qla2xxx/qla+AF8-os.c b/drivers/scsi/qla2xxx/qla+AF8-os.c
+AD4 index 63c47bc7ae59..db331cb5ba3c 100644
+AD4 --- a/drivers/scsi/qla2xxx/qla+AF8-os.c
+AD4 +-+-+- b/drivers/scsi/qla2xxx/qla+AF8-os.c
+AD4 +AEAAQA -1788,7 +-1788,7 +AEAAQA static void qla2x00+AF8-abort+AF8-srb(struct qla+AF8-qpair +ACo-qp, srb+AF8-t +ACo-sp, const int res,
+AD4  static void
+AD4  +AF8AXw-qla2x00+AF8-abort+AF8-all+AF8-cmds(struct qla+AF8-qpair +ACo-qp, int res)
+AD4  +AHs
+AD4 -	int cnt, status+ADs
+AD4 +-	int cnt+ADs
+AD4  	unsigned long flags+ADs
+AD4  	srb+AF8-t +ACo-sp+ADs
+AD4  	scsi+AF8-qla+AF8-host+AF8-t +ACo-vha +AD0 qp-+AD4-vha+ADs

When I prepared commit c4e521b654e1 I verified that my patch did not produce any
warnings when building with W+AD0-1. So something must be wrong at your side. Did you
perhaps start from linux-next to prepare this patch? If so, please submit this
patch to Stephen Rothwell.

Bart.
