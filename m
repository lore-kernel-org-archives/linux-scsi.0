Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5F1C43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F0546205C9
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 18:39:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfLISjT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 13:39:19 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:48286 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfLISjT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 13:39:19 -0500
Received: from localhost (unknown [IPv6:2610:98:8005::247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: krisman)
        by bhuna.collabora.co.uk (Postfix) with ESMTPSA id 7E35D290CD3;
        Mon,  9 Dec 2019 18:39:16 +0000 (GMT)
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Lee Duncan <LDuncan@suse.com>
Cc:     "cleech\@redhat.com" <cleech@redhat.com>,
        "martin.petersen\@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi\@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "open-iscsi\@googlegroups.com" <open-iscsi@googlegroups.com>,
        Bharath Ravi <rbharath@google.com>,
        "kernel\@collabora.com" <kernel@collabora.com>,
        "Dave Clausen" <dclausen@google.com>, Nick Black <nlb@google.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Anatol Pomazau <anatol@google.com>,
        Tahsin Erdogan <tahsin@google.com>,
        Frank Mayhar <fmayhar@google.com>, Junho Ryu <jayr@google.com>,
        Khazhismel Kumykov <khazhy@google.com>
Subject: Re: [PATCH] iscsi: Perform connection failure entirely in kernel space
Organization: Collabora
References: <20191209182054.1287374-1-krisman@collabora.com>
        <9865d3ff-676f-7502-d1a5-dd41cb940cd3@suse.com>
Date:   Mon, 09 Dec 2019 13:39:13 -0500
In-Reply-To: <9865d3ff-676f-7502-d1a5-dd41cb940cd3@suse.com> (Lee Duncan's
        message of "Mon, 9 Dec 2019 18:29:14 +0000")
Message-ID: <85h829l4xa.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Lee Duncan <LDuncan@suse.com> writes:

> On 12/9/19 10:20 AM, Gabriel Krisman Bertazi wrote:
>> From: Bharath Ravi <rbharath@google.com>
>> 
>> Connection failure processing depends on a daemon being present to (at
>> least) stop the connection and start recovery.  This is a problem on a
>> multipath scenario, where if the daemon failed for whatever reason, the
>> SCSI path is never marked as down, multipath won't perform the
>> failover and IO to the device will be forever waiting for that
>> connection to come back.
>> 
>> This patch implements an optional feature in the iscsi module, to
>> perform the connection failure inside the kernel.  This way, the
>> failover can happen and pending IO can continue even if the daemon is
>> dead. Once the daemon comes alive again, it can perform recovery
>> procedures if applicable.
>
>
> I don't suppose you've tested how this plays with the daemon, when present?

Hello,

Yes, I did.  It seemed to work properly over TCP.

The stop calls are serialized by the rx_mutex, whoever gets it first,
gets the job done.  The second should return immediately since the socket
is no longer there.

What am I missing?

-- 
Gabriel Krisman Bertazi
