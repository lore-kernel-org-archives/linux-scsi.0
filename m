From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: RE: [patch 6/8] mptfusion: fc transport
Date: Wed, 1 Dec 2004 16:40:58 -0700
Message-ID: <91888D455306F94EBD4D168954A9457C667E8F@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:26578 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261501AbULAXlL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Dec 2004 18:41:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wednesday, December 01, 2004 1:50 PM, James Bottomley wrote:
> Nothing complex.  How about just a simple module wrapper for the PCI
> attachment, so you have the FC devices in one, the SPI in 
> another etc. 
> Then you could attach and initialise the FC transport only if the user
> modprobes the FC driver.
> 
> I just don't see it being tenable to drag in the whole of the fc
> transport class in a SCSI only configuration for fusion.
> 

This sounds to me that your asking for a separate drivers for SCSI, FC and
SAS. Right?
Meaning in addition to mptscsih.ko, we would have mptfc.ko, mptsas.ko. Each
having its unique module_init, module_exit, and probe routines.  
If so, code will triple because now we will be replicating same source
across drivers 
that handle scsi queued commands, interrupt handling, error recovery,
firmware
asyn event handling, etc.  

Eric Moore
