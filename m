From: "Chris Williams" <chris.williams@auto-online.co.uk>
Subject: Megaraid2 on 2.4.18 kernel
Date: Tue, 4 May 2004 14:28:18 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <90A82A461FA4D441ACD1F2AA351AED4D055C49@jet5.autoonline.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.auto-online.co.uk ([212.74.13.67]:56587 "EHLO
	bruce7.autoonline.local") by vger.kernel.org with ESMTP
	id S264359AbUEDN2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 May 2004 09:28:19 -0400
Received: from auto-online.co.uk (jet5.autoonline.local [192.168.8.5])
	by bruce7.autoonline.local (8.12.3/8.12.3/Debian-6.6) with ESMTP id i44DSI2Y000487
	for <linux-scsi@vger.kernel.org>; Tue, 4 May 2004 14:28:18 +0100
Content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi there,
I'm trying to get the megaraid2 driver (v2.19.3) running with my stock
debian 2.4.18 kernel. My only remaining holdup is the yield statement
here->
 
--------------
static int
__mega_busywait_mbox (adapter_t *adapter)
{
        volatile mbox_t *mbox = adapter->mbox;
        long counter;
 
        for (counter = 0; counter < 10000; counter++) {
                if (!mbox->busy)
                        return 0;
                udelay(100); yield();
        }
        return -1;              /* give up after 1 second */
}
------------
 
which is unresolved under the 2.4.18 kernel.
 
I got around the problem by simply removing the yield statement - which
so far has no adverse effects. My question is this: Do you think I can
get away with this, or will I be punished harshly at some point in the
future. If I can't just remove the yield statement, what could I do
instead? I'd really like to stay with the 2.4.18 kernel because of
security updates and such, but I need the latest version of the megaraid
driver for my dell 1750 perc 4d scsi controller.

Thanks for any help you can give,
Chris.

