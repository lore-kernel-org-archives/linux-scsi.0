From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] Reduce AACRAID hardware queue size
Date: Tue, 23 Jun 2009 10:31:29 -0500
Message-ID: <1245771089.4149.88.camel@mulgrave.site>
References: <1245756306-29023-1-git-send-email-apw@canonical.com>
	 <1245756306-29023-2-git-send-email-apw@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53781 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760484AbZFWPbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2009 11:31:33 -0400
In-Reply-To: <1245756306-29023-2-git-send-email-apw@canonical.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Mathias Urlichs <matthias@urlichs.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2009-06-23 at 12:25 +0100, Andy Whitcroft wrote:
> From: Mathias Urlichs <matthias@urlichs.de>
> 
> BugLink: http://bugzilla.kernel.org/show_bug.cgi?id=11120
> BugLink: http://bugs.launchpad.net/bugs/249964
> 
> Reduce the hardware queue size for the AACRAID controller.  This controloler
> suffers adapter aborts and scsi resets under high load otherwise:
> 
>     aacraid: Host adapter abort request (0,0,2,0)
>     aacraid: Host adapter abort request (0,0,3,0)
>     aacraid: Host adapter reset request. SCSI hang ?
>     aacraid: Host adapter abort request (0,0,0,0)
> 
> Signed-Off-By: Mathias Urlichs <matthias@urlichs.de>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  drivers/scsi/aacraid/aacraid.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index cdbdec9..0d5d036 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -24,7 +24,7 @@
>  #define AAC_MAX_LUN		(8)
>  
>  #define AAC_MAX_HOSTPHYSMEMPAGES (0xfffff)
> -#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)256)
> +#define AAC_MAX_32BIT_SGBCOUNT	((unsigned short)127)

So I'm afraid this isn't a proper fix.  It was a diagnostic test to see
if SGBCOUNT was the root cause for this card.

Incidentally, SGBCOUNT isn't queue depth, its maximum number of sectors
in an individual transfer.  What we'd need to show for this to be the
fix is that every 32 bit aacraid card is affected, which, given the
paucity of bug reports, I don't think so.

Firstly, Matthias, can you see if on an unmodified aacraid, this fixes
the problem for you:

echo 63 > /sys/block/<disk>/queue/max_sectors_kb

63 is because the parameter is in kb for sysfs, but in number of 512
byte blocks for the driver.  If it does, we can likely just add it to
the udev unusual devices and not bother with a kernel fix.

To fix the kernel properly, we'd need to add an AAC_QUIRK for this
adapter, which is a bit more work, so lets see if udev can fix it for us
first ...

James


