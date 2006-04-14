From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3] - mpt fusion -
Date: Fri, 14 Apr 2006 02:04:05 +0100
Message-ID: <20060414010405.GB23580@infradead.org>
References: <664A4EBB07F29743873A87CF62C26D70080B51@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:52107 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965046AbWDNBEG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Apr 2006 21:04:06 -0400
Content-Disposition: inline
In-Reply-To: <664A4EBB07F29743873A87CF62C26D70080B51@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Thu, Apr 13, 2006 at 04:08:22PM -0600, Moore, Eric wrote:
> Bug fix - Due to a recent change in scsi_transport_sas,
> in the function sas_rphy_add(), its possible to have the
> same target mapped to two different device nodes, 
> meaning /dev/sda at id=0 and /dev/sdb at id=1, are remapped
> in mptsas to the same device at id=foo.
> 
> I'll explain the problem.
> The sas drivers have a rphy to rphy relationship.  An rphy
> created on a hba phy points to the expander phy.  Then the expander
> phy creates a rphy pointing back to the same hba rphy. The expander
> phy which contains the rphy pointing back to the hba phy, contains
> the attributes device_type = SAS_END_DEVICE, and target_port_protocals =
> 0.
> Hence the recent change in sas_rphy_add() make it drop down to
> scsi_scan_target, whereas before there was sepecial handling to 
> prevent this case from happening.  With this change, the mptsas slave
> entry 
> points are called to enumerate the rphy that points back to the hba phy.
> The target id in our data structures is the same as a real target device
> on another phy.  Thus we end up mapping the same target to two different
> rphys.
> To fix this, I added a check in mptsas_slave_alloc to make sure the
> requested rphy is mapped to a true end device.

This needs to be fixed in the transport class again.

