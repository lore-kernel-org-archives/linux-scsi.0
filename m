From: Anatolij Gustschin <agust@denx.de>
Subject: Re: [PATCH] [SCSI] mptsas: Fix issue with chain pools allocation on
 katmai
Date: Wed, 13 Jan 2010 11:13:13 +0100
Message-ID: <20100113111313.3a6f0399@wker>
References: <1260625941-12179-1-git-send-email-agust@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:53671 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0AMKNW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2010 05:13:22 -0500
In-Reply-To: <1260625941-12179-1-git-send-email-agust@denx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Kashyap Desai <kashyap.desai@lsi.com>, Eric Moore <Eric.Moore@lsi.com>, James Bottomley <James.Bottomley@suse.de>

On Sat, 12 Dec 2009 14:52:21 +0100
Anatolij Gustschin <agust@denx.de> wrote:

> Since commit 9d2e9d66a3f032667934144cd61c396ba49f090d
> mptsas driver fails to allocate memory for the MPT chain buffers
> for second LSI adapter on PPC440SPe Katmai platform:
> ...
> ioc1: LSISAS1068E B3: Capabilities={Initiator}
> mptbase: ioc1: ERROR - Unable to allocate Reply, Request, Chain Buffers!
> mptbase: ioc1: ERROR - didn't initialize properly! (-3)
> mptsas: probe of 0002:31:00.0 failed with error -3
> 
> This commit increased MPT_FC_CAN_QUEUE value but initChainBuffers()
> doesn't differentiate between SAS and FC causing increased allocation
> for SAS case, too. Later pci_alloc_consistent() fails to allocate
> increased chain buffer pool size for SAS case.
> 
> Provide a fix by looking at the bus type and using appropriate
> MPT_SAS_CAN_QUEUE value while calculation of the number of chain
> buffers.

Could someone please comment on this patch? Thanks!

Anatolij

