From: Doug Ledford <dledford@redhat.com>
Subject: Re: urgent SCSI help please
Date: Wed, 01 Oct 2003 01:38:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1064986725.3839.106.camel@compaq.xsintricity.com>
References: <BAY2-F170FSZDhd2stb00001311@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pix-525-pool.redhat.com ([66.187.233.200]:21295 "EHLO
	lacrosse.corp.redhat.com") by vger.kernel.org with ESMTP
	id S261958AbTJAFjF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Oct 2003 01:39:05 -0400
In-Reply-To: <BAY2-F170FSZDhd2stb00001311@hotmail.com>
List-Id: linux-scsi@vger.kernel.org
To: Stepan Novotill <snovotill@hotmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2003-10-01 at 00:50, Stepan Novotill wrote:
> What does this mean in /var/log/messages when I read data from DTF2 tapes?
> 
> kernel: sym53c875-1-<5,*>: FAST-20 WIDE SCSI 40.0 MB/s (50.0 ns, offset 8)
> last message repeated 11706 times
> last message repeated 9539 times
> 
> Ive swapped out everything including all SCSI components, kernel versions, 
> drivers, everything.

It means that your driver and the tape drive are constantly performing
speed negotiations.  Some drivers don't like it when the device
initiates speed negotiations (I'm not claiming that the sym drivers is
one of those, just that some don't).  However, I wouldn't be suprised if
the driver is accepting incoming negotiations, but then also initiating
a new negotiation cycle itself (I don't know this to be the case, but it
wouldn't suprise me too much).  Maybe that would cause your tape drive
to reissue it's negotiation.  Which would cause the driver to reissue
its negotiation.  Anyway, one thing to check is try making sure that the
tape drive isn't initiating speed negotiations.  It usually doesn't help
at all, and in some cases causes problems for drivers, so best to just
leave it off.  A lot of devices have a jumper or dip switch somewhere
that allows you to disable this.  The manuals usually call it Target
Initiated SDTR or Target Ininitiated Negotiation or something similar to
that.

HTH.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


