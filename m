From: Don Brace <Don.Brace@pmcs.com>
Subject: RE: [PATCH 2/2] cciss: correct the non-resettable board list
Date: Tue, 19 May 2015 18:56:44 +0000
Message-ID: <07F70BBF6832E34FA1C923241E8833AB486AA28D@BBYEXM01.pmc-sierra.internal>
References: <1424191222-30570-1-git-send-email-thenzl@redhat.com>
 <1424191222-30570-2-git-send-email-thenzl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:43027 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbbESS4p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 May 2015 14:56:45 -0400
In-Reply-To: <1424191222-30570-2-git-send-email-thenzl@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "axboe@kernel.dk" <axboe@kernel.dk>

> -----Original Message-----
> From: Tomas Henzl [mailto:thenzl@redhat.com]
> Sent: Tuesday, February 17, 2015 10:40 AM
> To: linux-scsi@vger.kernel.org
> Cc: Don Brace; linux-kernel@vger.kernel.org; axboe@kernel.dk
> Subject: [PATCH 2/2] cciss: correct the non-resettable board list
> 
> The hpsa driver carries a more recent version,
> copy the table from there.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> ---
>  drivers/block/cciss.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> index 48498220cd..0ca65b25ef 100644
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -582,12 +582,32 @@ static u32 unresettable_controller[] = {
>  	0x3215103C, /* Smart Array E200i */
>  	0x3237103C, /* Smart Array E500 */
>  	0x323D103C, /* Smart Array P700m */
> +	0x40800E11, /* Smart Array 5i */
>  	0x409C0E11, /* Smart Array 6400 */
>  	0x409D0E11, /* Smart Array 6400 EM */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
>  };
> 
>  /* List of controllers which cannot even be soft reset */
>  static u32 soft_unresettable_controller[] = {
> +	0x40800E11, /* Smart Array 5i */
> +	0x40700E11, /* Smart Array 5300 */
> +	0x40820E11, /* Smart Array 532 */
> +	0x40830E11, /* Smart Array 5312 */
> +	0x409A0E11, /* Smart Array 641 */
> +	0x409B0E11, /* Smart Array 642 */
> +	0x40910E11, /* Smart Array 6i */
> +	/* Exclude 640x boards.  These are two pci devices in one slot
> +	 * which share a battery backed cache module.  One controls the
> +	 * cache, the other accesses the cache through the one that controls
> +	 * it.  If we reset the one controlling the cache, the other will
> +	 * likely not be happy.  Just forbid resetting this conjoined mess.
> +	 */
>  	0x409C0E11, /* Smart Array 6400 */
>  	0x409D0E11, /* Smart Array 6400 EM */
>  };
> @@ -4663,8 +4683,7 @@ static int cciss_kdump_hard_reset_controller(struct
> pci_dev *pdev)
>  	 */
>  	cciss_lookup_board_id(pdev, &board_id);
>  	if (!ctlr_is_resettable(board_id)) {
> -		dev_warn(&pdev->dev, "Cannot reset Smart Array 640x "
> -				"due to shared cache module.");
> +		dev_warn(&pdev->dev, "Controller not resettable\n");
>  		return -ENODEV;
>  	}
> 
> --
> 1.9.3
Signed-off-by Don Brace <don.brace@pmcs.com>
