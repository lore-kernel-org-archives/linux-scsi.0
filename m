From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Subject: Deadlock in transport_fc
Date: Mon, 06 Jun 2005 21:29:33 +0200
Message-ID: <42A4A41D.7010504@fujitsu-siemens.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:41556 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S261645AbVFFT3q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Jun 2005 15:29:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>

Hi,

currently I'm trying to use the new transport_fc to read the
very often changing FibreChannel configuration in a test system.

To avoid a growing list of consistent binding entries (which
make no sense in this special case), I tried to switch off this
feature by
     "echo none > /sys/class/fc_host/host1/tgtid_bind_type"

Unfortunately, the system stalls immediately, I guess the reason
is store_fc_private_host_tgtid_bind_type() calling
fc_rport_terminate() while holding host_lock.

If I understand the code correctly, even if tgtid_bind_type
would work correctly, still the rport-nummer and scsi-target-id
would count up on configuration changes. In the lpfc-driver, I
saw:
#define MAX_FCP_TARGET              256     /* max num of FCP targets supported */
Will this result in problems after 256 configuration changes?
If so, what could I do?

BTW: My Emulex boards do not recognize a change behind the
FibreChannel switch. So I force them to scan the configuration
using "echo [01] >/sys/class/scsi_host/host1/board_online".
Is there a better way to do this?

Regards
Bodo

P.S.: Please CC me, I'm not on the list.
