From: Michael Clark <michael@metaparadigm.com>
Subject: Re: [PATCH] Additional BLIST_LARGELUN devices
Date: Thu, 27 Jun 2002 22:09:11 +0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D1B1C87.4020504@metaparadigm.com>
References: <20020626164744.GH3023@gum01m.etpnet.phys.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>, Dave Jones <davej@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>



On 06/27/02 00:47, Kurt Garloff wrote:

>Hi Marcello, Dave,
>
>here are some additional devices that need the BLIST_LARGELUN flag.
>

[snip]

>-	{"CNSI", "G7324", "*", BLIST_SPARSELUN},     // Chaparral G7324 RAID
>-	{"CNSi", "G8324", "*", BLIST_SPARSELUN},     // Chaparral G8324 RAID
>+	{"CMD", "CRA-7280", "*", BLIST_SPARSELUN | BLIST_LARGELUN},   // CMD RAID Controller
>+	{"CNSI", "G7324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparral G7324 RAID
>+	{"CNSi", "G8324", "*", BLIST_SPARSELUN | BLIST_LARGELUN},     // Chaparral G8324 RAID
>

The G8324 correctly identifies itself as SCSI-3 so doesn't
need the BLIST_LARGELUN flag (proc output below
from 2.4.18 with automated large lun scanning).

This is as long as my fix for scanning large luns automatically
on SCSI-3 devices that went into 2.4.17-pre5 hasn't been
reverted in 2.4.19-pre

# cat /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SEAGATE  Model: ST318405LC       Rev: 0105
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 06 Lun: 00
  Vendor: ESG-SHV  Model: SCA HSBP M10     Rev: 0.06
  Type:   Processor                        ANSI SCSI revision: 02
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 50
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Processor                        ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 51
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Processor                        ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 52
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Processor                        ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 53
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Processor                        ANSI SCSI revision: 03
Host: scsi2 Channel: 00 Id: 00 Lun: 63
  Vendor: CNSi     Model: G8324            Rev: L411
  Type:   Processor                        ANSI SCSI revision: 03


