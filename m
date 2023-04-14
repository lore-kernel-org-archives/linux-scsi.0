Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFC90C77B6E
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Apr 2023 07:37:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbjDNHh5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Apr 2023 03:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDNHhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Apr 2023 03:37:55 -0400
Received: from new4-smtp.messagingengine.com (new4-smtp.messagingengine.com [66.111.4.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E6F6A42;
        Fri, 14 Apr 2023 00:37:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E30575822FC;
        Fri, 14 Apr 2023 03:37:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 14 Apr 2023 03:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        cc:content-type:content-type:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1681457820; x=1681458420; bh=XLLhERAerHpvpvWR7EwIHo+3j
        h0i7E/z1J3JQz8Orpw=; b=eAIk8xQz+ndoutT10tmKcuQMcVbaEZ6jOC2sNIvDI
        k9APx1OqbwX/8RYRAttpjdqF+qfonmTUlk6loB2bP2EJFvELUVD0cAvWkhhE+hJM
        coYWPWs05HKuSswcpj/F99G2BdFhfJRCft6G05pG9yakiA3R0Kla3zQFavy1mVxb
        DAtHo0hFxtaw/rofVQQSLpSLHjjRn90/fnr0TEcMpdHUFD8n4cZv47bIwntQq5Fo
        a0TuGDdp28VRzhjOCaXPTIN21oeJmPUerJBNsHxmVo6MqnYprcJPaXClWmQs0WsX
        csIS1NKPcVHoOa8A9gax9q4EdztCFWeQcbPJ7uhYO8/wQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=ie1e949a3.fm3;
         t=1681457820; x=1681458420; bh=XLLhERAerHpvpvWR7EwIHo+3jh0i7E/z
        1J3JQz8Orpw=; b=hkHW+vody89G4EVZZ20L0XPxQacKSeby9hupUL6V8ut5f7ge
        AO2Zo5qqNExEUItKEgwA9yTNYKZp8Aa4vVRgwFC7PbvPyp6PyuX4I1y/UQyJhtRq
        dAoc09WPkscVK9xLNqitjTqM2xLS1ZsMqMAnkByGU7aTAeQ/VkeGfQx46cbpleY/
        WmOG5hLgE+43IA30XSWkmJqprP86oNh11ZwNrV1w3X2JKvzJOAvuc7W3OVg3Nb3Q
        o6OD5vfWTZvTsysmB9u/Rfsb1746l5EpHOKuvvQY7Jx6z+0MwR5HaP64F1DRABrm
        8+lJ4BiKYUcWMT6x2jm3jjAfrL4ycA94aQdmaw==
X-ME-Sender: <xms:nAI5ZP_97Zje1Bd8kVllHzDPc_A4j0kpDNLvowBIznvHYydeRkTOrQ>
    <xme:nAI5ZLtbkoDxuf0eBG0NNVatKVE6apKGmyvrLFu0EcU7mYCgFQpRdsswVQkWeUWEi
    7R5BXeeE_M1V83ZnZI>
X-ME-Received: <xmr:nAI5ZNBof-7M_h4JK1lfGoAhOAgljGDXOV6KfZcK1-gHTk4gnLZqLv-4Xfpj9pRyydr2oQd3oHpgnZZeBvlgEQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdekledguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkgggtugesthdtsfdttddtvdenucfhrhhomhepufhhihhnkdhi
    tghhihhrohcumfgrfigrshgrkhhiuceoshhhihhnihgthhhirhhosehfrghsthhmrghilh
    drtghomheqnecuggftrfgrthhtvghrnhepveevgeevveeivdehfeeggeeiveevfeekvdeg
    udetgeelieduheeuieekieeftedtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepshhhihhnihgthhhirhhosehfrghsthhmrghilhdrtghomh
X-ME-Proxy: <xmx:nAI5ZLfsDUmXHg_CEzedSe3anoAzathy2hg41XhMGVb_q08jT0pLug>
    <xmx:nAI5ZEP4kcTqbZJz-Gdj5_QZyCimXrmfqFOlTvCxLa11MxXmhaU39Q>
    <xmx:nAI5ZNmC3U8BL2gTCcGbisbJOrFsP-7fdpImSWxbGf6MTUgJDODq0A>
    <xmx:nAI5ZO03mwthqCfoI8OkU1eL010_ocGZIsAUo82Q2TCrWodtMH5DyWBWHNg>
Feedback-ID: ie1e949a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Apr 2023 03:36:59 -0400 (EDT)
Date:   Fri, 14 Apr 2023 16:36:55 +0900
From:   Shin'ichiro Kawasaki <shinichiro@fastmail.com>
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: blktests scsi/007 failure
Message-ID: <725nkvuvvbf4qwiylarw5r56tjt3r6nrvy5sijk6affzqv2s3e@6xapeviellsp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Bart,

Recently, I built a new blktests trial environment on QEMU. With this
environment, I observe scsi/007 failure. FYI, let me share blktests output [1]
and kernel message [2].

I found the failure depends on kernel configs for debug such as KASAN. When I
enable KASAN, the test case fails. When I disable KASAN, the test case passes.
It looks that the failure depends on the slow kernel (and/or slow machine).

The test case sets 1 second to the block layer timeout to trigger the SCSI error
handler. It also sets 3 seconds to scsi_debug delay assuming the error handler
completes before the 3 seconds. From the kernel message, it looks that the error
handler takes longer than the 3 seconds delay, so I/O completes as success
before the error handler completion. This I/O success is not expected then the
test case fails. As a trial, I extended the scsi_debug delay time to 10 seconds,
then I observed the test case passes.

Do you expect the I/O success by slow SCSI error handler? If so, the test case
needs improvement by extending the scsi_debug delay time.


[1] blktests output

scsi/007 (Trigger the SCSI error handler)                    [failed]
    runtime  25.594s  ...  13.646s
    --- tests/scsi/007.out      2023-04-06 10:11:07.926670528 +0900
    +++ /home/shin/Blktests/blktests/results/nodev/scsi/007.out.bad     2023-04-14 16:09:45.447892078 +0900
    @@ -1,3 +1,3 @@
     Running scsi/007
    -Reading from scsi_debug failed
    +Reading from scsi_debug succeeded
     Test complete

[2] kernel message

[ 3714.407999] run blktests scsi/007 at 2023-04-14 16:09:31
[ 3714.523102] scsi_debug:sdebug_driver_probe: scsi_debug: trim poll_queues to 0. poll_q/nr_hw = (0/1)
[ 3714.525023] scsi host3: scsi_debug: version 0191 [20210520]
                 dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0
[ 3714.533733] scsi 3:0:0:0: Direct-Access     Linux    scsi_debug       0191 PQ: 0 ANSI: 7
[ 3714.543198] sd 3:0:0:0: Power-on or device reset occurred
[ 3714.543250] sd 3:0:0:0: Attached scsi generic sg2 type 0
[ 3714.550936] sd 3:0:0:0: [sdc] 16384 512-byte logical blocks: (8.39 MB/8.00 MiB)
[ 3714.554821] sd 3:0:0:0: [sdc] Write Protect is off
[ 3714.558024] sd 3:0:0:0: [sdc] Mode Sense: 73 00 10 08
[ 3714.562414] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[ 3714.566601] sd 3:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
[ 3714.570045] sd 3:0:0:0: [sdc] Optimal transfer size 524288 bytes
[ 3714.586397] sd 3:0:0:0: [sdc] Attached SCSI disk
[ 3715.999917] sd 3:0:0:0: [sdc] tag#103 abort scheduled
[ 3716.015174] sd 3:0:0:0: [sdc] tag#103 aborting command
[ 3716.019935] sd 3:0:0:0: [sdc] tag#103 retry aborted command
[ 3717.090803] sd 3:0:0:0: [sdc] tag#178 previous abort failed
[ 3717.098780] scsi host3: Waking error handler thread
[ 3717.098917] scsi host3: scsi_eh_3: waking up 0/1/1
[ 3717.106279] scsi host3: scsi_eh_prt_fail_stats: cmds failed: 0, cancel: 1
[ 3717.111212] scsi host3: Total of 1 commands on 1 devices require eh work
[ 3717.116170] sd 3:0:0:0: scsi_eh_3: Sending BDR
[ 3717.120493] sd 3:0:0:0: [sdc] tag#178 scsi_eh_done result: 2
[ 3717.125183] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd timeleft: 10000
[ 3717.130301] sd 3:0:0:0: Power-on or device reset occurred
[ 3717.134935] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd: scsi_eh_completed_normally 2001
[ 3717.140241] sd 3:0:0:0: [sdc] tag#178 scsi_eh_tur return: 2001
[ 3719.033180] sd 3:0:0:0: [sdc] tag#178 scsi_eh_done result: 0
[ 3719.037656] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd timeleft: 8114
[ 3719.043293] sd 3:0:0:0: [sdc] tag#178 scsi_send_eh_cmnd: scsi_eh_completed_normally 2002
[ 3719.049631] sd 3:0:0:0: [sdc] tag#178 scsi_eh_tur return: 2002
[ 3719.055489] sd 3:0:0:0: [sdc] tag#178 scsi_eh_3: flush retry cmd
[ 3719.061420] scsi host3: waking up host to restart
[ 3719.069512] scsi host3: scsi_eh_3: sleeping
[ 3720.175944] sd 3:0:0:0: [sdc] tag#180 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=1s
[ 3720.182709] sd 3:0:0:0: [sdc] tag#180 CDB: Read(10) 28 00 00 00 3f 80 00 00 08 00
[ 3720.189825] I/O error, dev sdc, sector 16256 op 0x0:(READ) flags 0x80700 phys_seg 1 prio class 2
[ 3722.342015] sd 3:0:0:0: Power-on or device reset occurred
[ 3725.349863] sd 3:0:0:0: Power-on or device reset occurred
[ 3727.275069] sd 3:0:0:0: [sdc] tag#79 Medium access timeout failure. Offlining disk!
[ 3727.279944] sd 3:0:0:0: [sdc] tag#79 FAILED Result: hostbyte=DID_TIME_OUT driverbyte=DRIVER_OK cmd_age=7s
[ 3727.285131] sd 3:0:0:0: [sdc] tag#79 CDB: Read(10) 28 00 00 00 3f 80 00 00 08 00
[ 3727.289961] I/O error, dev sdc, sector 16256 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 2
[ 3727.294862] Buffer I/O error on dev sdc, logical block 2032, async page read
[ 3727.996161] sd 3:0:0:0: [sdc] Synchronizing SCSI cache

