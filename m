From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: use set_host_byte instead of open-coding it
Date: Wed, 11 Oct 2017 15:05:40 +0200
Message-ID: <ceff38de-c8f7-9279-4769-5fcaa239ec7a@linux.vnet.ibm.com>
References: <20171010152939.21353-1-jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171010152939.21353-1-jthumshirn@suse.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org


On 10/10/2017 05:29 PM, Johannes Thumshirn wrote:
> Call set_host_byte() instead of open-coding it.
> 
> Converted using this simple Coccinelle spatch
> 
> <SmPL>
> @@
> local idexpression struct scsi_cmnd *c;
> expression E1;
> @@
> 
> - c->result = E1 << 16;
> + set_host_byte(c, E1);

Maybe I misunderstand, but doesn't set_host_byte only set the host byte 
but leave the other 3 parts untouched in c->result?

static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
{
	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
}

In contrast, assigning something to c->result resets all parts.
If so, the semantic patch would introduce a subtle semantic change.
Unless it's guaranteed that in all the touched cases, c->result always 
has 0 for status, message, and driver byte before calling set_host_byte().

Bart's suggestion also sounds nice.

FYI: Originally, I only thought about using set_host_byte in that one 
place fix of yours; I did not expect a full framework rework.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
