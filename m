From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3] cmdfilter: clean up sysfs interface
Date: Sat, 9 Aug 2008 06:04:24 +0900
Message-ID: <20080809060435V.fujita.tomonori@lab.ntt.co.jp>
References: <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
	<6cf6b73e0808080505v5989bd3bm7beedea2b443bc55@mail.gmail.com>
	<6cf6b73e0808081146n42a2b59bm1a55cc5f0cef41bb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:34640 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464AbYHHVFE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Aug 2008 17:05:04 -0400
In-Reply-To: <6cf6b73e0808081146n42a2b59bm1a55cc5f0cef41bb@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adel.gadllah@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

On Fri, 8 Aug 2008 20:46:55 +0200
"Adel Gadllah" <adel.gadllah@gmail.com> wrote:

> v3 clean up parsing.
> 
> -----------------------------------
> 
> This patch changes the interface of the cmd filter to use a +/- notation like:
> echo -- +0x02 +0x03 -0x08
> If neither + or - is given it defaults to + (allow command).
> 
> Note: The interface was added in 2.6.17-rc1 and is unused
> and undocumented so far so it's safe to change it.
> 
> Cc: matthew@wil.cx
> Cc: fujita.tomonori@lab.ntt.co.jp,
> Cc: jens.axboe@oracle.com
> Cc: James.Bottomley@hansenpartnership.com
> Cc: dan.j.williams@intel.com
> Cc: pjones@redhat.com
> Cc: viro@zeniv.linux.org.uk
> Cc: dougg@torque.net
> Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>
> 
>  block/cmd-filter.c |   53 ++++++++++++++++++++++++++++++---------------------
>  1 files changed, 31 insertions(+), 22 deletions(-)

Hmm, the patch seems to be corrupted again.


> diff --git a/block/cmd-filter.c b/block/cmd-filter.c
> index eec4404..f838d04 100644
> --- a/block/cmd-filter.c
> +++ b/block/cmd-filter.c

I think that you can remove "linux/parser.h".


> @@ -84,8 +84,8 @@ static ssize_t rcf_cmds_show(struct
> blk_scsi_cmd_filter *filter, char *page,
> 
>  	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
>  		if (test_bit(i, okbits)) {
> -			sprintf(npage, "%02x", i);
> -			npage += 2;
> +			sprintf(npage, "0x%02x", i);
> +			npage += 4;
>  			if (i < BLK_SCSI_MAX_CMDS - 1)
>  				sprintf(npage++, " ");
>  		}
> @@ -111,32 +111,41 @@ static ssize_t rcf_writecmds_show(struct
> blk_scsi_cmd_filter *filter,
>  static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
>  			      const char *page, size_t count, int rw)
>  {
> -	ssize_t ret = 0;
>  	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
> -	int cmd, status, len;
> -	substring_t ss;
> -
> -	memset(&okbits, 0, sizeof(okbits));
> -
> -	for (len = strlen(page); len > 0; len -= 3) {
> -		if (len < 2)
> -			break;
> -		ss.from = (char *) page + ret;
> -		ss.to = (char *) page + ret + 2;
> -		ret += 3;
> -		status = match_hex(&ss, &cmd);
> +	int cmd, set;
> +	char *p, *status;
> +
> +	if (rw == READ) {
> +		memcpy(&okbits, filter->read_ok, sizeof(okbits));
> +		target_okbits = filter->read_ok;
> +	} else {
> +		memcpy(&okbits, filter->write_ok, sizeof(okbits));
> +		target_okbits = filter->write_ok;
> +	}

Do we need this? We can modify filter->write_ok or filter->read_ok
directly?


> +	while ((p = strsep((char **)&page, " ")) != NULL) {
> +		set = 1;
> +
> +		if (p[0] == '-') {
> +			set = 0;
> +			p++;
> +		}

As I wrote, I prefer to let simple_strtol to handle '-' though the
current code is also fine by me.


> +		if (p[0] == '+')
> +			p++;
> +
> +		cmd = simple_strtol(p, &status, 16);
> +
>  		/* either of these cases means invalid input, so do nothing. */
> -		if (status || cmd >= BLK_SCSI_MAX_CMDS)
> +		if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
>  			return -EINVAL;
> 
> -		__set_bit(cmd, okbits);
> +		if (set)
> +			__set_bit(cmd, okbits);
> +		else
> +			__clear_bit(cmd, okbits);
>  	}
> 
> -	if (rw == READ)
> -		target_okbits = filter->read_ok;
> -	else
> -		target_okbits = filter->write_ok;
> -
>  	memmove(target_okbits, okbits, sizeof(okbits));
>  	return count;


diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index 0e3a123..39c37a8 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -20,7 +20,6 @@
 #include <linux/list.h>
 #include <linux/genhd.h>
 #include <linux/spinlock.h>
-#include <linux/parser.h>
 #include <linux/capability.h>
 #include <linux/bitops.h>
 
@@ -65,8 +64,8 @@ static ssize_t rcf_cmds_show(struct blk_cmd_filter *filter, char *page,
 
 	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
 		if (test_bit(i, okbits)) {
-			sprintf(npage, "%02x", i);
-			npage += 2;
+			sprintf(npage, "0x%02x", i);
+			npage += 4;
 			if (i < BLK_SCSI_MAX_CMDS - 1)
 				sprintf(npage++, " ");
 		}
@@ -92,33 +91,37 @@ static ssize_t rcf_writecmds_show(struct blk_cmd_filter *filter,
 static ssize_t rcf_cmds_store(struct blk_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
-	ssize_t ret = 0;
-	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, status, len;
-	substring_t ss;
-
-	memset(&okbits, 0, sizeof(okbits));
-
-	for (len = strlen(page); len > 0; len -= 3) {
-		if (len < 2)
-			break;
-		ss.from = (char *) page + ret;
-		ss.to = (char *) page + ret + 2;
-		ret += 3;
-		status = match_hex(&ss, &cmd);
-		/* either of these cases means invalid input, so do nothing. */
-		if (status || cmd >= BLK_SCSI_MAX_CMDS)
-			return -EINVAL;
-
-		__set_bit(cmd, okbits);
-	}
+	unsigned long *target_okbits;
+	int cmd, set;
+	char *p, *status;
 
 	if (rw == READ)
 		target_okbits = filter->read_ok;
 	else
 		target_okbits = filter->write_ok;
 
-	memmove(target_okbits, okbits, sizeof(okbits));
+	while ((p = strsep((char **)&page, " ")) != NULL) {
+		set = 1;
+
+		if (p[0] == '+')
+			p++;
+
+		cmd = simple_strtol(p, &status, 16);
+		if (cmd < 0) {
+			cmd = -cmd;
+			set = 0;
+		}
+
+		/* either of these cases means invalid input, so do nothing. */
+		if (status == p || cmd >= BLK_SCSI_MAX_CMDS)
+			return -EINVAL;
+
+		if (set)
+			__set_bit(cmd, target_okbits);
+		else
+			__clear_bit(cmd, target_okbits);
+	}
+
 	return count;
 }
 
