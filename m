From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: (RAID controller) Unified way to get alarms
Date: Tue, 2 Mar 2004 09:37:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F38D237@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:36320 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261658AbUCBOhd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Mar 2004 09:37:33 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Fabien Salvi <fabien@cri74.org>, linux-scsi@vger.kernel.org

Unification would be nice, especially when internationalization is
required.

Currently syslogd does not support utf-8z and converts some of the
characters into escape sequences. The fix is simple, the path is long
...

/proc/ is being shunned in any case, I'd drop that one like a rock.

Drivers have no access to system language environment, so the
translation for internationalization definitely lives in the application
world.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Fabien Salvi
Sent: Tuesday, March 02, 2004 4:06 AM
To: linux-scsi@vger.kernel.org
Subject: (RAID controller) Unified way to get alarms

Hello,

I've noticed each PCI Raid card (for example ICP-Vortex ,LSILogic or 
ServerRAID) with their own driver uses a specific way to get alarms.

We could have several types of alarm or warning, depending on the event 
(degraded RAID, bad sectors detected, temperature sensor, etc...) :

- audible alarm ==> the more classical signal
- messages in kernel logs ==> not all drivers support this and each one 
send different messages
- messages in console ==> idem
- informations in /proc/scsi/... (for 2.4 kernel) ==> for example in 
/proc/scsi/gdth/0 with ICP controllers

- others ?


Unlike proprietary OS with proprietary (manufacter) driver, we have the 
ability under linux and with opensource drivers to use an unified way to

get warning and alarms from a RAID controller.

Why don't use it ?

It will permit a single tool to manage these events without writing one 
per driver...

-- 
Fabien SALVI
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
