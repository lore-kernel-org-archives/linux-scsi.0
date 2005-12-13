From: Randy Dunlap <randy_d_dunlap@linux.intel.com>
Subject: Re: RFC: ACPI/scsi/libata integration and hotswap
Date: Tue, 13 Dec 2005 10:14:17 -0800
Message-ID: <20051213101417.13fdb14c.randy_d_dunlap@linux.intel.com>
References: <20051208030242.GA19923@srcf.ucam.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20051208030242.GA19923@srcf.ucam.org>
Sender: linux-ide-owner@vger.kernel.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, acpi-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Hi Matthew,

I have a few comments and a question on this patch, please.
(Yes, I know it won't be merged.)
Most of these are general patch process comments.
However, the last comment is the important one.

1.  I had problems applying it.  What tree is it against?
    Say so in the description.

2.  use diff -p (in SubmittingPatches)

3.  use diffstat

4.  Why 2 diffs against include/linux/libata.h ?
    I was hoping that diffstat would show this, but it just merges
    the 2 libata.h patches together.  'lsdiff' does show this,
    however.

5.  #includes in alpha order as much as possible.

6.  Patch had some trailing whitespace (usually tabs).
    Some tools detect this and warn about it.

7.  Most important:  What good does the ACPI interface do/add?
    What I mean is that acpi_get_child() in scsi_acpi_find_channel()
    always returns a handle value of 0, so it doesn't get us
    any closer to determining the ACPI address (_ADR) of the SATA
    devices.  The acpi_get_devices() technique in my patch (basically
    walking the ACPI namespace, looking at all "devices") is the
    only way that I know of doing this, but I would certainly
    like to find a better way.


On Thu, 8 Dec 2005 03:02:42 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> Hi!
> 
> The included patch does three things:
> 
> 1) It adds basic support for binding SCSI and SATA devices to ACPI 
> device handles. At the moment this is limited to hosts, and in practice 
> it's probably limited to SATA ones (ACPI doesn't spec how SCSI devices 
> should appear in the DSDT, so I'm guessing that in general they don't). 
> Given a host, you can DEVICE_ACPI_HANDLE(dev) it to get the handle to 
> the ACPI device - this should be handy for implementing suspend 
> functions, since the methods should be in a standard location underneath 
> this.

[snip]

Thanks,
---
~Randy
