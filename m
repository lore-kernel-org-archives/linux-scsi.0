From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] silence gcc warning about possibly uninitialized use
	of variable in scsi_scan
Date: Sun, 26 Feb 2006 12:21:24 -0600
Message-ID: <1140978084.3692.6.camel@mulgrave.il.steeleye.com>
References: <200602261639.15657.jesper.juhl@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:53995 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751349AbWBZSV1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Feb 2006 13:21:27 -0500
In-Reply-To: <200602261639.15657.jesper.juhl@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Youngdale <ericy@cais.com>, Eric Youngdale <eric@andante.org>, linux-scsi@vger.kernel.org

On Sun, 2006-02-26 at 16:39 +0100, Jesper Juhl wrote:
> Gcc can't see that 'result' will always be initialized inside the for loop
> and thus it warns
>   drivers/scsi/scsi_scan.c:445: warning: 'result' might be used uninitialized in this function
> This patch silences the warning by initializing 'result' to zero.

Really, this is a gcc bug.  My version of the compiler:

gcc version 4.0.3 20051201 (prerelease) (Debian 4.0.2-5)

Doesn't give this warning.  And, since the loop has fixed parameters,
gcc should see not only that it's always executed, but that it could be
unrolled.

Which version is causing the problem?

James


