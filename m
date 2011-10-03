From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [SCSI] remove arbitrary SD_MAX_DISKS namespace limit
Date: Mon, 03 Oct 2011 12:57:59 -0500
Message-ID: <1317664679.3041.48.camel@dabdike.int.hansenpartnership.com>
References: <4E89E721.7000308@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60074 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756694Ab1JCR6C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2011 13:58:02 -0400
In-Reply-To: <4E89E721.7000308@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2011-10-03 at 11:47 -0500, Dave Kleikamp wrote:
> I see no reason to limit the SCSI disk namespace to sdXXX. We test
> systems with more than 18278 LUNs.

I suppose we kept the old limit for historical reasons, so I've no real
objection to raising it, except the error messages now need to be beefed
up.  We need one for the ida_get_new() failure and the original
exhaustion messages needs to move to the sd_format_disk_name() check ...
that's now what checks we don't go over the possible size in
DISK_NAME_LEN (I know at 32 it's way beyond INT_MAX ... but just in case
someone decides to lower it) ... probably it's the same error message
(but better make it unique for the static checkers).

James


