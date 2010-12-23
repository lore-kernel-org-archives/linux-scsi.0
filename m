From: Chuck Tuffli <ctuffli@gmail.com>
Subject: Re: [RFC] lldd_I_T_nexus_reset use in sas_ata.c
Date: Thu, 23 Dec 2010 14:56:25 -0800
Message-ID: <AANLkTim2dnMU5oH6vZdFL80U85KcTfTGikXwKDzFRuON@mail.gmail.com>
References: <AANLkTimTDLOv8A7Vq3y6-8L4VA8PpU135fSQZH8SgaKQ@mail.gmail.com>
	<1293138306.10141.14.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65357 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0LWW40 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 17:56:26 -0500
Received: by wyb28 with SMTP id 28so6529402wyb.19
        for <linux-scsi@vger.kernel.org>; Thu, 23 Dec 2010 14:56:25 -0800 (PST)
In-Reply-To: <1293138306.10141.14.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, Dec 23, 2010 at 1:05 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Thu, 2010-12-23 at 11:34 -0800, Chuck Tuffli wrote:
>> Can some shed light on why sas_ata_phy_reset() does an I_T nexus
>> reset? It seems like calling sas_phy_reset() might be more accurate =
in
>> this case. Thanks.
>
> It needs an ATA reset that propagates. =A0ATA resets don't key off SA=
S phy
> resets, they have a separate reset sequence, which is triggered by th=
e
> I_T nexus reset.

Maybe this is a misunderstanding on my part, but I thought there were
two ways to reset ATA devices connected to SAS/SMP:
- SRST FIS or
- issuing a link reset via LOCAL_PHY_CONTROL / SMP_PHY_CONTROL

Since sas_phy_reset() triggers the second case and three of the SAS
drivers (aic94xx, mvsas, pm8001) all internally call sas_phy_reset()
as a part of the I_T nexus reset, it seemed like this was a more
direct and consistent approach.

---chuck
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
