From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 12 May 2003 12:59:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052762365.2148.59.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
	<1052711864.1768.7.camel@mulgrave>
	<20030512063833.GA4133@beaverton.ibm.com>
	<1052761851.2093.55.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:13575 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262438AbTELRqv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 May 2003 13:46:51 -0400
In-Reply-To: <1052761851.2093.55.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Anderson <andmike@us.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, mochel@osdl.org

On Mon, 2003-05-12 at 12:50, James Bottomley wrote:
> Surprisingly, it still fails.  I've debugged the refcounting and I see
> it fall to zero in scsi_host_put but the dev release method doesn't
> trigger for no reason I can see.
> 
> It's probably a kobject initialisation problem somewhere.

OK, found it.  the ->release is triggered by the kobj_kset, which isn't
set until device_add time, not device init time.

Therefore, we shouldn't really put and get objects until they've been
added (or the kobj_set_kset_s needs to be moved to device_initialize()).

The more I think about it, the more it does look like we need to
separate the partially initialized case from the fully initialized one,
so perhaps the initial patch I made and thought was awful may actually
turn out to be the more correct one.

James


