From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: fdomain: fix building pcmcia front-end
Date: Tue, 18 Jun 2019 23:13:01 -0400
Message-ID: <yq1v9x2uv2a.fsf@oracle.com>
References: <20190617111937.2355936-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190617111937.2355936-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Mon, 17 Jun 2019 13:19:17 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Ondrej Zary <linux@zary.sk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


Arnd,

> Move the common support outside of the SCSI_LOWLEVEL section.
> Alternatively, we could move all of SCSI_LOWLEVEL_PCMCIA into
> SCSI_LOWLEVEL. This would be more sensible, but might cause surprises
> for users that have SCSI_LOWLEVEL disabled.

It seems messy to me that PCMCIA lives outside of the LOWLEVEL section.

Given that the number of users that rely on PCMCIA for their system disk
is probably pretty low, I think I'm leaning towards cleaning things up
instead of introducing a nonsensical top level option.

Or even better: Get rid of SCSI_FDOMAIN as a user-visible option and
select it if either of the PCI/ISA/PCMCIA drivers are enabled.

-- 
Martin K. Petersen	Oracle Linux Engineering
