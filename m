From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi_scan.c patch
Date: Tue, 3 Dec 2002 10:39:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021203103941.A29259@eng2.beaverton.ibm.com>
References: <UTC200211282202.gASM2U808846.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <UTC200211282202.gASM2U808846.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Thu, Nov 28, 2002 at 11:02:30PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: linux-scsi@vger.kernel.org

On Thu, Nov 28, 2002 at 11:02:30PM +0100, Andries.Brouwer@cwi.nl wrote:
> Wondering why my CD-writer did not have a name in sysfs, I saw
> that when the name is longer than 50 bytes no name at all is used.
> The (much smaller) code below constructs a truncated name instead.
> 
> (A reason not to truncate would be the desire to obtain a unique
> name, where the unicity is guaranteed by the serial number.
> However, my HP CD-writer has a serial number that consists of the
> '[' byte only, not much distinctive here.)
> 
> Andries

My understanding of sysfs is that the name field is supposed to have
a description of the device, not an id.

We should add a scsi_device char * uid, and put the id there, then we can
allocate it as large as we want, and set the name to something describing
the scsi device, most simply something like:

scsi Direct-Access

That is, "scsi" followed by the ascii version of the scsi type.

-- Patrick Mansfield
