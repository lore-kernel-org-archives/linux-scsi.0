From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation on
 katmai
Date: Wed, 13 Jan 2010 15:56:17 +0530
Message-ID: <0D1E8821739E724A86F4D16902CE275C1C93DBC3F4@inbmail01.lsi.com>
References: <1260625941-12179-1-git-send-email-agust@denx.de>
 <20100113111313.3a6f0399@wker>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:54292 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab0AMK0p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2010 05:26:45 -0500
In-Reply-To: <20100113111313.3a6f0399@wker>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anatolij Gustschin <agust@denx.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@suse.de>

Anatolij,

Patch provided by you is OK to me.
Please consider it as ACKED.

- Kashyap

> -----Original Message-----
> From: Anatolij Gustschin [mailto:agust@denx.de]
> Sent: Wednesday, January 13, 2010 3:43 PM
> To: linux-scsi@vger.kernel.org
> Cc: Desai, Kashyap; Moore, Eric; James Bottomley
> Subject: Re: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation
> on katmai
> 
> On Sat, 12 Dec 2009 14:52:21 +0100
> Anatolij Gustschin <agust@denx.de> wrote:
> 
> > Since commit 9d2e9d66a3f032667934144cd61c396ba49f090d
> > mptsas driver fails to allocate memory for the MPT chain buffers
> > for second LSI adapter on PPC440SPe Katmai platform:
> > ...
> > ioc1: LSISAS1068E B3: Capabilities={Initiator}
> > mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
> > mptbase: ioc1: ERROR - didn't initialize properly! (-3)
> > mptsas: probe of 0002:31:00.0 failed with error -3
> >
> > This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
> > doesn't differentiate between SAS and FC causing increased allocation
> > for SAS case, too. Later pci_alloc_consistent() fails to allocate
> > increased chain buffer pool size for SAS case.
> >
> > Provide a fix by looking at the bus type and using appropriate
> > MPT_SAS_CAN_QUEUE value while calculation of the number of chain
> > buffers.
> 
> Could someone please comment on this patch? Thanks!
> 
> Anatolij

