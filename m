From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Adding transport attributes to qla1280
Date: 15 Sep 2004 11:38:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095262722.1942.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:41123 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266488AbUIOPjO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Sep 2004 11:39:14 -0400
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@classic.engr.sgi.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jes Sorensen <jes@wildopensource.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi All,

I've run into rather a nasty problem in the qla1280 drivers to do with
transport attributes.  My plan, if I can get settable attributes to
work, is to convert it over to the SPI transport class and pull in
domain validation for free.

The problem is that the API in the driver for setting attributes:
qla1280_set_target_parameters() doesn't seem to work ... at least it
does apparently set the parameters using a qla1280 mailbox command, and
if I read them back again with the other command, it confirms the
setting.  However, the next attempt to access the device hangs the
entire system.

My deduction from all of this is that the HBA is changing the transfer
settings on its side but not renegotiating those new settings with the
device.  However, without a bus analyser, I can't be sure I'm correct.

So, since this entire HBA is one of the magic ones that runs in
proprietary firmware and has no documentation even for the mailbox
command interface, could someone who has access to the secret documents
look in them and tell me how I can do this?

Alternatively, actually releasing the specs for what are now at least 4
year old chips would be a very nice gesture on the part of Qlogic.

James


