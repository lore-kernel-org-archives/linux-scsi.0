From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH 2/6] mpt fusion: Firmware Event implementation using
	seperate WorkQueue
Date: Tue, 07 Apr 2009 15:46:21 +0000
Message-ID: <1239119181.9096.21.camel@mulgrave>
References: <20090403115025.GC17721@lsi.com>
	 <1238782865.3359.78.camel@mulgrave.int.hansenpartnership.com>
	 <0D1E8821739E724A86F4D16902CE275C1410F4CA52@inbmail01.lsi.com>
	 <1239029135.3641.3.camel@mulgrave>
	 <0D1E8821739E724A86F4D16902CE275C1410F4CC13@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50851 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804AbZDGPqV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2009 11:46:21 -0400
In-Reply-To: <0D1E8821739E724A86F4D16902CE275C1410F4CC13@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

On Tue, 2009-04-07 at 19:18 +0530, Desai, Kashyap wrote:
> It is actually for some customer specific array. They are using multi
> pathing with LSI HBA. When switch over from one path to other path
> happens TUR request for that device won't reply immediately. It
> normally took ~150 seconds. 

A multi-pathing fix doesn't belong in your driver.  The correct place to
fix this is in the pathing software:  if it's dm-mp, it likely needs a
quiesce phase before probing the path.

The reason is that this will manifest for everyone, not just people
using LSI drivers.

James

> Since it is customer specific solution and they are planning to use
> upstream driver in future instead of LSI's inbox driver, I have posted
> it to upstream. Well, I will remove it once that specific need is no
> more required in future.


