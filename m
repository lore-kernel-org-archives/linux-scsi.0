From: Douglas Gilbert <dgilbert@interlog.com>
Subject: sense data for status GOOD
Date: Tue, 30 Mar 2010 12:01:03 -0400
Message-ID: <4BB2203F.1060409@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32772 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754141Ab0C3QBJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Mar 2010 12:01:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by elrond.infotech.no (Postfix) with ESMTP id AC95230FB4
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2010 18:01:05 +0200 (CEST)
Received: from elrond.infotech.no ([127.0.0.1])
	by localhost (elrond.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9AGm1G0K19sM for <linux-scsi@vger.kernel.org>;
	Tue, 30 Mar 2010 18:01:05 +0200 (CEST)
Received: from [10.7.0.10] (unknown [10.7.0.10])
	by elrond.infotech.no (Postfix) with ESMTPA id 37E3230F73
	for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2010 18:01:05 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The folk at t10.org slipped this innocuous looking
addition into sam5r04 section 5.3.1 on status codes.

"Sense data may be delivered in the buffer defined by
the Sense Data argument of the Execute Command
procedure call (see 5.1) for any status code."

Previously sense data was only valid for status
CHECK_CONDITION [0x2] (and the obsolete
COMMAND_TERMINATED [0x22]). The quoted section in
the previous paragraph means that sense data could
arrive with any status code.

And now with draft sbc3r22 there is an example:
status=GOOD, sense_key=COMPLETED (recently added)
additional_sense_qualifier="INSPECT REFERRALS
SENSE DESCRIPTORS". Referrals are new and explained
in sbc3r22. IMO only a very small audience would
be interested in them. However it does indicate
a new trend.


So the question for the Linux scsi subsystem is
does it (or can it without many changes) convey
"non CHECK_CONDITION" sense data back up from
an initiator (LLD) to code that might care?

Doug Gilbert

