From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] - mpt fusion - panic in mptsas_slave_configure
Date: Fri, 14 Apr 2006 02:02:53 +0100
Message-ID: <20060414010253.GA23580@infradead.org>
References: <664A4EBB07F29743873A87CF62C26D70080B50@NAMAIL4.ad.lsil.com> <1144967295.3474.68.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:51083 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965039AbWDNBDQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 21:03:16 -0400
Content-Disposition: inline
In-Reply-To: <1144967295.3474.68.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Moore, Eric" <Eric.Moore@lsil.com>, linux-scsi@vger.kernel.org

On Thu, Apr 13, 2006 at 05:28:14PM -0500, James Bottomley wrote:
> On Thu, 2006-04-13 at 16:08 -0600, Moore, Eric wrote:
> > This issue was created in due to recent scsi_transport_sas change,
> > when sas_read_port_mode_page was added into the mptsas drivers
> > slave_config entry point.    
> > 
> > This new API expects that all sdev's to be assocated to an rphy, however
> > that is not the case for logical volumes, as they are created using
> > scsi_add_device, instead of sas_rphy_add().
> 
> Erm, there's something else wrong here, then.  The sas transport class
> shouldn't be attaching to the raid volumes (only the raid components)
> since a RAID volume is not a SAS device.  I think when this came up ages
> ago, I said the SAS class should do a deny_binding() callback like the
> SPI transport class does for the mptfusion driver ... 

mptsas_slave_configure isn't anything sas transport class specificy, it's
the ->slave_configure method in the host template for all fusion SAS
controllers.  Independent of possibly needing a ->deny_binding this is the
right thing to do here.
