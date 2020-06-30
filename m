Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85F9C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 16:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A0A020723
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 16:49:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="Y4lqJd/g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgF3Qt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 12:49:27 -0400
Received: from mail3.bemta25.messagelabs.com ([195.245.230.85]:24265 "EHLO
        mail3.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728022AbgF3Qt1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 12:49:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1593535763; i=@ts.fujitsu.com;
        bh=ikU9y8d9NWle2jmeRj0Q9QG+d25DFL9hUdZ8kAybhLI=;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=Y4lqJd/gP8K8c7o3ucpwtB9qRN6dARkSI7VjrHf0uL/V20QVW4XPbOR3WGk+iZUmC
         cRBE4/FdDm4ix2iYZEggV2BL35lkjXziWXPthMm9HjKeXDl8WlmTfVlLQLqNmb00pZ
         oF9Rf1iczqUTmMCrIZ76nVawJ1puRBxnvmjCgGTGDwvmnoj7H+TmLT8rg+WFKi5etZ
         Gm2TbzUIaeEM4fXR7u4UHUH8dqNxWy4ikDPRYwpgwzxOnL2UIbKvpeycpzPLuA07rs
         5xfzwPi6AoGyQhCNgaxlJfkZ2mD3Om+IgTzhW+hs6lz53DSPATOFVBBwmmfP6rq+mV
         lAYz3BzKAVwKg==
Received: from [100.112.197.196] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-west-1.aws.symcld.net id B5/94-04571-31D6BFE5; Tue, 30 Jun 2020 16:49:23 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRWlGSWpSXmKPExsViZ8MxVVco93e
  cQcMna4vu6zvYLJYf/8dk8XfSDVaL1qVvmRxYPD4+vcXi8XmTXABTFGtmXlJ+RQJrxqwJD9kL
  uuUqbv59ydLAOF2ii5GLQ0hgMqPEgYvXmCCcfkaJE7/2s3QxcnKwCRhIrJh0H8wWFvCSuLL/E
  jtIkYjAGkaJlXfmMYMkeAUcJb4/PMoOYrMIqEoc//+TrYuRg0NUIFzi2Qp/iBJBiZMzn4DNYR
  ZQl/gz7xIzhC0ucevJfCYIW15i+9s5zBMYeWYhaZmFpGUWkpZZSFoWMLKsYjRPKspMzyjJTcz
  M0TU0MNA1NDTSNbQ00zUz0Uus0k3SSy3VLU8tLtE11EssL9YrrsxNzknRy0st2cQIDM6UgiMO
  Oxjvv/6gd4hRkoNJSZT3ctLvOCG+pPyUyozE4oz4otKc1OJDjDIcHEoSvE+ygHKCRanpqRVpm
  TnASIFJS3DwKInwemUDpXmLCxJzizPTIVKnGBWlxHkXgyQEQBIZpXlwbbDovMQoKyXMy8jAwC
  DEU5BalJtZgir/ilGcg1FJmNcCZApPZl4J3PRXQIuZgBZf0/oFsrgkESEl1cC0+EHsw+Wq+gd
  n3PEvCno4S3zP/7tW/4r1WuZyhYY85t7f0ZHstmlBFcvrxioZ/zcLC74Ep2TvmtHbtnfajuXa
  n9jn8Oy5ZuQzqdH8/J+vOc6/ZhyVWrJNauf/zHW628tYNgp7P+GpKqrs0HPo/aAhueelgftJn
  1uypfbrn84uLm3KlE3b+nt2vt2e8zu3mJcyylT97k0+0D3n6mWXjn7h7ns8TLlFk3e7GD/WEd
  +bJfYnMr2/sXjp1KYZgawbfzjG7943f60sl5aBbHvDjFfGM/80a3/1NogIipTqKtd5JTo/aM6
  z4Mp2/lhRaZdptfW7BaWlUkq8Z14+3GzgcDvthODyVZ2x0w36HA0WLlJiKc5INNRiLipOBABU
  OnwxSQMAAA==
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-15.tower-285.messagelabs.com!1593535762!1425794!1
X-Originating-IP: [62.60.8.149]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.2; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 29368 invoked from network); 30 Jun 2020 16:49:22 -0000
Received: from unknown (HELO mailhost2.uk.fujitsu.com) (62.60.8.149)
  by server-15.tower-285.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 30 Jun 2020 16:49:22 -0000
Received: from x-serv01 ([172.17.38.52])
        by mailhost2.uk.fujitsu.com (8.14.5/8.14.5) with SMTP id 05UGnC53003309;
        Tue, 30 Jun 2020 17:49:12 +0100
Received: from [172.17.39.90] (unknown [172.17.39.90])
        by x-serv01 (Postfix) with ESMTP id 2C70520251;
        Tue, 30 Jun 2020 18:49:07 +0200 (CEST)
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Message-ID: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
Date:   Tue, 30 Jun 2020 18:49:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

When using tcmu it might happen, that userspace application cannot be
built as 64 bit program even on a 64 bit host due to existing 32 bit
libraries that must be used, e.g. for compression, encryption,
deduplication, ...

Currently this only works with manual changes in userspace include
file target_core_user.h due to a missing padding field in
struct tcmu_cmd_entry.

Here are field offsets printed by a small program on a 64 bit host,
compiled as 64 bit program and as 32 bit:

Devel:~ # gcc -o print_offsets print_offsets.c
Devel:~ # ./print_offsets
Offset of tcmu_cmd_entry.hdr.len_op          = 0000
Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
Offset of tcmu_cmd_entry.hdr.kflags          = 0006
Offset of tcmu_cmd_entry.hdr.uflags          = 0007

Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
Offset of tcmu_cmd_entry.req.cdb_off         = 0018
Offset of tcmu_cmd_entry.req.iov[0]          = 0030

Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
Offset of tcmu_cmd_entry.rsp.read_len        = 000c
Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010

Size of struct tcmu_cmd_entry = 0070


Devel:~ # gcc -m32 -o print_offsets print_offsets.c
Devel:~ # ./print_offsets
Offset of tcmu_cmd_entry.hdr.len_op          = 0000
Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
Offset of tcmu_cmd_entry.hdr.kflags          = 0006
Offset of tcmu_cmd_entry.hdr.uflags          = 0007

Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
Offset of tcmu_cmd_entry.req.cdb_off         = 0014
Offset of tcmu_cmd_entry.req.iov[0]          = 002c

Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
Offset of tcmu_cmd_entry.rsp.read_len        = 000c
Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010

Size of struct tcmu_cmd_entry = 0070


The offset of the fields req.cdb_off and req.iov differ for 64-bit
and 32-bit compilation.

That means:
 - 64-bit application on 64-bit host works well
 - 32-bit application on 32-bit host works well
 - 32-bit application on 64-bit host fails.

Unfortunately I don't see a way to fix this problem such, that
32-bit application runs fine on 32-bit and 64-bit host without
breaking compatibility.

So I'm wondering whether the following change would be a viable
solution:

diff --git a/include/uapi/linux/target_core_user.h b/include/uapi/linux/target_core_user.h
--- a/include/uapi/linux/target_core_user.h
+++ b/include/uapi/linux/target_core_user.h
@@ -114,6 +114,9 @@ struct tcmu_cmd_entry {
 			__u32 iov_cnt;
 			__u32 iov_bidi_cnt;
 			__u32 iov_dif_cnt;
+#ifdef APPL32BIT_ON_KERNEL64BIT
+			__u32 __pad9;
+#endif
 			__u64 cdb_off;
 			__u64 __pad1;
 			__u64 __pad2;


Using this change we can do:

Devel:~ # gcc -m32 -DAPPL32BIT_ON_KERNEL64BIT -o print_offsets print_offsets.c
Devel:~ # ./print_offsets
Offset of tcmu_cmd_entry.hdr.len_op          = 0000
Offset of tcmu_cmd_entry.hdr.cmd_id          = 0004
Offset of tcmu_cmd_entry.hdr.kflags          = 0006
Offset of tcmu_cmd_entry.hdr.uflags          = 0007

Offset of tcmu_cmd_entry.req.iov_cnt         = 0008
Offset of tcmu_cmd_entry.req.iov_bidi_cnt    = 000c
Offset of tcmu_cmd_entry.req.iov_dif_cnt     = 0010
Offset of tcmu_cmd_entry.req.cdb_off         = 0018
Offset of tcmu_cmd_entry.req.iov[0]          = 0030

Offset of tcmu_cmd_entry.rsp.scsi_status     = 0008
Offset of tcmu_cmd_entry.rsp.read_len        = 000c
Offset of tcmu_cmd_entry.rsp.sense_buffer[0] = 0010

Size of struct tcmu_cmd_entry = 0070


So we can compile a 32-bit application that works on 64-bit kernel without
need to manipulate the include file prepared by the kernel.

What do you think? Do you know a better solution?

Thank you,
Bodo

