From: Tomas Henzl <thenzl@redhat.com>
Subject: Re: [PATCH v4 04/43] hpsa: clean up aborts
Date: Fri, 17 Apr 2015 15:19:59 +0200
Message-ID: <5531087F.8070107@redhat.com>
References: <20150416134224.30238.66082.stgit@brunhilda> <20150416134703.30238.10876.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998AbbDQNU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Apr 2015 09:20:26 -0400
In-Reply-To: <20150416134703.30238.10876.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Don Brace <don.brace@pmcs.com>, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.combrace@pmcs.com
Cc: linux-scsi@vger.kernel.org

On 04/16/2015 03:47 PM, Don Brace wrote:
> From: Stephen Cameron <stephenmcameron@gmail.com>
>
> Do not send aborts to logical devices that do not support aborts
>
> Instead of relying on what the Smart Array claims for supporting logical
> drives, simply try an abort and see how it responds at device discovery
> time.  This way devices that do support aborts (e.g. MSA2000) can work
> and we do not waste time trying to send aborts to logical drives that do
> not support them (important for high IOPS devices.)
>
> While rescanning devices only test whether devices support aborts
> the first time we encounter a device rather than every time.
>
> Some Smart Arrays required aborts to be sent with tags in
> the wrong endian byte order.  To avoid having to know about
> this, we would send two aborts with tags with each endian order.
> On high IOPS devices, this turns out to be not such a hot idea.
> So we now have a list of the devices that got the tag backwards,
> and we only send it one way.
>
> If all available commands are outstanding and the abort handler
> is invoked, the abort handler may not be able to allocate a command
> and may busy-wait excessivly.  Reserve a small number of commands
> for the abort handler and limit the number of concurrent abort
> requests to the number of reserved commands.
>
> Reviewed-by: Scott Teel <scott.teel@pmcs.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
> Signed-off-by: Don Brace <don.brace@pmcs.com>

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

Tomas

