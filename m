From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [regression] uas no longer queues commands since v4.5.2
Date: Mon, 23 May 2016 07:38:01 -0700
Message-ID: <1464014281.2331.5.camel@HansenPartnership.com>
References: <CAGnHSEnR8n3-zxn767DEQv7eoDbA0cc3d_7xo8OZmO+g4jth+w@mail.gmail.com>
	 <b2eca29b-a954-f35b-7880-a99a2d6ddab8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33726 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753525AbcEWOiF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 May 2016 10:38:05 -0400
In-Reply-To: <b2eca29b-a954-f35b-7880-a99a2d6ddab8@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Tom Yan <tom.ty89@gmail.com>, linux-usb@vger.kernel.org, gregkh@linuxfoundation.org
Cc: linux-scsi@vger.kernel.org

On Mon, 2016-05-23 at 13:48 +0200, Hans de Goede wrote:
> Hi,
> 
> On 22-05-16 12:39, Tom Yan wrote:
> > With commit 198de51dbc3454d95b015ca0a055b673f85f01bb, uas no longer
> > set `queue_depth` with scsi_change_queue_depth(), so now
> > `queue_depth`
> > of UAS drives are 1. Even though `can_queue` is set to
> > `devinfo->qdepth - 2`, but apparently that does not help, since I
> > can
> > see performance impact.
> > 
> > Suppose limiting `can_queue` is the right way to fix this bug
> > (https://bugzilla.redhat.com/show_bug.cgi?id=1315013), do we really
> > need to eliminate scsi_change_queue_depth() at the same time
> > though?
> 
> No, I thought it was no longer needed, assuming the slave would
> inherit the host's value, but I was mistaken, the slave will default
> to a queue_depth of 1 if not specified.

Just to improve understanding: shost->can_queue is the host limit: it's
the maximum number of commands that can be outstanding on the host at
any one time, which is why it's used as the count for the shared tag
map.  It's also a fixed limit and can't be altered after the host is
instantiated.  sdev->queue_depth is the device queue limit, it can be
altered dynamically during device operation.  There's no relation
between them except that if you make queue_depth larger than can_queue,
the latter rules.

James


