From: Christoph Hellwig <hch@infradead.org>
Subject: Re: When is QLogic 6.x driver going into 2.5?
Date: Wed, 1 Jan 2003 11:47:56 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030101114756.A19957@infradead.org>
References: <3679966B84813344B908D418BA3F6A4AA8406B@AVEXCH01.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3679966B84813344B908D418BA3F6A4AA8406B@AVEXCH01.qlogic.org>; from ravi.anand@qlogic.com on Tue, Dec 31, 2002 at 07:30:46PM -0800
List-Id: linux-scsi@vger.kernel.org
To: Ravi Anand <ravi.anand@qlogic.com>
Cc: Christoph Hellwig <hch@infradead.org>, rwhron@earthlink.net, linux-scsi@vger.kernel.org

On Tue, Dec 31, 2002 at 07:30:46PM -0800, Ravi Anand wrote:
> Can you kindly elaborate on the extra work needed.

First thing is of course to actually port the driver to 2.5-CURRENT, there's
no way it'll get into 2.4 before 2.5.

The it needs some massaging into an actual linux driver:

* remove typedef abuse
* remove #ifdef abuse.  The current driver is ifdef hell at it's best.
  examples:

#ifdef UNIQUE_FW_NAME
unsigned short fw2300ip_version = 3*1024+1;
#else
unsigned short risc_code_version = 3*1024+1;
#endif

  just always use the unique name, it can't harm

#if QLA2X_PERFORMANCE

  WTF?  Either your performance changes work and can always be enabled
  or you should remove them from a submitted driver.
  The useful remaining options should be turned into CONFIG_* symbols
  for use with the kernel config tools.

* the source file organization is a mess.  Don't ever include c files
  in other c files.  Reorganize the code into qla2100/qla2200/qla2300
  specific sources and common sources instead of the ifdef mess and
  turn the shared code into a library module (e.g. qla2x00.ko)

* don't delcare the host template in a header but as normal struct,
  see the many 2.5 driver that underwent that change (i.e. aic7xxx)

Second there's a bunch of functional changes that need to be done:

* Convert to the new pci API and scsi_add_host/scsi_remove_host for
  proper PCI hotplug support.
* Remove failover/multipath support.  It has been frequently stated
  multipathing for linux schould be handle in the driver-independant
  later, like the merged md-level support or IBM's scsi midlayer
  MP patches.
* Don't use deprecated functions like check_region :)
* Use proper abstraction instead of version checking hell in the
  source files.  I.e. the many occurances of

#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
        spin_lock_irq(&io_request_lock);
#else
	spin_lock_irq(ha->host->host_lock);
#endif

  should be hidden behing a proper wrapper.
* scsi_block_requests/scsi_unblock_requests instead of queueing commands
  yourself in ->queuecommand if the port stated is "dead" and remove
  much of the then obsolete queueing code.


Janitoral stuff:

* there seems to be lots of missing error return checks (i.e. copy_from_user)
* rename kmem_zalloc or just use kmalloc directly - Linux 2.5 already has
  a kmem_zalloc (in XFS)

I guess there's some more stuff that can be found once the driver is in
a saner shape, but the list is already huge enough 8)

