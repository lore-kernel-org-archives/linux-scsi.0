From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi tree build failure
Date: Tue, 30 Dec 2008 10:30:31 -0600
Message-ID: <1230654631.3296.13.camel@localhost.localdomain>
References: <20081231031639.dc19a03c.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20081231031639.dc19a03c.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Jaswinder Singh <jaswinder@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2008-12-31 at 03:16 +1100, Stephen Rothwell wrote:
> Hi James,
> 
> Today's linux-next build (sparc defconfig) failed like this:
> 
> drivers/scsi/qlogicpti.c: In function 'qlogicpti_load_firmware':
> drivers/scsi/qlogicpti.c:480: error: 'struct qlogicpti' has no member named 'sdev'
> 
> An interaction between commit 68175399c8b5ee90960e78c1bb8e3353e71fbf33
> ("[SCSI] qlogicpti: use request_firmware") from the scsi tree and commit
> 5dc2536bb8d8adb5fdfbe76cd6fdcdf9de3f40f8 ("qlogicpti: Convert to pure OF
> driver") which is in Linus' tree.
> 
> The version of the firmware commit that has been in the firmware tree
> since Nov 19 has this conflict corrected.
> 
> I have left it for today (as it is getting way to late).  Please fix it
> up for tomorrow.

I'm slightly annoyed this hasn't been building.  I accepted it into the
SCSI tree because I was under the impression it had been well tested in
linux-next.

I can't actually build this driver, but I think this is the fix, if
someone can verify, I'll fold it into the patch.

Looking at the firmware patches, they all seem to have a kconfig
deficiency in that the modified drivers should now be selecting
FW_LOADER ... it this the case?

James

---

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e17a4d2..a342426 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -477,7 +477,7 @@ static int __devinit qlogicpti_load_firmware(struct qlogicpti *qpti)
 	unsigned long flags;
 	int i, timeout;
 
-	err = request_firmware(&fw, FIRMWARE_1000, &qpti->sdev->ofdev.dev);
+	err = request_firmware(&fw, FIRMWARE_1000, &qpti->op->dev);
 	if (err) {
 		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
 		       FIRMWARE_1000, err);
