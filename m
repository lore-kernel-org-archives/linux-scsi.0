From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [patch 02/13] git-scsi-misc gdth fix
Date: Tue, 12 Feb 2008 17:27:33 +0200
Message-ID: <47B1BAE5.1030503@panasas.com>
References: <200802050752.m157qrLV010691@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:50623 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759172AbYBLPaQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Feb 2008 10:30:16 -0500
In-Reply-To: <200802050752.m157qrLV010691@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, davemilter@gmail.com

On Tue, Feb 05 2008 at 9:53 +0200, akpm@linux-foundation.org wrote:
> From: James Bottomley <James.Bottomley@SteelEye.com>
> 
> On Sun, 2007-10-14 at 12:21 -0700, Andrew Morton wrote:
>> On Sun, 14 Oct 2007 22:45:47 +0400 "Dave Milter" <davemilter@gmail.com> wrote:
>>
>>> I build linux-2.6.23-mm1 and try to boot it using qemu,
>>> and it crashed with trace like this:
>>> do_page_fault
>>> error_code
>>> lock_acquire
>>> _spin_lock_irqsave
>>> gdth_timeout
>>> run_timer_softirq
>>> __do_softirq
>>> do_softirq
>>>
>>> I have screenshot, but have no idea, is it legal to include it, if I
>>> sent copy to lkml.
>>> config of kernel in attachment,
>>> I apply all three patches from hot-fixes.
>>>
>> The screenshot is here:  http://userweb.kernel.org/~akpm/crash.png
>>
>> It would appear that gdth_timeout() is passing a bad pointer into
>> spin_lock_irqsave().
> 
> There's a bug in the gdth rework in that the instance can be deleted
> from the list before the actual timer is stopped.  This can be worked
> around I think by the following patch; although we really should be
> stopping the timer from firing when the list goes empty.
> 
> 
> James said:
> 
> This is almost certainly the wrong fix for real hardware.  Although it
> kills the timer when the list goes empty, nothing will ever restart it
> when the list fills again.
> 
> Boaz, since you touched all of this, you get to fix it.  The correct fix
> will be to control the timer along with the actual list instead of at
> entry/exit time.  If you're not going to add this empty check to the
> timer routine, make sure you use del_timer_sync() before removing the
> last element from the list.
> 
> 
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/gdth.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff -puN drivers/scsi/gdth.c~git-scsi-misc-gdth-fix drivers/scsi/gdth.c
> --- a/drivers/scsi/gdth.c~git-scsi-misc-gdth-fix
> +++ a/drivers/scsi/gdth.c
> @@ -3791,6 +3791,9 @@ static void gdth_timeout(ulong data)
>      gdth_ha_str *ha;
>      ulong flags;
>  
> +    if (list_empty(&gdth_instances))
> +	return;
> +
>      ha = list_first_entry(&gdth_instances, gdth_ha_str, list);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
> _
Hello dear Andrew

Do you perhaps remember who as reported this problem, and if he can
test patches?

Boaz

---
gdth: Try to fix the Timer at exit problem

Remove_sync the timer before we delete the cards.

Testing-patches: Boaz Harrosh <bharrosh@panasas.com>

---
git-diff --stat -p v2.6.24
 drivers/scsi/gdth.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b253b8c..57fa756 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -5102,6 +5105,9 @@ static int __init gdth_pci_probe_one(gdth_pci_str *pcistr, int ctr)
 	if (error)
 		goto out_free_coal_stat;
 	list_add_tail(&ha->list, &gdth_instances);
+
+	scsi_scan_host(shp);
+
 	return 0;
 
  out_free_coal_stat:
@@ -5137,8 +5143,6 @@ static void gdth_remove_one(gdth_ha_str *ha)
 		ha->sdev = NULL;
 	}
 
-	gdth_flush(ha);
-
 	if (shp->irq)
 		free_irq(shp->irq,ha);
 
@@ -5236,14 +5240,15 @@ static void __exit gdth_exit(void)
 {
 	gdth_ha_str *ha;
 
-	list_for_each_entry(ha, &gdth_instances, list)
-		gdth_remove_one(ha);
+	unregister_chrdev(major,"gdth");
+	unregister_reboot_notifier(&gdth_notifier);
 
 #ifdef GDTH_STATISTICS
-	del_timer(&gdth_timer);
+	del_timer_sync(&gdth_timer);
 #endif
-	unregister_chrdev(major,"gdth");
-	unregister_reboot_notifier(&gdth_notifier);
+
+	list_for_each_entry(ha, &gdth_instances, list)
+		gdth_remove_one(ha);
 }
 
 module_init(gdth_init);





