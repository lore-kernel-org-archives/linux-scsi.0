From: Ahmed Tamrawi <ahmedtamrawi@gmail.com>
Subject: Possible Lock Dangling in function [fnic_handle_fip_timer] on [v4.3-rc1]
Date: Wed, 16 Sep 2015 10:14:27 -0500
Message-ID: <CAFZT-jK1V3vOPZA8CUK=T__3GdVhLM_NG3PR7HDJNf0RBtJb1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f174.google.com ([209.85.223.174]:36086 "EHLO
	mail-io0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418AbbIPPO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Sep 2015 11:14:28 -0400
Received: by ioii196 with SMTP id i196so233727957ioi.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2015 08:14:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello:

A possibility of a dangling lock and eventually a deadlock can occur
in function [fnic_handle_fip_timer] on [v4.3-rc1].

Github Link: https://github.com/torvalds/linux/blob/v4.3-rc1/drivers/scsi/fnic/fnic_fcs.c#L1267

The lock acquired at line 1284  will not be unlocked upon function's
exit if (vlan->state) value is (FIP_VLAN_AVAIL) when entering the
switch statement at line 1298.

A possible fix is to add a default case to the switch block or add a
special case to handle the case where vlan->state) value is
(FIP_VLAN_AVAIL).


Thanks
~Ahmed Tamrawi
