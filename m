From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] gdth: Stop abusing ->done for internal commands
Date: Tue, 25 Sep 2007 19:30:29 +0200
Message-ID: <46F945B5.2030305@panasas.com>
References: <1190738524460-git-send-email-willy@linux.intel.com> <1190738524757-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25350 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752657AbXIYRag (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 13:30:36 -0400
In-Reply-To: <1190738524757-git-send-email-willy@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>

On Tue, Sep 25 2007 at 18:42 +0200, Matthew Wilcox <willy@linux.intel.com> wrote:
> From: Matthew Wilcox <matthew@wil.cx>
> 
> The ->done member was being used to mark commands as being internal.
> I decided to put a magic number in ->underflow instead.  I believe this
> to be safe as no current user of ->underflow has any of the bottom 9
> bits set.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  drivers/scsi/gdth.c      |   19 +++++++++++--------
>  drivers/scsi/gdth_proc.c |    4 ++--
>  2 files changed, 13 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index 8a6a5f8..42a200f 100644
> --- a/drivers/scsi/gdth.c
> +++ b/drivers/scsi/gdth.c
> @@ -691,6 +691,9 @@ static const struct file_operations gdth_fops = {
>      .release = gdth_close,
>  };
>  
> +#define GDTH_MAGIC	0xc2e7c389	/* I got it from /dev/urandom */
> +#define IS_GDTH_INTERNAL_CMD(scp)	(scp->underflow == GDTH_MAGIC)
> +
>  #include "gdth_proc.h"
>  #include "gdth_proc.c"
>  
> @@ -713,7 +716,7 @@ static void gdth_scsi_done(struct scsi_cmnd *scp)
>  {
>  	TRACE2(("gdth_scsi_done()\n"));
>  
> -	if (scp->done == gdth_scsi_done)
> +	if (IS_GDTH_INTERNAL_CMD(scp))
>  		complete((struct completion *)scp->request);
>  	else 
>  		scp->scsi_done(scp);
> @@ -738,7 +741,7 @@ int __gdth_execute(struct scsi_device *sdev, gdth_cmd_str *gdtcmd, char *cmnd,
>      scp->cmd_len = 12;
>      memcpy(scp->cmnd, cmnd, 12);
>      scp->SCp.this_residual = IOCTL_PRI;   /* priority */
> -    scp->done = gdth_scsi_done;
> +    scp->underflow = GDTH_MAGIC;
>      gdth_queuecommand(scp, NULL);
>      wait_for_completion(&wait);
>  
> @@ -2319,7 +2322,7 @@ static void gdth_putq(int hanum,Scsi_Cmnd *scp,unchar priority)
>      ha = HADATA(gdth_ctr_tab[hanum]);
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
> -    if (scp->done != gdth_scsi_done) {
> +    if (!IS_GDTH_INTERNAL_CMD(scp)) {
>          scp->SCp.this_residual = (int)priority;
>          b = virt_ctr ? NUMDATA(scp->device->host)->busnum:scp->device->channel;
>          t = scp->device->id;
> @@ -2382,7 +2385,7 @@ static void gdth_next(int hanum)
>      for (nscp = pscp = ha->req_first; nscp; nscp = (Scsi_Cmnd *)nscp->SCp.ptr) {
>          if (nscp != pscp && nscp != (Scsi_Cmnd *)pscp->SCp.ptr)
>              pscp = (Scsi_Cmnd *)pscp->SCp.ptr;
> -        if (nscp->done != gdth_scsi_done) {
> +        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
>              b = virt_ctr ?
>                  NUMDATA(nscp->device->host)->busnum : nscp->device->channel;
>              t = nscp->device->id;
> @@ -2408,7 +2411,7 @@ static void gdth_next(int hanum)
>              firsttime = FALSE;
>          }
>  
> -        if (nscp->done != gdth_scsi_done) {
> +        if (!IS_GDTH_INTERNAL_CMD(nscp)) {
>          if (nscp->SCp.phase == -1) {
>              nscp->SCp.phase = CACHESERVICE;           /* default: cache svc. */ 
>              if (nscp->cmnd[0] == TEST_UNIT_READY) {
> @@ -2471,7 +2474,7 @@ static void gdth_next(int hanum)
>                  else
>                      gdth_scsi_done(nscp);
>              }
> -        } else if (nscp->done == gdth_scsi_done) {
> +        } else if (IS_GDTH_INTERNAL_CMD(nscp)) {
>              if (!(cmd_index=gdth_special_cmd(hanum,nscp)))
>                  this_cmd = FALSE;
>              next_cmd = FALSE;
> @@ -3812,7 +3815,7 @@ static int gdth_sync_event(int hanum,int service,unchar index,Scsi_Cmnd *scp)
>                      scp->sense_buffer[2] = NOT_READY;
>                      scp->result = (DID_OK << 16) | (CHECK_CONDITION << 1);
>                  }
> -                if (scp->done != gdth_scsi_done) {
> +                if (!IS_GDTH_INTERNAL_CMD(scp)) {
>                      ha->dvr.size = sizeof(ha->dvr.eu.sync);
>                      ha->dvr.eu.sync.ionode  = hanum;
>                      ha->dvr.eu.sync.service = service;
> @@ -4910,7 +4913,7 @@ static int gdth_queuecommand(struct scsi_cmnd *scp,
>  #endif
>  
>      priority = DEFAULT_PRI;
> -    if (scp->done == gdth_scsi_done)
> +    if (IS_GDTH_INTERNAL_CMD(scp))
>          priority = scp->SCp.this_residual;
>      else
>          gdth_update_timeout(hanum, scp, scp->timeout_per_command * 6);
> diff --git a/drivers/scsi/gdth_proc.c b/drivers/scsi/gdth_proc.c
> index 32982eb..1f8d9a5 100644
> --- a/drivers/scsi/gdth_proc.c
> +++ b/drivers/scsi/gdth_proc.c
> @@ -805,7 +805,7 @@ static void gdth_stop_timeout(int hanum, int busnum, int id)
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
>      for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
> -        if (scp->done != gdth_scsi_done) {
> +        if (!IS_GDTH_INTERNAL_CMD(scp)) {
>              b = virt_ctr ?
>                  NUMDATA(scp->device->host)->busnum : scp->device->channel;
>              t = scp->device->id;
> @@ -829,7 +829,7 @@ static void gdth_start_timeout(int hanum, int busnum, int id)
>      spin_lock_irqsave(&ha->smp_lock, flags);
>  
>      for (scp = ha->req_first; scp; scp = (Scsi_Cmnd *)scp->SCp.ptr) {
> -        if (scp->done != gdth_scsi_done) {
> +        if (!IS_GDTH_INTERNAL_CMD(scp)) {
>              b = virt_ctr ?
>                  NUMDATA(scp->device->host)->busnum : scp->device->channel;
>              t = scp->device->id;

OK This is on top of the first patch that I will take care of,
right? (http://www.spinics.net/lists/linux-scsi/msg19470.html)

Here 2 it will not merge with my patchset. So I'll take it off your hands
and rebase it to mine.

In my patchset I have introduced a gdth_cmnd_priv. That is associated
with every command and is put on cmnd->host_scribble, I than moved lots
of abused Scp and other members to that new structure. I also put a 
simple boolean that states that these are Internal commands. So what
is left of this patch is the:
-    scp->done = gdth_scsi_done;
I will add that one line removal to your previous patch.

> Ah; I was basing this on linus + scsi-misc.  I guess scsi_lib hadn't
> been converted because I just took the code from there.
Yes scsi_lib was not converted, but scsi.c was.

Boaz

