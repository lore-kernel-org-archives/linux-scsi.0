From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_set_host_offline (resend)
Date: 29 Mar 2003 15:54:59 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048974903.21704.313.camel@mulgrave>
References: <20030325100704.GC3868@beaverton.ibm.com>
	<1048613872.2070.12.camel@mulgrave>
	<20030325184530.GA1202@beaverton.ibm.com>
	<1048618939.1790.29.camel@mulgrave>
	<20030325232920.GB2692@beaverton.ibm.com>
	<1048779761.1789.21.camel@mulgrave>
	<20030328173253.A32352@one-eyed-alien.net>
	<1048948992.21525.1.camel@mulgrave>
	<20030329125302.A10565@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030329125302.A10565@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Mike Anderson <andmike@us.ibm.com>, mochel@osdl.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 2003-03-29 at 14:53, Matthew Dharm wrote:
> My understanding was that I couldn't call set_device_offline with the host
> lock held, which is a problem because I need the host lock to traverse the
> device list.

The solution we're talking about here is from the user level hotplug
scripts.  Once we get the remove-single-device fixed, you simply use the
device hot unplug script to traverse the attached SCSI devices, clean up
the user land (kill processes, unmount filesystems etc.) and then blow
the devices away.  After the host has no devices, you should simply be
able to trigger a host removal from within your driver.

James


