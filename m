From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: RFC: Move SG_GET_SCSI_ID from sg to scsi
Date: Mon, 27 Mar 2006 16:22:12 -0600
Message-ID: <1143498132.3334.28.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.58.0603061133070.2997@be1.lrz>
	 <440C8E60.6020005@torque.net> <440D9F8E.7050402@s5r6.in-berlin.de>
	 <442861C4.7080304@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:57533 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751098AbWC0WWY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Mar 2006 17:22:24 -0500
In-Reply-To: <442861C4.7080304@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Bodo Eggert <7eggert@gmx.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2006-03-27 at 17:05 -0500, Douglas Gilbert wrote:
> I have been reviewing this thread and had one point
> to add here.
> 
> The identity of the initiator port is important, at
> least to a SCSI target that can implement (PERSISTENT)
> RESERVE on behalf of one of its logical units.
> So you may need to keep the equivalent of Scsi_Host:this_id
> somewhere.

Since Scsi_Host:this_id is an integer, it's impossible that a
TransportID (which is what you use to identify the port) would ever fit
into it, since these are defined to be at least 24 bytes long.

> That is another shortcoming of the <hctl> tuple: the
> initiator port isn't there.

Actually, it may not be in HCIL, but it is in the transport classes
(although the only implementor is FC at this time, I think).  And that's
where it should be since format and contents of the transport ID are
transport specific.

James


