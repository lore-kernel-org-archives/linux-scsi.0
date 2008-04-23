From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Fix down_interruptible() to check the return value take 2 (was: aacraid broken in git)
Date: Wed, 23 Apr 2008 08:16:06 -0400
Message-ID: <BCC76E6D-9A0F-4DC1-822A-50EE44A52890@adaptec.com>
References: <86802c440804181855t615a5616g62d083695ca8ea08@mail.gmail.com> <3AC1542A-0338-4796-9218-502C4AAD64D2@adaptec.com> <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-329-865016404
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:59870 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbYDWMQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Apr 2008 08:16:09 -0400
In-Reply-To: <86802c440804211742g1fe25aadjeaffce49722e7c46@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-Scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Yinghai Lu <yhlu.kernel@gmail.com>


--Apple-Mail-329-865016404
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 21, 2008, at 8:42 PM, Yinghai Lu wrote:

> bisected to:
>
> yhlu@mpk12-office-77-185:~/xx/xx/kernel/linux-2.6> git-bisect good
> e6990c6448ca9359b6d4ad027c0a6efbf4379e64 is first bad commit
> commit e6990c6448ca9359b6d4ad027c0a6efbf4379e64
> Author: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
> Date:   Mon Apr 14 14:20:16 2008 -0400
>
>    [SCSI] aacraid: Fix down_interruptible() to check the return value
>
>    Instead of ignoring the return value in aac_fib_send() return 2 to
>    indicate to the layers above that fib transmission was aborted  
> due to
>    timeout.
>
>    Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>
>    Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com 
> >
>
> :040000 040000 2f23bf33d76d6f37c558251003f88537c6e639fe
> 63d59091ca7ac527b5106540eea06d7b6649862d M      drivers


The return value for down_interruptible was incorrectly checked!  
updated patch enclosed.

This attached patch is against current scsi-misc-2.6 (minus original  
down_interruptible patch).

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's  
handling of patch attachments (inline gets damaged, please use  
attachment).

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

  drivers/scsi/aacraid/commsup.c |    8 +++++---
  1 file changed, 5 insertions(+), 3 deletions(-)

diff -ru a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/ 
commsup.c
--- a/drivers/scsi/aacraid/commsup.c	2008-04-14 14:08:00.737201138 -0400
+++ b/drivers/scsi/aacraid/commsup.c	2008-04-14 14:09:34.019252960 -0400
@@ -515,10 +515,12 @@
  				}
  				udelay(5);
  			}
-		} else
-			(void)down_interruptible(&fibptr->event_wait);
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done = 2;
+			up(&fibptr->event_wait);
+		}
  		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
  			fibptr->done = 2; /* Tell interrupt we aborted */
  			spin_unlock_irqrestore(&fibptr->event_lock, flags);
  			return -EINTR;

Sincerely - Mark Salyzyn


--Apple-Mail-329-865016404
Content-Disposition: attachment;
	filename=aacraid_down_interruptible2.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_down_interruptible2.patch"
Content-Transfer-Encoding: 7bit

diff -ru a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
--- a/drivers/scsi/aacraid/commsup.c	2008-04-14 14:08:00.737201138 -0400
+++ b/drivers/scsi/aacraid/commsup.c	2008-04-14 14:09:34.019252960 -0400
@@ -515,10 +515,12 @@
 				}
 				udelay(5);
 			}
-		} else
-			(void)down_interruptible(&fibptr->event_wait);
+		} else if (down_interruptible(&fibptr->event_wait)) {
+			fibptr->done = 2;
+			up(&fibptr->event_wait);
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -EINTR;

--Apple-Mail-329-865016404
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit





--Apple-Mail-329-865016404--
