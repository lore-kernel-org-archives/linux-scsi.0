From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] SCSI Core patches
Date: Tue, 14 Jan 2003 21:01:36 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF05415A5A.7D53015A-ONC1256CAE.00687CAC@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: Luben Tuikov <luben@splentec.com>, linux-scsi@vger.kernel.org


Patrick,

> With the current scsi code, going to a 64-bit lun means changing
sdev->lun
> and conditionally changing references to it to use a 64-bit struct
> scsilun, or (mainly in the lldd) to call a conversion function if you
must
> use less than 64-bits.

Why would a conversion function be required?
Have we a conversion function for our current 32 bit LUNS which is larger
than required by our Parallel SCSI HBA drivers?
What would chang for those drivers if we go to 64 bit LUNs?

>(Currently, no open source FCP adapters use an 8
> byte lun to talk to the host adapter hardware, not even the qlogic
> adapter.)

Here you are under a misapprehension
http://www-124.ibm.com/developerworks/opensource/linux390
/current2_4_19-may2002.shtml#kernel20021125

Using 8 byte LUNs for FCP is not a question of driver-to-HBA communication
but is required by FCP.
ftp://ftp.t11.org/t10/drafts/fcp2/fcp2r07a.pdf
An HBA dd has to put an 8 byte LUN into the control block used for
SCSI command transfer (FCP_CMND IU), for example.
I am wondering how those drivers make up an 8 byte LUN
from a 32 bit LUN.


Martin Peschke

