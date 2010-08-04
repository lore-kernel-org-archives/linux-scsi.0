From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: build warning after merge of the scsi tree
Date: Wed, 04 Aug 2010 00:17:56 -0400
Message-ID: <1280895476.11045.323.camel@mulgrave.site>
References: <20100804131300.8570fe77.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20100804131300.8570fe77.sfr@canb.auug.org.au>
Sender: linux-next-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

cc linux-scsi added

On Wed, 2010-08-04 at 13:13 +1000, Stephen Rothwell wrote:
> Hi James,
> 
> After merging the scsi tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/scsi/scsi_sysfs.c:384: warning: dereferencing 'void *' pointer
> 
> Introduced by commit db5bd1e0b505c54ff492172ce4abc245cf6cd639 ("[SCSI]
> convert to the new PM framework").  This build does not have
> CONFIG_PM_OPS set.

So this one looks to be a compiler error.  in the none CONFIG_PM_OPS
case, we have

scsi_priv.h:#define scsi_bus_pm_ops             (*NULL)

So &scsi_bus_pm_ops should be NULL (not a deref of null).

James
