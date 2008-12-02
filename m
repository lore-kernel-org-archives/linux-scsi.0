From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: aacraid: Adaptec 2200S support broken on x86_64 by commit 94cf6ba11b068b8a8f68a1e88bffb6827e92124b
Date: Tue, 2 Dec 2008 10:59:02 -0600
Message-ID: <20081202165902.GA9524@auslistsprd01.us.dell.com>
References: <48D10E1A.8030804@siemens.com> <48EB6600.9020204@redhat.com> <20081110152006.8982133b.akpm@linux-foundation.org> <1226377257.5014.88.camel@localhost.localdomain> <20081110205453.1c0e4f69.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:65351 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbYLBQ7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 11:59:10 -0500
Content-Disposition: inline
In-Reply-To: <20081110205453.1c0e4f69.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tomas Henzl <thenzl@redhat.com>, gernot.hillier@siemens.com, aacraid@adaptec.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mark_salyzyn@adaptec.com, Thomas Guyot-Sionnest <dermoth@aei.ca>, stable@kernel.org

On Mon, Nov 10, 2008 at 08:54:53PM -0800, Andrew Morton wrote:
> On Mon, 10 Nov 2008 20:20:57 -0800 James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > Could someone from Adaptec and Dell please verify that this is correct?
> > Mark Salyzyn no longer works there, but the aacraid@adaptec.com address
> > is supposed to still be working.
> 
> Here is the patch:
> 
> 
> 
> From: Tomas Henzl <thenzl@redhat.com>
> 
> A lot of 64bit machines with Adaptec 2200S and 2120S controllers don't
> recognize SCSI disks any more with the patch "fix driver failure with Dell
> PowerEdge Expandable RAID Controller 3/Di", but fail with tons of "aac_srb:
> aac_fib_send failed with status: 8195" instead. This patch disables the
> quirk introduced in the change cited above for those two controllers again.
> 
> Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> Cc: <aacraid@adaptec.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Tested-by: Thomas Guyot-Sionnest <dermoth@aei.ca>
> Cc: <stable@kernel.org>		[2.6.27.x, 2.6.26.x, 2.6.25.x]
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/aacraid/linit.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff -puN drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s drivers/scsi/aacraid/linit.c
> --- a/drivers/scsi/aacraid/linit.c~aacraid-disable-dell-percraid-quirk-on-adaptec-2200s-and-2120s
> +++ a/drivers/scsi/aacraid/linit.c
> @@ -175,8 +175,8 @@ static struct aac_driver_ident aac_drive
>  	{ aac_rx_init, "percraid", "DELL    ", "PERCRAID        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* PERC 3/Di (Boxster/PERC3DiB) */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "catapult        ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* catapult */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "tomcat          ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* tomcat */
> -	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2120S (Crusader) */
> -	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan) */
> +	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2120S   ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2120S (Crusader) */
> +	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG },		      /* Adaptec 2200S (Vulcan) */
>  	{ aac_rx_init, "aacraid",  "ADAPTEC ", "Adaptec 2200S   ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Adaptec 2200S (Vulcan-2m) */
>  	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S220     ", 1, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S220 (Legend Crusader) */
>  	{ aac_rx_init, "aacraid",  "Legend  ", "Legend S230     ", 2, AAC_QUIRK_31BIT | AAC_QUIRK_34SG | AAC_QUIRK_SCSI_32 }, /* Legend S230 (Legend Vulcan) */
> _


Dell's storage teams have been investigating, to be sure those are the
only known affected cards.  To the best of everyone's knowledge here,
this is correct.

Please apply at your earliest convenience.

Thanks,
Matt

-- 
Matt Domsch
Linux Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
