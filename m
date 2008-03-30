From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch 11/17] scsi: ch.c fix shadowed variable warnings
Date: Sun, 30 Mar 2008 12:21:55 -0500
Message-ID: <1206897715.4224.55.camel@localhost.localdomain>
References: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40244 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYC3RWE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 30 Mar 2008 13:22:04 -0400
In-Reply-To: <200803282148.m2SLmdA5012246@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Fri, 2008-03-28 at 14:48 -0700, akpm@linux-foundation.org wrote:
> From: Harvey Harrison <harvey.harrison@gmail.com>
> 
> err shadows the array of errors in this driver, switch to ch_err
> drivers/scsi/ch.c:271:6: warning: symbol 'err' shadows an earlier one
> drivers/scsi/ch.c:116:3: originally declared here
> 
> cmd shadows the argument to this function, switch to ch_cmd
> drivers/scsi/ch.c:724:11: warning: symbol 'cmd' shadows an earlier one
> drivers/scsi/ch.c:596:20: originally declared here
> 
> Small code cleanup as well in if() statement.
> 
> [akpm@linux-foundation.org: coding-style fixes]
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/ch.c |   29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> diff -puN drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings drivers/scsi/ch.c
> --- a/drivers/scsi/ch.c~scsi-chc-fix-shadowed-variable-warnings
> +++ a/drivers/scsi/ch.c
> @@ -268,16 +268,16 @@ ch_read_element_status(scsi_changer *ch,
>  static int
>  ch_init_elem(scsi_changer *ch)
>  {
> -	int err;
> +	int ch_err;

This isn't really the correct fix, is it?  The driver stupidity is
having a global (although static) variable called err which invites
problems like this.  How about this fix?

James

---

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 7aad154..b1be2d8 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -113,7 +113,7 @@ static const struct {
 	unsigned char  asc;
 	unsigned char  ascq;
 	int	       errno;
-} err[] = {
+} ch_err_desc[] = {
 /* Just filled in what looks right. Hav'nt checked any standard paper for
    these errno assignments, so they may be wrong... */
 	{
@@ -155,11 +155,11 @@ static int ch_find_errno(struct scsi_sense_hdr *sshdr)
 	/* Check to see if additional sense information is available */
 	if (scsi_sense_valid(sshdr) &&
 	    sshdr->asc != 0) {
-		for (i = 0; err[i].errno != 0; i++) {
-			if (err[i].sense == sshdr->sense_key &&
-			    err[i].asc   == sshdr->asc &&
-			    err[i].ascq  == sshdr->ascq) {
-				errno = -err[i].errno;
+		for (i = 0; ch_err_desc[i].errno != 0; i++) {
+			if (ch_err_desc[i].sense == sshdr->sense_key &&
+			    ch_err_desc[i].asc   == sshdr->asc &&
+			    ch_err_desc[i].ascq  == sshdr->ascq) {
+				errno = -ch_err_desc[i].errno;
 				break;
 			}
 		}


