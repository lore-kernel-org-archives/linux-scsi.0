From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH 0/2] fusion SAS support
Date: Wed, 24 Aug 2005 00:08:40 -0700
Message-ID: <20050824070840.GA568604@sgi.com>
References: <20050819162634.GA15401@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:51909 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1750785AbVHXHIv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Aug 2005 03:08:51 -0400
Content-Disposition: inline
In-Reply-To: <20050819162634.GA15401@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jejb@steeleye.com, Eric.Moore@lsil.com, linux-scsi@vger.kernel.org

On Fri, Aug 19, 2005 at 06:26:34PM +0200, Christoph Hellwig wrote:
> This patch implements minimal SAS support for fusion.  It needs the
> previous set of fusion updates and the minimal SAS transport class to
> work.  I'll probably revisit the transport class later to introduce a
> rport object, but I'll need some real enclosures with extenders and
> SMP ports to experiment with first.  So my suggestion is to put the
> current state of the art into scsi-misc so it gets exposure in -mm
> and people can start reviwing the design and send patches.  (Lots
> of thanks to James Smart btw, I had hoped to get more of this
> constructive critizism).


Hi Christoph,

I applied your four (sets of) patches, and they all seem to work
fine.  When connected through an expander, the data is a little light,
but direct connect works great.  Below, targets 0 and 1 are direct
connect to a 1064 chip, while targets 21-29 are through an expander.

pc-mdr5:/sys/class/sas_transport/target0:0:1 # lsscsi
[0:0:0:0]    disk    SEAGATE  ST373454SS       0002  /dev/sda
[0:0:1:0]    disk    SEAGATE  ST3146854SS      0002  /dev/sdb
[0:0:21:0]   enclosu LSILOGIC SASX12 SEP       v0.1  -       
[0:0:22:0]   disk    SEAGATE  ST373454SS       0002  /dev/sdk
[0:0:23:0]   disk    SEAGATE  ST373454SS       0002  /dev/sdl
[0:0:24:0]   disk    SEAGATE  ST3146854SS      0002  /dev/sdm
[0:0:25:0]   disk    SEAGATE  ST3146854SS      0002  /dev/sdn
[0:0:26:0]   disk    SEAGATE  ST3146854SS      0002  /dev/sdo
[0:0:27:0]   disk    SEAGATE  ST3146854SS      0002  /dev/sdp
[0:0:28:0]   disk    SEAGATE  ST373454SS       0002  /dev/sdq
[0:0:29:0]   disk    SEAGATE  ST373454SS       0002  /dev/sdr

pc-mdr5:/sys/class/sas_transport/target0:0:1 # more /sys/class/sas_transport/target0\:0\:[01]/*

*** /sys/class/sas_transport/target0:0:0/device: directory ***

::::::::::::::
/sys/class/sas_transport/target0:0:0/device_type
::::::::::::::
end device
::::::::::::::
/sys/class/sas_transport/target0:0:0/initiator_port_protocols
::::::::::::::
none
::::::::::::::
/sys/class/sas_transport/target0:0:0/phy_identifier
::::::::::::::
1
::::::::::::::
/sys/class/sas_transport/target0:0:0/sas_address
::::::::::::::
0x5000c500004015fd
::::::::::::::
/sys/class/sas_transport/target0:0:0/target_port_protocols
::::::::::::::
ssp

*** /sys/class/sas_transport/target0:0:1/device: directory ***

::::::::::::::
/sys/class/sas_transport/target0:0:1/device_type
::::::::::::::
end device
::::::::::::::
/sys/class/sas_transport/target0:0:1/initiator_port_protocols
::::::::::::::
none
::::::::::::::
/sys/class/sas_transport/target0:0:1/phy_identifier
::::::::::::::
0
::::::::::::::
/sys/class/sas_transport/target0:0:1/sas_address
::::::::::::::
0x5000c50000000ef5
::::::::::::::
/sys/class/sas_transport/target0:0:1/target_port_protocols
::::::::::::::
ssp

*** /sys/class/sas_transport/target0:0:24/device: directory ***

::::::::::::::
/sys/class/sas_transport/target0:0:24/device_type
::::::::::::::
none
::::::::::::::
/sys/class/sas_transport/target0:0:24/initiator_port_protocols
::::::::::::::
none
::::::::::::::
/sys/class/sas_transport/target0:0:24/phy_identifier
::::::::::::::
0
::::::::::::::
/sys/class/sas_transport/target0:0:24/sas_address
::::::::::::::
0x0
::::::::::::::
/sys/class/sas_transport/target0:0:24/target_port_protocols
::::::::::::::
none
