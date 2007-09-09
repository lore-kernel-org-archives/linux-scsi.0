From: devzero@web.de
Subject: Re: [PATCH 1/2] fusion :  shost max_id not set in VMWare guest os
Date: Mon, 10 Sep 2007 00:58:39 +0200
Message-ID: <1969544227@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fmmailgate04.web.de ([217.72.192.242]:50115 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbXIIW67 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Sep 2007 18:58:59 -0400
Received: from web.de
	by fmmailgate04.web.de (Postfix) with SMTP id 8001D30F2213
	for <linux-scsi@vger.kernel.org>; Mon, 10 Sep 2007 00:58:40 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi ,=20

there`s probably another bug in VMWare LSI emulated scsi controller, re=
cent solaris builds crash the vmware process on boot (iirc, it was a re=
gression introduced in snv_63).

from what i`ve read so far it happens during scsi device initialization=
 from withing mpt driver, but unfortunately the mpt driver in solaris s=
eems to be closed source.

since there i found no more information within vmware community or with=
in opensolaris community about details of this bug - maybe anybody here=
 knows what`s causing this crash and if it can perhaps be reproduced fr=
om within linux ?
i`m even unsure if some hacker could exploit this to break out of a vir=
tual machine !? i`m running VMs in dmz setup.....

regards
roland



>[PATCH 1/2] fusion :  shost max_id not set in VMWare guest os
>
>In vmware guest os with emulated LSI 53c1030, the port facts config pa=
ge is
>not having MaxDevices initialized to 16 devices. Instead its set to ze=
ro.
>Thereforewhen driver loads, no devices are scanned for from scsi_scan_=
host.
>Prior to the3.04.04 driver, shost max_id was set to hard coded value \
>MPT_MAX_SCSI_DEVICES. After that release, support for greater than 255=
 targets was \
>added, and the driver was taking the target count from the port facts =
instead.  With \
>this patch we will restore the hard coded values for SPI, but at the s=
ame time use \
>the settingsneeded for SAS and Fibre Channel.
>
>Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

_______________________________________________________________________=
___
Erweitern Sie FreeMail zu einem noch leistungsst=E4rkeren E-Mail-Postfa=
ch!	=09
Mehr Infos unter http://produkte.web.de/club/?mc=3D021131

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
