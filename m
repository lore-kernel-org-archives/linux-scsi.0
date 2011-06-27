From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][Resend] SCSI, target, loopback: Fix memory leak in
 tcm_loop_make_scsi_hba()
Date: Tue, 28 Jun 2011 00:30:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1106280029150.30245@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1106272351520.30245@swampdragon.chaosbits.net> <20110627222526.GA14591@shale.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110627222526.GA14591@shale.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Carpenter <error27@gmail.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 28 Jun 2011, Dan Carpenter wrote:

> On Mon, Jun 27, 2011 at 11:54:48PM +0200, Jesper Juhl wrote:
> > --- a/drivers/target/loopback/tcm_loop.c
> > +++ b/drivers/target/loopback/tcm_loop.c
> > @@ -1321,7 +1321,8 @@ struct se_wwn *tcm_loop_make_scsi_hba(
> >  
> >  	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
> >  			" %s\n", name);
> > -	return ERR_PTR(-EINVAL);
> > +	ret = -EINVAL;
> > +	goto out;
> 
> You've added a weird bunny hop goto here.  It might be better to
> change the if (ptr) check to if (!ptr) so we could fall through
> here in the normal case.
> 
> >  
> >  check_len:
> >  	if (strlen(name) >= TL_WWN_ADDR_LEN) {
> 
> If this check fails then it calls kfree() and returns.  It would be
> cleaner to "goto out" here as well.
> 

You mean like this - right?

---

There is a memory leak in tcm_loop_make_scsi_hba().

If all the strstr() calls return NULL and we end up at
 return ERR_PTR(-EINVAL);
then we'll be leaking the memory previously allocated to tl_hba as
that variable goes out of scope.

This patch should fix the leak.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/target/loopback/tcm_loop.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 70c2e7f..e7a32e9 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -1314,22 +1314,21 @@ struct se_wwn *tcm_loop_make_scsi_hba(
 		goto check_len;
 	}
 	ptr = strstr(name, "iqn.");
-	if (ptr) {
-		tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
-		goto check_len;
+	if (!ptr) {
+		printk(KERN_ERR "Unable to locate prefix for emulated Target "
+				"Port: %s\n", name);
+		ret = -EINVAL;
+		goto out;
 	}
-
-	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
-			" %s\n", name);
-	return ERR_PTR(-EINVAL);
+	tl_hba->tl_proto_id = SCSI_PROTOCOL_ISCSI;
 
 check_len:
 	if (strlen(name) >= TL_WWN_ADDR_LEN) {
 		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
 			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
 			TL_WWN_ADDR_LEN);
-		kfree(tl_hba);
-		return ERR_PTR(-EINVAL);
+		ret = -EINVAL;
+		goto out;
 	}
 	snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off]);
 
-- 
1.7.5.2


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
