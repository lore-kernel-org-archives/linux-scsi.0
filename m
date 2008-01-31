From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 2.6.24] bugfix for an overflow condition in usb storage
 & isd200.c
Date: Thu, 31 Jan 2008 22:05:19 +0200
Message-ID: <47A229FF.4040404__43742.9041172892$1201810013$gmane$org@panasas.com>
References: <Pine.LNX.4.44L0.0801301807420.17156-100000@iolanthe.rowland.org> <47A1948B.2010402@panasas.com> <20080131070846.4464eb3c@chirp.tahoe> <47A1E6A0.8050500@panasas.com> <47A2033D.2050502@panasas.com> <20080131180051.GA22341@kroah.com> <47A22369.80906@panasas.com> <20080131194941.GR14375@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:48809 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580AbYAaUFn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2008 15:05:43 -0500
In-Reply-To: <20080131194941.GR14375@one-eyed-alien.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>, Mark Glines <mark@glines.org>, James Bottomley <James.Bottomley@SteelEye.com>, Alan Stern <stern@rowland.harvard.edu>

On Thu, Jan 31 2008 at 21:49 +0200, Matthew Dharm <mdharm-scsi@one-eyed-alien.net> wrote:
> No.  No no no.
> 
> The ISD200 code was written by the ISD200 developers.  I really don't want
> to go mucking about changing what commands actually get send to the ISD200
> parts.  We have no idea if the will reliably accept a 36-byte INQUIRY.
> 
> Just because it happens to work for a couple of people doesn't mean it
> works in the general case.  Without guidance from In-System, this is a bad
> idea.
> 
> The way to deal with this is to do this via bounce buffering.  The two
> commands affected (INQUIRY and MODE_SENSE) are low-performance items.
> Discarding data from the end of them is also perfectly legal per spec.
> 
> Also, the entire idea of a negative resid makes my head hurt.  That sort of
> change is in the category of "likely to break something else" which only
> expects positive resid values.
> 
> Matt
> 
Please re-inspect the code again.
There is no device involved here. The code completely emulates this commands
with a driver made up information. the send_to_device is Zero.
(Nothing to bounce)

There is one more command like that but the standard does not permit choice
in that respect.

The negative resid is returned by iscsi for ages so I would say the scsi-ml
is fine with it. But if you want I can reset the resid and mark an overflow
condition in cmnd->status.

Boaz
