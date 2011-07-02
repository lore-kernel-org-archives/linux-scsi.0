From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PULL] isci: sas controller driver for 3.0
Date: Sat, 02 Jul 2011 17:45:29 -0500
Message-ID: <1309646729.2554.17.camel@mulgrave>
References: <1309563349.19567.26.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54783 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755112Ab1GBWpd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jul 2011 18:45:33 -0400
In-Reply-To: <1309563349.19567.26.camel@dwillia2-linux>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, Jeff Skirvin <jeffrey.d.skirvin@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>, Ed Nadolski <edmund.nadolski@intel.com>, David Milburn <dmilburn@redhat.com>, Jeff Garzik <jeff@garzik.org>, Jacek Danecki <jacek.danecki@intel.com>, hare@suse.de

On Fri, 2011-07-01 at 16:35 -0700, Dan Williams wrote:
> James, please pull from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git master
> 
> ...to receive the isci driver that supports the integrated 6Gb/s SAS
> capabilities of the upcoming Intel(R) C600 series chipset family.  This
> part is targeted at standard servers / workstations and provides
> up to 8-ports (2x4-port controllers) of SAS beyond the traditional SATA
> ports (surfaced by the ahci driver).
> 
> Since the last merge candidate [1], the driver has shed an additional
> 3,500 lines of code:

Look, this tree is unacceptable because

A. It's not bisectable.  This is what happens when I try a bisection:

HEAD is now at f6edc9b isci: unify constants
scripts/kconfig/conf --oldnoconfig Kconfig
#
# configuration written to .config
#
scripts/kconfig/conf --silentoldconfig Kconfig
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CC [M]  drivers/scsi/isci/init.o
In file included from drivers/scsi/isci/init.c:66:0:
drivers/scsi/isci/core/scic_controller.h:67:6: error: nested redefinition of 'enum sci_controller_mode'
drivers/scsi/isci/core/scic_controller.h:67:6: error: redeclaration of 'enum sci_controller_mode'
drivers/scsi/isci/isci.h:75:6: note: originally defined here
drivers/scsi/isci/core/scic_controller.h:68:2: error: redeclaration of enumerator 'SCI_MODE_SPEED'
drivers/scsi/isci/isci.h:76:2: note: previous definition of 'SCI_MODE_SPEED' was here
drivers/scsi/isci/core/scic_controller.h:69:2: error: redeclaration of enumerator 'SCI_MODE_SIZE'
drivers/scsi/isci/isci.h:77:2: note: previous definition of 'SCI_MODE_SIZE' was here
make[1]: *** [drivers/scsi/isci/init.o] Error 1
make: *** [drivers/scsi/isci/isci.ko] Error 2

And B. It's got contaminated history like this:

commit bf94796e9b00fa3cc6d5f8021ceb547312fbed78
Author: Jack Wang <jack_wang@usish.com>
Date:   Thu Dec 2 13:27:05 2010 -0800

    [SCSI] libsas: fix bug for vacant phy
    
    This patch fix bug reported by Chuck. And this new version incorporate comments
    from Hannes. Please consider to include it into mainline.
    
    [ upstream: 2bc72c91 ]
    Signed-off-by: Jack Wang <jack_wang@usish.com>
    Signed-off-by: Lindar Liu <lindar_liu@usish.com>
    Tested-by: Chuck Tuffli <Chuck_Tuffli@pmc-sierra.com>
    Signed-off-by: James Bottomley <James.Bottomley@suse.de>

commit 258c6a82d41929cee8e357887a6ba0518fb4085f
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Tue Nov 23 09:47:14 2010 -0800

    libsas: fix definition of wideport, include local sas address
    
    To date libsas has only looked at the attached sas address when
    determining the formation of wide ports.  The specification and some
    hardware expects that phys with different addresses will not form a wide
    port unless the local peer phys also match each other.  Introduce a flag
    to select stricter behavior at sas_register_ha() time.  The flag can be
    dropped once it is known that all libsas users expect the same behavior.
    
    Current drivers just initialize this field to zero and get the
    traditional behavior.
    
    [upstream: 00f0254ed9b19164d416dc2e3c2e81eda55a6faf]
    Reported-by: Patrick Thomson <patrick.s.thomson@intel.com>
    Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Cc: Jack Wang <jack_wang@usish.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

commit 73782d7e0e27b4a8b285f56e2f2c11534e33239f
Author: Darrick J. Wong <djwong@us.ibm.com>
Date:   Tue Nov 23 09:48:34 2010 -0800

    libsas: Don't issue commands to devices that have been hot-removed
    
    sd will get hung up issuing commands to flush write cache if a SAS
    device behind the expander is unplugged without warning.  Change libsas
    to reject commands to domain devices that have already gone away.
    
    [maciej.trela@intel.com: removed setting ->gone in sas_deform_port() to
     permit sync cache commands at module removal]
    
    [upstream: 56dd2c0691a5a387b7b05835fe547dc6fade9407]
    Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
    linux-scsi-reference: <20071204223516.GA6767@tree.beaverton.ibm.com>
    Cc: Jeff Garzik <jeff@garzik.org>
    Cc: Brian King <brking@linux.vnet.ibm.com>
    Cc: Patrick Thomson <patrick.s.thomson@intel.com>
    Cc: Jeff Skirvin <jeffrey.d.skirvin@intel.com>
    Tested-by: Haipao Fan <haipao.fan@intel.com>
    Signed-off-by: Maciej Trela <maciej.trela@intel.com>
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>

I need clean history and a bisectable tree ... By Sunday, since this has
to be in linux-next before the next kernel release, which will likely be
Monday.

Since the tree is huge, I don't think this is fixable in the timescale,
so just a single patch will do ... I can construct that, but I need the
change log from you, please.

James


