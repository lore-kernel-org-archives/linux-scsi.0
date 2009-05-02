From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: MPT fusion SAS target numbering...
Date: Sat, 02 May 2009 18:30:38 -0500
Message-ID: <1241307038.3639.73.camel@mulgrave.int.hansenpartnership.com>
References: <20090502.151510.127219702.davem@davemloft.net>
	 <660360F4F2570145BD872F298951B17A80F01F53@cosmail03.lsi.com>
	 <20090502.155155.30314776.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39512 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbZEBXaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2009 19:30:39 -0400
In-Reply-To: <20090502.155155.30314776.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: Eric.Moore@lsi.com, linux-scsi@vger.kernel.org, tayfun.kocaoglu@sun.com, Greg.Onufer@sun.com

On Sat, 2009-05-02 at 15:51 -0700, David Miller wrote:
> From: "Moore, Eric" <Eric.Moore@lsi.com>
> Date: Sat, 2 May 2009 16:44:54 -0600
> 
> > the sas transport layer is assigning the target id's
> 
> Can you show me where that happens and how the MPT fusion
> SAS driver exports the SAS topology target IDs to that
> layer?

It happens in scsi_transport_sas.c:sas_rphy_add() which uses the
sas_host_attr's next_target_id to track a monotonically increasing
number for the SCSI target id (it gets incremented every time a remote
port is added to the system).

What the SAS spec defines as the target id is really a 64 bit WWPN,
which was difficult at the time to place in the SCSI mid layer SPI based
concept of a target.   If the fusion is also defining some number as a
target id that isn't the WWPN, then we could export that as well
somewhere ... that's essentially what we did for the qlogic and emulex
persistent bindings.

James


