From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: [PATCH] oops in sd_shutdown
Date: Tue, 12 Aug 2003 04:49:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030812044901.A1650@pclin040.win.tue.nl>
References: <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher> <Pine.LNX.4.53.0308111426570.16008@thevillage.soulcatcher> <20030812002844.B1353@pclin040.win.tue.nl> <5.2.1.1.0.20030811180413.01a67dc0@no.incoming.mail>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5.2.1.1.0.20030811180413.01a67dc0@no.incoming.mail>; from kazrak+kernel@cesmail.net on Mon, Aug 11, 2003 at 06:13:50PM -0700
To: Jeff Woods <kazrak+kernel@cesmail.net>
Cc: Andries Brouwer <aebr@win.tue.nl>, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 11, 2003 at 06:13:50PM -0700, Jeff Woods wrote:

> Looking only at the above code snippet, I'd suggest something more like:

> +       if (!sdp || 


This is not meaningful.

A general kind of convention is that a pointer will be NULL either
by mistake, when it is uninitialized, or on purpose, when no object
is present or no action (other than the default) needs to be performed.

But that general idea is broken by container_of(), which just subtracts
a constant. So, one should check before subtracting that the pointer
is non-NULL. Checking afterwards is meaningless.
