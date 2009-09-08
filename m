From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: scsi-post-merge tree build failure
Date: Tue, 08 Sep 2009 10:48:43 -0500
Message-ID: <1252424923.3990.204.camel@mulgrave.site>
References: <20090907200646.c6d6fadc.sfr@canb.auug.org.au>
	 <20090908181221.e8f98215.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751302AbZIHPsp@vger.kernel.org>
In-Reply-To: <20090908181221.e8f98215.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Jayamohan Kallickal <jayamohank@serverengines.com>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2009-09-08 at 18:12 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> On Mon, 7 Sep 2009 20:06:46 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> > 
> > drivers/scsi/be2iscsi/be_main.c: In function 'hwi_write_buffer':
> > drivers/scsi/be2iscsi/be_main.c:1481: error: implicit declaration of function 'virt_to_bus'
> > 
> > Caused by commit 9316dc3deb9675c674f96a0c6fb74ccc6c497fae ("[SCSI]
> > be2iscsi: add 10Gbps iSCSI - BladeEngine 2 driver") which I have reverted
> > for today.
> 
> The driver needs to depend on CONFIG_VIRT_TO_BUS if it needs to use
> virt_to_bus().  That will prevent it from building on some platforms
> (like powerpc) that do not implement virt_to_bus() and its brothers.

Actually, this is a modern hardware iSCSI card not some legacy piece of
hardware: it needs to use the proper API for this.

James
