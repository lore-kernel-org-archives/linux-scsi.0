From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: sg driver and the error handler
Date: Wed, 11 May 2005 10:14:25 -0700
Message-ID: <20050511171425.GA9286@us.ibm.com>
References: <Pine.LNX.4.44L0.0505101433520.5058-100000@iolanthe.rowland.org> <20050510225831.GA4181@us.ibm.com> <42823565.9000806@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:18572 "EHLO e4.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262004AbVEKROi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2005 13:14:38 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4BHEXoR000329
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 13:14:33 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4BHEXc0121678
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 13:14:33 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4BHEWZc008490
	for <linux-scsi@vger.kernel.org>; Wed, 11 May 2005 13:14:32 -0400
Content-Disposition: inline
In-Reply-To: <42823565.9000806@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@SteelEye.com>, Doug Gilbert <dgilbert@interlog.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, May 11, 2005 at 12:40:05PM -0400, Luben Tuikov wrote:
> On 05/10/05 18:58, Patrick Mansfield wrote:
> > As you say, what you really want is the correct result going back to the
> > user, not the result of the TUR.
> > 
> > So save and restore the result in scsi_eh_tur, and also in scsi_eh_try_stu.
> > The request sense one already saves and restores it.
> 
> I think he even wants the stronger condition -- after the command is reclaimed
> from the LLDD, just send back the result to the application client.  And let
> the application client decide whether they want to send TUR or something else.

The TUR is part of the error recovery, and so it should be sent
independent of the timed out command.

I know we want to have transport specific error (or timeout) handling and
recovery. But for current usage, we should return the result of the
timeout to the upper level driver (and implicitly to the application).

-- Patrick Mansfield
