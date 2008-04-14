From: Mark Salyzyn <Mark_Salyzyn@adaptec.com>
Subject: Re: + aacraid-fix-unchecked-down_interruptible.patch added to -mm tree
Date: Mon, 14 Apr 2008 14:20:16 -0400
Message-ID: <83EFA74B-508C-44CF-835A-E454A342DA11@adaptec.com>
References: <200804102037.m3AKb2g4016314@imap1.linux-foundation.org> <1207860882.4915.35.camel@localhost.localdomain> <18656C81-9F7B-47D8-B02C-9E7667349500@adaptec.com> <20080410142929.3be73136.akpm@linux-foundation.org> <69D7FE1A-36E3-4BA4-8B54-728B50E7E6B7@adaptec.com> <1207864657.4915.40.camel@localhost.localdomain>
Mime-Version: 1.0 (Apple Message framework v919.2)
Content-Type: multipart/mixed; boundary=Apple-Mail-40-109266139
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:41916 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765628AbYDNSUX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Apr 2008 14:20:23 -0400
In-Reply-To: <1207864657.4915.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>


--Apple-Mail-40-109266139
Content-Disposition: attachment;
	filename=aacraid_down_interruptible.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="aacraid_down_interruptible.patch"
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
+		} else if (down_interruptible(&fibptr->event_wait) == 0) {
+			fibptr->done = 2;
+			up(&fibptr->event_wait);
+		}
 		spin_lock_irqsave(&fibptr->event_lock, flags);
-		if (fibptr->done == 0) {
+		if ((fibptr->done == 0) || (fibptr->done == 2)) {
 			fibptr->done = 2; /* Tell interrupt we aborted */
 			spin_unlock_irqrestore(&fibptr->event_lock, flags);
 			return -EINTR;

--Apple-Mail-40-109266139
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit



Discussion below.

This attached patch is against current scsi-misc-2.6.

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
+		} else if (down_interruptible(&fibptr->event_wait) == 0) {
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

On Apr 10, 2008, at 5:57 PM, James Bottomley wrote:

> On Thu, 2008-04-10 at 17:44 -0400, Mark Salyzyn wrote:
>>      if (down_interruptible(&fibptr->event_wait) == 0) {
>>              fibptr->done = 2;
>>                up(&fibptr->event_wait);
>>      }
>>
>> would make me feel much more comfortable ... The fib can never be
>> 'freed'. The fib is owned by the adapter until it completes it on  
>> it's
>> own (if ever, the assumption here is that the adapter is misbehaving
>> on this 'one' fib). Setting the value of 2 allows us to report back  
>> to
>> the ioctl caller a failed operation without actually closing out the
>> fib.
>>
>> I am having a problem with my bandwidth right now to do a unit test  
>> to
>> see if this gets the job done.
>
> That's OK ... send the patch when you're ready; I'll make sure it gets
> upstream.  We'll do the standard put it into scsi-misc and backport if
> it seems stable, so we'll have time to shake out any problems.
>
> James

--Apple-Mail-40-109266139--
