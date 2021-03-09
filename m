Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,HK_RANDOM_REPLYTO,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E4B0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 04:13:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36F1D64DAE
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Mar 2021 04:13:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCIEMy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Mar 2021 23:12:54 -0500
Received: from mout.perfora.net ([74.208.4.194]:33605 "EHLO mout.perfora.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229714AbhCIEMa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Mar 2021 23:12:30 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Mar 2021 23:12:30 EST
Received: from [192.168.0.186] ([108.168.115.113]) by mrelay.perfora.net
 (mreueus003 [74.208.5.2]) with ESMTPSA (Nemesis) id 0LkeyA-1lrQtZ0Hsi-00aYFt
 for <linux-scsi@vger.kernel.org>; Tue, 09 Mar 2021 05:07:29 +0100
To:     linux-scsi@vger.kernel.org
Reply-To: tomkcpr@mdevsys.com
From:   TomK <tomkcpr@mdevsys.com>
Subject: qla2xxx fails to present LUN's.
Message-ID: <385d62fa-8786-c942-e3bd-3e9a32ce60c5@mdevsys.com>
Date:   Mon, 8 Mar 2021 23:07:27 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:B6qQ1IKcPVECyk/kRdV0U2wNjGE53Ld1UEJ0IYao+2DS7PG8W/D
 Ers+kpOaHMR3oISp3XrB+6E21gMrrQdCAowv0kag9flJMK/PKGzoz7Do1zOI95/8oMMLMVq
 ir6dGrv/hW0VguH1mlwcu/1ledRGc5TrmMChRCWmoENr8g/ijEKFAwN69NNDVDx18EKebgI
 8gEHggMqnNDB/1fAOjylQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:8SR1LZCQdwA=:vMcrYjc0Vgz/kWQt068svj
 Y78ySjyBcQUuwHozw4HOv6uqkyhRyHNRLmq6mKhGNOh394khAyxfxy/5hmdRqsdDzN5j5/2Tu
 NWJqLGlysGKzNS7acgvTFTMKgv5rPe/9Lo84pqwpE2jc5MveJs4wsgBhTOAmWEMzxj6vdDhws
 b6rsLm+o/xXlVeqcHCpsaAnhegi6Nmc80EiVEgNLq/6x9Nf4o3bNqujWiAzUqaA8UCJs+4T2X
 tAA68JXRYcYOuNIUAALmN8AtMDYy6ehcapgRjbT7yXeMUUTTJBRYBQjmCdPrs0BzYNDr2IIMr
 rkMiW7w3qAvfwziWA0fZWIxpEE4X4oSIuQ7qeHs9DyvrdhdqWSTsfgXN880tx65bnszPaK0Xh
 NXXcC9ZsU0X0OvA1uG6hXPz+14vvi4TGkcvIpOb5OMOkYsp3/SeVX769hmqR4xXpDAp8FUICn
 U/j2PqGK9w==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

Using QLogic Corp. ISP2432 as a target for a make-shift storage solution.

Every now and then the qla2xxx drivers on the storage server (target) 
fail and stop presenting any LUNS to the initiators.  This is despite 
nothing being wrong with the SFP's or the cables.  No combination of 
actions such as starting, restarting, changing cables, SFP's makes any 
difference. The target simply stops presenting LUNS.

One of the suggestions I've read about is to disable irqpoll.

https://access.redhat.com/solutions/1273273

However, is this the right step to take and remove it from the boot 
options?  Or is there something more I'm missing.  The target was up for 
more then 230 days suggesting otherwise.

Appreciate any feedback.

LOG
------------------

Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=8192, cmd->sg_cnt=2, 
cmd->dma_data_direction=1 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0fe9
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 000e
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, 
cmd->dma_data_direction=1 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 000e
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0fcf
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, 
cmd->dma_data_direction=1 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0fcf
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0fd1
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=1, 
cmd->dma_data_direction=1 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0fd1
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e82e:3: 
IMMED_NOTIFY ATIO
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-f826:3: 
qla_target(0): Port ID: 01:02:00 ELS opcode: 0x03 lid 2 
20:01:47:81:16:67:99:3a
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-f897:3: Linking 
sess 00000000884c90f2 [0] wwn 20:01:47:81:16:67:99:3a with PLOGI ACK to 
wwn 20:01:47:81:16:67:99:3a s_id 01:02:00, ref=1 pla 0000000008279d60 link 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-28f9:3: 
qlt_handle_login 4772 20:01:47:81:16:67:99:3a  DS 8
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-28f9:3: 
qlt_handle_login 4803 20:01:47:81:16:67:99:3a post del sess
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e801:3: 
Scheduling sess 00000000884c90f2 for deletion
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-f826:3: 
qla_target(0): Exit ELS opcode: 0x03 res 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-290a:3: 
qlt_unreg_sess sess 00000000884c90f2 for deletion 20:01:47:81:16:67:99:3a
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-287d:3: FCPort 
20:01:47:81:16:67:99:3a state transitioned from ONLINE to LOST - 
portid=010200.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-28a3:3: Port 
login retry 500143801677993a, lid 0x0002 retry cnt=45.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-f884:3: 
qlt_free_session_done: se_sess 00000000e8086aa7 / sess 00000000884c90f2 
from port 20:01:47:81:16:67:99:3a loop_id 0x02 s_id 01:02:00 logout 1 
keep 1 els_logo 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-2870:3: 
Async-logout - hdl=246 loop-id=2 portid=010200 20:01:47:81:16:67:99:3a.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-5836:3: 
Async-logout complete - 20:01:47:81:16:67:99:3a hdl=246 portid=010200 
iop0=0.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-f893:3: 
qlt_logo_completion_handler: se_sess 00000000e8086aa7 / sess 
00000000884c90f2 from port 20:01:47:81:16:67:99:3a loop_id 0x02 s_id 
01:02:00 LOGO failed: 0x0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0fdc
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0fdc
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-680b:3: 
isp_abort_needed=0 loop_resync_needed=0 fcport_update_needed=0 
start_dpc=0 reset_marker_needed=0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-680c:3: 
beacon_blink_needed=0 isp_unrecoverable=0 fcoe_ctx_reset_needed=0 
vp_dpc_needed=0 relogin_needed=1.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-4801:3: DPC 
handler waking up, dpc_flags=0x100.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-480d:3: Relogin 
scheduled.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-4800:3: DPC 
handler sleeping.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-2908:3: 
qla2x00_relogin 20:01:47:81:16:67:99:3a DS 10 LS 3
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-2902:3: 
qla24xx_handle_relogin_event 20:01:47:81:16:67:99:3a DS 10 LS 3 P 0 del 
1 cnfl           (null) rscn 0|0 login 4|5 fl 1
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-2908:3: 
qla2x00_relogin 31:03:10:1b:31:81:51:21 DS 0 LS 7
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-2902:3: 
qla24xx_handle_relogin_event 31:03:10:1b:31:81:51:21 DS 0 LS 7 P 0 del 2 
cnfl           (null) rscn 0|0 login 0|0 fl 3
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-28d8:3: 
qla24xx_fcport_handle_login 31:03:10:1b:31:81:51:21 DS 0 LS 7 P 0 fl 3 
confl           (null) rscn 0|0 login 0 retry 45 lid 4096 scan 2
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-480e:3: Relogin 
end.
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0f68
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=512, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0f68
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e872:3: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0fca
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e818: 
is_send_status=1, cmd->bufflen=4096, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[000000002dc8fdca] qp 0
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.1]-e874:3: 
qlt_free_cmd: se_cmd[000000002dc8fdca] ox_id 0fca
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.0]-e872:2: 
qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 06ad
Mar  7 07:06:11 storage01 kernel: qla2xxx [0000:04:00.0]-e818: 
is_send_status=1, cmd->bufflen=512, cmd->sg_cnt=0, 
cmd->dma_data_direction=2 se_cmd[00000000da3fa0ff] qp 0


[root@storage01 log]# modinfo qla2xxx
filename:       /lib/modules/4.18.19/kernel/drivers/scsi/qla2xxx/qla2xxx.ko
firmware:       ql2500_fw.bin
firmware:       ql2400_fw.bin
firmware:       ql2322_fw.bin
firmware:       ql2300_fw.bin
firmware:       ql2200_fw.bin
firmware:       ql2100_fw.bin
version:        10.00.00.07-k
license:        GPL
description:    QLogic Fibre Channel HBA Driver
author:         QLogic Corporation
srcversion:     182E6CC028891402101A4D4
alias:          pci:v00001077d00002261sv*sd*bc*sc*i*
alias:          pci:v00001077d00002271sv*sd*bc*sc*i*

Log setting:

echo 0x7fffffff > /sys/module/qla2xxx/parameters/ql2xextended_error_logging

-- 
Thx,
TK.
