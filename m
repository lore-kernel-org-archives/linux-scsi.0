From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 00/12] Roll-up of sas_ata patches
Date: Sun, 04 Feb 2007 09:11:46 -0600
Message-ID: <1170601907.3424.4.camel@mulgrave.il.steeleye.com>
References: <200701300915.l0U9FuPu010198@d01av04.pok.ibm.com>
	 <1170541934.3345.69.camel@mulgrave.il.steeleye.com>
	 <45C5A581.1070504@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:47258 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbXBDPMB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Feb 2007 10:12:01 -0500
In-Reply-To: <45C5A581.1070504@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Alexis Bruemmer <alexisb@us.ibm.com>

On Sun, 2007-02-04 at 01:21 -0800, Darrick J. Wong wrote:
> James Bottomley wrote:
> 
> > There's a problem somewhere with your error handler changes (which I
> > picked up thanks to the problems with the V28 firmware).  What I see
> > without your changes is that for a directly attached SATA device, when
> > the firmware begins its death spiral, the commands all return and
> > eventually send I/O errors to the filesystem,  With your patch series
> > applied, it just loops forever giving messages like:
> > 
> > Feb  3 12:07:06 localhost kernel: aic94xx: escb_tasklet_complete: phy5: LINK_RESET_ERROR
> > Feb  3 12:07:06 localhost kernel: aic94xx: phy5: Receive FIS timeout
> > Feb  3 12:07:06 localhost kernel: aic94xx: phy5: retries:0 performing link reset seq
> > Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: aic94xx: control_phy_tasklet_complete: phy5, lrate:0x8, proto:0xe
> > Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: sas: Enter sas_scsi_recover_host
> > Feb  3 12:07:06 localhost kernel: sas: --- Exit sas_scsi_recover_host
> 
> Interesting, since the opposite happens with SAS disks. :)

Well, the initial error is a firmware induced drive error of some type.

> The infinite loop is usually what happens if a scsi_cmnd gets pulled off
> the eh queue without being scsi_eh_finish_cmnd()'d.  Can you send me the
> whole dmesg?  It's possible that we're trying to abort a command, which
> of course fails for a SATA disk, so we try bigger and bigger hammers....
> and the big hammers don't call scsi-eh-finish-cmd.

I've put the full log from detection of the aic94xx to forced power off
(all 512k of it) at

http://www2.kernel.org:/pub/linux/kernel/people/jejb/klog.aic94xx.failure.txt

(give it a while for the kernel.org mirrors to propagate)

> Did these SATA link reset errors only start showing up after the v28
> firmware patch, or has this always happened?  I've noticed lately that I
> get link reset errors if I run a short exercise on an ext3 filesystem on
> a SATA disk, yet dd exercise runs just fine.  But I had also thought
> that it was just my flaky hardware. :)

Er ... no idea ... The problem only shows up with V28 firmware, so I've
never seen a SATA disc fail with the V17 firmware.

