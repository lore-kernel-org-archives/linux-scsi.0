From: Alexander Viro <viro@math.psu.edu>
Subject: Re: Why /dev/sdc1 doesn't show up...
Date: Sun, 17 Nov 2002 15:01:06 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0211171457290.23400-100000@steklov.math.psu.edu>
References: <20021117195258.GC3280@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021117195258.GC3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Linus Torvalds <torvalds@transmeta.com>



On Sun, 17 Nov 2002, Doug Ledford wrote:

> in scsi_module.c works, but is too ugly to live (and totally defeats the
> purpose of the new module loading code anyway).  Oh, and all the high

There is a purpose?  Seriously, "no use of ones object during init" is
WRONG.  Rusty, remember I've told you that block devices need to be
able to open() during init?  That's what it is.

We _might_ eventually kludge around that, but IMO the ->live checks on
the init side are just plain wrong.

