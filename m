From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: SCSI git trees
Date: Mon, 3 Aug 2009 11:09:11 -0700
Message-ID: <20090803110911.37044826.randy.dunlap@oracle.com>
References: <1248887256.3900.78.camel@mulgrave.site>
	<19063.9181.620137.814464@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:37726 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbZHCSJT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2009 14:09:19 -0400
In-Reply-To: <19063.9181.620137.814464@stoffel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 3 Aug 2009 13:52:29 -0400 John Stoffel wrote:

> >>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:
> 
> James> It seems I got unsubscribed from linux-scsi last week while I was on
> James> holiday and I've likely missed a slew of patches, it seems like an
> James> appropriate time to remind everyone how the SCSI trees work.
> 
> James> ---
> 
> James> There are two git based scsi trees:
> 
> James> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git
> 
> James> called the scsi-misc tree for patches being collected for the
> James> next merge window.  And

James,
Would it help you for patchwork to capture linux-scsi patches?
either patchwork.kernel.org or patchwork.ozlabs.org


> I don't see my patch to block/Kconfig to make BLK_DEV_BSG be enabled
> by default.  Is this going to be pushed for 2.6.32-rc1 when the merge
> window opens up?  
> 
> I've attached the patch, just to make sure.  Let me know if I should
> send it in properly.
> 
> Thanks!
> John
> 
> 
> Make Block Layer SG support v4 the default, since recent udev versions
> depend on this to access serial numbers and other low level info
> properly.
> 
> This should be backported to older kernels as well, since most distros
> have
> enabled this for a long time.
> 
> Signed-off-by: John Stoffel <john@stoffel.org>
> ---
>  block/Kconfig |   11 +++++++----
>  1 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/block/Kconfig b/block/Kconfig
> index e7d1278..55bbefc 100644
> --- a/block/Kconfig
> +++ b/block/Kconfig
> @@ -45,9 +45,9 @@ config LBD
>           If unsure, say N.
> 
>  config BLK_DEV_BSG
> -       bool "Block layer SG support v4 (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
> -       ---help---
> +       bool "Block layer SG support v4"
> +       default y
> +       help
>           Saying Y here will enable generic SG (SCSI generic) v4
> 	  support
>           for any block device.
> 
> @@ -57,7 +57,10 @@ config BLK_DEV_BSG
>           protocols (e.g. Task Management Functions and SMP in Serial
>           Attached SCSI).
> 
> -         If unsure, say N.
> +         This option is required by recent UDEV versions to properly
> +         access device serial numbers, etc.
> +
> +         If unsure, say Y.
> 
>  config BLK_DEV_INTEGRITY
>         bool "Block layer data integrity support"
> -- 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
