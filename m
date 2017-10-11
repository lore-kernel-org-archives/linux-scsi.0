From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] scsi: use set_host_byte instead of open-coding it
Date: Wed, 11 Oct 2017 15:25:52 +0200
Message-ID: <20171011132552.tqfrg6ccqny2bzn2@linux-x5ow.site>
References: <20171010152939.21353-1-jthumshirn@suse.de>
 <ceff38de-c8f7-9279-4769-5fcaa239ec7a@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ceff38de-c8f7-9279-4769-5fcaa239ec7a@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 11, 2017 at 03:05:40PM +0200, Steffen Maier wrote:
> Maybe I misunderstand, but doesn't set_host_byte only set the host byte but
> leave the other 3 parts untouched in c->result?
> 
> static inline void set_host_byte(struct scsi_cmnd *cmd, char status)
> {
> 	cmd->result = (cmd->result & 0xff00ffff) | (status << 16);
> }
> 
> In contrast, assigning something to c->result resets all parts.
> If so, the semantic patch would introduce a subtle semantic change.
> Unless it's guaranteed that in all the touched cases, c->result always has 0
> for status, message, and driver byte before calling set_host_byte().

Yes it does, another case I'll have to add to my coccinelle spatch, thanks for
reminding me (and I'm also doing it for set_msg_byte() and set_driver_byte(),
the status byte will be done manually probably).

> 
> Bart's suggestion also sounds nice.

Yes I'm working on implementing it currently.

> 
> FYI: Originally, I only thought about using set_host_byte in that one place
> fix of yours; I did not expect a full framework rework.

Oh well:
$ git diff --stat master..
[..]
 80 files changed, 589 insertions(+), 540 deletions(-)

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
