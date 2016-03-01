From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 1/1] sd: add missing scenario for sd_config_write_same
Date: Mon, 29 Feb 2016 20:34:22 -0500
Message-ID: <yq11t7vdlr5.fsf@sermon.lab.mkp.net>
References: <56d0c09d.5a46620a.e4c6.0855@mx.google.com>
	<yq1ziunf7e3.fsf@sermon.lab.mkp.net>
	<CAGnHSE=3gkawOPpHWfxwZ64U8pjLLzVDr3-kWN0c_d7TJDA2WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48371 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbcCABed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Feb 2016 20:34:33 -0500
In-Reply-To: <CAGnHSE=3gkawOPpHWfxwZ64U8pjLLzVDr3-kWN0c_d7TJDA2WA@mail.gmail.com>
	(Tom Yan's message of "Sat, 27 Feb 2016 09:46:06 +0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Yan <tom.ty89@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "Tom" == Tom Yan <tom.ty89@gmail.com> writes:

Tom> Since you've mentioned it, why do we disable write same for all
Tom> devices with a ATA Information VPD?

Generally speaking, SAS controllers that properly translate SCSI WRITE
SAME to ATA ditto also support modern features such as the REPORT
SUPPORTED OPERATION CODES command.

For the SAS controllers that do not support RSOC we check for the ATA
Information VPD page to determine whether we are talking to a SAS or
SATA device. If it's a SATA device we skip WRITE SAME because in most
cases either the controller's SATL or the drive itself will fail
miserably.

-- 
Martin K. Petersen	Oracle Linux Engineering
