From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 11:45:24 -0500
Message-ID: <1212425124.3369.20.camel@localhost.localdomain>
References: <12124164141515-patch-mail.ibm.com>
	 <48441AEE.6050605@garzik.org>  <48441F82.6060706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48441F82.6060706@linux.vnet.ibm.com>
Sender: linux-ide-owner@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: Jeff Garzik <jeff@garzik.org>, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com, Tejun Heo <htejun@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-06-02 at 11:27 -0500, Brian King wrote:
> There is also the issue of HBA queue limits. Since each SATA rphy uses
> its
> own SCSI host, we lost host queue limit enforcement. I've implemented
> a
> request_limit in ipr in order to solve this for ipr, but this really
> does not scale well to lots of SATA devices, so we would probably need
> queue groups at the block level before moving libsas to the new API.

But this is the point that principally illustrates the problems.  We
really need one SCSI host per physical device, not per phy because most
multi-phy devices have a hard per device queue limit.

The problems seem to come at us from the 1:1 relationship between a
'port' and a host in libata.  Is there no way we can perhaps recast what
we think of as a phy as what libata thinks of as a link and thus keep us
at one host per actual physical device?

James



