From: Douglas Gilbert <dougg@torque.net>
Subject: lk 2.4.27 error handling, ad infinitum
Date: Tue, 31 Aug 2004 22:48:02 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41347382.8010806@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:65203 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S268335AbUHaMss (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2004 08:48:48 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: marcelo.tosatti@cyclades.com

The following scenario has been brought to my attention.

While handling a error (e.g. a timeout) the
scsi_send_eh_cmnd() function issues a (stalled) queued command.
Now that command hits a repeatable failure (e.g. MEDIUM ERROR).

In this scaenario it would seem that the "goto retry" forms
an infinite loop re-issuing that command on the same (broken)
block.

Comments?

The good news is that this problem has not been observed in
the lk 2.6 series.

Doug Gilbert
