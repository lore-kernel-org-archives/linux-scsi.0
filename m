From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: RE: [PATCH 1/3] aacraid: add missing curly braces
Date: Fri, 18 Mar 2016 20:50:30 +0000
Message-ID: <198D06D448A18D4E93F08FB849C4E39D7D218372@BBYEXM01.pmc-sierra.internal>
References: <1457965789-3373916-1-git-send-email-arnd@arndb.de>
 <1457965789-3373916-2-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37812 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751546AbcCRUub convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2016 16:50:31 -0400
In-Reply-To: <1457965789-3373916-2-git-send-email-arnd@arndb.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, Tomas Henzl <thenzl@redhat.com>, Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>, Fengguang Wu <fengguang.wu@intel.com>


> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Monday, March 14, 2016 7:30 AM
> To: martin.petersen@oracle.com;
> James.Bottomley@HansenPartnership.com; Adaptec OEM Raid Solutions;
> James E.J. Bottomley
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Arnd
> Bergmann; Johannes Thumshirn; Tomas Henzl; Mahesh Rajashekhara;
> Raghava Aditya Renukunta; Fengguang Wu
> Subject: [PATCH 1/3] aacraid: add missing curly braces
> 
> gcc-6 warns about obviously wrong indentation for newly added
> code in aac_slave_configure():
> 
> drivers/scsi/aacraid/linit.c: In function 'aac_slave_configure':
> drivers/scsi/aacraid/linit.c:458:3: warning: statement is indented as if it were
> guarded by... [-Wmisleading-indentation]
>    sdev->tagged_supported = 1;
>    ^~~~
> drivers/scsi/aacraid/linit.c:455:4: note: ...this 'else' clause, but it is not
> 
> gcc is correct, and evidently this was meant to be within the curly
> braces that should have been there to start with. This patch adds
> them, which avoids the warning and makes it clear what was intended
> here.
> 
> Nothing changes in behavior because in the 'if' block, the
> sdev->tagged_supported flag is known to be set already.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 6bf3b630d0a7 ("aacraid: SCSI blk tag support")
> ---
>  drivers/scsi/aacraid/linit.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
> index 21a67ed047e8..ff6caab8cc8b 100644
> --- a/drivers/scsi/aacraid/linit.c
> +++ b/drivers/scsi/aacraid/linit.c
> @@ -452,10 +452,11 @@ static int aac_slave_configure(struct scsi_device
> *sdev)
>  		else if (depth < 2)
>  			depth = 2;
>  		scsi_change_queue_depth(sdev, depth);
> -	} else
> +	} else {
>  		scsi_change_queue_depth(sdev, 1);
>  		sdev->tagged_supported = 1;
> +	}
> 
>  	return 0;
>  }
> --
> 2.7.0

Reviewed-by: Raghava Aditya Renukunta < raghavaaditya.renukunta@pmcs.com >

Regards,
Raghava Aditya

