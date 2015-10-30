From: James Bottomley <James.Bottomley@Hansenpartnership.com>
Subject: Re: [RESEND PATCH] mpt2sas: Remove usage of 'struct timeval'
Date: Fri, 30 Oct 2015 18:11:51 +0900
Message-ID: <cc10647b-d628-415b-bf77-4b5344799cbc@email.android.com>
References: <20151030090515.GA3542@tina-laptop>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54028 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758333AbbJ3JMK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Oct 2015 05:12:10 -0400
In-Reply-To: <20151030090515.GA3542@tina-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tina Ruchandani <ruchandani.tina@gmail.com>, linux-scsi@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, Abhijit Mahajan <abhijit.mahajan@avagotech.com>, Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, y2038@lists.linaro.org



On October 30, 2015 6:05:15 PM GMT+09:00, Tina Ruchandani <ruchandani.tina@gmail.com> wrote:
>'struct timeval' will have its tv_sec value overflow on 32-bit systems
>in year 2038 and beyond. This patch replaces the use of struct timeval
>for computing mpi_request.TimeStamp, and instead uses ktime_t which
>provides
>64-bit seconds value. The timestamp computed remains unaffected
>(milliseconds
>since Unix epoch).
>
>Signed-off-by: Tina Ruchandani <ruchandani.tina@gmail.com>

Can you wait a cycle on this? Martin Petersen is on a mission to wrangle the mpt2/3sas merger in this window, which will conflict with this.

James


> drivers/scsi/mpt2sas/mpt2sas_base.c | 8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
>b/drivers/scsi/mpt2sas/mpt2sas_base.c
>index 58e4521..6d80477 100644
>--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
>+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
>@@ -57,6 +57,7 @@
> #include <linux/sort.h>
> #include <linux/io.h>
> #include <linux/time.h>
>+#include <linux/ktime.h>
> #include <linux/kthread.h>
> #include <linux/aer.h>
> 
>@@ -3616,7 +3617,7 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc,
>int sleep_flag)
> 	Mpi2IOCInitRequest_t mpi_request;
> 	Mpi2IOCInitReply_t mpi_reply;
> 	int i, r = 0;
>-	struct timeval current_time;
>+	ktime_t current_time;
> 	u16 ioc_status;
> 	u32 reply_post_free_array_sz = 0;
> 	Mpi2IOCInitRDPQArrayEntry *reply_post_free_array = NULL;
>@@ -3678,9 +3679,8 @@ _base_send_ioc_init(struct MPT2SAS_ADAPTER *ioc,
>int sleep_flag)
> 	/* This time stamp specifies number of milliseconds
> 	 * since epoch ~ midnight January 1, 1970.
> 	 */
>-	do_gettimeofday(&current_time);
>-	mpi_request.TimeStamp = cpu_to_le64((u64)current_time.tv_sec * 1000 +
>-	    (current_time.tv_usec / 1000));
>+	current_time = ktime_get_real();
>+	mpi_request.TimeStamp = cpu_to_le64(ktime_to_ms(current_time));
> 
> 	if (ioc->logging_level & MPT_DEBUG_INIT) {
> 		__le32 *mfp;

-- 
Sent from my Android device with K-9 Mail. Please excuse my brevity.
