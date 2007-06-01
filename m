From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: fix shutdown handler to also disable interrupts.
Date: Fri, 1 Jun 2007 13:34:24 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A5551E@otce2k301.adaptec.com>
References: <86802c440706011007r7c9162c3w1fe0ba1952361f19@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:37224 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761570AbXFARe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jun 2007 13:34:27 -0400
Content-class: urn:content-classes:message
In-reply-to: <86802c440706011007r7c9162c3w1fe0ba1952361f19@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yinghai Lu <yhlu.kernel@gmail.com>, vgoyal@in.ibm.com
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

Yes, this patch makes sure that the Adapter is shut down correctly, and
thus when the kexec driver loads, it does not automatically reset the
adapter during initialization. This regression was a result of adding
code to the driver to detect if the adapter needed a reset as a result
of an unclean shutdown in order to deal with an issue that came up with
kdump. Kdump does not issue a clean shutdown. As you see, it was the
process of making the driver smarter to find out if it needed to reset
the adaptec fw that triggered the problem.

As noted before, please be advised to go through SUN channels. Upgrade
your Drive(s), SES, Motherboard and Card Firmware to the latest
versions; and make sure you are using compatible drives and drive bays
to see if this problem dealing with the superfluous reset on your
pre-release system goes away. You will be able to trigger this by trying
to perform a kdump on the system, OR by reverting this patch and running
your kexec test. The superfluous reset has yet to cause an issue with a
released card beyond noticing a superfluous Firmware reset as Vivek has
pointed out.

Sincerely -- Mark Salyzyn

From: Yinghai Lu [mailto:yhlu.kernel@gmail.com] sez:
> On 6/1/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
> > Thanks Mark. This does fix the issue of unnecessary reset of aacraid
> > adapter over kexec on my machine.
> i'm little confused about that.
> this patch is some clear shutdown, so even next start will have tight
> condition will not try to reset the adapter fw. right Mark?
> Maybe the driver could be smart to find out if it need to 
> reset adaptec fw.
> 
> YH 
