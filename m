From: Willem Riede <wrlk@riede.org>
Subject: Re: [PATCH] fix jiffies compare warning in osst
Date: Tue, 11 Mar 2003 18:52:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311235229.GG7082@linnie.riede.org>
References: <20030311201301.B986@lst.de>
Reply-To: wrlk@riede.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030311201301.B986@lst.de>; from hch@lst.de on Tue, Mar 11, 2003 at 14:13:01 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On 2003.03.11 14:13 Christoph Hellwig wrote:
> 
> --- 1.39/drivers/scsi/osst.c	Sun Feb  2 17:50:23 2003
> +++ edited/drivers/scsi/osst.c	Mon Mar 10 14:35:46 2003
> @@ -777,7 +777,7 @@
>  #define OSST_POLL_PER_SEC 10
>  static int osst_wait_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int curr, int minlast, int to)
>  {
> -	long	startwait     = jiffies;
> +	unsigned long startwait = jiffies;
>  	char  * name          = tape_name(STp);
>  #if DEBUG
>  	char	notyetprinted = 1;
> @@ -1288,7 +1288,7 @@
>  	int             logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
>  						- (nframes + pending - 1) * blks_per_frame;
>  	char          * name             = tape_name(STp);
> -	long		startwait        = jiffies;
> +	unsigned long	startwait        = jiffies;
>  #if DEBUG
>  	int		dbg              = debugging;
>  #endif
> @@ -1477,7 +1477,7 @@
>  	int		expected  = 0;
>  	int		attempts  = 1000 / skip;
>  	int		flag      = 1;
> -	long		startwait = jiffies;
> +	unsigned long	startwait = jiffies;
>  #if DEBUG
>  	int		dbg       = debugging;
>  #endif
> -

There are five functions that use jiffies. You fixed three of them.
If this change is done (and that's fine with me) it should be done
with this patch:

--- /home/wriede/develop/Driver25/osst.c	Thu Jan 30 18:34:38 2003
+++ osst.c	Tue Mar 11 18:46:48 2003
@@ -607,7 +607,7 @@
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	Scsi_Request  * SRpnt;
-	long		startwait = jiffies;
+	unsigned long	startwait = jiffies;
 #if DEBUG
 	int		dbg  = debugging;
 	char          * name = tape_name(STp);
@@ -674,7 +674,7 @@
 {
 	unsigned char	cmd[MAX_COMMAND_SIZE];
 	Scsi_Request  * SRpnt;
-	long		startwait = jiffies;
+	unsigned long	startwait = jiffies;
 #if DEBUG
 	int		dbg = debugging;
 	char          * name = tape_name(STp);
@@ -778,8 +778,8 @@
 #define OSST_POLL_PER_SEC 10
 static int osst_wait_frame(OS_Scsi_Tape * STp, Scsi_Request ** aSRpnt, int curr, int minlast, int to)
 {
-	long	startwait     = jiffies;
-	char  * name          = tape_name(STp);
+	unsigned long	startwait     = jiffies;
+	char	      * name          = tape_name(STp);
 #if DEBUG
 	char	notyetprinted = 1;
 #endif
@@ -1289,7 +1289,7 @@
 	int             logical_blk_num  = ntohl(STp->buffer->aux->logical_blk_num) 
 						- (nframes + pending - 1) * blks_per_frame;
 	char          * name             = tape_name(STp);
-	long		startwait        = jiffies;
+	unsigned long	startwait        = jiffies;
 #if DEBUG
 	int		dbg              = debugging;
 #endif
@@ -1478,7 +1478,7 @@
 	int		expected  = 0;
 	int		attempts  = 1000 / skip;
 	int		flag      = 1;
-	long		startwait = jiffies;
+	unsigned long	startwait = jiffies;
 #if DEBUG
 	int		dbg       = debugging;
 #endif

Thanks, Willem Riede.
