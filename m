From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: SAI_READ_CAPACITY_16?
Date: Wed, 6 Apr 2005 12:00:33 -0400
Message-ID: <60807403EABEB443939A5A7AA8A7458BFF2211@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:1726 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262239AbVDFQAg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Apr 2005 12:00:36 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j36G0Zr31339
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 09:00:35 -0700
Received: from otce2k01.adaptec.com (otce2k01.adaptec.com [10.12.1.83])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j36G0YD00932
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 09:00:34 -0700
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>

Troubled spoofing back >2TB support in the aacraid driver.

For some reason, sd_read_capacity (in sd.c) in the 2.6.9-5.EL (RHEL4)
kernel is not issuing the SERVICE_REQUEST_IN+SAI_READ_CAPACITY_16
command to the queuecommand handler (the handler is not even called),
even though it instruments up that the command is issued (and returns
not supported). The READ_CAPACITY call makes it through successfully
indicating 0xFFFFFFFF capacity to trigger the SAI_READ_CAPACITY_16
request fine. Could there be a bug in the scsi layers reissuing commands
reusing the request structure misdirecting the requests?

The only changes to the current tree appear to be in the handling of the
request sense information, so I expect the same behavior from
latest/greatest.

Any successes in the current tree with >2TB support being reported by
the SAI_READ_CAPACITY_16 call?

Sincerely -- Mark Salyzyn
