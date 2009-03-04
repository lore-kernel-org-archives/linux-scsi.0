From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 3 Mar 2009 16:29:21 -0800
Message-ID: <660360F4F2570145BD872F298951B17A7689E415@cosmail03.lsi.com>
References: <1236115756.15993.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og114.obsmtp.com ([64.18.2.215]:42502 "EHLO
	exprod7og114.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbZCDA3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 19:29:47 -0500
In-Reply-To: <1236115756.15993.23.camel@localhost.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Tuesday, March 03, 2009 2:29 PM, James Bottomley wrote: 
> On Wed, 2009-02-25 at 14:12 -0700, Matthew Wilcox wrote:
> > On Wed, Feb 25, 2009 at 01:27:00PM -0700, Moore, Eric wrote:
> > > What are you suggesting?   Calling wmb()?
> > 
> > PCI writes can be posted, so the him_register writel() may 
> not complete
> > for a few thousand cycles.  wmb() isn't going to solve the 
> problem.  A
> > readl() from the device would, as would your current solution of
> > ignoring subsequent interrupts.
> 
> This seems to be the most serious issue with the current 
> patch set.  If
> you repost with that fixed, I can put it into scsi-misc and we can
> address the other issues later.
> 

I will repost the patch set tommorrow with the following changes

(1) Add readl following writel from the function that disables interrupts

(2) Replace 0xFFFFFFFFFFFFFFFFULL with ~0ULL

(3) when calling pci_enable_msix, only pass one msix entry (instead of 15).  

(4) remove the "current HW implementation uses..... " comment in the sources

(5) merge in a bug fix for SIGIO/POLLIN notifcation reported by the storlib team.

Eric Moore