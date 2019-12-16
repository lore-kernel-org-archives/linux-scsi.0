Return-Path: <SRS0=9qbq=2G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2363C43603
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 20:08:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D06F21582
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Dec 2019 20:08:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="v/hfEOb7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLPUIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Dec 2019 15:08:46 -0500
Received: from mta-02.yadro.com ([89.207.88.252]:34866 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726799AbfLPUIq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Dec 2019 15:08:46 -0500
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 03E7642F15;
        Mon, 16 Dec 2019 20:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        in-reply-to:content-disposition:content-type:content-type
        :mime-version:references:message-id:subject:subject:from:from
        :date:date:received:received:received; s=mta-01; t=1576526922;
         x=1578341323; bh=IltlcFnRcjN7EY+jCVg80lEMC0oJ6yw708uBExC7Dhk=; b=
        v/hfEOb76gPZXuI+IhKWxAAPWR7KXWH3y0isVx918rredLF7rNIyce4jicQbyOjp
        iqIGMSGmMFT8hmnKNDz+V6w+DgIPEuybHMoE6HtOlseStwzmP4szLlWS9ChLOuHs
        gSrQDuuAUQWC85NTFJMA7fk7fB/ujk58x2M5i6Kpy9M=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id icW5RaglgvDY; Mon, 16 Dec 2019 23:08:42 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id A5D5841203;
        Mon, 16 Dec 2019 23:08:40 +0300 (MSK)
Received: from localhost (172.17.128.60) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 16
 Dec 2019 23:08:40 +0300
Date:   Mon, 16 Dec 2019 23:08:39 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Quinn Tran <qutran@marvell.com>,
        Himanshu Madhani <hmadhani@marvell.com>
CC:     Martin Wilck <mwilck@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        <linux-scsi@vger.kernel.org>, Martin Wilck <mwilck@suse.com>,
        Daniel Wagner <dwagner@suse.de>, <linux@yadro.com>
Subject: Re: [PATCH 3/4] qla2xxx: Fix point-to-point mode for qla25xx and
 older
Message-ID: <20191216200839.iqquahc6vygvpk6k@SPB-NB-133.local>
References: <20191209180223.194959-1-bvanassche@acm.org>
 <20191209180223.194959-4-bvanassche@acm.org>
 <fdff60ffaacad1b3a850942f61bdd92ab5bc6d12.camel@suse.de>
 <20191212200720.wbq2en3pnnpegrij@SPB-NB-133.local>
 <20191214010400.r6ord53kwbh2lmlm@SPB-NB-133.local>
 <86234568-0ab4-4efa-5f4f-05b0d604be3a@acm.org>
 <20191216114535.7ijs2nwqwrljq6pa@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20191216114535.7ijs2nwqwrljq6pa@SPB-NB-133.local>
X-Originating-IP: [172.17.128.60]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 16, 2019 at 02:45:35PM +0300, Roman Bolshakov wrote:
> On Sat, Dec 14, 2019 at 04:09:41PM -0800, Bart Van Assche wrote:
> > On 2019-12-13 17:04, Roman Bolshakov wrote:
> > > Bart, what kernel do you use on initiator? Should we bring in
> > > workarounds for initiators into mainline?
> > 
> > The setup I use to test point-to-point mode is as follows:
> > * A single server equipped with a QLE2562 adapter.
> > * The two ports of the QLE2562 adapter directly connected to each other.
> > * Both FC ports are assigned to a VM such that if a kernel crash occurs
> >   only the VM has to be rebooted (PCIe-passthrough).
> > * The following in /etc/modprobe.d/qla2xxx.conf of the VM used for
> >   testing:
> > 
> > options qla2xxx qlini_mode=dual ql2xextended_error_logging=0x5200b000
> > 
> > With this setup it is guaranteed that initiator and target are running
> > the same kernel version.
> > 
> > I run all my tests with mainline kernels. Typically I run my tests on
> > top of a merge of Martin's scsi-fixes and scsi-queue branches. Since the
> > regression that I reported is a regression in the upstream kernel I
> > think the fix should go into the upstream kernel.
> > 
> 
> Hi Bart,
> 
> The setup details are helpful. Yes, I can reproduce it with
> qlini_mode=dual. But it works with qlini_mode=disabled.
> 
> But, qlini_mode=dual works if target is created before initiator is
> started.  So, the transition from initiator mode to target is the one
> that needs a fix.
> 
> There first PLOGI after target creation fails because it complains about
> wrong D_ID in Login/Logout IOCB:
> 
> qla2xxx [0000:00:07.0]-3873:1: Enter: PLOGI portid=0000ef
> qla2xxx [0000:00:07.0]-3873:1: PLOGI 00000000003b33d0 00000000f1800318
> qla2xxx [0000:00:07.0]-3873:1: PLOGI buffer:
> qla2xxx [0000:00:07.0]-0909:1: +116   0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
> qla2xxx [0000:00:07.0]-0909:1: ----- -----------------------------------------------
> qla2xxx [0000:00:07.0]-0909:1: 0000: 03 00 00 00 20 20 00 0c 88 00 08 00 00 ff 00 1f
> qla2xxx [0000:00:07.0]-0909:1: 0010: 00 00 07 d0 21 00 00 24 ff 7f 35 c7 20 00 00 24
> qla2xxx [0000:00:07.0]-0909:1: 0020: ff 7f 35 c7 00 00 00 00 00 00 00 00 00 00 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0030: 00 00 00 00 00 00 00 00 20 00 08 00 00 ff 00 04
> qla2xxx [0000:00:07.0]-0909:1: 0040: 00 01 00 00 80 00 00 00 00 00 08 00 00 ff 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0050: 00 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0060: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0070: 00 00 00 00
> qla2xxx [0000:00:07.0]-3873:1: PLOGI ELS IOCB:
> qla2xxx [0000:00:07.0]-0909:1: +64    0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
> qla2xxx [0000:00:07.0]-0909:1: ----- -----------------------------------------------
> qla2xxx [0000:00:07.0]-0909:1: 0000: 53 01 00 00 05 00 00 00 00 00 00 00 01 00 00 10
> qla2xxx [0000:00:07.0]-0909:1: 0010: 00 00 00 00 01 00 03 00 ef 00 00 00 ef 00 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0020: 74 00 00 00 74 00 00 00 00 00 a5 30 00 00 00 00
> qla2xxx [0000:00:07.0]-0909:1: 0030: 74 00 00 00 00 00 a6 30 00 00 00 00 74 00 00 00
> qla2xxx [0000:00:07.0]-3874:1: ELS_DCMD PLOGI sent, hdl=5, loopid=0, to port_id 0000ef from port_id 0000ef
> qla2xxx [0000:00:07.0]-583f:1: ELS IOCB Done -Driver ELS logo error hdl=5 comp_status=0x31 error subcode 1=0x19 error subcode 2=0x18 total_byte=0x74
> qla2xxx [0000:00:07.0]-3872:1: ELS_DCMD ELS done rc 458752 hdl=5, portid=0000ef 21:00:00:24:ff:12:b1:a0
> qla2xxx [0000:00:07.0]-28eb:1: qla2x00_els_dcmd2_sp_done 21:00:00:24:ff:12:b1:a0 cmd error fw_status 0x31 0x19 0x18
> 
> Also note, that the IOCB is sent from port 0000ef to port 0000ef. This
> is definitely wrong and should be fixed. I'm still looking how it
> reached the invalid state.
> 

Hi all again,

Bart,

In my setup I use QLE2560 as target (it has lower WWPN) and one port of
QLE2742 as initiator. The proposed fix doesn't work for me. The same
PLOGI error is returned.

When target is started with qlini_mode=dual, the connection is
initialized in AL_PA topology. FW assigns AL_PA for both ports. It sets
AL_PA ef for the target port and e8 for initiator on my setup.

LOOP DOWN event comes right after then target is created and existing
rport is deleted by initiator without explicit LOGO and N_Port handle
cleanup.

Then the topology changes to N2N, the session is getting re-initialized,
but initiator doesn't set correct D_ID for PLOGI, because FW returns
wrong port id for initiator (ef instead of e8) in the response of Get ID
mailbox command.

Quinn, Himanshu, does it tell something to you?

> If qla2xxx target is started with qlini_mode=disabled in P2P mode,
> initiator/target have port ids 000001/000002. The port with bigger WWPN
> in the pair typically assigns 000001 to itself and 000002 to the peer.
> 

Thank you,
Roman
