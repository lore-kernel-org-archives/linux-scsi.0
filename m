From: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Subject: Server freeze when LSI53C1030 didn't send reply message
Date: Thu, 30 Oct 2003 20:00:06 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200310301100.AA02735@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44975 "EHLO
	fgwmail5.fujitsu.co.jp") by vger.kernel.org with ESMTP
	id S262352AbTJ3LAa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Oct 2003 06:00:30 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73]) by fgwmail5.fujitsu.co.jp (8.12.10/Fujitsu Gateway)
	id h9UB0SVv006731 for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2003 20:00:28 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from s6.gw.fujitsu.co.jp by m3.gw.fujitsu.co.jp (8.12.10/Fujitsu Domain Master)
	id h9UB0S62004501 for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2003 20:00:28 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fjmail501.fjmail.jp.fujitsu.com (fjmail501-0.fjmail.jp.fujitsu.com [10.59.80.96]) by s6.gw.fujitsu.co.jp (8.12.10)
	id h9UB0RE9017104 for <linux-scsi@vger.kernel.org>; Thu, 30 Oct 2003 20:00:27 +0900
	(envelope-from fukuchi.masao@jp.fujitsu.com)
Received: from fukuchi.jp.fujitsu.com
 (fjscan502-0.fjmail.jp.fujitsu.com [10.59.80.122])
 by fjmail501.fjmail.jp.fujitsu.com
 (Sun Internet Mail Server sims.4.0.2001.07.26.11.50.p9)
 with SMTP id <0HNK00C0IH8P3S@fjmail501.fjmail.jp.fujitsu.com> for
 linux-scsi@vger.kernel.org; Thu, 30 Oct 2003 20:00:26 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: jralston1@netscape.net, Pam.Delaney@lsil.com
Cc: linux-scsi@vger.kernel.org, endo@ic.macnica.co.jp, obinata@ic.macnica.co.jp

I'm working on a verification of sequence for FC/SCSI cards during
error injection.

In this test, I experienced the system freeze 1 minutes or more.

This error injection causes no reply from LSI53C1030 and I found
mptscsih_tm_pending_wait() finishes by timeout.

This function is called at the beggining of task management request and
it waits until the previous task management request will complete.
But, because no reply comes from LSI53C1030, this function finishes by timeout.
This function uses mdelay(250)(250ms wait) and repeats 240 times, and
this causes system freeze 1 minutes because no task can run in mdelay().

Please improve the program not to use mdelay().

Refs(operation flow).
  [MID LAYER]              [HBA DRIVER]             [LSI53C1030]
            ---read cmd--->
                                     --request msg-->
  *Detects 30s timeout
            --task abort-->
                           [message]>> Attempting task abort!
                                     --request msg-->(Task Mgmt:Abort Task)
            <----reply-----(FAILED)
            --targ reset-->
                           [message]>> Attempting target reset!
            <----reply-----(FAILED)
            --bus reset--->
                           [message]>> Attempting bus reset!
                           *wait until previous target reset finishes
                            -> timeout(60s)
            <----reply-----(FAILED)
            --host reset-->
                           [message]>> Attempting host reset!
                            :

Our environment:
  Server: Fujitsu Primergy C200
    Linux kernel: 2.6.0-test4
  HBA: LSILogic LSI22320-R
    HBA driver: default driver in 2.6.0-test4
    CARD FW: 01.03.10.00-IM

Thanks,
Fukuchi

---
Masao Fukuchi                  L-Server Development Div., Fujitsu Limited
E-mail: fukuchi.masao@jp.fujitsu.com
