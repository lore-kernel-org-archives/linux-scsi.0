From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] bnx2fc: shift wrapping bug in
 bnx2fc_process_unsol_compl()
Date: Mon, 28 Nov 2016 16:24:45 +0300
Message-ID: <20161128132137.GR6266@mwanda>
References: <20161126183629.9969-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50935 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754505AbcK1NZ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Nov 2016 08:25:26 -0500
Content-Disposition: inline
In-Reply-To: <20161126183629.9969-1-christophe.jaillet@wanadoo.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: QLogic-Storage-Upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, Nov 26, 2016 at 07:36:29PM +0100, Christophe JAILLET wrote:
> BNX2FC_NUM_ERR_BITS is 63. err_warn_bit_map is a u64. So, to make sure that
> no shift wrapping will occur, we need need additionnal casting.
> 
> The same test is already done a few lines above and '(u64)1' is already
> used there. So just do the same here.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> I guess that this could also be written with a '1ULL << i' which would be
> cleaner and less verbose IMHO, but apparently this driver does not use
> such things yet. So keep the current style with casting.

Ugh...  No.  This is not code to emulate.  Use 1ULL << i.  Even if we
did the cast, you would only need one:

			if (err_warn_bit_map & ((u64)1 << i)) {


regards,
dan carpenter

