From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH / RFC] osst, st, sg sysfs removes
Date: Sat, 11 Jan 2003 09:02:25 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030111170225.GB1878@beaverton.ibm.com>
References: <20030109222107.GA5041@beaverton.ibm.com> <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.50.0301111416510.2294-100000@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Matt_Domsch@Dell.com, wrlk@riede.org, Douglas Gilbert <dougg@torque.net>, mochel@osdl.org

Kai Makisara [Kai.Makisara@kolumbus.fi] wrote:
> Looks OK to me (at least the st part). I have been planning to export some
> settings in the directories this patch removes but it has to wait until
> corresponding entries can be created into the (currently non-existent)
> char tree.
> 
> While looking at the sysfs/bus/scsi tree after this patch, I noticed that
> all devices currently get linked to the sd driver:

This is a bug. The problem is that the drivers in bus/scsi/drivers are
not full enabled for sysfs. They are not using sysfs driver probe
routines. This means the scsi bus_match routine controls the binding of
the device to the driver. I need to change the scsi bus_match routine,
but it might involve a hack as it will need to do a test similar to the old
detect routines that we just removed.

The scsi cleans up that have happen make support of sysfs driver probe
routines close to implementing once we come up with a solution for sg
binding ( sysfs does not support multiple driver bindings per device).

-andmike
--
Michael Anderson
andmike@us.ibm.com

