From: "Hillier, Gernot" <gernot.hillier@siemens.com>
Subject: Re: aacraid: Adaptec 2200S support broken on x86_64 by commit 94cf6ba11b068b8a8f68a1e88bffb6827e92124b
Date: Tue, 07 Oct 2008 17:48:30 +0200
Message-ID: <48EB84CE.2020702@siemens.com>
References: <48D10E1A.8030804@siemens.com> <48EB6600.9020204@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thoth.sbs.de ([192.35.17.2]:21388 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753092AbYJGPoM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Oct 2008 11:44:12 -0400
In-Reply-To: <48EB6600.9020204@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>, aacraid@adaptec.com, mark_salyzyn@adaptec.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Tomas Henzl wrote:
> Hillier, Gernot wrote:
>> On our AMD64 machines equipped with old Adaptec 2200S controllers, we
>> experienced a regression when updating to 2.6.25. The machines won't
>> boot anymore (in a reasonable time), but instead spit out tons of those
>> messages:
>> aac_srb: aac_fib_send failed with status: 8195
[...]
>> We found that this regression seems to be introduced by the bugfix
>> "aacraid: fix driver failure with Dell PowerEdge Expandable RAID Controller 3/Di":
>> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=94cf6ba11b068b8a8f68a1e88bffb6827e92124b
[...]
> from what I read about this it seems to me that people are complaining also about issues with the 2120S Controller.
> So if the patch is taken in this form the original patch should be extended to cover both controllers.
> 
> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> 
> ---
> diff -Naurp linux-2.6.18.i686b/drivers/scsi/aacraid/linit.c linux-2.6.18.i686p6/drivers/scsi/aacraid/linit.c
> --- linux-2.6.18.i686b/drivers/scsi/aacraid/linit.c	2008-09-25 18:06:23.000000000 +0200
> +++ linux-2.6.18.i686p6/drivers/scsi/aacraid/linit.c	2008-10-03 12:12:06.000000000 +0200
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
> 
> 
> 

All our tests with this patch enabled look good so far and comment #30 in
[1] also states that removing AAC_QUIRK_SCSI_32 for those controllers fixes
the problem.

As the original workaround was only intended to fix things on the DELL
PERCRAID, I'd be glad to see our patch being applied to disable the
workaround for our controllers again.

I didn't provide a description for the original patch yet (sorry), so
here's a suggestion:

--- SNIP ---
aacraid: disable Dell Percraid quirk on Adaptec 2200S and 2120S

A lot of 64bit machines with Adaptec 2200S and 2120S controllers don't
recognize SCSI disks any more with the patch "fix driver failure with Dell
PowerEdge Expandable RAID Controller 3/Di", but fail with tons of "aac_srb:
aac_fib_send failed with status: 8195" instead. This patch disables the
quirk introduced in the change cited above for those two controllers again.

Signed-off-by: Gernot Hillier <gernot.hillier@siemens.com>
--- SNAP ---

[1] https://bugzilla.redhat.com/show_bug.cgi?id=453472

-- 
Gernot Hillier, Siemens AG, CT SE 2
