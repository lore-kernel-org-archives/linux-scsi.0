From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: [patch] ACPI work on aic7xxx
Date: Tue, 20 Jul 2004 12:48:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40FD4CFA.6070603@optonline.net>
References: <40FD38A0.3000603@optonline.net> <20040720155928.GC10921@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from thunderdog.allegientsystems.com ([208.251.178.238]:62869 "EHLO
	lasn-001.allegientsystems.com") by vger.kernel.org with ESMTP
	id S266005AbUGTQsq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jul 2004 12:48:46 -0400
In-Reply-To: <20040720155928.GC10921@atrey.karlin.mff.cuni.cz>
List-Id: linux-scsi@vger.kernel.org
To: Pavel Machek <pavel@suse.cz>
Cc: linux-scsi@vger.kernel.org, random1@o-o.yi.org, Luben Tuikov <luben_tuikov@adaptec.com>

Pavel Machek wrote:

>>+#if 0
>>+        switch(state)
>>+        {
>>+                case 1: /* S1 */
>>+                        device_state=1; /* D1 */;
>>+                        break;
>>+                case 3: /* S3 */
>>+                case 4: /* S4 */
>>+                        device_state=3; /* D3 */;
>>+                        break;
>>+                default:
>>+                        return -EAGAIN /*FIXME*/;
>>+                        break;
>>+        }
>>+#else
>>+	device_state = state;
>>+#endif
> 
> 
> Can you kill #if 0 code?

Yes. This is a work in progress. Interestingly, the ifdef'd-out code was 
pasted from mptbase.c in the MPT Fusion driver. If it's broken here, 
it's probably broken there -- seems the state parameter passed to the 
pci resume callback is intended to be a PCI D state, not an ACPI S 
state. Can somebody confirm or deny? The kernel is actually passing 
state 2 (D2) to the driver when I enter ACPI S3, so presumably the same 
failure could happen to fusion.

