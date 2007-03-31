From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Sat, 31 Mar 2007 13:46:27 -0500
Message-ID: <1175366787.3760.68.camel@mulgrave.il.steeleye.com>
References: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40335 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753824AbXCaSqb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2007 14:46:31 -0400
In-Reply-To: <NONAMEB98KtdhQYZkxO000005d5@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, promise_linux <promise_linux@promise.com>

On Fri, 2007-03-30 at 15:21 -0700, Ed Lin wrote:
> After reset completed, the scsi error handler sends out START_STOP
> and TEST_UNIT_READY to the device. For 'normal' devices these
> commands will be handled by firmware. However, because the RAID
> console only interfaces to scsi mid layer, the firmware will not process
> these commands for it. This will make the console to be offlined right
> after reset. Add the handling in driver to fix this problem.

I don't see how this explanation can be correct.  The error handler only
sends a START_STOP command if sdev->allow_restart is one, which you have
to set in the slave_configure routines (which stex doesn't).  If you're
seeing a START_STOP in the eh path, there's something else wrong.
TEST_UNIT_READY, certainly ... it's part of a restart check.

James


