From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] megaraid: Convert from "scsi.h" to <scsi.h> (and
	friends)
Date: Sun, 06 Jan 2008 13:31:03 -0600
Message-ID: <1199647863.5205.85.camel@localhost.localdomain>
References: <20080106190335.28212.90140.sendpatchset@thinktank.campus.ltu.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:43286 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753754AbYAFTbI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Jan 2008 14:31:08 -0500
In-Reply-To: <20080106190335.28212.90140.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Richard Knutsson <ricknu-0@student.ltu.se>
Cc: megaraidlinux@lsi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Sun, 2008-01-06 at 20:03 +0100, Richard Knutsson wrote:
> Convert glue-include "scsi.h" to <scsi.h> (and friends).
> 
> (binary sizes)
> allyesconfig: before: 260132
>               after:  260048
> 
> allmodconfig: before: 261740
>               after:  261656
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Do not have the hardware, but since it compiles I hope it is alright.
> 
> 
> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> index 66c6520..9f1e2c5 100644
> --- a/drivers/scsi/megaraid.c
> +++ b/drivers/scsi/megaraid.c
> @@ -48,8 +48,9 @@
>  #include <linux/dma-mapping.h>
>  #include <scsi/scsicam.h>
>  
> -#include "scsi.h"
> +#include <scsi/scsi_cmnd.h>
>  #include <scsi/scsi_host.h>
> +#include <scsi.h>

I'm afraid this is pretty much wrong.  The scsi.h being referred to here
is the local scsi.h in the build directory, so it should be included as
a string.  For #include, "..." means begin the search in the local
directory (what is wanted here) and <...> means begin the search
starting with the predefined include paths.

The rest of the patch looks like a spurious (unrelated and undescribed)
downcasing of TRUE and FALSE.

James


