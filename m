From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] SCSI on non-ISA systems
Date: Fri, 8 Nov 2002 16:50:11 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021109005011.GC1040@beaverton.ibm.com>
References: <20021108135742.A22790@flint.arm.linux.org.uk> <Pine.GSO.4.21.0211081522050.23267-100000@vervain.sonytel.be> <20021108144234.A24114@flint.arm.linux.org.uk> <1036772421.16651.10.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1036772421.16651.10.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King <rmk@arm.linux.org.uk>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>, Rusty Trivial Russell <trivial@rustcorp.com.au>, linux-scsi@vger.kernel.org

Alan Cox [alan@lxorguk.ukuu.org.uk] wrote:
> On Fri, 2002-11-08 at 14:42, Russell King wrote:
> > Probably the correct answer is to get everyone to use an explicit release
> > function and just kill scsi_host_generic_release() entirely.
> > 
> > However, I'm sure other people will have differing views on that.
> 
> There are three things I'd like to do in that area
> 
> 1.	Make a release function mandatory (and I'm happy to paste it into the
> old scsi drivers)

This sounds good to get rid of this function. My list of drivers having
detect functions shows only 16 of 103 would need the addition of a
release function.

There is already a check for detect at the top of the scsi_register_host
function. When release is added a printk would also be nice to indicate
lack of these required functions. Douglas Gilbert is starting to work on
updating the api document so we can change the required field to yes if
the driver is using the scsi_register_host / scsi_unregister_host
interface and not-required if it using Christoph's newer scsi_add_host /
scsi_remove_host.

-andmike
--
Michael Anderson
andmike@us.ibm.com

