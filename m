From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Open-FCoE on linux-scsi
Date: Fri, 04 Jan 2008 12:45:45 +0100
Message-ID: <477E1C69.9010203@s5r6.in-berlin.de>
References: <10A7D0016239E24092DEF05CCC582E43028A671C@fmsmsx411.amr.corp.intel.com><200712281911.lBSJBWnB020367@mbox.iij4u.or.jp><10A7D0016239E24092DEF05CCC582E4302BB68C8@fmsmsx411.amr.corp.intel.com> <200801031035.m03AZYcJ012171@mbox.iij4u.or.jp> <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:37659 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbYADLqk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jan 2008 06:46:40 -0500
In-Reply-To: <10A7D0016239E24092DEF05CCC582E4302BB789B@fmsmsx411.amr.corp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Love, Robert W" <robert.w.love@intel.com>
Cc: FUJITA Tomonori <tomof@acm.org>, "Zou, Yi" <yi.zou@intel.com>, "Leech, Christopher" <christopher.leech@intel.com>, "Dev, Vasu" <vasu.dev@intel.com>, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 1/3/2008 10:58 PM, Love, Robert W wrote:
[FUJITA Tomonori wrote]
>>I would add one TODO item, better integration with scsi_transport_fc.
>>If we have HW FCoE HBAs in the future, we need FCoE support in the fc
>>transport class (you could use its netlink mechanism for event
>>notification).
> 
> What do you have in mind in particular? Our layers are, 
> 
> SCSI
> Openfc
> FCoE
> net_devive
> NIC driver
> 
> So, it makes sense to me that we fit under scsi_transport_fc. I like our
> layering- we clearly have SCSI on our top edge and net_dev at our bottom
> edge. My initial reaction would be to resist merging openfc and fcoe and
> creating a scsi_transport_fcoe.h interface.

AFAIU the stack should be:

  - SCSI core,
    scsi_transport_fc
  - Openfc (an FCoE implementation)
  - net_device
  - NIC driver

_If_ there will indeed be dedicated FCoE HBAs in the future, the
following stack could exist in addition to the one above:

  - SCSI core,
    scsi_transport_fc
  - FCoE HBA driver(s)

-- 
Stefan Richter
-=====-==--- ---= --=--
http://arcgraph.de/sr/
