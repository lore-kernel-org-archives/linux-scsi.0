From: Bernd Schubert <bs@q-leap.de>
Subject: [PATCH 0/4 V2] mpt fusion error handler patches
Date: Tue, 23 Sep 2008 15:16:47 +0200
Message-ID: <200809231516.48197.bs@q-leap.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns1.q-leap.de ([153.94.51.193]:37053 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbYIWNQz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Sep 2008 09:16:55 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>, Eric Moore <Eric.Moore@lsi.com>, Sathya Prakash <Sathya.Prakash@lsi.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: DL-MPTFusionLinux@lsi.com

Hello,

here is version 2 of the patches, version 1 may be found here: 
http://kerneltrap.org/mailarchive/linux-scsi/2008/9/12/3279954

In difference to the previous series I skipped the removal of 
mptscsih_TMHandler(), since it actually does the right thing, it only cause 
the HardReset function to be activated, which caused the real trouble.

I also made the soft/hard reset calls into one main call. From this main call 
it is then also generally possible to avoid calling the hard reset handler.

There is still one issue left, while in the 4.x series of the driver the 
mptscsih_IssueTaskMgmt() succeeds for task aborts, this still fails in the in 
kernel version. My guess is the this is related to the completion calls. 
While the in-kernel driver uses mptscsih_tm_wait_for_completion(), the 4.x 
series uses just like the in kernel mptsas the generic 
wait_for_completion_timeout() handler. 
But switching to that actually means a lot of work. Without to be sure this is 
really the cause of the trouble, I won't spend my time on it.


Cheers,
Bernd


-- 
Bernd Schubert
Q-Leap Networks GmbH
