From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/6] scsi_dh : increment the refcounts while calling
 activate
Date: Thu, 29 Jul 2010 19:08:40 -0500
Message-ID: <1280448520.4441.930.camel@mulgrave.site>
References: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37048 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755080Ab0G3AIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Jul 2010 20:08:46 -0400
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF4D05DC422@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: device-mapper development <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Qi, Yanling" <Yanling.Qi@lsi.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

On Wed, 2010-07-28 at 16:59 -0600, Moger, Babu wrote:
> Hold the refcounts for device and scsi_dh_data while calling handler's
> activate. This will make sure that devices and scsi_dh_data are not
> removed while activate is still in progress. Make sure to call
> put_device and kref_put in the handler after activate is complete.

This is a complete no-no.  You can't take unreleased references in a
single patch.  I know the releases come in subsequent patches, but
that's not the way to do it.  You have to have an atomic change (as in
all refcounts must balance on either side of the patch).  If someone
bisected into this, it would likely never release stuff ... which could
lead to some unnecessary debugging.

James


