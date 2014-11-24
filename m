From: Christoph Hellwig <hch@infradead.org>
Subject: Re: BUG in scsi_lib.c due to a bad commit
Date: Mon, 24 Nov 2014 01:18:35 -0800
Message-ID: <20141124091835.GA21579@infradead.org>
References: <20141120060933.GA21432@infradead.org>
 <546E2880.5070303@laposte.net>
 <20141120175316.GA19590@infradead.org>
 <546E32A5.4040202@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <546E32A5.4040202@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Barto <mister.freeman@laposte.net>
Cc: Christoph Hellwig <hch@infradead.org>, "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Nov 20, 2014 at 07:27:49PM +0100, Barto wrote:
> but the sata DVD burner is now connected on a Jmicron sata PCIe card (
> with this configuration the bug doesn't occur ), I don't know if this
> change can modify the result of your command,
> 
> here is the result of another command :
> 
> $ for i in /sys/class/scsi_host/*; do cat $i/proc_name; done
> pata_jmicron
> pata_jmicron
> ata_piix
> ata_piix
> ata_piix
> ata_piix
> ahci
> ahci

Interesting.  So the jmicron card also has a queue depth of just one,
but the error still occurs?  I've added the linux-ide list, maybe
someone there has an idea how piix vs jmicron could have such different
behaviors for queueing or error handling.
