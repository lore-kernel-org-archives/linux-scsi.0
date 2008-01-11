From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] megaraid: fix section mismatch
Date: Thu, 10 Jan 2008 16:10:23 -0800
Message-ID: <20080110161023.91bf7618.akpm@linux-foundation.org>
References: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59037 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754513AbYAKANA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 19:13:00 -0500
In-Reply-To: <20080110143316.071efbc1.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, sam@ravnborg.org, Mauro Carvalho Chehab <mchehab@infradead.org>, Ingo Molnar <mingo@elte.hu>

On Thu, 10 Jan 2008 14:33:16 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Change megaraid_pci_driver_g variable name so that it matches the modpost
> whitelist that allows pointers to init text/data.
> 
> WARNING: vmlinux.o(.data+0x1a8e30): Section mismatch: reference to .init.text:megaraid_probe_one (between 'megaraid_pci_driver_g' and 'class_device_attr_megaraid_mbox_app_hndl')
> 

All these patches fix references to possibly-discarded sections and hence
fix possibly-serious bugs.  So all of them should go into 2.6.24.

I already had the qla2xxx one.  It was sent to James a month ago with not
atypical results.  The advansys one is stuck in git-scsi-misc.

I'll give it 24 hours and then shall send these:

scsi-qla2xxx-qla_osc-section-fix.patch
megaraid-fix-section-mismatch.patch
cciss-section-mismatch.patch
x86-discover_ebda-section-mismatch.patch
tpm-infineon-section-mismatch.patch
dvb-av7110-fix-section-mismatch.patch
hostap-section-mismatch-warning.patch

in to Linus.
