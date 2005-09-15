From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 2.6.14-rc1] scsi: sd, sr, st, and scsi_lib all fail to
 copy cmd_len to new cmd
Date: Thu, 15 Sep 2005 22:23:23 +1000
Message-ID: <432967BB.1080104@torque.net>
References: <CA45571DE57E1C45BF3552118BA92C9D69BDE2@WDSCEXBECL03.sc.wdc.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:12989 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1751180AbVIOMWr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 08:22:47 -0400
In-Reply-To: <CA45571DE57E1C45BF3552118BA92C9D69BDE2@WDSCEXBECL03.sc.wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Timothy Thelin <Timothy.Thelin@wdc.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Timothy Thelin wrote:
> This fixes an issue in scsi command initialization from a request
> where sd, sr, st, and scsi_lib all fail to copy the request's
> cmd_len to the scsi command's cmd_len field.

This is an important fix. The bug is triggered whenever a SCSI
command is sent that does not conform to the old "top 3 bits of
the first byte dictate cdb length" convention. This mainly happens
with vendor specific commands and with variable length commands
(those starting with opcode 0x7f). The latter is not a problem
today because linux doesn't support variable length commands
(or, to be more precise, those commands with more than 16 bytes
in them).

Doug Gilbert
