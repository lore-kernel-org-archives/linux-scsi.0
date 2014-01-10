From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: [PATCH 3/6] libata: resume in the background
Date: Fri, 10 Jan 2014 14:26:09 -0800
Message-ID: <CAA9_cmfzgNkep_ZBKwyvW3iUXnKyNjpbB1uGtDLonbD1wCM10g@mail.gmail.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
	<1387236657-4852-1-git-send-email-psusi@ubuntu.com>
	<1387236657-4852-4-git-send-email-psusi@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48956 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaAJW0K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 17:26:10 -0500
In-Reply-To: <1387236657-4852-4-git-send-email-psusi@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, Tejun Heo <tj@kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Mon, Dec 16, 2013 at 3:30 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> Don't block the resume path waiting for the disk to
> spin up.
> ---
>  drivers/ata/libata-core.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 8f856bb..4a28caf 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -5430,20 +5430,18 @@ static int __ata_port_resume_common(struct ata_port *ap, pm_message_t mesg,
>  static int ata_port_resume_common(struct device *dev, pm_message_t mesg)
>  {
>         struct ata_port *ap = to_ata_port(dev);
> +       static int dontcare;
>
> -       return __ata_port_resume_common(ap, mesg, NULL);
> +       return __ata_port_resume_common(ap, mesg, &dontcare);
>  }

I was going to comment that this leaves us open to a race to submit
new i/o before recovery starts, but scsi_schedule_eh already blocks
new i/o, so I think we're good.  I think it deserves a comment here
about why it's safe to not care.

>
>  static int ata_port_resume(struct device *dev)
>  {
>         int rc;
>
> +       if (pm_runtime_suspended(dev))
> +               return 0;

Why?  If we dpm_resume() a port that was rpm_suspend()ed the state
needs to be reset to active.  I think this check also forces the port
to resume twice, once for system resume and again for the eventual
runtime_resume.

>         rc = ata_port_resume_common(dev, PMSG_RESUME);
> -       if (!rc) {
> -               pm_runtime_disable(dev);
> -               pm_runtime_set_active(dev);
> -               pm_runtime_enable(dev);
> -       }
>
>         return rc;
>  }

...so, the pm_runtime_suspended() check should go and something like
this folded in:

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 92d7797223be..a6cc107c9434 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -4143,5 +4143,11 @@ static void ata_eh_handle_port_resume(struct
ata_port *ap)
                ap->pm_result = NULL;
        }
        spin_unlock_irqrestore(ap->lock, flags);
+
+       if (rc == 0) {
+               pm_runtime_disable(dev);
+               pm_runtime_set_active(dev);
+               pm_runtime_enable(dev);
+       }
 }
 #endif /* CONFIG_PM */
