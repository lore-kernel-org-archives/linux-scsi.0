From: Dan Carpenter <error27@gmail.com>
Subject: smatch stuff: fnic:  VNIC_FNIC_EDTOV_MAX is too high.
Date: Mon, 14 Jun 2010 14:52:25 +0200
Message-ID: <20100614125225.GW5483@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39565 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0FNMwu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2010 08:52:50 -0400
Received: by wwb18 with SMTP id 18so3788859wwb.19
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jun 2010 05:52:46 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: Joe Eykholt <jeykholt@cisco.com>, linux-scsi@vger.kernel.org

This is a smatch thing.  Neither VNIC_FNIC_EDTOV_MAX nor
VNIC_FNIC_RATOV_MAX do anything.  They are both set to 255000 but ed_tov
and ra_tov are u16 so they can't go higher than 65535.

drivers/scsi/fnic/fnic_res.c
    95          c->ed_tov =
    96                  min_t(u32, VNIC_FNIC_EDTOV_MAX,
    97                        max_t(u32, VNIC_FNIC_EDTOV_MIN,
    98                              c->ed_tov));
    99
   100          c->ra_tov =
   101                  min_t(u32, VNIC_FNIC_RATOV_MAX,
   102                        max_t(u32, VNIC_FNIC_RATOV_MIN,
   103                              c->ra_tov));

regards,
dan carpenter

