From: Matthew Wilcox <matthew@wil.cx>
Subject: Add Brownie 1200U3P to blacklist
Date: Thu, 5 Jul 2007 08:57:50 -0600
Message-ID: <20070705145750.GA20828@parisc-linux.org>
References: <468D0281.2080300@unicaen.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:52749 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756948AbXGEO5w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 10:57:52 -0400
Content-Disposition: inline
In-Reply-To: <468D0281.2080300@unicaen.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrien Corbi?re <adrien.corbiere@unicaen.fr>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2007 at 04:38:57PM +0200, Adrien Corbi?re wrote:
> You've helped me last year with a bogus scsi device
> (http://www.spinics.net/lists/linux-scsi/msg08048.html). I'm going to
> work on another campus of my university, and i get the same problem with
> a different model. I've added the line:
> 
>         {"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
> 
> in the file linux-2.6.18/drivers/scsi/scsi_devinfo.c, and the device is
> now working well too. Could you add this in the next kernel relaese
> please ? Thanks in advance.

Hi Adrien,

Seems like a reasonable request.  James, could you apply this patch?

---

The Brownie 1200U3P has the same problem with REPORT LUNS as the
1600U3P.  Add it to the blacklist.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 18dd5cc..19c44f0 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -128,6 +128,7 @@ static struct {
 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36},
+	{"BROWNIE", "1200U3P", NULL, BLIST_NOREPORTLUN},
 	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN},
 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
 	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_36},

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
