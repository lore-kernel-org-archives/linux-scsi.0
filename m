From: Julia Lawall <julia@diku.dk>
Subject: Re: [patch 15/17] drivers/scsi: Use DIV_ROUND_UP
Date: Wed, 24 Sep 2008 21:26:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0809242125450.19914@ask.diku.dk>
References: <200809222156.m8MLupx2032307@imap1.linux-foundation.org>
 <20080923004345.GC27204@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:60783 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYIXT0v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 15:26:51 -0400
In-Reply-To: <20080923004345.GC27204@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Mon, 22 Sep 2008, Matthew Wilcox wrote:

> On Mon, Sep 22, 2008 at 02:56:51PM -0700, akpm@linux-foundation.org wrote:
> >  
> >  		one_clock = esp->ccycle / 1000;
> >  		rounded_up = (period << 2);
> > -		rounded_up = (rounded_up + one_clock - 1) / one_clock;
> > +		rounded_up = DIV_ROUND_UP(rounded_up, one_clock);
> >  		stp = rounded_up;
> >  		if (stp && esp->rev >= FAS236) {
> >  			if (stp >= 50)
> 
> Is this not exactly equivalent to:
> 
> 		one_clock = esp->ccycle / 1000;
> 		stp = DIV_ROUND_UP(period << 2, one_clock);
> 
> (rounded_up is local to this if condition).

Agreed.  An updated patch is below.

julia

--------------------

From: Julia Lawall <julia@diku.dk>

Use the macro DIV_ROUND_UP and eliminate the variable rounded_up, as
suggested by Matthew Wilcox.

Signed-off-by: Julia Lawall <julia@diku.dk>

---

 drivers/scsi/esp_scsi.c       |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 62a4618..a680e18 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -1453,7 +1453,7 @@ static void esp_msgin_sdtr(struct esp *esp, struct esp_target_data *tp)
 		offset = 0;
 
 	if (offset) {
-		int rounded_up, one_clock;
+		int one_clock;
 
 		if (period > esp->max_period) {
 			period = offset = 0;
@@ -1463,9 +1463,7 @@ static void esp_msgin_sdtr(struct esp *esp, struct esp_target_data *tp)
 			goto do_reject;
 
 		one_clock = esp->ccycle / 1000;
-		rounded_up = (period << 2);
-		rounded_up = (rounded_up + one_clock - 1) / one_clock;
-		stp = rounded_up;
+		stp = DIV_ROUND_UP(period << 2, one_clock);
 		if (stp && esp->rev >= FAS236) {
 			if (stp >= 50)
 				stp--;
