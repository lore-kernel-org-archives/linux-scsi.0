From: "Seymour, Shane M" <shane.seymour@hpe.com>
Subject: RE: [PATCH] [SCSI] osst: remove double conversion of timeout
Date: Fri, 8 Jan 2016 00:02:18 +0000
Message-ID: <DDB9C85B850785449757F9914A034FCB445092F8@G9W0766.americas.hpqcorp.net>
References: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:19734 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbcAHACU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Jan 2016 19:02:20 -0500
In-Reply-To: <1452197433-26086-1-git-send-email-hofrat@osadl.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nicholas Mc Guire <hofrat@osadl.org>, Willem Riede <osst@riede.org>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "osst-users@lists.sourceforge.net" <osst-users@lists.sourceforge.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi Nicholas,

> -		msleep(jiffies_to_msecs(initial_delay));
> +		schedule_timeout_uninterruptible(initial_delay);
 
The code to msleep looks like this:

/**
 * msleep - sleep safely even with waitqueue interruptions
 * @msecs: Time in milliseconds to sleep for
 */
void msleep(unsigned int msecs)
{
	unsigned long timeout = msecs_to_jiffies(msecs) + 1;

	while (timeout)
		timeout = schedule_timeout_uninterruptible(timeout);
}

So msleep will wait for the requested amount of time to pass even if woken early but your change may not. To make it equivalent you would need to borrow code from msleep and remove the "if (initial_delay > 0)" and just have:

	while (initial_delay)
		initial_delay = schedule_timeout_uninterruptible(initial_delay);

We can change initial_delay since it's not used elsewhere in the function and if initial_delay is 0 we won't ever call schedule_timeout_uninterruptible in the while loop so there's no need to test if it's > 0 or not.
 
Thanks
Shane
