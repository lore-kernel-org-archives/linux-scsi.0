From: Nishanth Aravamudan <nacc@us.ibm.com>
Subject: Re: [patch 4/7] scsi/qla_os: replace schedule_timeout() with ssleep()
Date: Wed, 12 Jan 2005 15:43:14 -0800
Message-ID: <20050112234314.GB2688@us.ibm.com>
References: <20050111232257.909231F226@trashy.coderock.org> <1105547532.5577.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:39393 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261593AbVALXnT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Jan 2005 18:43:19 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e6.ny.us.ibm.com (8.12.10/8.12.10) with ESMTP id j0CNhF9S006462
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:43:15 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0CNhFK2285624
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:43:15 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j0CNhFvR018562
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jan 2005 18:43:15 -0500
Content-Disposition: inline
In-Reply-To: <1105547532.5577.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: domen@coderock.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, andrew.vasquez@qlogic.com

On Wed, Jan 12, 2005 at 10:32:11AM -0600, James Bottomley wrote:
> On Wed, 2005-01-12 at 00:22 +0100, domen@coderock.org wrote:
> > Description: Use ssleep() instead of schedule_timeout() to guarantee the
> [...]
> > -		set_current_state(TASK_UNINTERRUPTIBLE);
> > -		schedule_timeout(ABORT_POLLING_PERIOD);
> > +		msleep(ABORT_POLLING_PERIOD);
> 
> The description doesn't match the code.
> 
> Also, the qla driver is maintained.  You should cc
> andrew.vasquez@qlogic.com (I know they don't make it easy, like having
> an entry in the MAINTAINERS file or even an email address in the code).

Please find the corrected Description with this patch (and the appropriate CC).
Thanks!

-Nish

Description: Use msleep() instead of schedule_timeout() to guarantee the
task delays as expected. Change the values of the constants being used
appropriately. I left the arithmetic there as it was before, even though
it could be easily simplified away.

Signed-off-by: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/qla2xxx/qla_os.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/qla2xxx/qla_os.c~ssleep-drivers_scsi_qla2xxx_qla_os drivers/scsi/qla2xxx/qla_os.c
--- kj/drivers/scsi/qla2xxx/qla_os.c~ssleep-drivers_scsi_qla2xxx_qla_os	2005-01-10 18:00:26.000000000 +0100
+++ kj-domen/drivers/scsi/qla2xxx/qla_os.c	2005-01-10 18:00:26.000000000 +0100
@@ -885,8 +885,8 @@ qla2x00_queuecommand(struct scsi_cmnd *c
 static int
 qla2x00_eh_wait_on_command(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
 {
-#define ABORT_POLLING_PERIOD	HZ
-#define ABORT_WAIT_TIME		((10 * HZ) / (ABORT_POLLING_PERIOD))
+#define ABORT_POLLING_PERIOD	1000
+#define ABORT_WAIT_TIME		((10 * 1000) / ABORT_POLLING_PERIOD)
 
 	int		found = 0;
 	int		done = 0;
@@ -923,8 +923,7 @@ qla2x00_eh_wait_on_command(scsi_qla_host
 
 		spin_unlock_irq(ha->host->host_lock);
 
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(ABORT_POLLING_PERIOD);
+		msleep(ABORT_POLLING_PERIOD);
 
 		spin_lock_irq(ha->host->host_lock);
