From: Christian Krause <chkr@plauener.de>
Subject: minor issue with READ_10 -> READ_6 fallback
Date: Fri,  4 Nov 2005 13:54:25 +0100
Message-ID: <20051104135425.ehyu430xfwook4o0@mail.tu-chemnitz.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lana.hrz.tu-chemnitz.de ([134.109.132.3]:43966 "EHLO
	lana.hrz.tu-chemnitz.de") by vger.kernel.org with ESMTP
	id S932092AbVKDMyF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 07:54:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Recently I've found some minor issues in the current linux scsi
implementation. Before I'll submit any patches I want to discuss
these problems with you, maybe I'm wrong and there are some reasons
for the way it's implemented, which I don't know so far.

I've found these issues during developing a USB mass storage device
for the company I work for at the moment.


linux-2.6.14/drivers/scsi/sd.c, line 929:

static void sd_rw_intr(struct scsi_cmnd * SCpnt):
[...]
                case ILLEGAL_REQUEST:
                        if (SCpnt->device->use_10_for_rw &&
                            (SCpnt->cmnd[0] == READ_10 ||
                             SCpnt->cmnd[0] == WRITE_10))
                                SCpnt->device->use_10_for_rw = 0;
                        if (SCpnt->device->use_10_for_ms &&
                            (SCpnt->cmnd[0] == MODE_SENSE_10 ||
                             SCpnt->cmnd[0] == MODE_SELECT_10))
                                SCpnt->device->use_10_for_ms = 0;
                        break;

This function is called after the lower layer has completeda scsi
command.

Similar code is in scsi_lib.c, line 920, in a function which is
called after the completion of a scsi command.

"use_10_for_rw" is set to 1 per default (in libata-scsi.c or
scsi_scan.c).

The purpose of the mentioned code pieces seems to be to fall back
to READ/WRITE_6 if READ/WRITE_10 (the same for MODE_SENSE/SELECT)
is not available.


But the assumption, that Sensekey==ILLEGAL_REQUEST does always mean
"I don't support the command" is just wrong.

One example (this is the one where I discovered the problem):
If a READ_10 is issued which tries to read a block which is not within
the range of blocks of the device (means: requested block number is
greater than the one which is reported by READ_CAPACITY), the device
must [1] return CHECK_CONDITION and set its sense data to

SenseKey = ILLEGAL REQUEST
Additional Sense Code = LOGICAL BLOCK ADDRESS OUT OF RANGE


This means, that a sense key of ILLEGAL_REQUEST in response to
a READ_10 does not always mean that the device doesn't support
READ_10 and a fallback to READ_6 makes sense.

Sure, it could be a bug that a read outside the range of the device
is issued, but nevertheless the mentioned pieces of code are
not completely correct.

I suggest to check the additional sense code which the device must
have set to INVALID COMMAND OPERATION CODE if it hasn't implemented
the command. In this case the fallback to READ_6, ... makes sense.





Please can you comment on whether my investigations are correct?
If so, I'll create appropriate patches.


Best regards,
Christian


references to SCSI specifications:
[1]: SBC-2, 4.4 Logical blocks
[2]: SPC-3, 4.3.1 CDB Usage and structure


