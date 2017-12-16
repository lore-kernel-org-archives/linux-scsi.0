From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: scsi_devinfo: devices and pattern matching
Date: Sat, 16 Dec 2017 14:31:34 +0100
Message-ID: <bebefebe-e1b8-5f15-a59d-ed5099ebcf4e@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f45.google.com ([74.125.82.45]:42906 "EHLO
        mail-wm0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752724AbdLPNbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Dec 2017 08:31:39 -0500
Received: by mail-wm0-f45.google.com with SMTP id b199so22142072wme.1
        for <linux-scsi@vger.kernel.org>; Sat, 16 Dec 2017 05:31:38 -0800 (PST)
Content-Language: en-GB
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Alan Stern <stern@rowland.harvard.edu>, Bart Van Assche <bart.vanassche@wdc.com>, Martin Wilck <mwilck@suse.com>, Martin Petersen <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

Hi,

After last pattern matching changes, maybe some entries should be revised:


Empty strings(current meaning?):
	{"", "Scanner", "1.80", BLIST_NOLUN},	/* responds to all lun */
	{"Promise", "", NULL, BLIST_SPARSELUN},
	{"HP", "C1790A", "", BLIST_NOLUN},		/* scanjet iip */
	{"HP", "C2500A", "", BLIST_NOLUN},		/* scanjet iicx */


Overlapping(?) strings(remove one???):
	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},

	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
	
	{"Promise", "", NULL, BLIST_SPARSELUN},
	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},


Odd "revision level" string(is it right? EOT?):
        {"SEAGATE", "ST157N", "\004|j", BLIST_NOLUN},


Duplicate strings(They should be merged):
	{"TEXEL", "CD-ROM", "1.06", BLIST_BORKEN},
	{"TEXEL", "CD-ROM", "1.06", BLIST_NOLUN},


Keep in mind, for future patches, that there are regex metacharacters(!!):
        {"IOMEGA", "Io20S         *F", NULL, BLIST_KEY},
        {"INSITE", "Floptical   F*8I", NULL, BLIST_KEY},
        {"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},     /* Dell PV 530F */


For homogeneity reasons, should "*" revision level be replaced by NULL?


And the current pattern matching algorithm should be described clearer, right
now it's a bit confused.


Thank you.
