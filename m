From: Patrick Mochel <mochel@osdl.org>
Subject: Re: [PATCH] declare and export scsi_bus_type
Date: Thu, 12 Dec 2002 10:00:03 -0600 (CST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0212120951150.976-100000@localhost.localdomain>
References: <20021212091203.A21539@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021212091203.A21539@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matt Domsch <Matt_Domsch@Dell.com>, linux-scsi@vger.kernel.org


> On Wed, Dec 11, 2002 at 07:46:22PM -0600, Matt Domsch wrote:
> > Below please find a patch, written by Pat Mochel, to declare and export
> > scsi_bus_type.  My EDD code requires this to be exported in order to walk
> > the list of SCSI devices to match what BIOS discovered.
> 
> I'm very unhappy with exporting random parts of the scsi midlayer.  In
> what way do you need it?  How does your code work with modular scsi?

It's a not a random piece. It's a symbolic representation of the scsi bus 
type. It is designed to be exported for modular and optional components to 
use. 

EDD is a perfect example of this. It parses the firmware and obtains data
about the installed hard disks. It needs to associate the physical
hardware with the firmware data. So, it iterates over the SCSI (and soon 
IDE, I believe) drives, searching for a match. It uses scsi_bus_type 
because it uses the helper

int bus_for_each_dev(struct bus_type * bus, struct device * start, void * data,
                     int (*fn)(struct device *, void *));

Exporting the bus type keeps EDD at a good level of abstraction: it is 
ia32-specific, so it can remain in arch/i386/ in a single source file, and 
out of drivers/scsi/ and drivers/ide/. Instead of splitting the 
functionality between those three places. 

The bus type is accessible anyway, via the driver mdoel core. A piece of
code can iterate over the registered bus types and find the one named
'scsi', so it's by no means inaccessible. On the other hand, I can export
a call 'find_bus()' to search the bus-space for a bus with a certain name, 
but that is much less efficient that dereferencing an explicit pointer. 

	-pat

