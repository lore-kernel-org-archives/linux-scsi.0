From: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] [PATCH 06/12] adt7470: Load automatically on
 IntelliStation Z30 via DMI
Date: Wed, 8 Oct 2008 13:08:08 +0200
Message-ID: <20081008130808.3384d650@hyperion.delvare>
References: <20081007011824.12701.39532.stgit@elm3a70.beaverton.ibm.com>
	<20081007011854.12701.39465.stgit@elm3a70.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:40507 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753287AbYJHLIZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 07:08:25 -0400
In-Reply-To: <20081007011854.12701.39465.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-scsi@vger.kernel.org>, lm-sensors <lm-sensors@lm-sensors.org>

Hi Darrick,

On Mon, 06 Oct 2008 18:18:54 -0700, Darrick J. Wong wrote:
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> ---
> 
>  drivers/hwmon/adt7470.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
> index 656bf3d..ef26014 100644
> --- a/drivers/hwmon/adt7470.c
> +++ b/drivers/hwmon/adt7470.c
> @@ -1114,3 +1114,6 @@ MODULE_LICENSE("GPL");
>  
>  module_init(adt7470_init);
>  module_exit(adt7470_exit);
> +
> +MODULE_ALIAS("dmi:bvnIBM:*:rn9228:*");
> +MODULE_ALIAS("dmi:bvnIBM:*:rn9232:*");

Nack. We have a user-space script to detect hardware monitoring chips
and load the corresponding drivers. We aren't going to add 2000+
DMI-based module aliases to handle all motherboards out there in the
kernel directly, this simply doesn't scale. And you need some
user-space configuration in almost all cases, so even DMI-based module
aliases wouldn't give you an automatic setup.

On top of that, in cases where detection doesn't work, there are better
ways to instantiate specific I2C devices now.

-- 
Jean Delvare
