From: Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation on
 katmai
Date: Fri, 15 Jan 2010 14:12:12 +0100
Message-ID: <20100115141212.3c245f5d@wker>
References: <1260625941-12179-1-git-send-email-agust@denx.de>
	<20100113111313.3a6f0399@wker>
	<0D1E8821739E724A86F4D16902CE275C1C93DBC3F4@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:48323 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951Ab0AONMT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Jan 2010 08:12:19 -0500
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1C93DBC3F4@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>, James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>

On Wed, 13 Jan 2010 15:56:17 +0530
"Desai, Kashyap" <Kashyap.Desai@lsi.com> wrote:

> Anatolij,
> 
> Patch provided by you is OK to me.
> Please consider it as ACKED.

OK, thanks. James, could you apply this patch then?

Anatolij
 
> > -----Original Message-----
> > From: Anatolij Gustschin [mailto:agust@denx.de]
> > Sent: Wednesday, January 13, 2010 3:43 PM
> > To: linux-scsi@vger.kernel.org
> > Cc: Desai, Kashyap; Moore, Eric; James Bottomley
> > Subject: Re: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation
> > on katmai
> > 
> > On Sat, 12 Dec 2009 14:52:21 +0100
> > Anatolij Gustschin <agust@denx.de> wrote:
> > 
> > > Since commit 9d2e9d66a3f032667934144cd61c396ba49f090d
> > > mptsas driver fails to allocate memory for the MPT chain buffers
> > > for second LSI adapter on PPC440SPe Katmai platform:
> > > ...
> > > ioc1: LSISAS1068E B3: Capabilities={Initiator}
> > > mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
> > > mptbase: ioc1: ERROR - didn't initialize properly! (-3)
> > > mptsas: probe of 0002:31:00.0 failed with error -3
> > >
> > > This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
> > > doesn't differentiate between SAS and FC causing increased allocation
> > > for SAS case, too. Later pci_alloc_consistent() fails to allocate
> > > increased chain buffer pool size for SAS case.
> > >
> > > Provide a fix by looking at the bus type and using appropriate
> > > MPT_SAS_CAN_QUEUE value while calculation of the number of chain
> > > buffers.
> > 
> > Could someone please comment on this patch? Thanks!
> > 
> > Anatolij

