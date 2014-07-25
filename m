From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/5] [SCSI] Do not use platform_bus as a parent
Date: Fri, 25 Jul 2014 07:46:56 -0700
Message-ID: <1406299616.1789.13.camel@jarvis.lan>
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>
	 <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49791 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751618AbaGYOrD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Jul 2014 10:47:03 -0400
In-Reply-To: <1406298233-27876-4-git-send-email-pawel.moll@arm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pawel Moll <pawel.moll@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@wwwdotorg.org>, Catalin Marinas <Catalin.Marinas@arm.com>, paul@pwsan.com, Arnd Bergmann <arnd@arndb.de>, Peter De Schrijver <pdeschrijver@nvidia.com>, arm@kernel.org, linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, 2014-07-25 at 15:23 +0100, Pawel Moll wrote:
> The host devices without a parent were "forcefully adopted"
> by platform bus. This patch removes this assignment. In
> effect the dev_dev may be NULL now, which means ISA.
> 
> Cc: James E.J. Bottomley <JBottomley@parallels.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
> 
> This patch is a part of effort to remove references to platform_bus
> and make it static.
> 
> James, could you please have a look and advice if the change is
> correct? Would you happen to know the "real reasons" behind
> using the root platform_bus device a parent?

Yes, for DMA purposes, the parent cannot now be NULL; we'll get a panic
in the DMA transfers if it is.  A lot of the legacy ISA device on x86
and I thought some ARM SOC devices don't pass in the parent device, so
we hang them off a known parent.

You can grep for it; these are the devices that will begin to panic if
you apply this patch:

arch/ia64/hp/sim/simscsi.c:     error = scsi_add_host(host, NULL);
drivers/scsi/a2091.c:   error = scsi_add_host(instance, NULL);
drivers/scsi/a3000.c:   error = scsi_add_host(instance, NULL);
drivers/scsi/aha152x.c: if( scsi_add_host(shpnt, NULL) ) {
drivers/scsi/gdth.c:    error = scsi_add_host(shp, NULL);
drivers/scsi/gdth.c:    error = scsi_add_host(shp, NULL);
drivers/scsi/gvp11.c:   error = scsi_add_host(instance, NULL);
drivers/scsi/imm.c:     err = scsi_add_host(host, NULL);
drivers/scsi/pcmcia/fdomain_stub.c:    if (scsi_add_host(host, NULL))
drivers/scsi/pcmcia/nsp_cs.c:   ret = scsi_add_host (host, NULL);
drivers/scsi/pcmcia/qlogic_stub.c:      if (scsi_add_host(shost, NULL))
drivers/scsi/pcmcia/sym53c500_cs.c:     if (scsi_add_host(host, NULL))
drivers/scsi/ppa.c:     err = scsi_add_host(host, NULL);
drivers/scsi/qlogicfas.c:       if (scsi_add_host(hreg, NULL))
drivers/scsi/scsi_module.c:             error = scsi_add_host(shost, NULL);
drivers/scsi/sgiwd93.c: err = scsi_add_host(host, NULL);

Note I've picked up scsi_module, so anything that uses the SCSI module
interface also has this problem.

James


