From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] get rid of ->detect for upper layer drivers
Date: Thu, 7 Nov 2002 16:39:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107163954.B9189@lst.de>
References: <200211071225.EAA29497@adam.yggdrasil.com> <20021107142525.GA1292@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107142525.GA1292@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Nov 07, 2002 at 06:25:25AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: "Adam J. Richter" <adam@yggdrasil.com>, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 06:25:25AM -0800, Mike Anderson wrote:
> The reason scsi_bus_match is not clean is that scsi currently does not
> follow the device model correctly. We currently allow multiple object
> types on the scsi bus device list. This means your second container_of
> may not be operating on a struct scsi_device object.
> 
> The multiple objects in the scsi bus device list is the result of some
> mis-placed nodes and trying to work around the one driver to one device
> binding issue. In scsi if sg is loaded a scsi device can have up to 2
> drivers (i.e. sg + sd, etc).
> 
> The removal of detect should eventually result in other reductions /
> cleaner code (If the sg binding issue can be resolved cleanly). Scsi can
> then move to device model probe and remove routines and the elimination
> of the scsi_devicelist.

Yupp, IMHO we should move to a better interpretation of the driver
model.  But the question how do we solve the sg issue.  There are two
ways I could imagine:

(a)  we have primary and secondary upperlevel drivers, a primary one
     is registered with the driver model (and you can have only one
     per scsi device), a secondary is not.
(b)  sg becomes something different than a upperlevel driver

I think (b) is the way to go, we should just make the direct access
a property of the scsi device so that each device gets a sg node,
without any probing.

