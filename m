From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] scsi: hyper-v storvsc -- host takes MAINTENANCE_IN
 commands badly -- elide them
Date: Fri, 16 May 2014 10:42:50 -0700
Message-ID: <1400262170.2221.53.camel@dabdike.int.hansenpartnership.com>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
 <1400254748-21573-3-git-send-email-abbotti@mev.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1400254748-21573-3-git-send-email-abbotti@mev.co.uk>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Tim Gardner <tim.gardner@canonical.com>, linux-scsi@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>, Andy Whitcroft <apw@canonical.com>, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2014-05-16 at 16:39 +0100, Ian Abbott wrote:
> From: Andy Whitcroft <apw@canonical.com>
> 
> BugLink: http://bugs.launchpad.net/bugs/1234417

This is a pretty low quality bug report; where's the analysis that
should be in your patch?

The problem is, is it not, that when you turn on trim we now also probe
for write same using report opcodes (which is a SAI MAINTENANCE IN
commad) and that's causing the boot hang.

Firstly, that might be an indicator that the SPC3 route isn't a good one
because there might be more hidden nasties like this ... and that goes
back to how much testing have you done with the patch I suggested?

If it is only a WRITE SAME problem, then the preferred route would be
simply to set no_write_same in the template.

James

> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
> Original patch title was "UBUNTU: SAUCE: storvsc -- host takes
> MAINTENANCE_IN commands badly elide them".  Changed by Ian Abbott
> <abbotti@mev.co.uk>
> ---
>  drivers/scsi/storvsc_drv.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 3903c8a..c1eddd1 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1539,6 +1539,8 @@ static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
>  	 * this. So, don't send it.
>  	 */
>  	case SET_WINDOW:
> +	/* the host does not handle MAINTENANCE_IN preventing boot.*/
> +	case MAINTENANCE_IN:
>  		scmnd->result = ILLEGAL_REQUEST << 16;
>  		allowed = false;
>  		break;
