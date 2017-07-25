From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/2] scsi: aacraid: Off by one NUL terminator
Date: Tue, 25 Jul 2017 22:51:10 +0300
Message-ID: <20170725195110.uwrzzkzvrbfqv7ld@mwanda>
References: <20170725194955.dd4g6msevoesty4t@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170725194955.dd4g6msevoesty4t@mwanda>
Sender: kernel-janitors-owner@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We're putting a NUL terminator one character beyond the end of the
struct and that's obviously wrong.  On the other hand, I'm not positive
this is the correct fix.  This change was added deliberately and was
mentioned in the changlog of commit b836439faf04 ("aacraid: 4KB sector
support").  The relevant section is "Also fix up a name truncation
problem".  Can someone review this code and figure out the right thing
to do?

Fixes: b836439faf04 ("aacraid: 4KB sector support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 4591113c49de..22c7461f65c9 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -549,7 +549,7 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] = '\0';
+		sp[sizeof(((struct aac_get_name_resp *)NULL)->data) - 1] = '\0';
 		while (*sp == ' ')
 			++sp;
 		if (*sp) {
