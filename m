From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 106861] DPOFUA should not be related to WCE / Caching mode page
Date: Thu, 29 Oct 2015 08:15:26 +0000
Message-ID: <bug-106861-11613-F8gSaqYTVA@https.bugzilla.kernel.org/>
References: <bug-106861-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41853 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbbJ2IPa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 Oct 2015 04:15:30 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id 92ADD20961
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:15:29 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id 79FA82096A
	for <linux-scsi@vger.kernel.org>; Thu, 29 Oct 2015 08:15:26 +0000 (UTC)
In-Reply-To: <bug-106861-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=106861

--- Comment #1 from Tom Yan <tom.ty89@gmail.com> ---
Example drive:

[tom@localhost ~]$ sudo sdparm --long /dev/sdc
    /dev/sdc: WD        My Passport 083A  1065
    Direct access device specific parameters: WP=0  DPOFUA=1
Control [co] mode page:
  SWP         0  [cha: n, def:  0, sav:  0]  Software write protect
[tom@localhost ~]$ sudo sdparm -a --long /dev/sdc
    /dev/sdc: WD        My Passport 083A  1065
    Direct access device specific parameters: WP=0  DPOFUA=1
Control [co] mode page:
  TST         0  [cha: n, def:  0, sav:  0]  Task set type
  TMF_ONLY    0  [cha: n, def:  0, sav:  0]  Task management functions only
  DPICZ       0  [cha: n, def:  0, sav:  0]  Disable protection information
check if protect field zero
  D_SENSE     0  [cha: n, def:  0, sav:  0]  Descriptor format sense data
  GLTSD       0  [cha: n, def:  0, sav:  0]  Global logging target save disable
  RLEC        0  [cha: n, def:  0, sav:  0]  Report log exception condition
  QAM         1  [cha: n, def:  1, sav:  1]  Queue algorithm modifier
  NUAR        0  [cha: n, def:  0, sav:  0]  No unit attention on release
  QERR        0  [cha: n, def:  0, sav:  0]  Queue error management
  RAC         0  [cha: n, def:  0, sav:  0]  Report a check
  UA_INTLCK   0  [cha: n, def:  0, sav:  0]  Unit attention interlocks control
  SWP         0  [cha: n, def:  0, sav:  0]  Software write protect
  ATO         0  [cha: n, def:  0, sav:  0]  Application tag owner
  TAS         0  [cha: n, def:  0, sav:  0]  Task aborted status
  ATMPE       0  [cha: n, def:  0, sav:  0]  Application tag mode page enabled
  RWWP        0  [cha: n, def:  0, sav:  0]  Reject write without protection
  AUTOLOAD    0  [cha: n, def:  0, sav:  0]  Autoload mode
  BTP         0  [cha: n, def:  0, sav:  0]  Busy timeout period (100us)
  ESTCT       0  [cha: n, def:  0, sav:  0]  Extended self test completion time
(sec)
Power condition [po] mode page:
  PM_BG       0  [cha: n, def:  0, sav:  0]  Power management, background
functions, precedence
  STANDBY_Y   0  [cha: n, def:  0, sav:  0]  Standby_y timer enable
  IDLE_C      0  [cha: n, def:  0, sav:  0]  Idle_c timer enable
  IDLE_B      0  [cha: n, def:  0, sav:  0]  Idle_b timer enable
  IDLE        0  [cha: n, def:  0, sav:  0]  Idle_a timer enable
  STANDBY     1  [cha: y, def:  1, sav:  1]  Standby_z timer enable
  ICT         0  [cha: n, def:  0, sav:  0]  Idle_a condition timer (100 ms)
  SCT       18000  [cha: y, def:18000, sav:18000]  Standby_z condition timer
(100 ms)
  IBCT        0  [cha: n, def:  0, sav:  0]  Idle_b condition timer (100 ms)
  ICCT        0  [cha: n, def:  0, sav:  0]  Idle_c condition timer (100 ms)
  SYCT        0  [cha: n, def:  0, sav:  0]  Standby_y condition timer (100 ms)
  CCF_IDLE    0  [cha: n, def:  0, sav:  0]  check condition on transition from
idle
  CCF_STAND   0  [cha: n, def:  0, sav:  0]  check condition on transition from
standby
  CCF_STOPP   0  [cha: n, def:  0, sav:  0]  check condition on transition from
stopped

-- 
You are receiving this mail because:
You are the assignee for the bug.
