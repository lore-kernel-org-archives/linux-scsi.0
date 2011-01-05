From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] Use a better comparitor for scsi vendor/model table
 matching.
Date: Wed, 05 Jan 2011 10:36:27 -0600
Message-ID: <1294245387.15356.11.camel@mulgrave.site>
References: <1294241995-14270-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:41203 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab1AEQgd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Jan 2011 11:36:33 -0500
In-Reply-To: <1294241995-14270-1-git-send-email-pjones@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Linux SCSI <linux-scsi@vger.kernel.org>

On Wed, 2011-01-05 at 10:39 -0500, Peter Jones wrote:
> Previously we were using strncmp in order to avoid having to include
> whitespace in the devlist, but this means "HSV1000" matches a device
> list entry that says "HSV100", which is wrong.  This patch adds
> scsi_dh_strcmp(), which checks that any trailing characters in string 2
> are the pad character 0x20.

Hmm, the cockup comes from dh rolling its own comparators.  Could you
just convert it to use the standard ones in scsi_devinfo.c?  There's an
example of how to do this in scsi_transport_spi.c

James


