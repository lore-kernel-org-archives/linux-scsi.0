From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] correct attribute_container list usage
Date: Mon, 22 Aug 2005 17:47:06 -0500
Message-ID: <1124750826.5211.46.camel@mulgrave>
References: <1124723180.5211.25.camel@mulgrave>
	 <20050822214617.GA26441@us.ibm.com> <1124747956.5211.38.camel@mulgrave>
	 <20050822221427.GA26767@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:7861 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751370AbVHVWrP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 18:47:15 -0400
In-Reply-To: <20050822221427.GA26767@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>

On Mon, 2005-08-22 at 15:14 -0700, Patrick Mansfield wrote:
> based on whatever was in current 2.6.x git tree a couple weeks ago.]
> 
> The klist is (effectively) embedded within the struct device.
> 
> The klist_next() gets and puts on the klist object, so when the struct
> device ref (or kref) counts go to zero, we free up the klist independent
> of its ref counts.

Aarg, yet another object lifetime problem.

That somewhat lessens klist's utility, I think.  To fix this, the node
kref and the object that embeds it have to be tied together somehow.

One apparent, but rather nasty, solution would be to embed object get
and put into the klist head as functions that take the node, so
klist_next would take the object reference as well as the list kref,
then drop it on klist_release.

James


