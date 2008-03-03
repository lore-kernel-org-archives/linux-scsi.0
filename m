From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mvsas: fix default can_queue
Date: Sun, 02 Mar 2008 18:42:25 -0600
Message-ID: <1204504945.3069.30.camel@localhost.localdomain>
References: <1204308113.4003.45.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:46916 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbYCCAmb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Mar 2008 19:42:31 -0500
In-Reply-To: <1204308113.4003.45.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


On Fri, 2008-02-29 at 12:01 -0600, James Bottomley wrote:
> I noticed that the current marvell sas driver wasn't performing very
> well.  It turns out that it's setting can_queue not in the SCSI host,
> but in its own internal data structure, meaning it's always operating
> with a global queue depth of one.  This patch raises it to what the code
> seemed to be intending ... although I think can_queue should be
> MVS_CHIP_SLOT_SZ - 1 (without the divide by two)?
> 
> The good news is that with this change, I'm getting a respectable
> throughput on the fio hammer test; plus zapping random phy resets across
> the disk triggers error handler recovery correctly (so far).
> 
> I'm having less happy results with a SATAPI DVD ... it looks like the
> initial IDENTIFY goes across just fine, but that we stall on the other
> SCSI commands ... I'm still investigating this one.

Actually, I've run into another problem with this patch applied.  It
looks like NCQ fails with ATA disks.  What I see is that I/O goes fine
until I get more than one command outstanding to the device, then the
device stops responding.  I can keep the I/O flowing if I clamp the
device queue depth at 1.  SAS disks seem to be fine ... I can get
multiple outstanding commands to them correctly serviced.

James


