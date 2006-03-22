From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] remove generic symlink from sg
Date: Wed, 22 Mar 2006 09:58:24 -0600
Message-ID: <1143043104.3633.11.camel@mulgrave.il.steeleye.com>
References: <1142715978.3773.13.camel@mulgrave.il.steeleye.com>
	 <44216C67.2040701@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:15819 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751011AbWCVP63 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 10:58:29 -0500
In-Reply-To: <44216C67.2040701@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Wed, 2006-03-22 at 10:25 -0500, Douglas Gilbert wrote:
> Careful with the spin:-) It is arguable which one is
> redundant. I am testing this patch and it breaks
> lsscsi and sg_map26 (again). Could you tell me which
> version of the lk 2.6 series the scsi_generic:sg<n>
> link appeared in? Because if I switch my code to
> search for a scsi_generic:sg<n> symlink rather than
> following the generic symlink then I will break
> backward compatibility prior to that version (unless
> I cope with both). At least one major distro has an
> "enterprise" edition based on lk 2.6.5

It was this patch

76d1ce00bdd76c2987fbfb763cd40447413a55b3
[PATCH] Driver core: link device and all class devices derived from it.

which added it on 10 July 05 according to the log.

I'd suggest not checking for version, but instead check for
scsi_generic: as the beginning of the link and then fallback if it's not
found.

> > I'm open to going through the deprecated features business for this,
> > since this would represent a user visible change of the scsi sysfs
> > interface if you wish.
> 
> I can see from my lsscsi code and the st driver that
> tape devices still have a plain old "tape" symlink.
> Should I be expecting that one to break in the near
> future?

Presumably if that link is likewise redundant.

James


