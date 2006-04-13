From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/3] - mpt fusion - panic in mptsas_slave_configure
Date: Thu, 13 Apr 2006 17:28:14 -0500
Message-ID: <1144967295.3474.68.camel@mulgrave.il.steeleye.com>
References: <664A4EBB07F29743873A87CF62C26D70080B50@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:24747 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S965002AbWDMW2S (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 18:28:18 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70080B50@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-04-13 at 16:08 -0600, Moore, Eric wrote:
> This issue was created in due to recent scsi_transport_sas change,
> when sas_read_port_mode_page was added into the mptsas drivers
> slave_config entry point.    
> 
> This new API expects that all sdev's to be assocated to an rphy, however
> that is not the case for logical volumes, as they are created using
> scsi_add_device, instead of sas_rphy_add().

Erm, there's something else wrong here, then.  The sas transport class
shouldn't be attaching to the raid volumes (only the raid components)
since a RAID volume is not a SAS device.  I think when this came up ages
ago, I said the SAS class should do a deny_binding() callback like the
SPI transport class does for the mptfusion driver ... 

James


