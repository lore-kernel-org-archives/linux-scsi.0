From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] st.c for GET_IDLUN 2.6.6-rc2
Date: Wed, 28 Apr 2004 18:21:18 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404281752070.1103@kai.makisara.local>
References: <408B798B.50005@torque.net> <Pine.LNX.4.58.0404251153530.17534@kai.makisara.local>
 <408C5C72.4020301@torque.net> <Pine.LNX.4.58.0404261858140.24847@kai.makisara.local>
 <408F2820.4030605@torque.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep02-0.kolumbus.fi ([193.229.0.44]:60135 "EHLO
	fep02-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S261817AbUD1PVU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Apr 2004 11:21:20 -0400
In-Reply-To: <408F2820.4030605@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: osst@riede.org, linux-scsi@vger.kernel.org

On Wed, 28 Apr 2004, Douglas Gilbert wrote:

...
> Kai,
> Here is another take on this matter. A summary of the ioctls
> defined in block/scsi_ioctl.c follows with my comments:
> 
> ioctls defined in
> block/scsi_ioctl.c          Comment
> ==================          =======
> SCSI_IOCTL_SEND_COMMAND     redirects to scsi mid level
> SCSI_IOCTL_GET_IDLUN        yields 0 (wrong, trips up cdrecord??)
> SCSI_IOCTL_GET_BUS_NUMBER   yields 0 (wrong)
> SG_EMULATED_HOST            irrelevant to st (obsolete in sg)
> SG_GET_RESERVED_SIZE        irrelevant to st (to trick cdrecord)
> SG_GET_TIMEOUT              irrelevant to st (to trick cdrecord)
> SG_GET_VERSION_NUM          irrelevant to st (to trick cdrecord)
> SG_IO                       <<< only ioctl useful to st (+ osst) >>
> SG_SET_RESERVED_SIZE        irrelevant to st (to trick cdrecord)
> SG_SET_TIMEOUT              irrelevant to st (to trick cdrecord)
> CDROM_SEND_PACKET           irrelevant
> CDROMCLOSETRAY              irrelevant
> CDROMEJECT                  irrelevant
> 
> So if st just redirects only the SG_IO ioctl to scsi_cmd_ioctl()
> and lets the rest go to the scsi mid level (from where they can
> dribble down to the LLD) that solves the problem.
> 
If I read drivers/block/scsi_ioctl.c correctly, it contains a 
re-implementation of SCSI_IOCTL_SEND_COMMAND and it is then not redirected 
to mid level (again, I don't know why this has been done ;-). It is 
probably best that all SCSI drivers use the same implementation (and the 
other one is removed ...).

Your analysis is correct, and currently the only really useful thing 
implemented by scsi_cmd_ioctl() is SG_IO. However, I am an optimist and 
see a possibility that some other useful operations may be implemented in 
scsi_cmd_ioctl(). They may not be re-implementations of sg operations but 
something else useful for the users of the block layer. If only the buggy  
SCSI_IOCTL_GET_IDLUN and SCSI_IOCTL_GET_BUS_NUMBER are filtered in the 
high-level drivers, the new functions will be directly available.

-- 
Kai
