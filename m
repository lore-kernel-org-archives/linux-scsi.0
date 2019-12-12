Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11057C43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 20:07:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C23AE21556
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 20:07:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="Aw65oTrD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbfLLUH1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 15:07:27 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:60426 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730703AbfLLUH1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Dec 2019 15:07:27 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 2BF7F41207;
        Thu, 12 Dec 2019 20:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576181242;
         x=1577995643; bh=bVP5b51/Kbr4TVWift7ggj4RChseQ+s0zO784YvAV+M=; b=
        Aw65oTrDJTOIsRyS+v6PstK9DE6aOOyC3Pl46CNXeHV4KAElO0QFdQLH+RkePYL5
        5E8Rr0JFWgKsUhHxBPlEBnq0xtVg3+kxavyniYmrQwfTQscw3WAeNujTsfxpIWHN
        9VVv8zJ9AFcokz2lJYgZquEtee26BRMEJiLByP3IiKU=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Ld7y7F4ZHNx1; Thu, 12 Dec 2019 23:07:22 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 4B2F941203;
        Thu, 12 Dec 2019 23:07:21 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Thu, 12
 Dec 2019 23:07:20 +0300
Date:   Thu, 12 Dec 2019 23:07:20 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Martin Wilck <mwilck@suse.de>
CC:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Quinn Tran <qutran@marvell.com>,
        Martin Wilck <mwilck@suse.com>, Daniel Wagner <dwagner@suse.de>
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
Message-ID: <20191212200720.wbq2en3pnnpegrij@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
 <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Dec 10, 2019 at 11:52:11AM +0100, Martin Wilck wrote:
> Hello Bart,
> 
> On Mon, 2019-12-09 at 10:02 -0800, Bart Van Assche wrote:
> > Restore point-to-point for qla25xx and older. Although this patch
> > initializes
> > a field (s_id) that has been marked as "reserved" in the firmware
> > manual, it
> > works fine on my setup.
> > 
> > Cc: Quinn Tran <qutran@marvell.com>
> > Cc: Martin Wilck <mwilck@suse.com>
> > Cc: Daniel Wagner <dwagner@suse.de>
> > Cc: Roman Bolshakov <r.bolshakov@yadro.com>
> > Fixes: 0aabb6b699f7 ("scsi: qla2xxx: Fix Nport ID display value")
> > Fixes: edd05de19759 ("scsi: qla2xxx: Changes to support N2N logins")
> > Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> > ---
> >  drivers/scsi/qla2xxx/qla_iocb.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> Having followed the discussion between you and Roman, I guess this is
> ok. However I'd like to understand better in what ways the N2N topology
> was broken for you. After all, this patch affects only the LOGO
> payload. Was it a logout / relogin issue? Were wrong ports being logged
> out?
> 
> Regards,
> Martin
> 
> 

Hi Martin,

I think your concern is indeed valid. I didn't have a chance to test the
P2P target on QLE2562 earlier. Here's the log that shows the issue
Bart is experiencing:

[  179.925639] qla2xxx [0000:00:05.0]-1959:0: Entered qla24xx_get_port_login_templ.
[  179.925689] qla2xxx [0000:00:05.0]-1800:0: Entered qla2x00_mailbox_command.
[  179.925731] qla2xxx [0000:00:05.0]-1806:0: Prepare to issue mbox cmd=0x5a.
[  179.925771] qla2xxx [0000:00:05.0]-1911:0: Mailbox registers (OUT):
[  179.925813] qla2xxx [0000:00:05.0]-1912:0: mbox[0]<-0x005a
[  179.925856] qla2xxx [0000:00:05.0]-1912:0: mbox[1]<-0x0700
[  179.925897] qla2xxx [0000:00:05.0]-1912:0: mbox[2]<-0x3000
[  179.925939] qla2xxx [0000:00:05.0]-1912:0: mbox[3]<-0x0000
[  179.925981] qla2xxx [0000:00:05.0]-1912:0: mbox[4]<-0x0003
[  179.926021] qla2xxx [0000:00:05.0]-1912:0: mbox[5]<-0x0000
[  179.926063] qla2xxx [0000:00:05.0]-1912:0: mbox[6]<-0x0000
[  179.926105] qla2xxx [0000:00:05.0]-1912:0: mbox[7]<-0x0000
[  179.926147] qla2xxx [0000:00:05.0]-1912:0: mbox[8]<-0x001d
[  179.926188] qla2xxx [0000:00:05.0]-1917:0: I/O Address = 00000000167c2ddb.
[  179.926230] qla2xxx [0000:00:05.0]-180f:0: Going to unlock irq & waiting for interrupts. jiffies=ffffd115.
[  179.926367] qla2xxx [0000:00:05.0]-1814:0: Cmd=5a completed.
[  179.926413] qla2xxx [0000:00:05.0]-1913:0: Mailbox registers (IN):
[  179.926456] qla2xxx [0000:00:05.0]-1914:0: mbox[0]->0x4000
[  179.926489] qla2xxx [0000:00:05.0]-1914:0: mbox[1]->0x0700
[  179.926522] qla2xxx [0000:00:05.0]-1821:0: Done qla2x00_mailbox_command.
[  179.926566] qla2xxx [0000:00:05.0]-195b:0: Done qla24xx_get_port_login_templ.
[  179.926617] qla2xxx [0000:00:05.0]-28d8:0: qla24xx_fcport_handle_login 21:00:00:24:ff:7f:35:c7 DS 0 LS 4 P 0 fl 0 confl 00000000f1f36df6 rscn 0|0 login 1 lid 0 scan 2
[  179.926709] qla2xxx [0000:00:05.0]-2869:0: LOOP READY.
[  179.926751] qla2xxx [0000:00:05.0]-286b:0: qla2x00_configure_loop: exiting normally.
[  179.926801] qla2xxx [0000:00:05.0]-4810:0: Loop resync end.
[  179.926836] qla2xxx [0000:00:05.0]-4800:0: DPC handler sleeping.
[  179.926879] qla2xxx [0000:00:05.0]-28d9:0: Async-gnlist WWPN 21:00:00:24:ff:7f:35:c7
[  179.926928] qla2xxx [0000:00:05.0]-28da:0: Async-gnlist - OUT WWPN 21:00:00:24:ff:7f:35:c7 hndl 0
[  179.928148] qla2xxx [0000:00:05.0]-28e7:0: Async done-gnlist res 0 mb[1]=50 mb[2]=301a
[  179.928222] qla2xxx [0000:00:05.0]-28e8:0: qla24xx_async_gnl_sp_done 21:00:00:24:ff:7f:35:c7 00:00:01 CLS 4/4 lid 0
[  179.928295] qla2xxx [0000:00:05.0]-28e8:0: qla24xx_async_gnl_sp_done 21:00:00:24:ff:7f:35:c7 ff:ff:fe CLS 4/4 lid 7fe
[  179.928368] qla2xxx [0000:00:05.0]-107ff:0: qla24xx_handle_gnl_done_event 21:00:00:24:ff:7f:35:c7 DS 2 LS rc 4 0 login 1|1 rscn 0|0 lid 0
[  179.928449] qla2xxx [0000:00:05.0]-28e1:0: qla24xx_handle_gnl_done_event 725 21:00:00:24:ff:7f:35:c7 n 2 000001 lid 0
[  179.928520] qla2xxx [0000:00:05.0]-28e2:0: qla24xx_handle_gnl_done_event found 21:00:00:24:ff:7f:35:c7 CLS [4|4] fc4_type 1 ID[000001|000001] lid[0|0]
[  179.928611] qla2xxx [0000:00:05.0]-28d8:0: qla24xx_fcport_handle_login 21:00:00:24:ff:7f:35:c7 DS 2 LS 4 P 0 fl 0 confl 00000000f1f36df6 rscn 0|0 login 1 lid 0 scan 2

If discovery state is DSC_GNL and fcport->current_login_state & 0xf ==
6, target tries to do PRLI (which should be prohibited because
qlini_mode=disabled on the machine and scsi_host active_mode is
"Target"):

[  179.928706] qla2xxx [0000:00:05.0]-2918:0: qla24xx_fcport_handle_login 1595 21:00:00:24:ff:7f:35:c7 post FC PRLI
[  179.928828] qla2xxx [0000:00:05.0]-291b:0: Async-prli - 21:00:00:24:ff:7f:35:c7 hdl=0, loopid=0 portid=000001 retries=30 fc.
[  179.928969] qla2xxx [0000:00:05.0]-5836:0: Async-prli complete - 21:00:00:24:ff:7f:35:c7 hdl=4 portid=000001 iop0=422.
[  179.929053] qla2xxx [0000:00:05.0]-2929:0: qla2x00_async_prli_sp_done 21:00:00:24:ff:7f:35:c7 res 0
[  179.929118] qla2xxx [0000:00:05.0]-2918:0: qla24xx_handle_prli_done_event 1872 21:00:00:24:ff:7f:35:c7 post gpdb
[  179.929224] qla2xxx [0000:00:05.0]-28dc:0: Async-gpdb 21:00:00:24:ff:7f:35:c7 hndl 0 opt 0
[  179.929320] qla2xxx [0000:00:05.0]-28db:0: Async done-gpdb res 0, WWPN 21:00:00:24:ff:7f:35:c7 mb[1]=0 mb[2]=3011
[  179.929394] qla2xxx [0000:00:05.0]-28d2:0: qla24xx_handle_gpdb_event 21:00:00:24:ff:7f:35:c7 DS 5 LS 6 fc4_type 1 rc 0
[  179.929490] qla2xxx [0000:00:05.0]-28ef:0: qla2x00_update_fcport 21:00:00:24:ff:7f:35:c7

qla2x00_update_fcport sets discovery state to DSC_LOGIN_COMPLETE.

[  179.929720] qla2xxx [0000:00:05.0]-f806:0: Adding sess 000000005ec6d065 se_sess 00000000f0daac7c  to tgt 00000000dde86879 sess_count 1
[  179.929803] qla2xxx [0000:00:05.0]-f84b:0: qla_target(0): session for wwn 21:00:00:24:ff:7f:35:c7 (loop_id 0, s_id 0:0:1, confirmed completion not supported) added
[  179.929900] qla2xxx [0000:00:05.0]-287d:0: FCPort 21:00:00:24:ff:7f:35:c7 state transitioned from UNCONFIGURED to ONLINE - portid=000001.
[  180.773031] qla2xxx [0000:00:05.0]-e872:0: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
[  180.773123] qla2xxx [0000:00:05.0]-e82e:0: IMMED_NOTIFY ATIO
[  180.773126] qla2xxx [0000:00:05.0]-f826:0: qla_target(0): Port ID: 00:00:01 ELS opcode: 0x03 lid 0 21:00:00:24:ff:7f:35:c7
[  180.773243] qla2xxx [0000:00:05.0]-f897:0: Linking sess 000000005ec6d065 [0] wwn 21:00:00:24:ff:7f:35:c7 with PLOGI ACK to wwn 21:00:00:24:ff:7f:35:c7 s_id 00:00:01, ref=1 pla 00000000e7b769c4 link 0
[  180.773354] qla2xxx [0000:00:05.0]-28f9:0: qlt_handle_login 4802 21:00:00:24:ff:7f:35:c7  DS 7

So, if Discovery State is DSC_LOGIN_COMPLETE, let's nuke the session:

[  180.773413] qla2xxx [0000:00:05.0]-28f9:0: qlt_handle_login 4834 21:00:00:24:ff:7f:35:c7 post del sess
[  180.773471] qla2xxx [0000:00:05.0]-e801:0: Scheduling sess 000000005ec6d065 for deletion 21:00:00:24:ff:7f:35:c7
[  180.773544] qla2xxx [0000:00:05.0]-f826:0: qla_target(0): Exit ELS opcode: 0x03 res 0
[  180.773619] qla2xxx [0000:00:05.0]-290a:0: qlt_unreg_sess sess 000000005ec6d065 for deletion 21:00:00:24:ff:7f:35:c7
[  180.773692] qla2xxx [0000:00:05.0]-f884:0: qlt_free_session_done: se_sess 00000000f0daac7c / sess 000000005ec6d065 from port 21:00:00:24:ff:7f:35:c7 loop_id 0x00 s_id 00:00:01 logout 1 keep 1 els_logo 0
[  180.773800] qla2xxx [0000:00:05.0]-287d:0: FCPort 21:00:00:24:ff:7f:35:c7 state transitioned from ONLINE to LOST - portid=000001.
[  180.773886] qla2xxx [0000:00:05.0]-2870:0: Async-logout - hdl=0 loop-id=0 portid=000001 21:00:00:24:ff:7f:35:c7.

And here's the LOGO you was worried about:

[  180.774077] qla2xxx [0000:00:05.0]-5836:0: Async-logout complete - 21:00:00:24:ff:7f:35:c7 hdl=6 portid=000001 iop0=0.
[  180.774150] qla2xxx [0000:00:05.0]-f893:0: qlt_logo_completion_handler: se_sess 00000000f0daac7c / sess 000000005ec6d065 from port 21:00:00:24:ff:7f:35:c7 loop_id 0x00 s_id 00:00:01 LOGO failed: 0x0
[  180.829063] qla2xxx [0000:00:05.0]-f887:0: qlt_free_session_done: sess 000000005ec6d065 logout completed
[  180.829182] qla2xxx [0000:00:05.0]-f89a:0: se_sess 00000000f1f36df6 / sess 000000005ec6d065 port 21:00:00:24:ff:7f:35:c7 is gone, releasing own PLOGI (ref=1)
[  180.829276] qla2xxx [0000:00:05.0]-5889:0: Sending PLOGI ACK to wwn 21:00:00:24:ff:7f:35:c7 s_id 00:00:01 loop_id 0x00 exch 0x1155f0 ox_id 0x4
[  180.829364] qla2xxx [0000:00:05.0]-f801:0: Unregistration of sess 000000005ec6d065 21:00:00:24:ff:7f:35:c7 finished fcp_cnt 0
[  180.829445] qla2xxx [0000:00:05.0]-28f4:0: Async-nack 21:00:00:24:ff:7f:35:c7 hndl 0 PLOGI
[  180.829566] qla2xxx [0000:00:05.0]-28f2:0: Async done-nack res 0 21:00:00:24:ff:7f:35:c7  type 16

Then initiator sends a PLOGI:

[  181.810543] qla2xxx [0000:00:05.0]-e872:0: qlt_24xx_atio_pkt_all_vps: qla_target(0): type d ox_id 0000
[  181.810641] qla2xxx [0000:00:05.0]-e82e:0: IMMED_NOTIFY ATIO
[  181.810645] qla2xxx [0000:00:05.0]-f826:0: qla_target(0): Port ID: 00:00:01 ELS opcode: 0x03 lid 0 21:00:00:24:ff:7f:35:c7
[  181.810785] qla2xxx [0000:00:05.0]-f897:0: Linking sess 000000005ec6d065 [0] wwn 21:00:00:24:ff:7f:35:c7 with PLOGI ACK to wwn 21:00:00:24:ff:7f:35:c7 s_id 00:00:01, ref=1 pla 00000000eebd5532 link 0
[  181.810918] qla2xxx [0000:00:05.0]-28f9:0: qlt_handle_login 4802 21:00:00:24:ff:7f:35:c7  DS 0
[  181.810992] qla2xxx [0000:00:05.0]-5889:0: Sending PLOGI ACK to wwn 21:00:00:24:ff:7f:35:c7 s_id 00:00:01 loop_id 0x00 exch 0x115620 ox_id 0x5
[  181.811106] qla2xxx [0000:00:05.0]-f826:0: qla_target(0): Exit ELS opcode: 0x03 res 0
[  181.811251] qla2xxx [0000:00:05.0]-28f4:0: Async-nack 21:00:00:24:ff:7f:35:c7 hndl 0 PLOGI
[  181.811361] qla2xxx [0000:00:05.0]-28f2:0: Async done-nack res 0 21:00:00:24:ff:7f:35:c7  type 16

The block of messages just above can be seen a few more times which
means initiator sends multiple PLOGI requests.

I'll try to figure out the reason why qla24xx_fcport_handle_login
doesn't quit immediately.

Thanks,
Roman
