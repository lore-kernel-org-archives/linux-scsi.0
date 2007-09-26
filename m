From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] SCSI bug fix for 2.6.23-rc8
Date: Tue, 25 Sep 2007 20:57:01 -0500
Message-ID: <1190771821.8707.25.camel@localhost.localdomain>
References: <1190742924.3345.42.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55706 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbXIZB5E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 21:57:04 -0400
In-Reply-To: <1190742924.3345.42.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Tue, 2007-09-25 at 12:55 -0500, James Bottomley wrote:
> This is, unfortunately, not a recent regression but it's only been
> recently diagnosed.  Apparently the SCSI Parallel transport class domain
> validation cable width detection wasn't working, leading to cases where
> controllers with damaged cables would end up hanging the system (the
> reported one was an aic79xx controller, but the potential is there for
> all SPI based systems).  This bug would *only* affect systems whose
> cable integrity or connectors were compromised, so it isn't life
> threatening to every SCSI Parallel installation, but the consequence of
> running into it is a system hang.
> 
> The fix is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> James Bottomley (1):
>       scsi_transport_spi: fix domain validation failure from incorrect
> width setting
> 
> And the diffstat:
> 
>  scsi_transport_spi.c |   28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)

We've had another late arriving bug fix:

commit ff4abd6cfacf0bb23a077f615d3a5cd17359db1b
Author: David Miller <davem@davemloft.net>
Date:   Fri Aug 24 22:25:58 2007 -0700

    [SCSI] esp: fix instance numbering.
    
    Because the ->unique_id is set too late, the ESP scsi host
    instance numbers in the kernel log during probing are
    wrong.
    
    Bug reported by Meelis Roos.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

Which I've added.  The diffstat is now:

 esp_scsi.c           |    3 ++-
 scsi_transport_spi.c |   28 ++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

James


