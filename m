From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: T10 adds locally assigned UUID designation descriptor
Date: Mon, 08 Feb 2016 11:00:00 -0800
Message-ID: <1454958000.2543.39.camel@HansenPartnership.com>
References: <56B8D14D.7020502@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54298 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922AbcBHTAF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 14:00:05 -0500
In-Reply-To: <56B8D14D.7020502@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2016-02-08 at 12:33 -0500, Douglas Gilbert wrote:
> Recently, in draft spc5r08, T10 added a locally assigned RFC 4122
> UUID *** designation descriptor. That descriptor can now be
> returned for VPD page 0x83 (device identification) amongst others.
> It can be used anywhere SCSI needs a unique identifier expanding
> the previous set of preferred identifiers: EUI, NAA and SCSI_name
> (iSCSI).
> 
> In the soon to be released sg3_utils version 1.42 the new UUID
> designation descriptor is decoded including Hannes' --export
> option found in sg_inq, for example:
> 
> # sg_inq --export /dev/sg0
>    ...
>    SCSI_IDENT_LUN_UUID=11223344-5566-7788-aabb-ccddeeffffee
> 
> Perhaps some udev work is needed to incorporate this new identifier.

Hm, we're going to have to do this carefully.  With the move to GPT
partitions, both the UUID= designator in fstab and the /dev/disk/by
-uuid/ of udev means the GPT UUID.  In theory the design of the UUID
space is to allow random selection without clashing, so we could just
place the SCSI ones in here as well and perhaps there won't be a
problem, but I'd like us to think about the consequences first.

James

