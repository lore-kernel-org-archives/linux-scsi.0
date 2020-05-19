Return-Path: <SRS0=JQ6K=7B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08329C433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 12:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA40A20825
	for <linux-scsi@archiver.kernel.org>; Tue, 19 May 2020 12:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgESM2d convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 May 2020 08:28:33 -0400
Received: from mx3.uni-regensburg.de ([194.94.157.148]:59764 "EHLO
        mx3.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgESM2d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 May 2020 08:28:33 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 May 2020 08:28:31 EDT
Received: from mx3.uni-regensburg.de (localhost [127.0.0.1])
        by localhost (Postfix) with SMTP id 1213D6000050
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 14:23:11 +0200 (CEST)
Received: from gwsmtp.uni-regensburg.de (gwsmtp1.uni-regensburg.de [132.199.5.51])
        by mx3.uni-regensburg.de (Postfix) with ESMTP id D7C12600004D
        for <linux-scsi@vger.kernel.org>; Tue, 19 May 2020 14:23:10 +0200 (CEST)
Received: from uni-regensburg-smtp1-MTA by gwsmtp.uni-regensburg.de
        with Novell_GroupWise; Tue, 19 May 2020 14:23:10 +0200
Message-Id: <5EC3CFAE020000A1000390D6@gwsmtp.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 18.2.1 
Date:   Tue, 19 May 2020 14:23:10 +0200
From:   "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To:     <linux-scsi@vger.kernel.org>
Subject: On FC host statistics ( /sys/class/fc_host/hostX/statistics)
 and monitoring plugins
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

I've developed a monitoring plugin that reads /sys/class/fc_host/hostX/statistics for numbers.
I'm not very happy about it for the following reasons:

1) Some numbers (e.g. fcp_frame_alloc_failures) are not supported by some drivers (e.g. QLE2690) and the value read from the file is "0xffffffffffffffff". The source seems to set this to -1, but when reading it back it looks like unsigned. For a 64-bit counter it's quite unlikely to read this value, but it's still possible.

2) While statistics counters seems to be 64 bits, I've experienced a "wrap around" at fewer bit positions (maybe like 40 bits) for the bfa driver. I have no idea whether it's a hardware restriction or a firmware/driver bug, however. I did my best to make sure it's not a problem of my plugin (assuming those counters are read atomically when using one read())

3) The bfa drivers has  an (maybe even two) "offlines" event counter, but that is not exported to fc_host statistics (it seems to me). I've seen several "bfa 0000:0e:00.0: Target (WWN = 50:01:43:80:11:36:89:da) connectivity lost for initiator (WWN = 10:00:00:05:1e:fb:3e:a0)" in syslog, but I'd like to see such events through statistics.

4) The bfa driver (QLogic-815) sets link_failure_count to 1 after a clean reboot. This triggers the monitoring plugin reporting a "link failure". That's not very nice.

My idea was (probably more universal than restricted to FC host statistics) to provide another file (maybe named "statistics") that lists the names of implemented statistics counters (i.e.: leaving out those set to -1) together with the significant bits (like 32 or 64), the type of the value (like "counter", "gauge", "boolean", "enum", "string", etc.)
"string" would be free text (I doubt it will make sense for statistics, but anyhow), "enum" would be single word tokens (e.g. _not_ " NPort (fabric via point-to-point)"), "counter" would count bytes or events (maybe a type "event_count[er]" may make sense), and "gauge" would be a non-monotonic value like utilization...

Finally an example what the existing "statistics" directory contains (4.12.14-95.51-default from SLES12 SP4):
/sys/class/fc_host/host0/statistics/dumped_frames: 0x0
/sys/class/fc_host/host0/statistics/error_frames: 0x0
/sys/class/fc_host/host0/statistics/fc_no_free_exch: 0x0
/sys/class/fc_host/host0/statistics/fc_no_free_exch_xid: 0x0
/sys/class/fc_host/host0/statistics/fc_non_bls_resp: 0x0
/sys/class/fc_host/host0/statistics/fc_seq_not_found: 0x0
/sys/class/fc_host/host0/statistics/fc_xid_busy: 0x0
/sys/class/fc_host/host0/statistics/fc_xid_not_found: 0x0
/sys/class/fc_host/host0/statistics/fcp_control_requests: 0x0
/sys/class/fc_host/host0/statistics/fcp_frame_alloc_failures: 0x0
/sys/class/fc_host/host0/statistics/fcp_input_megabytes: 0x0
/sys/class/fc_host/host0/statistics/fcp_input_requests: 0x0
/sys/class/fc_host/host0/statistics/fcp_output_megabytes: 0x0
/sys/class/fc_host/host0/statistics/fcp_output_requests: 0x0
/sys/class/fc_host/host0/statistics/fcp_packet_aborts: 0x0
/sys/class/fc_host/host0/statistics/fcp_packet_alloc_failures: 0x0
/sys/class/fc_host/host0/statistics/invalid_crc_count: 0x0
/sys/class/fc_host/host0/statistics/invalid_tx_word_count: 0x0
/sys/class/fc_host/host0/statistics/link_failure_count: 0x1
/sys/class/fc_host/host0/statistics/lip_count: 0x0
/sys/class/fc_host/host0/statistics/loss_of_signal_count: 0x0
/sys/class/fc_host/host0/statistics/loss_of_sync_count: 0x0
/sys/class/fc_host/host0/statistics/nos_count: 0x0
/sys/class/fc_host/host0/statistics/prim_seq_protocol_err_count: 0x0
/sys/class/fc_host/host0/statistics/reset_statistics: ()
/sys/class/fc_host/host0/statistics/rx_frames: 0x18221
/sys/class/fc_host/host0/statistics/rx_words: 0x1a3e8f9
/sys/class/fc_host/host0/statistics/seconds_since_last_reset: 0x2a79
/sys/class/fc_host/host0/statistics/tx_frames: 0x77f4
/sys/class/fc_host/host0/statistics/tx_words: 0x82483

And here's what 4.12.14-122.17-default (SLES12 SP5) contains for a different FC host:
/sys/class/fc_host/host3/statistics/dumped_frames: 0x0
/sys/class/fc_host/host3/statistics/error_frames: 0x0
/sys/class/fc_host/host3/statistics/fc_no_free_exch: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fc_no_free_exch_xid: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fc_non_bls_resp: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fc_seq_not_found: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fc_xid_busy: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fc_xid_not_found: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fcp_control_requests: 0x19
/sys/class/fc_host/host3/statistics/fcp_frame_alloc_failures: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fcp_input_megabytes: 0x2829
/sys/class/fc_host/host3/statistics/fcp_input_requests: 0x114b54e
/sys/class/fc_host/host3/statistics/fcp_output_megabytes: 0x11cbf
/sys/class/fc_host/host3/statistics/fcp_output_requests: 0xd87b98
/sys/class/fc_host/host3/statistics/fcp_packet_aborts: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/fcp_packet_alloc_failures: 0xffffffffffffffff
/sys/class/fc_host/host3/statistics/invalid_crc_count: 0x0
/sys/class/fc_host/host3/statistics/invalid_tx_word_count: 0x0
/sys/class/fc_host/host3/statistics/link_failure_count: 0x0
/sys/class/fc_host/host3/statistics/lip_count: 0x0
/sys/class/fc_host/host3/statistics/loss_of_signal_count: 0x0
/sys/class/fc_host/host3/statistics/loss_of_sync_count: 0x0
/sys/class/fc_host/host3/statistics/nos_count: 0x0
/sys/class/fc_host/host3/statistics/prim_seq_protocol_err_count: 0x0
/sys/class/fc_host/host3/statistics/rx_frames: 0x43a5ec7
/sys/class/fc_host/host3/statistics/rx_words: 0x2829a23ac
/sys/class/fc_host/host3/statistics/seconds_since_last_reset: 0x57dffc
/sys/class/fc_host/host3/statistics/tx_frames: 0x4b9e39d
/sys/class/fc_host/host3/statistics/tx_words: 0x11cbf9bc00

So it's hard to tell which FC HBA supports which statistics numbers...

The only message I see from bfa after boot (regarding link_failure_count set to 1) is "kernel: bfa 0000:0e:00.0: Logical port online: WWN = 10:00:00:05:1e:fb:3e:a0 Role = Initiator"...

Regards,
Ulrich Windl

