From: "Stephen J. Gowdy" <gowdy@slac.stanford.edu>
Subject: Re: USB multi card reader == SCSI multi lun target
Date: Mon, 1 Sep 2003 17:41:38 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.55.0309011741030.1870@localhost.localdomain>
References: <3F53E4FF.80401@torque.net>
Reply-To: gowdy@slac.stanford.edu
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp8.Stanford.EDU ([171.67.16.35]:43746 "EHLO
	smtp8.Stanford.EDU") by vger.kernel.org with ESMTP id S263400AbTIBAlw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Sep 2003 20:41:52 -0400
In-Reply-To: <3F53E4FF.80401@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

BTW, this is in the Linux USB FAQ;

http://www.linux-usb.org/FAQ.html#ts9


On Tue, 2 Sep 2003, Douglas Gilbert wrote:

> This is probably old news to USB folks but those
> nifty little USB multi card readers (e.g. CF, SD,
> MMC, SMC cards etc) appear in Linux as multi lun
> targets.
>
> Most distros only scan for lun 0 **. So to see
> luns > 0, commands like these are needed:
>
> echo "scsi add-single-device 1 0 0 1" > /proc/scsi/scsi
> echo "scsi add-single-device 1 0 0 2" > /proc/scsi/scsi
> echo "scsi add-single-device 1 0 0 3" > /proc/scsi/scsi
>
> The above sequence was needed for a 4 slot multi card reader.
> Following is some /proc/scsi/scsi output after an
> "scsi add-single-device 1 0 0 1" in a 2 slot multi card reader.
> Notice the end of the model string tells you what type of
> card is read at that lun.
>
> # cat /proc/scsi/scsi
> Attached devices:
> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>    Vendor: hp       Model: scanjet 7400c    Rev: 0.8A
>    Type:   Scanner                          ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>    Vendor: Generic  Model: USB Storage-SMC  Rev: 0090
>    Type:   Direct-Access                    ANSI SCSI revision: 02
> Host: scsi1 Channel: 00 Id: 00 Lun: 01
>    Vendor: Generic  Model: USB Storage-CFC  Rev: 0090
>    Type:   Direct-Access                    ANSI SCSI revision: 02
>
>
> ** Most distros don't set CONFIG_SCSI_MULTI_LUN because some
> "scsi" devices answer all luns. I think that bug in ide-scsi
> has been fixed in lk 2.4.22 (I've sent patches to this list
> for 2.4 and 2.5 to fix this). A scipt may be useful to scan
> the output of /proc/scsi/scsi for this class of device and if
> found manually scan for luns > 0.
>
> Doug Gilbert
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--
 /------------------------------------+-------------------------\
|Stephen J. Gowdy                     | SLAC, MailStop 34,       |
|http://www.slac.stanford.edu/~gowdy/ | 2575 Sand Hill Road,     |
|http://calendar.yahoo.com/gowdy      | Menlo Park CA 94025, USA |
|EMail: gowdy@slac.stanford.edu       | Tel: +1 650 926 3144     |
 \------------------------------------+-------------------------/
