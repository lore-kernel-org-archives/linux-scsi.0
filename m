From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Thu, 20 Nov 2014 09:53:16 -0800
Message-ID: <20141120175316.GA19590@infradead.org>
References: <20141120060933.GA21432@infradead.org>
 <546E2880.5070303@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <546E2880.5070303@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 20, 2014 at 06:44:32PM +0100, Barto wrote:
> I notice that my motherboard doesn't support "AHCI" mode, my motherboard
> uses an ICH7 sata controler, ICH7 doesn't support AHCI if I check the
> technical specifications of this controler,
> 
> it seems that my bios treats SATA devices like IDE devices ( IDE
> emulation mode ), for example I can read in the bios these lines "IDE 0
> channel master : "the name of Sata harddisk 1", "IDE 3 channel master :
> "the name of Sata harddisk 2",
> 
> perhaps the bug only occurs when the AHCI mode is not used ?

Looks like it.  I suspect you device only supports a single outstanding
command without AHCI, can you confirm this by doing:

for i in /sys/class/scsi_host/*; do cat $i/can_queue; done
