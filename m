From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 3/3] MidLayer updates - extending scsi_target support
Date: Sun, 06 Feb 2005 11:44:54 +1000
Message-ID: <42057696.5080109@torque.net>
References: <0B1E13B586976742A7599D71A6AC733C12EB22@xbl3.ma.emulex.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Received: from borg.st.net.au ([65.23.158.22]:38819 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S265741AbVBFBo3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Feb 2005 20:44:29 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C12EB22@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
>>the idea behind this is fine, I just don't like the interface.
>>
>>Really a target device is nothing more than a container to SCSI.  We
>>already do the transport add/remove calls for targets, I don't see we
>>need other calls duplicating this.  So, I think the 
>>implementation would
>>look a whole lot better if the fc transport class just exported an
>>interface to get the extra storage for the driver and tacked it on to
>>its allocation.  Then you can use the existing mid-layer transport
>>target triggers to do everything you want.
> 
> 
> This can certainly be transport-specific. However, I assumed the better
> solution was to make it more generic as there's nothing about this
> problem that's transport-centric. If a driver only tracks things by 
> target (not lun), it makes a whole lotta sense to allow for per-target
> data.

Targets "speak" the same transport protocol as the HBA.
This cannot necessarily be said about logical units.
Bridges are being proposed between SAS and SPI in which
U160/U320 disks on a SPI bus appear as luns on a single
SAS target (i.e. the bridge device). If the initiator
wants to speak to the disks then it uses luns (most likely
where SPI target ids appear as luns). The initiator may be
a little surprised if it queries the protocol specific mode
and log pages on those disks (as they will reveal their
native SPI transport characteristics). To query and configure
the bridge (and  perhaps check its protocol specific mode
and logs pages) well known logical unit numbers will be used.

SCSI targets seem like an important abstraction in their
own right, not just containers for lus.

Doug Gilbert
