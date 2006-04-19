From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Vendor specific cdrom error messages
Date: Wed, 19 Apr 2006 15:02:32 -0400
Message-ID: <44468948.6000109@torque.net>
References: <e25obb$2fp$1@sea.gmane.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55757 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751172AbWDSTCr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Apr 2006 15:02:47 -0400
In-Reply-To: <e25obb$2fp$1@sea.gmane.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Orion Poplawski <orion@cora.nwra.com>
Cc: linux-scsi@vger.kernel.org

Orion Poplawski wrote:
> I got the following error trying to burn a DVD on an IBM USB2 DVD-R burner:
> 
> Nov  7 11:40:36 makani kernel: cdrom: This disc doesn't have any tracks
> I recognize!
> Nov  7 11:41:59 makani kernel: sr 0:0:0:0: SCSI error: return code =
> 0x8000002
> Nov  7 11:41:59 makani kernel: sr0: Current: sense key: Data Protect
> Nov  7 11:41:59 makani kernel:     ASC=0x27 <<vendor>> ASCQ=0xff
> 
> This is on Fedora Core 4 and kernel 2.6.13-1.1532_FC4.
> 
> It turns out that this is because the drive did not have enough power
> (it was not plugged into the separate ac adapter).  I was able to
> determine this by booting into Windows, which gave me a nice descriptive
> error message.
> 
> I was wondering if it makes sense for the kernel drivers to know these
> error messages and report better errors, of it should be left up to user
> space tools.

I think that you can guess the answer to the above query.
Asc and/or ascq codes >= 0x80 (and <= 0xff) mark the
additional sense code as vendor specific.

The ascq code looks suspicious. An asc/ascq tuple of
<0x27,0x0> ("Write protected") would tie in pretty well
with the sense key of "Data Protect". A better choice
might be <0x5e,0x0> "Low power condition on".

Doug Gilbert

