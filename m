From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: PATCH: scsi: make scsi reset permissions more relaxed (RFC)
Date: Fri, 30 Aug 2013 11:18:01 -0500
Message-ID: <5220C5B9.3000908@tributary.com>
References: <20130830120450.GB31120@suse.de> <5220945A.2090906@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5220945A.2090906@interlog.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: Marcus Meissner <meissner@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 8/30/2013 7:47 AM, Douglas Gilbert wrote:

> I proposed the following patch some time back to give the user space finer
> resolution on resets with the option of stopping the escalation but it has
> gone nowhere: http://marc.info/?l=linux-scsi&m=136104139102048&w=2
> 
> With that patch you might only allow an unprivileged user the
> non-escalating LU and target reset variants.
> 
> If changes are made in that area, we might like to think about adding a new
> RESET variant mapping through to the I_T Nexus Reset TMF.

And a fine, incredibly useful patch it is. To the point of basically being a
requirement for SAN environments. Without it, all kinds of havoc can ensue.

But, the problem of burners going out to lunch, shows why its a stopgap. As most
burners are going to be SATA attached (without an expander), you probably want
to escalate all the way to the host reset if none of the other options work.

With a few other tweaks and the no-escalate patch, its possible to implement
escalation logic outside of the kernel that is aware of the device topology and
individual device states. That way HBA's aren't getting reset under active
functional devices.
