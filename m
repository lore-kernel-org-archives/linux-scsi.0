From: "Chris Pitzel" <chris@pitzel.dyndns.org>
Subject: Re: [PATCH] scsi/sym53c8xx_2: Fix NULL pointer dereference in slave_destroy
Date: Mon, 19 Dec 2011 16:57:29 -0600
Message-ID: <002701ccbea1$96e369c0$c4aa3d40$@dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail130c7.megamailservers.com ([69.49.98.230]:44040 "EHLO
	mail130c7.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751939Ab1LSW5e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 17:57:34 -0500
Received: from HOME (216-197-207-174.msjw.hsdb.sasknet.sk.ca [216.197.207.174])
	(authenticated bits=0)
	by mail130c7.megamailservers.com (8.13.6/8.13.1) with ESMTP id pBJMvVQp005933
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Mon, 19 Dec 2011 17:57:33 -0500
Content-Language: en-us
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

>On 12/04/2011 02:23 AM, psomas@gentoo.org wrote:

>> From: Stratos Psomadakis <psomas@gentoo.org>

>> 

>> sym53c8xx_slave_destroy unconditionally assumes that
sym53c8xx_slave_alloc has

>> succesesfully allocated a sym_lcb. This can lead to a NULL pointer
dereference

>> (exposed by commit 4e6c82b).

>> 

>> Signed-off-by: Stratos Psomadakis <psomas@gentoo.org>

>> Cc: stable@vger.kernel.org

>> ---

>> 

>>  drivers/scsi/sym53c8xx_2/sym_glue.c |    4 ++++

>>  1 files changed, 4 insertions(+), 0 deletions(-)

>> 

>> diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c
b/drivers/scsi/sym53c8xx_2/sym_glue.c

>> index b4543f5..76432f8 100644

>> --- a/drivers/scsi/sym53c8xx_2/sym_glue.c

>> +++ b/drivers/scsi/sym53c8xx_2/sym_glue.c

>> @@ -839,6 +839,10 @@ static void sym53c8xx_slave_destroy(struct
scsi_device *sdev)

>>      struct sym_lcb *lp = sym_lp(tp, sdev->lun);

>>      unsigned long flags;

>>  

>> +    /* if slave_alloc returned before allocating a sym_lcb, return */

>> +    if (!lp)

>> +           return;

>> +

>>      spin_lock_irqsave(np->s.host->host_lock, flags);

>>  

>>      if (lp->busy_itlq || lp->busy_itl) {

>Any comments/ack/nack on the patch?

 

Applied it to 3.1.3, 3.1.4, 3.1.5, and 3.2-rc6.  Previously loading
sym53c8xx (with my sym53c875 card) would cause a kernel panic during bootup
(worked fine on 3.1.0, 3.1.1, and the 2.6.x kernels, was sort of broken in
3.1.2, and panic'ed in 3.1.3-onwards).  Now I can boot just fine!  
 
Thank you very much!  
 
 
Chris

