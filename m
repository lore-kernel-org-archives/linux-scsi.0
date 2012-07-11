From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] [RESEND PATCH 3/3] dm mpath: add ability to disable
	partition creation
Date: Wed, 11 Jul 2012 16:18:40 +0100
Message-ID: <20120711151839.GC2095@agk-dp.fab.redhat.com>
References: <1340735525-21083-1-git-send-email-snitzer@redhat.com> <1340735525-21083-4-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654Ab2GKPSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Jul 2012 11:18:48 -0400
Content-Disposition: inline
In-Reply-To: <1340735525-21083-4-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: device-mapper development <dm-devel@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Peter Rajnoha <prajnoha@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>

On Tue, Jun 26, 2012 at 02:32:05PM -0400, Mike Snitzer wrote:
> The new 'no_partitions' feature serves as a notifier to kpartx to _not_
> create partitions on these multipath devices.
 
This isn't really multipath-specific so doesn't belong in the target.
It could go into dm core, but we already have flags attached to
udev cookies that can turn udev rules on and off and thereby could
allow userspace multipath to control whether or not kpartx creates
partitions on any particular device.

But first I'd like us to explore creating a config file for kpartx and
controlling the behaviour from there.  Activation could then be
triggered by target type, device name, scsi WWID, dm UUID etc. according
to rules in that file.

I think this approach of handling each layer independently gives us the
best chance of ending up with integrated management of arbitrary device
stacks.

Alasdair

