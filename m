From: James Bottomley <James.Bottomley@steeleye.com>
Subject: RE: [Announce] Emulex LightPulse Device Driver
Date: 10 Mar 2004 20:10:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078967456.10834.80.camel@mulgrave>
References: <3356669BBE90C448AD4645C843E2BF2802C014F1@xbl.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:43217 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262922AbUCKBLD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Mar 2004 20:11:03 -0500
In-Reply-To: <3356669BBE90C448AD4645C843E2BF2802C014F1@xbl.ma.emulex.com>
List-Id: linux-scsi@vger.kernel.org
To: "Smart, James" <James.Smart@Emulex.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>

On Wed, 2004-03-10 at 17:47, Smart, James wrote:
> we receive comments. There are constructs in the driver that are likely not
> going to change, such as the logging facility. How contentious is this ?
> What about the IP interfaces? and so on.  Anything we receive, especially on
> the larger concepts in the driver, only helps us understand what's ahead. 

Well, what your logging facility tries to do (discriminated messages to
the console based on a mask) is extremely standard for drivers.  The way
you implement it is slightly, erm, less than desirable.  Having your own
version of sprintf in your driver is a definite no-no (why do you do
this?  You never seem actually to use the added formatting characters
like %E?).  But at least it doesn't do anything silly like try to ouput
to the serial port.

As far as the IP portion goes: layering and separation should really be
the order of the day---perhaps even to the point where you have a core
module with a scsi and an IP one that sit on top of it.

> Our plans are to complete most of the work list on the FAQ by early April.
> We'll try to make weekly drops on SourceForge, with each snapshot containing
> a log of the changes.  Once the code base matures, we will ping the lists
> again, asking for feedback.

OK, I'll look forward to it.

James


