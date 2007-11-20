From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] Unify sysfs filenames for firmware version
Date: Tue, 20 Nov 2007 12:49:49 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01FEAC9B@otce2k301.adaptec.com>
References: <20071120133824.GD31112@earth.li> <47430CCE.50701@emulex.com> <20071120171454.GH31112@earth.li>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:50696 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755497AbXKTRtv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Nov 2007 12:49:51 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071120171454.GH31112@earth.li>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jonathan McDowell <noodles@earth.li>, James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>, Matt_Domsch@dell.com

Jonathan McDowell sez:
> On Tue, Nov 20, 2007 at 11:35:26AM -0500, James Smart wrote:
> > The hearburn I have with these patches is that you are changing
> > driver-specific attributes, not common ones as 
> > enforced/requested by a
> > subsystem. As such, you are breaking a management interface for
> > existing tools/scripts.
> Yes, that's true. Though at present we have the heartburn that anyone
> wanting to write a script to pull out firmware revisions has to know
> exactly where every driver stores this information.

The aacraid cards, which uses hba_monitor_version, hba_kernel_version
and hba_bios_version for each piece does not fit into the single
'firmware revision' common ideal and were noticeably missing from this
patch set.

Fortunately (?), Adaptec has not bought into using sysfs for their
management applications to pull these pieces and continues to pick them
up directly by issuing ioctl pass-through calls to the card's firmware,
so we have some leeway to change them to mold to a developing standard.
The fact that sysfs is a developing standard will confirm the management
application folks reasoning for shying away from sysfs ;-/

Sincerely -- Mark Salyzyn
