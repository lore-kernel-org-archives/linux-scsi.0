From: Dan Carpenter <error27@gmail.com>
Subject: bug report: fusion: odd range check in mptbase
Date: Sun, 28 Mar 2010 14:26:56 +0300
Message-ID: <20100328112656.GN5069@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50469 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0C1L1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Mar 2010 07:27:05 -0400
Received: by bwz1 with SMTP id 1so2875787bwz.21
        for <linux-scsi@vger.kernel.org>; Sun, 28 Mar 2010 04:27:04 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <Eric.Moore@lsi.com>
Cc: support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org

Hi, I'm just going through some Smatch results and couldn't figure out
what to do with this:

drivers/message/fusion/mptbase.c +7850 mpt_sas_log_info() 'originator_str' 3 <= 3
  7846          if ((sas_loginfo.dw.bus_type != 3 /*SAS*/) &&
  7847              (sas_loginfo.dw.originator < ARRAY_SIZE(originator_str)))
                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^			

  7848                  return;
  7849
  7850          originator_desc = originator_str[sas_loginfo.dw.originator];
                                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If sas_loginfo.dw.originator is == ARRAY_SIZE(originator_str) that would
be a buffer overflow on line 7850.

regards,
dan carpenter
