From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [Patch 2.6] sd.c spinup messages
Date: 24 Jun 2004 17:02:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1088114552.2069.63.camel@mulgrave>
References: <200406091950_MC3-1-8463-F129@compuserve.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:41859 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265878AbUFXWCd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jun 2004 18:02:33 -0400
In-Reply-To: <200406091950_MC3-1-8463-F129@compuserve.com>
List-Id: linux-scsi@vger.kernel.org
To: Chuck Ebbert <76306.1226@compuserve.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2004-06-09 at 18:48, Chuck Ebbert wrote:
> -                               printk(KERN_NOTICE "%s: Spinning up disk...",
> +                               printk(KERN_NOTICE "%s: Spinning up disk...\n",
>                                        diskname);
>                                 cmd[0] = START_STOP;
>                                 cmd[1] = 1;     /* Return immediately */
> @@ -903,7 +906,6 @@ sd_spinup_disk(struct scsi_disk *sdkp, c
>                                 current->state = TASK_UNINTERRUPTIBLE;
>                                 time1 = schedule_timeout(time1);
>                         } while(time1);
> -                       printk(".");

What this basically does is remove the indication that the drive is
being spun up.  That's quite a significant user visible change from what
we do now.

Current behaviour is dictated by the fact that some of the drives
(particularly older ones) take ages to spin up.  Without the visual
indication that something is going on people tend to press the reset
button and report kernel errors.

Instead of making such a global change, how about making this a
non-default configurable option within sd.

James


