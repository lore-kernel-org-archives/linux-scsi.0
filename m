From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [RFC] SCSI Hotplug for lk 2.5
Date: Fri, 2 Aug 2002 12:58:40 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020802125840.A795@eng2.beaverton.ibm.com>
References: <3D49BCDB.392ACAA4@torque.net> <200208021113.g72BD2m01761@fachschaft.cup.uni-muenchen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200208021113.g72BD2m01761@fachschaft.cup.uni-muenchen.de>; from Oliver.Neukum@lrz.uni-muenchen.de on Fri, Aug 02, 2002 at 11:40:29AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <Oliver.Neukum@lrz.uni-muenchen.de>
Cc: Douglas Gilbert <dougg@torque.net>, linux-scsi@vger.kernel.org

On Fri, Aug 02, 2002 at 11:40:29AM +0200, Oliver Neukum wrote:
> 
> How about new paths to a device? It seems that the FibreChannel
> people need that.

It is not only fibrechannel - dual initiated busses, dual ported
devices, maybe iSCSI and maybe other low level drivers can have
mutiple paths to the actual device.

Did you see Doug's:

  e)	for multipath devices I would expect a hotplug alert for
	each path a device is discovered on (perhaps this is not
	practical)	

With my current multi-path code, a hotplug per path is possible, and
not difficult to add. The device alert (as Doug describes) already includes
a path, we probably would also need some flag that says this is the first
path; on removal, you would want a flag saying if this was the last path.

User level code would have to notice (for example) that a device was
already found and mounted, and that this is just another path to the device.

-- Patrick Mansfield
