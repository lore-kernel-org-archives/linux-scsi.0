Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36AC3C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 02:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4C8061166
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Apr 2021 02:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhDNCL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 22:11:57 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:39362 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229769AbhDNCL4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Apr 2021 22:11:56 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id AFAF041373;
        Wed, 14 Apr 2021 02:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1618366292;
         x=1620180693; bh=sBoHdsx2yhlJUPKFliaRIve5fW5t1p8Hf12vJmv+hQw=; b=
        VNCs1D0+8fIwR6jTJ2TEFTl2FI9IODuBPHTtOX14O4OdY6iVyTGLcVQTSUYsQliZ
        N40BB6gDzyUNNXRcMUXgz2gF0GasBtuB0wt7CqF893sg1KjcBkbEg05VPrWfMne2
        x+iQPDSjgXXLCiFB9ZvbX2OLwjC2Bx9rWx229UrJFWE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bymHcYUfmMcu; Wed, 14 Apr 2021 05:11:32 +0300 (MSK)
Received: from T-EXCH-03.corp.yadro.com (t-exch-03.corp.yadro.com [172.17.100.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4A37541372;
        Wed, 14 Apr 2021 05:11:32 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-03.corp.yadro.com
 (172.17.100.103) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Wed, 14
 Apr 2021 05:11:32 +0300
Date:   Wed, 14 Apr 2021 05:11:31 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     TomK <tomkcpr@mdevsys.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: Re: QLE2432 initiator fails to see any LUN's on one of servers while
 using 5QLE2464 as a target.
Message-ID: <YHZPU5Q0N+isZAGB@SPB-NB-133.local>
References: <912519f2-69f7-b31a-8c25-af6254e5d0d3@mdevsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <912519f2-69f7-b31a-8c25-af6254e5d0d3@mdevsys.com>
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-03.corp.yadro.com (172.17.100.103)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 10, 2021 at 11:27:12AM -0400, TomK wrote:
> Hey Everyone,
> 
> In a basic SAN config using a few QLE2432 adapters connected to a target
> using a QLE2464 adapter via a EMC Brocade 5000B switch, one of the
> initiators fails to present a LUN after being online for sometime.  Over a
> period of time, few months, the initiator on one of the hosts stops showing
> available LUN's to the underlying VMware clients.
> 
> All the other hosts are fine, except for this specific one.  Unless that is,
> I reboot the target completely, affecting all the other working hosts in the
> process.
> 
> Digging a bit closer, I notice that the issue seems to strike an uncanny
> similarity to the following one:
> 
> https://www.spinics.net/lists/linux-scsi/msg136622.html

Hi Tom,

The discussion was related to P2P mode and that didn't work reliably
back in 2019. Your case is different because of the fabric switch
involved.

You're running driver v10.00.00.07-k, included in Linux 4.18.  I guess
that's Debian 9 (stretch) or Ubuntu 18.04 (Bionic).

What distribution are you running and what kernel version is installed
on the target?

> 
> However, I'm wondering why only one of the servers is affected and not the
> others?  Seems it is a card issue with the first host (please see image)
> however I'm not familiar with all the messages printed so can't be sure of
> the reason nor link things as effectively. Neither of the two ports of the
> HBA on Server 1 work, when in this disconnected state, despite switching
> SFP's on the Brocade switch, switching cables etc. That is, again, until I
> reboot the target entirely.
> 
> Initiator:
>                  50:01:43:80:16:77:99:38; 50:01:43:80:16:77:99:3a;
>                  50:01:43:80:16:77:99:3b; 50:01:43:80:16:77:99:39
> 
> Target:
> 		(see below)
> 
> This also started to happen a few months ago.  Everything was fine for a few
> years before that.
> 

I wonder if the kernel on the target was updated or may be ESXi itself
was updated?

The log below is helpful but not complete, it's not clear what happened
early after the first link init. To collect full logs you might need to
boot the kernel with qla2xxx.logging=0x7fffffff and then dump everything
related a port of qla2xxx, (e.g. 0000:04.00.0):

journalctl -k | grep 'qla2xxx \[0000:04:00.0\]'

> 
> Log snippet:
> 
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818:
> is_send_status=1, cmd->bufflen=73728, cmd->sg_cnt=0,
> cmd->dma_data_direction=2 se_cmd[00000000cc1dc466] qp 0
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:2: qlt_free_cmd:
> se_cmd[00000000cc1dc466] ox_id 00e1
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2:
> qlt_24xx_atio_pkt_all_vps: qla_target(0): type 6 ox_id 0110
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e818:
> is_send_status=1, cmd->bufflen=10240, cmd->sg_cnt=0,
> cmd->dma_data_direction=2 se_cmd[00000000cc1dc466] qp 0
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e874:2: qlt_free_cmd:
> se_cmd[00000000cc1dc466] ox_id 0110
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2:
> qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:2: IMMED_NOTIFY
> ATIO
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2:
> qla_target(0): Port ID: 01:09:00 ELS opcode: 0x03 lid 7
> 50:01:43:80:16:77:99:3a


Initiator port 3a performs PLOGI.

> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f897:2: Linking sess
> 00000000088a6dfa [0] wwn 50:01:43:80:16:77:99:3a with PLOGI ACK to wwn
> 50:01:43:80:16:77:99:3a s_id 01:09:00, ref=1 pla 000000004bdf1d76 link 0
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f9:2:
> qlt_handle_login 4772 50:01:43:80:16:77:99:3a  DS 8
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f9:2:
> qlt_handle_login 4803 50:01:43:80:16:77:99:3a post del sess
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e801:2: Scheduling
> sess 00000000088a6dfa for deletion
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2:
> qla_target(0): Exit ELS opcode: 0x03 res 0
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-290a:2:
> qlt_unreg_sess sess 00000000088a6dfa for deletion 50:01:43:80:16:77:99:3a

PLOGI replaces existing and session and it's scheduled for deletion and
transitioned from ONLINE to LOST.

> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-287d:2: FCPort
> 50:01:43:80:16:77:99:3a state transitioned from ONLINE to LOST -
> portid=010900.
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28a3:2: Port login
> retry 500143801677993a, lid 0x0007 retry cnt=45.
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f884:2:
> qlt_free_session_done: se_sess 000000001f2eac78 / sess 00000000088a6dfa from
> port 50:01:43:80:16:77:99:3a loop_id 0x07 s_id 01:09:00 logout 1 keep 1
> els_logo 0
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f886:2:
> qlt_free_session_done: waiting for sess 00000000088a6dfa logout
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2870:2: Async-logout
> - hdl=172 loop-id=7 portid=010900 50:01:43:80:16:77:99:3a.
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5836:2: Async-logout
> complete - 50:01:43:80:16:77:99:3a hdl=172 portid=010900 iop0=0.
> Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f893:2:
> qlt_logo_completion_handler: se_sess 000000001f2eac78 / sess
> 00000000088a6dfa from port 50:01:43:80:16:77:99:3a loop_id 0x07 s_id
> 01:09:00 LOGO failed: 0x0

Then some interesting things happens:
(https://www.microdevsys.com/WordPressDownloads/qla2xxx-hba.log-recent.start.end.event.txt):

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680b:2: isp_abort_needed=0 loop_resync_needed=0 fcport_update_needed=0 start_dpc=0 reset_marker_needed=0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-680c:2: beacon_blink_needed=0 isp_unrecoverable=0 fcoe_ctx_reset_needed=0 vp_dpc_needed=0 relogin_needed=1.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4801:2: DPC handler waking up, dpc_flags=0x100.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-480d:2: Relogin scheduled.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-4800:2: DPC handler sleeping.

Target then tries to relogin into some ports.

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2908:2: qla2x00_relogin 21:01:00:1b:32:a1:81:21 DS 0 LS 7
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2902:2: qla24xx_handle_relogin_event 21:01:00:1b:32:a1:81:21 DS 0 LS 7 P 0 del 2 cnfl           (null) rscn 0|0 login 0|0 fl 3
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28d8:2: qla24xx_fcport_handle_login 21:01:00:1b:32:a1:81:21 DS 0 LS 7 P 0 fl 3 confl           (null) rscn 0|0 login 0 retry 45 lid 4096 scan 2

This is a nitpick but it seems you have both target ports in the same
zone: 21:01:00:1b:32:a1:81:21 and 21:00:00:1b:32:81:81:21. It's
recommended to use pairs Single Initiator Port / Single Target Port zones.

Typically there's not much sense to have zoning between pure target
ports.

Please see:
 https://www.brighttalk.com/webcast/14967/355259
 https://fibrechannel.org/wp-content/uploads/2019/06/FCIA-FC-Zoning-Basics-Final.pdf
 https://fibrechannel.org/fibre-channel-zoning-fundamentals-and-fundamental-questions/

[... log message related to port 38 ...]

The target considers relogin into port 3a:

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2908:2: qla2x00_relogin 50:01:43:80:16:77:99:3a DS 10 LS 3

DS = 10 means DSC_DELETE_PEND, LS 3 = DSC_LS_PLOGI_PEND

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2902:2: qla24xx_handle_relogin_event 50:01:43:80:16:77:99:3a DS 10 LS 3 P 0 del 1 cnfl           (null) rscn 0|0 login 8|9 fl 1
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-480e:2: Relogin end.

But relogin from target side is skipped because the session is pending PLOGI:

        if ((fcport->fw_login_state == DSC_LS_PLOGI_PEND) ||
            (fcport->fw_login_state == DSC_LS_PRLI_PEND))
                return;

The session is then getting fully deleted:

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f887:2: qlt_free_session_done: sess 00000000088a6dfa logout completed
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f89a:2: se_sess           (null) / sess 00000000088a6dfa port 50:01:43:80:16:77:99:3a is gone, releasing own PLOGI (ref=1)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5889:2: Sending PLOGI ACK to wwn 50:01:43:80:16:77:99:3a s_id 01:09:00 loop_id 0x07 exch 0x11223c ox_id 0xae
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f801:2: Unregistration of sess 00000000088a6dfa 50:01:43:80:16:77:99:3a finished fcp_cnt 4
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f4:2: Async-nack 50:01:43:80:16:77:99:3a hndl 175 PLOGI
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f2:2: Async done-nack res 0 50:01:43:80:16:77:99:3a  type 16
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-5811:2: Asynchronous PORT UPDATE ignored 0007/0004/0600.
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83d:2: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=7, m[2]=4, m[3]=600)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83e:2: Async MB 2: Got PLOGI Complete
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83d:2: qla_target(0): Port update async event 0x8014 occurred: updating the ports database (m[0]=8014, m[1]=7, m[2]=4, m[3]=600)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f83e:2: Async MB 2: Got PLOGI Complete

New PLOGI from 3a is accepted.

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e872:2: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 5001
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-e82e:2: IMMED_NOTIFY ATIO
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2: qla_target(0): Port ID: 01:09:00 ELS opcode: 0x20 lid 7 50:01:43:80:16:77:99:3a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f896:2: PRLI (loop_id 0x07) for existing sess 00000000088a6dfa (loop_id 0x07)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28fb:2: qlt_24xx_handle_els 4986 50:01:43:80:16:77:99:3a post nack
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f826:2: qla_target(0): Exit ELS opcode: 0x20 res 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f806:2: Adding sess 00000000088a6dfa se_sess 000000001f2eac78  to tgt 00000000be50a70a sess_count 6
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-f84b:2: qla_target(0): session for wwn 50:01:43:80:16:77:99:3a (loop_id 7, s_id 1:9:0, confirmed completion not supported) added
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-d034:2: qla24xx_do_nack_work create sess success 00000000088a6dfa
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f4:2: Async-nack 50:01:43:80:16:77:99:3a hndl 176 PRLI
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f2:2: Async done-nack res 0 50:01:43:80:16:77:99:3a  type 17
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28f3:2: qla2x00_async_nack_sp_done 606 50:01:43:80:16:77:99:3a post upd_fcport fcp_cnt 5
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-28ef:2: qla2x00_update_fcport 50:01:43:80:16:77:99:3a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-287d:2: FCPort 50:01:43:80:16:77:99:3a state transitioned from LOST to ONLINE - portid=010900.

Initiator successfully performed PRLI, so FCP session from port 3a should
be established... but then the session is not added to the target.
The line provide a hint about what's going on:

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.0]-2100:2: qla_nvme_register_remote: Not registering target since Host NVME is not enabled

The line is printed from:

int qla_nvme_register_remote(struct scsi_qla_host *vha, struct fc_port *fcport)
{
[...]
        if (!vha->flags.nvme_enabled) {
                ql_log(ql_log_info, vha, 0x2100,
                    "%s: Not registering target since Host NVME is not enabled\n",
                    __func__);
                return 0;
        }
[...]
}

And qla2x00_update_fcport() quits before the session is added to target:

void
qla2x00_update_fcport(scsi_qla_host_t *vha, fc_port_t *fcport)
{
[...]
        qla2x00_set_fcport_state(fcport, FCS_ONLINE);
        qla2x00_iidma_fcport(vha, fcport);

        if (fcport->fc4f_nvme) {
                qla_nvme_register_remote(vha, fcport);
                return;
        }

        qla24xx_update_fcport_fcp_prio(vha, fcport);

	switch (vha->host->active_mode) {
        case MODE_INITIATOR:
                qla2x00_reg_remote_port(vha, fcport);
                break;
        case MODE_TARGET:
                if (!vha->vha_tgt.qla_tgt->tgt_stop &&
                        !vha->vha_tgt.qla_tgt->tgt_stopped)
                        qlt_fc_port_added(vha, fcport);
                break;
        case MODE_DUAL:
                qla2x00_reg_remote_port(vha, fcport);
                if (!vha->vha_tgt.qla_tgt->tgt_stop &&
                        !vha->vha_tgt.qla_tgt->tgt_stopped)
                        qlt_fc_port_added(vha, fcport);
                break;
        default:
                break;
        }
[...]
}

Initiator thinks the session is alive because PRLI was accepted but the
session doesn't exist from the target perspective and all I/O from the
initiator port is going to be discarded.

I guess NVMe support introduced in e84067d743010 ("scsi: qla2xxx: Add
FC-NVMe F/W initialization and transport registration") broke target in
v4.18

On the second target port of the same HBA (21:01:00:1b:32:a1:81:21) I
can see that target is blindly rejecting PLOGI from port 3a:

Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e872:3: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e82e:3: IMMED_NOTIFY ATIO
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f826:3: qla_target(0): Port ID: 01:09:00 ELS opcode: 0x03 lid 7 50:01:43:80:16:77:99:3a
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e81c:3: Sending TERM ELS CTIO (ha=0000000000841139)
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f897:3: Linking sess 0000000050a6ebea [0] wwn 50:01:43:80:16:77:99:3a with PLOGI ACK to wwn 50:01:43:80:16:77:99:3a s_id 01:09:00, ref=2 pla 0000000091a7edfc link 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-28f9:3: qlt_handle_login 4772 50:01:43:80:16:77:99:3a  DS 3
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-28f9:3: qlt_handle_login 4803 50:01:43:80:16:77:99:3a post del sess
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f826:3: qla_target(0): Exit ELS opcode: 0x03 res 0
Mar 28 02:40:24 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e862:3: qla_target(0): Unexpected NOTIFY_ACK received

[...]

Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e872:3: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e82e:3: IMMED_NOTIFY ATIO
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f826:3: qla_target(0): Port ID: 01:09:00 ELS opcode: 0x03 lid 7 50:01:43:80:16:77:99:3a
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e81c:3: Sending TERM ELS CTIO (ha=0000000000841139)
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f897:3: Linking sess 0000000050a6ebea [0] wwn 50:01:43:80:16:77:99:3a with PLOGI ACK to wwn 50:01:43:80:16:77:99:3a s_id 01:09:00, ref=2 pla 0000000091a7edfc link 0
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-28f9:3: qlt_handle_login 4772 50:01:43:80:16:77:99:3a  DS 3
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-28f9:3: qlt_handle_login 4803 50:01:43:80:16:77:99:3a post del sess
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-f826:3: qla_target(0): Exit ELS opcode: 0x03 res 0
Mar 28 02:40:45 mbpc-pc kernel: qla2xxx [0000:04:00.1]-e862:3: qla_target(0): Unexpected NOTIFY_ACK received

I couldn't find anything relevant in the provided logs about the port
but I guess it might be because of session not added to the target.

As a solution I recommend you to change kernel source on the target
from:

        if (fcport->fc4f_nvme) {
                qla_nvme_register_remote(vha, fcport);
                return;
        }

to:

        if (vha->host->active_mode != MODE_TARGET && fcport->fc4f_nvme) {
                qla_nvme_register_remote(vha, fcport);
                return;
        }


Hope that helps,
Roman
