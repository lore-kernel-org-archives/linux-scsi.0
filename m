From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH scsi-misc-2.6] allow REPORT LUN scanning even for LUN 0 PQ of 3
Date: Wed, 21 Sep 2005 17:10:35 -0700
Message-ID: <20050922001035.GA27643@us.ibm.com>
References: <20050830224316.GA11210@us.ibm.com> <1127272270.5589.57.camel@mulgrave> <20050921221500.GA24993@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:136 "EHLO e31.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S965188AbVIVAKy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Sep 2005 20:10:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8M0AYmL006416
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 20:10:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8M0BQ2N506636
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 18:11:26 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j8M0Ar2j010157
	for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2005 18:10:53 -0600
Content-Disposition: inline
In-Reply-To: <20050921221500.GA24993@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: hare@suse.de, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, Sep 21, 2005 at 03:15:00PM -0700, Patrick Mansfield wrote:

> But the module refcount stays non-zero for scsi-debug, probably
> scsi_device_put/get. I am still debugging ...

I forgot to mention no scsi_debug devices showed up.

I removed the bad "!" on !scsi_device_get(), and the "insmod ./scsi_debug.ko
max_luns=3' found 2 sd's as expected.

But, scsi_debug module count is still at 1. Removing (via delete attr) the
2 scsi_debug devices, and module count is still at 1. So probably still a
missing scsi_device_put(). I'm trying to debug a bit more.

-- Patrick Mansfield
