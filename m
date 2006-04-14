From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: section mismatches (scsi e.g.)
Date: Fri, 14 Apr 2006 18:52:10 +0200
Message-ID: <20060414165210.GA4053@mars.ravnborg.org>
References: <20060414092911.71f25ac1.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtp.tele.dk ([193.162.159.95]:26376 "EHLO pasmtp.tele.dk")
	by vger.kernel.org with ESMTP id S1751283AbWDNQwY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Apr 2006 12:52:24 -0400
Content-Disposition: inline
In-Reply-To: <20060414092911.71f25ac1.rdunlap@xenotime.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rdunlap@xenotime.net>
Cc: scsi <linux-scsi@vger.kernel.org>

On Fri, Apr 14, 2006 at 09:29:11AM -0700, Randy.Dunlap wrote:
> Hi Sam,
> 
> I was looking at these warnings (on 2.6.17-rc1-git8):
> 
> WARNING: drivers/scsi/3w-9xxx.o - Section mismatch: reference to .init.data: from .data between 'twa_driver' (at offset 0x18) and 'twa_error_table'
> WARNING: drivers/scsi/3w-xxxx.o - Section mismatch: reference to .init.data: from .data between 'tw_driver' (at offset 0x18) and 'tw_sense_table'
> WARNING: drivers/scsi/gdth.o - Section mismatch: reference to .init.text:gdth_detect from .data between 'driver_template' (at offset 0x270) and 'async_cache_tab'
> 
> I either don't see a problem or I'm having trouble reading/decoding
> the warning messages.  Could you look at these 3 sometime?

> WARNING: drivers/scsi/3w-9xxx.o
twa_driver contains a reference to twa_pci_tbl which is marked
devinitdata.

Darren Jenkins already pointed this pattern out but somehow I lost
the patch (not applied).
It is here:

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0b92ddf..81448e5 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -492,7 +492,7 @@ static int strrcmp(const char *s, const 
  *   These functions may often be marked __init and we do not want to
  *   warn here.
  *   the pattern is identified by:
- *   tosec   = .init.text | .exit.text
+ *   tosec   = .init.text | .exit.text | .init.data
  *   fromsec = .data
  *   atsym = *_driver, *_ops, *_probe, *probe_one
  **/
@@ -522,7 +522,8 @@ static int secref_whitelist(const char *
 
 	/* Check for pattern 2 */
 	if ((strcmp(tosec, ".init.text") != 0) &&
-	    (strcmp(tosec, ".exit.text") != 0))
+	    (strcmp(tosec, ".exit.text") != 0) &&
+	    (strcmp(tosec, ".init.data") != 0))
 		f2 = 0;
 	if (strcmp(fromsec, ".data") != 0)
 		f2 = 0;

> WARNING: drivers/scsi/3w-xxxx.o
Same issue as above.

> WARNING: drivers/scsi/gdth.o 
>From modpost.c:
* Pattern 2:
*   Many drivers utilise a *_driver container with references to
*   add, remove, probe functions etc.
*   These functions may often be marked __init and we do not want to
*   warn here.
*   the pattern is identified by:
*   tosec   = .init.text | .exit.text
*   fromsec = .data
*   atsym = *_driver, *_ops, *_probe, *probe_one
**/

Shall we include *_template in this list?
The most common name seems to be the ambigous driver_template.
Some scsi drievers has been a bit more specific and used
<driver>_template.
In total 76 drivers.

16 drivers uses: *_sht for their scsi_host_template variables.
And one uses NCR_Q720_tpnt.

I will push the 'lost' patch later today.

	Sam
> 
> Must have CONFIG_HOTPLUG=n ...
> 
> ---
> ~Randy
