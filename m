From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] scsi_dh: add ALUA notification for EMC Clariion devices
Date: Tue, 23 Sep 2008 09:57:28 -0600
Message-ID: <20080923155728.GD27204@parisc-linux.org>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:45068 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbYIWP5o (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 11:57:44 -0400
Content-Disposition: inline
In-Reply-To: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Levy_Jerome@emc.com
Cc: linux-scsi@vger.kernel.org

On Tue, Sep 23, 2008 at 10:46:18AM -0400, Levy_Jerome@emc.com wrote:
> Adding sense code data decode and notification for optimal/non-optimal
> path changeover on Clariion devices. Unfortunately in the read sense
> code we can't do another inquiry, so we can't tell the user whether we
> are on the optimal or non-optimal path, only that a change has occurred.

I'm not sure that printk is the optimal user notification here.

What if we had a uevent so that udev could take action, such as issuing
an inquiry?

What if we scheduled some work so we could issue an inquiry and take
appropriate action?

>         case UNIT_ATTENTION:
> +                if (sense_hdr->asc == 0x2A && sense_hdr->ascq == 0x06)
> +                        /*
> +                         * ALUA status has changed. Report to host,
> +                         * no further action required... jml
> +                         */
> +                        sdev_printk(KERN_NOTICE, sdev,
> +                                    "%s: Asymmetric access state has
> changed.\n",
> +                                    CLARIION_NAME);
> +                        return SUCCESS;
> +                break;
>                 if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
