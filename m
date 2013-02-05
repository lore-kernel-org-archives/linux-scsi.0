From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [LSF/MM] iSER Target implementation for v3.10
Date: Mon, 04 Feb 2013 21:23:30 -0800
Message-ID: <1360041810.22598.61.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: lsf-pc <lsf-pc@lists.linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

Hi folks,

[Topic]

iSER Target implementation for upstream in v3.10 timeframe

[Abstract]

I'm currently working on a kernel level iSCSI Extensions for RDMA (iSER)
target driver using OFA Verbs for Infiniband + Ethernet based
transports.

This naturally involves quite a bit of re-factoring + creation of a
iscsit_transport template in iscsi-target code to utilize existing login
+ authentication path processing, incoming RX PDU handling, outgoing TX
PDU encoding, and other logic that ends up being independent of
underlying iSCSI/TCP + iSER/RCaP transport usage.

Currently this is implemented as a secondary level fabric driver that
lives (transparently) under the top-level iscsi-target configfs group
in /sys/kernel/config/target/iscsi/, and is enabled + disabled on a per
IPv4/IPv6 network portal context basis using a 'iser' attribute.

I'll be posting the initial RFC code for review in the upcoming weeks,
and at LSF would like to discuss potential performance improvements
(namely pre-allocation) related to ib_isert that can be extended to
other fabric drivers, along with modernizations (namely se_cmd->cmd_kref
usage) for existing traditional iscsi-target code.

Thank you,

--nab
