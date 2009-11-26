From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] enclosure: fix oops while iterating enclosure_status
 array
Date: Thu, 26 Nov 2009 09:50:20 -0600
Message-ID: <1259250620.7584.28.camel@mulgrave.site>
References: <4B05E183.4010301@jeffreymahoney.com>
	 <1258753394.2889.315.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41814 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbZKZPuW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2009 10:50:22 -0500
In-Reply-To: <1258753394.2889.315.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Mahoney <jeffm@jeffreymahoney.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi@vger.kernel.org

On Fri, 2009-11-20 at 16:43 -0500, James Bottomley wrote:
> *really* (promise) adding linux-scsi to the cc list this time.
> 
> Patch looks fine to me, though, thanks.
> 
> James
> 
> On Thu, 2009-11-19 at 19:23 -0500, Jeff Mahoney wrote:
> > enclosure_status is expected to be a NULL terminated array of strings
> >  but isn't actually NULL terminated. When writing an invalid value to
> >  /sys/class/enclosure/.../.../status, it goes off the end of the array
> >  and Oopses.
> > 
> >  This patch uses the array size instead.
> > 
> > Reported-by: Artur Wojcik <artur.wojcik@intel.com>
> > Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> > ---
> >  drivers/misc/enclosure.c |    5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > --- a/drivers/misc/enclosure.c
> > +++ b/drivers/misc/enclosure.c
> > @@ -412,8 +412,9 @@ static ssize_t set_component_status(stru
> >  	struct enclosure_component *ecomp = to_enclosure_component(cdev);
> >  	int i;
> >  
> > -	for (i = 0; enclosure_status[i]; i++) {
> > -		if (strncmp(buf, enclosure_status[i],
> > +	for (i = 0; i < ARRAY_SIZE(enclosure_status); i++) {
> > +		if (enclosure_status[i] &&
> > +		    strncmp(buf, enclosure_status[i],
> >  			    strlen(enclosure_status[i])) == 0 &&
> >  		    (buf[strlen(enclosure_status[i])] == '\n' ||
> >  		     buf[strlen(enclosure_status[i])] == '\0'))

Actually, it's not fine ... it's giving this error:

drivers/misc/enclosure.c: In function 'set_component_status':
drivers/misc/enclosure.c:453: warning: array subscript is above array bounds

It's another place where there's an assumption that the array is zero
terminated.

I think the actual best fix is simply to make the assumption true, like
the patch below.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index e9eae4a..1eac626 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -391,6 +391,7 @@ static const char *const enclosure_status [] = {
 	[ENCLOSURE_STATUS_NOT_INSTALLED] = "not installed",
 	[ENCLOSURE_STATUS_UNKNOWN] = "unknown",
 	[ENCLOSURE_STATUS_UNAVAILABLE] = "unavailable",
+	[ENCLOSURE_STATUS_MAX] = NULL,
 };
 
 static const char *const enclosure_type [] = {
diff --git a/include/linux/enclosure.h b/include/linux/enclosure.h
index 90d1c21..9a33c5f 100644
--- a/include/linux/enclosure.h
+++ b/include/linux/enclosure.h
@@ -42,6 +42,8 @@ enum enclosure_status {
 	ENCLOSURE_STATUS_NOT_INSTALLED,
 	ENCLOSURE_STATUS_UNKNOWN,
 	ENCLOSURE_STATUS_UNAVAILABLE,
+	/* last element for counting purposes */
+	ENCLOSURE_STATUS_MAX
 };
 
 /* SFF-8485 activity light settings */


