From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
Date: Fri, 10 Jan 2014 10:12:37 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1401101007330.1399-100000@iolanthe.rowland.org>
References: <20140109235045.GA17660@xanatos>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20140109235045.GA17660@xanatos>
Sender: stable-owner@vger.kernel.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: walt <w41ter@gmail.com>, David Laight <David.Laight@ACULAB.COM>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 9 Jan 2014, Sarah Sharp wrote:

> > I can't see anything obvious either.
> > However there is no response to the 'stop endpoint' command.
> > Section 4.6.9 (page 107 of rev1.0) states that the controller will complete
> > any USB IN or OUT transaction before raising the command completion event.
> > Possibly it is too 'stuck' to complete the transaction?
> 
> The host has to stop processing the transaction, it can't "wait" for the
> transaction to finish.  "The Stop Endpoint Command is expected to stop
> endpoint activity as soon as possible, which may mean that it stops in
> the middle of a TRB."

Just to clarify for Walt: There's a difference between a transaction 
and a transfer.  Transfers can take an indefinitely long time to 
complete, because the device doesn't have to accept or send any data 
until it is ready.

By contrast, transactions have sharply bounded lifetimes.  A
transaction consists of some maximum number of packets (usually 3,
sometimes a little more) with upper limits on the time intervals
between them.

A TRB lies somewhere between a transfer and a transaction.  A single 
TRB can encompass a single transaction or multiple transactions, and a 
single transfer can involve more than one TRB.

Alan Stern
