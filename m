Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6FBC3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 17:05:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E99032067D
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 17:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581699929;
	bh=cWM9G1+pZU3ZZCBvu3fIWh4fzIRXlhjZcJ8EV4CjiQ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wBEbTCGMi3eFLYElc8Vla+M4E0/Yei4EqlyYx+sK4wCnBCfr8Kr/MyCIzrahcxbwA
	 /0EClvm4QcYoslLPvJIy5+GfsfL+OivMfwF488d9K8k1BkqUtMuawUbYBkYuh6Sskc
	 DL/K/E8fHbiVBGOvh3Z3h9boGZ7/6oo4dX1T5JKQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405099AbgBNRFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:05:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404190AbgBNRFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 12:05:22 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45A0920656;
        Fri, 14 Feb 2020 17:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581699921;
        bh=cWM9G1+pZU3ZZCBvu3fIWh4fzIRXlhjZcJ8EV4CjiQ8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DAqU7RRXAEyU1EJAwzZGw0BmErbfj4k3CaDJbiUIDvJYLuPB0JyLiv0MnAGJgFX0B
         Cb13B6mBmLGphZRZDHyDvsQQ4EkKhDNaR+02nQn+OJGsvPnzmzr0zNZLuSrUNlDTIH
         H9Gun0tLntYG+Npjsw5EEBdjqksgTqKXqXL9kYJA=
Date:   Sat, 15 Feb 2020 02:05:14 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tim Walker <tim.t.walker@seagate.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
 <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com>
 <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
 <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2020 at 05:04:25PM +0100, Hannes Reinecke wrote:
> On 2/14/20 3:40 PM, Keith Busch wrote:
> > On Fri, Feb 14, 2020 at 08:32:57AM +0100, Hannes Reinecke wrote:
> > > On 2/13/20 5:17 AM, Martin K. Petersen wrote:
> > > > People often artificially lower the queue depth to avoid timeouts. The
> > > > default timeout is 30 seconds from an I/O is queued. However, many
> > > > enterprise applications set the timeout to 3-5 seconds. Which means that
> > > > with deep queues you'll quickly start seeing timeouts if a drive
> > > > temporarily is having issues keeping up (media errors, excessive spare
> > > > track seeks, etc.).
> > > > 
> > > > Well-behaved devices will return QF/TSF if they have transient resource
> > > > starvation or exceed internal QoS limits. QF will cause the SCSI stack
> > > > to reduce the number of I/Os in flight. This allows the drive to recover
> > > > from its congested state and reduces the potential of application and
> > > > filesystem timeouts.
> > > > 
> > > This may even be a chance to revisit QoS / queue busy handling.
> > > NVMe has this SQ head pointer mechanism which was supposed to handle
> > > this kind of situations, but to my knowledge no-one has been
> > > implementing it.
> > > Might be worthwhile revisiting it; guess NVMe HDDs would profit from that.
> > 
> > We don't need that because we don't allocate enough tags to potentially
> > wrap the tail past the head. If you can allocate a tag, the queue is not
> > full. And convesely, no tag == queue full.
> > 
> It's not a problem on our side.
> It's a problem on the target/controller side.
> The target/controller might have a need to throttle I/O (due to QoS settings
> or competing resources from other hosts), but currently no means of
> signalling that to the host.
> Which, incidentally, is the underlying reason for the DNR handling
> discussion we had; NetApp tried to model QoS by sending "Namespace not
> ready" without the DNR bit set, which of course is a totally different
> use-case as the typical 'Namespace not ready' response we get (with the DNR
> bit set) when a namespace was unmapped.
> 
> And that is where SQ head pointer updates comes in; it would allow the
> controller to signal back to the host that it should hold off sending I/O
> for a bit.
> So this could / might be used for NVMe HDDs, too, which also might have a
> need to signal back to the host that I/Os should be throttled...

Okay, I see. I think this needs a new nvme AER notice as Martin
suggested. The desired host behavior is simiilar to what we do with a
"firmware activation notice" where we temporarily quiesce new requests
and reset IO timeouts for previously dispatched requests. Perhaps tie
this to the CSTS.PP register as well.
