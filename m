From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/2] [tgt]: Add proper STGT <-> bs_sg passthrough v2
Date: Tue,  1 Jun 2010 01:50:36 -0700
Message-ID: <1275382236-17647-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:41721 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753411Ab0FAItd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2010 04:49:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: stgt-devel <stgt@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Boaz Harrosh <bharr>
Cc: James Bottomley <James.Bottomley@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings STGT folks,

Here is another go at a proper STGT bs_sg passthrough following input from Tomo and Boaz.
After taking another look, it ended up making alot more sense to split up the queue and
completion paths into struct scsi_lu->cmd_perform() and struct scsi_lu->cmd_done() callers
to support existing 'internal STGT port emulation' and proper struct scsi_cmd -> LUN passthrough
for bs_sg with TCM_Loop ports.

Following Boaz's recommendation, I will next have a look at extending bs_sg to support BSG so we
can actually pass things like SCSI Task Attrs and TMRs into TCM_Loop ports.  Until then, please have
a look and let me know if anything is missing.  These patches have been tested using STGT/iSCSI <->
TCM_Loop iSCSI Target Ports on v2.6.34 via Open-iSCSI with SPC-4 ALUA.  Here is the brief status:

tgtadm --lld iscsi --mode target --op show 
Target 1: iqn.2003-01.org.linux-iscsi.target.i686:sn.2aa7bad648f
    System information:
        Driver: iscsi
        State: ready
    I_T nexus information:
        I_T nexus: 1
            Initiator: iqn.1993-08.org.debian:01:2dadf92d0ef
            Connection: 0
                IP Address: 172.16.201.129
    LUN information:
        LUN: 0
            Type: controller
            SCSI ID: IET     00010000
            SCSI SN: beaf10
            Size: 0 MB
            Online: Yes
            Removable media: No
            Backing store type: rdwr
            Backing store path: None
        LUN: 1
            Type: disk
            SCSI ID: IET     00010001
            SCSI SN: beaf11
            Size: 0 MB
            Online: Yes
            Removable media: No
            Backing store type: sg
            Backing store path: /dev/sg7
    Account information:
    ACL information:
        ALL

and on the Open-iSCSI side:

[ 3282.692718] scsi6 : iSCSI Initiator over TCP/IP
[ 3282.979474] scsi 6:0:0:0: RAID              IET      Controller       0001 PQ: 0 ANSI: 5
[ 3282.982814] scsi 6:0:0:0: Attached scsi generic sg4 type 12
[ 3282.986803] scsi 6:0:0:1: Direct-Access     LIO-ORG  IBLOCK           3.1  PQ: 0 ANSI: 5
[ 3282.990601] sd 6:0:0:1: [sdf] 3072000 512-byte hardware sectors (1573 MB)
[ 3282.995035] sd 6:0:0:1: [sdf] Write Protect is off
[ 3282.995050] sd 6:0:0:1: [sdf] Mode Sense: 2f 00 00 00
[ 3282.999349] sd 6:0:0:1: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 3283.003189] sd 6:0:0:1: [sdf] 3072000 512-byte hardware sectors (1573 MB)
[ 3283.005275] sd 6:0:0:1: [sdf] Write Protect is off
[ 3283.005287] sd 6:0:0:1: [sdf] Mode Sense: 2f 00 00 00
[ 3283.008722] sd 6:0:0:1: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[ 3283.009550]  sdf: unknown partition table
[ 3283.091273] sd 6:0:0:1: [sdf] Attached SCSI disk
[ 3283.092361] sd 6:0:0:1: Attached scsi generic sg5 type 0
[ 3283.419050] sd 6:0:0:1: alua: supports implicit and explicit TPGS
[ 3283.426177] sd 6:0:0:1: alua: port group 00 rel port 01
[ 3283.428413] sd 6:0:0:1: alua: port group 00 state A supports TOUSNA
[ 3283.454882] sd 6:0:0:1: alua: port group 00 state A supports TOUSNA

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (2):
  [tgt]: Add proper STGT LUN backstore passthrough support
  [bs_sg]: Add bs_sg_init() for STGT LUN passthrough

 usr/bs_sg.c  |   20 ++++++++++++
 usr/sbc.c    |    1 +
 usr/target.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 usr/tgtd.h   |   15 +++++++++
 4 files changed, 120 insertions(+), 8 deletions(-)

