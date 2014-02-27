From: Michael Schmitz <schmitzmic@gmail.com>
Subject: Re: [PATCH 02/16] scsi: atari_scsi: fix sleep_on race
Date: Thu, 27 Feb 2014 20:58:21 +1300
Message-ID: <530EF01D.6000208@gmail.com>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de> <1393412516-3762435-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393412516-3762435-3-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Arnd Bergmann wrote:
> sleep_on is known broken and going away. The atari_scsi driver is one of
> two remaining users in the falcon_get_lock() function, which is a rather
> crazy piece of code. This does not attempt to fix the driver's locking
> scheme in general, but at least prevents falcon_get_lock from going to
> sleep when no other thread holds the same lock or tries to get it,
> and we no longer schedule with irqs disabled.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Michael Schmitz <schmitzmic@gmail.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/scsi/atari_scsi.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
> index a3e6c8a..b33ce34 100644
> --- a/drivers/scsi/atari_scsi.c
> +++ b/drivers/scsi/atari_scsi.c
> @@ -90,6 +90,7 @@
>  #include <linux/init.h>
>  #include <linux/nvram.h>
>  #include <linux/bitops.h>
> +#include <linux/wait.h>
>  
>  #include <asm/setup.h>
>  #include <asm/atarihw.h>
> @@ -549,8 +550,10 @@ static void falcon_get_lock(void)
>  
>  	local_irq_save(flags);
>  
> -	while (!in_irq() && falcon_got_lock && stdma_others_waiting())
> -		sleep_on(&falcon_fairness_wait);
> +	wait_event_cmd(falcon_fairness_wait,
> +		       !in_irq() && falcon_got_lock && stdma_others_waiting(),
> +		       local_irq_restore(flags),
> +		       local_irq_save(flags));
>  
>  	while (!falcon_got_lock) {
>  		if (in_irq())
> @@ -562,7 +565,10 @@ static void falcon_get_lock(void)
>  			falcon_trying_lock = 0;
>  			wake_up(&falcon_try_wait);
>  		} else {
> -			sleep_on(&falcon_try_wait);
> +			wait_event_cmd(falcon_try_wait,
> +				       falcon_got_lock && !falcon_trying_lock,
> +				       local_irq_restore(flags),
> +				       local_irq_save(flags));
>  		}
>  	}
>  
>   
Nack - the completion condition in the first hunk has its logic 
reversed. Try this instead (while() loops while condition true, do {} 
until () loops while condition false, no?)

I'm 99% confident I had tested your current version of the patch before 
and found it still attempts to schedule while in interrupt. I can retest 
if you prefer, but that'll have to wait a few days.

diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index a3e6c8a..cc1b013 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -90,6 +90,7 @@
 #include <linux/init.h>
 #include <linux/nvram.h>
 #include <linux/bitops.h>
+#include <linux/wait.h>
 
 #include <asm/setup.h>
 #include <asm/atarihw.h>
@@ -549,8 +550,10 @@ static void falcon_get_lock(void)
 
        local_irq_save(flags);
 
-       while (!in_irq() && falcon_got_lock && stdma_others_waiting())
-               sleep_on(&falcon_fairness_wait);
+       wait_event_cmd(falcon_fairness_wait,
+               in_irq() || !falcon_got_lock || !stdma_others_waiting(),
+               local_irq_restore(flags),
+               local_irq_save(flags));
 
        while (!falcon_got_lock) {
                if (in_irq())
@@ -562,7 +565,10 @@ static void falcon_get_lock(void)
                        falcon_trying_lock = 0;
                        wake_up(&falcon_try_wait);
                } else {
-                       sleep_on(&falcon_try_wait);
+                       wait_event_cmd(falcon_try_wait,
+                               falcon_got_lock && !falcon_trying_lock,
+                               local_irq_restore(flags),
+                               local_irq_save(flags));
                }
        }
 

Cheers,

    Michael
