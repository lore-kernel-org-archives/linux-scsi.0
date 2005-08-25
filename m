From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6: how do I this in sysfs?
Date: Thu, 25 Aug 2005 20:09:51 +0100
Message-ID: <20050825190951.GA20812@infradead.org>
References: <D4CFB69C345C394284E4B78B876C1CF10AB38B33@cceexc23.americas.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:12929 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932283AbVHYTKC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Aug 2005 15:10:02 -0400
Content-Disposition: inline
In-Reply-To: <D4CFB69C345C394284E4B78B876C1CF10AB38B33@cceexc23.americas.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com, mochel@osdl.org, "Moore, Eric Dean" <Eric.Moore@lsil.com>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, Luben Tuikov <luben_tuikov@adaptec.com>

> > typedef struct _CSMI_SAS_IDENTIFY {
> >    __u8  bDeviceType;
> >    __u8  bRestricted;
> >    __u8  bInitiatorPortProtocol;
> >    __u8  bTargetPortProtocol;
> >    __u8  bRestricted2[8];
> >    __u8  bSASAddress[8];
> >    __u8  bPhyIdentifier;
> >    __u8  bSignalClass;
> >    __u8  bReserved[6];
> > } CSMI_SAS_IDENTIFY,
> >   *PCSMI_SAS_IDENTIFY;

please compare this with struct sas_identify in
include/linux/scsi_transport_sas.h and look at
drivers/scsi/scsi_transport_sas.c om how it's exposed.

> > typedef struct _CSMI_SAS_PHY_ENTITY {
> >    CSMI_SAS_IDENTIFY Identify;
> >    __u8  bPortIdentifier;
> >    __u8  bNegotiatedLinkRate;
> >    __u8  bMinimumLinkRate;
> >    __u8  bMaximumLinkRate;
> >    __u8  bPhyChangeCount;
> >    __u8  bAutoDiscover;
> >    __u8  bReserved[2];
> >    CSMI_SAS_IDENTIFY Attached;
> > } CSMI_SAS_PHY_ENTITY,
> >   *PCSMI_SAS_PHY_ENTITY;

and this one to struct sas_port_attrs.

This is after my minimal sas transport class, please also read the
thread about it on linux-scsi

