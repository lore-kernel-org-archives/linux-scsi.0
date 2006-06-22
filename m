From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 1/2] Improve SCSI device type decoding
Date: Wed, 21 Jun 2006 22:42:11 -0400
Message-ID: <449A0383.7030503@torque.net>
References: <20060621165300.GX1630@parisc-linux.org> <449989BB.1010205@torque.net> <20060621184842.GA1630@parisc-linux.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:6338 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S932601AbWFVCnR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Jun 2006 22:43:17 -0400
In-Reply-To: <20060621184842.GA1630@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Jun 21, 2006 at 02:02:35PM -0400, Douglas Gilbert wrote:
> 
>>Not forgetting peripheral device types 1eh and 1fh
>>which are well known logical unit and unknown or
>>no device type respectively.
> 
> 
> I don't think you read the whole patch ;-)

Obviously not closely enough.

> +       if (type == 0x1e)
> +               return "Well-known LUN   ";
> +       if (type > ARRAY_SIZE(scsi_device_types))
> +               return "Unknown          ";
> 
> Did you want to distinguish between a device of type unknown and a
> device type Linux doesn't know about?

If a device server yields a peripheral qualifier of 3
in a INQUIRY response (e.g. for the "lun 0" trick when
there are lun_s>0) then the associated pdt should be
set to 1fh. The unallocated pdt_s are marked as "reserved"
in the draft.
It is also possible that a drive with removable media
may not want to commit to a pdt before it sees media.
So I would prefer to see the distinction.


Doug Gilbert

