From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: What does scsi_level mean?
Date: Sun, 22 Jul 2007 13:00:21 -0700
Message-ID: <20070722130021.4ca93fb0.randy.dunlap@oracle.com>
References: <4104961b0707202239i3e4be45asb7b7697b5e366fba@mail.gmail.com>
	<4104961b0707220342k1da5163cl9c3f077cfbe3cc06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:55109 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbXGVT4b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Jul 2007 15:56:31 -0400
In-Reply-To: <4104961b0707220342k1da5163cl9c3f077cfbe3cc06@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jidong xiao <jidong.xiao@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 22 Jul 2007 18:42:14 +0800 jidong xiao wrote:

> Any one can kindly explain this?
> 
> Thanks
> Jason Xiao
> 
> On 7/21/07, jidong xiao <jidong.xiao@gmail.com> wrote:
> > I noticed that there is a char scsi_level in the struct scsi_device,
> > what does scsi_level mean?
> >
> > struct scsi_device {
> > ...
> >        char scsi_level;
> > ...
> > }

Does this help?
It's explained in include/scsi/scsi.h as:

/*
 *  struct scsi_device::scsi_level values. For SCSI devices other than those
 *  prior to SCSI-2 (i.e. over 12 years old) this value is (resp[2] + 1)
 *  where "resp" is a byte array of the response to an INQUIRY. The scsi_level
 *  variable is visible to the user via sysfs.
 */

#define SCSI_UNKNOWN    0
#define SCSI_1          1
#define SCSI_1_CCS      2
#define SCSI_2          3
#define SCSI_3          4        /* SPC */
#define SCSI_SPC_2      5
#define SCSI_SPC_3      6


> > Is it SCSI revision?
> > If the answer is true, then I am quite curious, from the code I have
> > read, SCSI_2 is something special, see following function:
> > picked up from drivers/scsi/scsi_sysfs.c:
> > int scsi_sysfs_target_initialize(struct scsi_device *sdev){
> >                /*
> >                 * If there wasn't another lun already configured at
> >                 * this target, then default this device to SCSI_2
> >                 * until we know better
> >                 */
> >                sdev->scsi_level = SCSI_2;
> > }
> >
> > Why SCSI_2 could be the default value, why not SCSI_1, why not SCSI_3,
> > and etc.Seems SCSI_2 is distinguished from other levels,any reason for
> > this?
> >
> > Thanks
> > Jason Xiao



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
