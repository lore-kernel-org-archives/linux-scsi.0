From: Levy_Jerome@emc.com
Subject: RE: [PATCH 1/1] scsi_dh: add ALUA notification for EMC Clariion devices
Date: Tue, 23 Sep 2008 12:04:02 -0400
Message-ID: <6416EE16C1AF1E4C86882867E4DD0FF6026D1D3F@CORPUSMX40B.corp.emc.com>
References: <6416EE16C1AF1E4C86882867E4DD0FF6026D1BF1@CORPUSMX40B.corp.emc.com> <20080923155728.GD27204@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mexforward.lss.emc.com ([128.222.32.20]:17685 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbYIWQE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Sep 2008 12:04:28 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20080923155728.GD27204@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org

There's no real action to take -- the array will handle the condition
properly. This is just an informative message. It _would_ be nice if we
displayed the actual status, and I could do that in a uevent. Is it
reasonable to run one in the context of a sense-code routine or are we
better off keeping it fast and simple? 

The other thing I was thinking of was merely setting a flag and letting
dm-multipath do the reporting later on. I'd be open to either
approach... or better ideas...

Jerry Levy, Engineer IV
EMC Global Services Technical Support, PREM ISG
AMER Host Systems Software - UNIX

-----Original Message-----
From: Matthew Wilcox [mailto:matthew@wil.cx] 
Sent: Tuesday, September 23, 2008 11:57 AM
To: Levy, Jerome
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] scsi_dh: add ALUA notification for EMC Clariion
devices

On Tue, Sep 23, 2008 at 10:46:18AM -0400, Levy_Jerome@emc.com wrote:
> Adding sense code data decode and notification for optimal/non-optimal
> path changeover on Clariion devices. Unfortunately in the read sense
> code we can't do another inquiry, so we can't tell the user whether we
> are on the optimal or non-optimal path, only that a change has
occurred.

I'm not sure that printk is the optimal user notification here.

What if we had a uevent so that udev could take action, such as issuing
an inquiry?

What if we scheduled some work so we could issue an inquiry and take
appropriate action?

>         case UNIT_ATTENTION:
> +                if (sense_hdr->asc == 0x2A && sense_hdr->ascq ==
0x06)
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
Matthew Wilcox				Intel Open Source Technology
Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

