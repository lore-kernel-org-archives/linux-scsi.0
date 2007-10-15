From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 10:08:00 -0600
Message-ID: <20071015160800.GA324@parisc-linux.org>
References: <200710112011.22000.rob@landley.net> <200710141836.55211.rob@landley.net> <4712FE33.3000400@s5r6.in-berlin.de> <200710150426.04924.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1762923AbXJOQIT@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200710150426.04924.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, David Newall <david@davidnewall.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 15, 2007 at 04:26:04AM -0500, Rob Landley wrote:
> For example, usb devices are never easy to order.  IDE devices (back when they 
> had their own namespace) were trivial to order back when /dev/hda couldn't 
> move without use of a screwdriver.

Ah, but it could.  If you had more than one IDE controller (which is
even possible on laptops; the Fujitsu P7120 is one that I'm familiar
with that has more than one), the initialisation order *of the
controllers* would change which was hda and which was hde.

> Combining USB and IDE into the same /dev/sd? namespace makes enumerating the 
> IDE devices much harder than in the traditional "/dev/hdb doesn't move 
> without a screwdriver" model.  The merger creates a new problem for IDE, one 
> which didn't exist before: the addition or removal of other unrelated types 
> of devices may change this device's location next boot.  It may be possible 
> to add additional complication to the system to compensate, but what was the 
> advantage of merging the namespaces in the first place?

It's not something anyone particularly set out to do, it's just how
it worked out.  It was justified by saying "ok, this goes from a 99%
solution to a 96% solution, but there's 100% solution called uuids".
I don't particularly agree with this line of argumentation, but it did
hold sway.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
