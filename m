From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [REPOST][PATCH] update max sdev block limit
Date: Tue, 16 May 2006 09:34:50 -0700
Message-ID: <20060516163450.GA25071@us.ibm.com>
References: <1147358563.3507.4.camel@localhost.localdomain> <4469EB45.7070104@sgi.com> <4469F83F.4030407@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:31369 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S932111AbWEPQfG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 May 2006 12:35:06 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k4GGZ5WB007169
	for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 12:35:05 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k4GGZ5Kh264260
	for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 10:35:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k4GGZ3YT003824
	for <linux-scsi@vger.kernel.org>; Tue, 16 May 2006 10:35:04 -0600
Content-Disposition: inline
In-Reply-To: <4469F83F.4030407@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Michael Reed <mdr@sgi.com>, linux-scsi@vger.kernel.org

On Tue, May 16, 2006 at 12:05:19PM -0400, James Smart wrote:
> I don't mind making it bigger, especially as this is just a max, not the
> default value. I tried to keep it low, as I believe even 2 mins is a long
> time from the system's perspective. 10 minutes is forever (and remember
> the scan deadlock that we just worked through).

Yes, so add default and max settings instead of using the max as the default.

And I still don't see how the scsi timeout can (reliably) make it through
these block/unblocks. EH_RESET_TIMER doesn't freeze the scsi timeout like
you really need, just restarts it. 

For example, with default sd timeout of 30, you could be one second into a
command, block for 28 seconds, unblock, and then still timeout.

-- Patrick Mansfield
