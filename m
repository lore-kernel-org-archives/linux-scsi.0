From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: SAS transport class status?
Date: Fri, 29 Jul 2005 10:43:55 -0400
Message-ID: <42EA40AB.1000105@adaptec.com>
References: <1122582465.14803.14.camel@duffman> <42E94310.9020604@adaptec.com> <42EA3451.9010908@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15772 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262607AbVG2OoK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Jul 2005 10:44:10 -0400
In-Reply-To: <42EA3451.9010908@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: Tom Duffy <tduffy@sun.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On 07/29/05 09:51, Brian King wrote:
> Luben, are you also working on the PHY transport class James mentions in
> his OLS paper, or have you been focusing just on the SAS transport class?

SAS layer.  It sits between a SAS LLDD and SCSI Core, and it manages
phy events, ports and port events, domain discovery, device registration
and unregistration with SCSI Core, etc.  Devices are registered with their
respective managing layers: SSP port devices with SCSI Core, STP and directly
attached SATA, and SATA Port multiplier (ports) with libata.  SMP ports
are driven by the SAS layer (since SMP is strictly a SAS proto).

SAS LLDDs do phy management, OOB, and report phy, port, and HA events
to the SAS layer.  SAS LLDDs do not do port management or discovery or
device management (they are just a "transport").

Attributes of all and any entities managed by the SAS layer
and their relationships are portrayed in sysfs in true manner.
They themselves depict the physical world as seen by the SAS
host adapter.

Reference of the internal infrastucture:
SAS 1.1, chapter 4.

Architecture reference:
SAM4r02, chapter 1.3, Figure 2 (same as in SPC), where
"Device specific commands" is SCSI ULDD (sd, st, etc),
"Shared Command Set"       is SCSI Core,
"SCSI Protocols"           is the SAS layer for SAS HAs,
"Interconnects"            is the SCSI LLDD (aic94xx, etc).

	Luben
