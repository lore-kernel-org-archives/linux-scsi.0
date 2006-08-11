From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] SCSI and FC Transport: add netlink support for posting
 of transport events
Date: Fri, 11 Aug 2006 10:23:40 -0400
Message-ID: <44DC92EC.1020609@emulex.com>
References: <1155070439.6275.5.camel@localhost.localdomain> <20060811043237.GA29551@us.ibm.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63952 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751155AbWHKOXw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 Aug 2006 10:23:52 -0400
In-Reply-To: <20060811043237.GA29551@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Mike Anderson wrote:
> What about using netlink attributes? The attributes do have more overhead,
> but it would seem that using attributes instead of sending out a
> whole structure would make it easier on the user space side to support
> different kernel versions without syncing the tools with the kernel.

Yeah, I guessed you were going to raise this.

I just didn't see any advantage to it. The macros really didn't help with
anything really interesting, such as endianness. I guess they do help with
some potential structure packing issues. I saw them as just ensuring that
you walked on the path right - which for most intents and purposes, you
will as you really are not self-discovering data. As long as you use
well-defined types and watch the structure alignments, it should be fine.
The overhead didn't seem worthit. Enlighten me if I'm taking them too lightly.

I'm assuming your "syncing the tools with the kernel" statement infers the
use of a version element in place of the attributes above. I don't see how
you lose the version. It's the key for the later structure decode regardless
of whether it's attribute-ized or not. Am I missing something ? I'm also
(obviously) a proponent of the version so that a tool can provide backward
compatibility, or spot new un-recognized data.

-- james
