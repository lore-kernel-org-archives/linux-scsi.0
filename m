From: Luben Tuikov <luben@splentec.com>
Subject: [CARE]: number of LUNS from REPORT LUNS data report and macros
Date: Mon, 26 Aug 2002 20:49:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D6ACCA2.68364DDA@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from splentec.com (canoe.splentec.com [209.47.35.250])
	by pepsi.splentec.com (8.11.6/8.11.0) with ESMTP id g7R0ncH09356
	for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2002 20:49:38 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Two issues here.

Firstly, I don't think that one can quite do
``num_luns = (length / sizeof(ScsiLun));'' in scsi_scan.c.

The reason is that we should keep clear separation of what/how
the kernel represents some standard/drafts data and how it comes
from the device. I.e. one wouldn't assume (one step further) that
_also_ the byte ordering is the same in the report data and in ScsiLun,
i.e.  (ScsiLun *)(data+i*sizeof(ScsiLun)) ... not!

A SCSI LUN should be represented by ``u64''. Futhermore, only
a LLDD should poplulate such a variable (as outlined in another email)
directly or indirectly (though REPORT LUNS data).

Secondly, please get rid of the big
#ifdef CONFIG_SCSI_REPORT_LUNS in scsi_scan.c.
Linus has made this a point numerous times.

Lets keep this great subsystem great!

(Those issues should naturally go away once u64 LUN is adopted.)

-- 
Luben
