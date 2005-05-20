From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] Sanitize PQ3 device handling (Take #2)
Date: Fri, 20 May 2005 14:40:30 -0700
Message-ID: <20050520214030.GA8925@us.ibm.com>
References: <428CA4E3.9030601@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:20637 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S261378AbVETVxg
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 17:53:36 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j4KLrZmD722616
	for <linux-scsi@vger.kernel.org>; Fri, 20 May 2005 17:53:35 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4KLrZwj253184
	for <linux-scsi@vger.kernel.org>; Fri, 20 May 2005 15:53:35 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j4KLrYfj020609
	for <linux-scsi@vger.kernel.org>; Fri, 20 May 2005 15:53:35 -0600
Content-Disposition: inline
In-Reply-To: <428CA4E3.9030601@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, May 19, 2005 at 04:38:27PM +0200, Hannes Reinecke wrote:
> Hi James,
> 
> this is an updated version of the patch. As I suspected, the issue isn't
> quite as easy. Problem is that older SCSI-2 device have the habit for
> responding to LUN1 in addition to LUN0, even though only one device is
> attached. LUN1 has set PQ to 3 accordingly.
> And of course we _don't_ want those fake devices to stick around.
> So I've improved the logic to not register devices with LUN != 0 and a
> PQ of 1 or 3. All other devices are registered accordingly.
> 
> I can't really see why we should register devices with PQ 1 and LUN !=
> 0; if one wants to have them he still can do a REPORT LUN on LUN 0 and
> an explicit scan for the missing device.
> 
> And I do think the locking is slightly wrong for the failure case;
> without this adaptecs have a habit of crashing when doing a rmmod.

Is that what the extra put's are fixing? That should be a separate patch.

> But again, comments etc are welcome.

I had a similar patch, that did not leave LUN 0 configured: 

http://marc.theaimsgroup.com/?l=linux-scsi&m=110297733824960&w=2

It did not change handling of PQ.

I don't have a strong opinion for either direction, but having LUN 0 with
and sometimes without an sd there bothers me. Pick your poison ...

Long term, a way to access any LUN on a target from user space would be
very useful, not just LUN 0.

And ...

> --- linux-2.6.12-rc4/drivers/scsi/scsi_scan.c.orig	2005-05-19 15:57:51.000000000 +0200
> +++ linux-2.6.12-rc4/drivers/scsi/scsi_scan.c	2005-05-19 16:18:26.000000000 +0200
> @@ -64,15 +64,15 @@
>   * SCSI_SCAN_NO_RESPONSE: no valid response received from the target, this
>   * includes allocation or general failures preventing IO from being sent.
>   *
> - * SCSI_SCAN_TARGET_PRESENT: target responded, but no device is available
> - * on the given LUN.
> + * SCSI_SCAN_TARGET_IGNORED: target responded, but is ignored from the
> + * midlayer
>   *
> - * SCSI_SCAN_LUN_PRESENT: target responded, and a device is available on a
> - * given LUN.
> + * SCSI_SCAN_TARGET_PRESENT: target responded, and is registered with the
> + * midlayer
>   */
>  #define SCSI_SCAN_NO_RESPONSE		0
> -#define SCSI_SCAN_TARGET_PRESENT	1
> -#define SCSI_SCAN_LUN_PRESENT		2
> +#define SCSI_SCAN_TARGET_IGNORED	1
> +#define SCSI_SCAN_TARGET_PRESENT	2

I prefer naming with all LUN in all the defines since we are returning LUN
status, or leave as is. For SCSI_SCAN_TARGET_IGNORED, we are not
configuring the LUN.

i.e. keep the original:

#define SCSI_SCAN_NO_RESPONSE		0
#define SCSI_SCAN_TARGET_PRESENT	1
#define SCSI_SCAN_LUN_PRESENT		2

Or:

#define SCSI_SCAN_NO_RESPONSE		0
#define SCSI_SCAN_LUN_IGNORED		1
#define SCSI_SCAN_LUN_PRESENT		2


You should add code to not print the "unknown device type" if PQ 3 or 1,
or special case type 31 (0x1f).

SCSI spec says for PQ of 011 (3):

	The device server is not capable of supporting a peripheral device
	on this logical unit.  For this peripheral qualifier the
	peripheral device type shall be set to 1Fh to provide
	compatibility with previous versions of SCSI.

We see the warnings now even for PQ of 1 (I don't know the age of these
devices):

scsi: unknown device type 31
  Vendor: IBM       Model: 5703001           Rev: 0150
    Type:   Unknown                            ANSI SCSI revision: 00

For PQ of 3 there should be a lot more.

-- Patrick Mansfield
