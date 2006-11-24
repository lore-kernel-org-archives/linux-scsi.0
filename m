From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] scsi/initio: section mismatches with HOTPLUG=n
Date: Fri, 24 Nov 2006 16:51:36 -0600
Message-ID: <1164408696.2813.19.camel@mulgrave.il.steeleye.com>
References: <20061119185343.e4dde647.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:29851 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S935103AbWKXWvv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Nov 2006 17:51:51 -0500
In-Reply-To: <20061119185343.e4dde647.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>, Ben Collins <bcollins@ubuntu.com>

On Sun, 2006-11-19 at 18:53 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data: from .text between 'i91u_detect' (at offset 0x26e8) and 'i91uSCBPost'
> WARNING: drivers/scsi/initio.o - Section mismatch: reference to .init.data:i91u_pci_devices from .text between 'i91u_detect' (at offset 0x26ef) and 'i91uSCBPost'

Hmm, this apparently got into the tree unreviewed via Ben Collins:

commit 012887327875915f76a6208e81fe0d67a682ec15
Author: Ben Collins <bcollins@ubuntu.com>
Date:   Wed Oct 18 08:40:57 2006 -0400

    [initio] Add pci dev table for module auto loading.
    
    Signed-off-by: Ben Collins <bcollins@ubuntu.com>

Ben, for future reference, would you send SCSI patches over the SCSI
list, please.  Secondly, do you intend to complete this change?  What
Randy proposes will restore the driver to its original state.  However,
it could also be fixed properly by adding __devinit to all the relevant
PCI initialisation routines, which would be preferable.

James


