From: david@lang.hm
Subject: Re: What still uses the block layer?
Date: Tue, 16 Oct 2007 12:54:58 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0710161238140.6995@asgard.lang.hm>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net>
 <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net>
 <20071015160800.GA324@parisc-linux.org> <47139F15.7050702@s5r6.in-berlin.de>
 <Pine.LNX.4.64.0710151954550.3949@asgard.lang.hm> <20071016111911.30a18e12@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:45923
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934219AbXJPTvO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Oct 2007 15:51:14 -0400
In-Reply-To: <20071016111911.30a18e12@the-village.bc.nu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Matthew Wilcox <matthew@wil.cx>, Rob Landley <rob@landley.net>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

On Tue, 16 Oct 2007, Alan Cox wrote:

>>> /dev/sd-ide-b	- second IDE HDD,
>>> /dev/sr-sata-0	- first SATA CD-ROM,
>
> I wouldn't try dividing those by pata v sata. You'll cause all sorts of
> problems in the process because of PATA-SATA and SATA-PATA bridges.

if you use a PATA-SATA bridge (IDE drive SATA controller), it would look 
to the system like a SATA drive and be addressed and enumerated as SATA.

if you use a SATA-PATA bridge (SATA drive, PATA controller), it would look 
to the system like a PATA drive and be addressed and enumerated as PATA. 
prior to libata the device would be /dev/hdX, with X depending on how it's 
cabled and if it's set to master or slave, it wouldn't matter if that 
device then converts to other things, the system would still know it as an 
IDE drive.

this works exactly the same way that external encosures that hold SATA or 
IDE drives, but have SCSI interfaces to the system have always worked so 
it's what sysadmins will expect.

David Lang
