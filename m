From: Jesper Juhl <jj@chaosbits.net>
Subject: [PATCH] aacraid: Remove mem leak in aac_send_raw_srb().
Date: Thu, 6 Jan 2011 21:26:45 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1101062120090.13988@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


We leak in drivers/scsi/aacraid/commctrl.c::aac_send_raw_srb().

We allocate memory:
	...
			struct user_sgmap* usg;
			usg = kmalloc(actual_fibsize - sizeof(struct aac_srb)
			  + sizeof(struct sgmap), GFP_KERNEL);
and then neglect to free it:
	...
			for (i = 0; i < usg->count; i++) {
				u64 addr;
				void* p;
				if (usg->sg[i].count >
				    ((dev->adapter_info.options &
				     AAC_OPT_NEW_COMM) ?
				      (dev->scsi_host_ptr->max_sectors << 9) :
				      65536)) {
					rcode = -EINVAL;
					goto cleanup;
	... this 'goto' makes 'usg' go out of scope and leak the memory we 
	    allocated.
	    Other exits properly kfree(usg), it's just here it is 
	    neglected.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 commctrl.c |    1 +
 1 file changed, 1 insertion(+)

  Compile tested only, I don't have a way to test this properly, but I 
  think it's fairly obvious.

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 645ddd9..33370fb 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -649,6 +649,7 @@ static int aac_send_raw_srb(struct aac_dev* dev, void __user * arg)
 				     AAC_OPT_NEW_COMM) ?
 				      (dev->scsi_host_ptr->max_sectors << 9) :
 				      65536)) {
+					kfree(usg);
 					rcode = -EINVAL;
 					goto cleanup;
 				}



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.
