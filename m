Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C65F3C388F9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 14:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63EDC206D9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Nov 2020 14:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M/RhQU63"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgKKO7B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Nov 2020 09:59:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58972 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727347AbgKKO7B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Nov 2020 09:59:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605106739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xua3mhBe8M4FFwev2AEdMg4KXoynjIqMN5tIW6slLbw=;
        b=M/RhQU63p5v4KRnIMx4kOjIu+0PjPUp59QZt9qPJ8UomzLSbWm3KRQA99H697gSXzmS3S5
        xRK+iOuJctdPnmMfTyjn+KMN3v9VJWC4mR5e+4SQmEpQO5mAWD+zjW8UmDf7eKY54QM/9Y
        fQbYxUraTpw0C5uY9NtIEeo7joxuRHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469--XJmr91TMmuZUg25wXQ3xA-1; Wed, 11 Nov 2020 09:58:57 -0500
X-MC-Unique: -XJmr91TMmuZUg25wXQ3xA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1076A10924D9;
        Wed, 11 Nov 2020 14:58:47 +0000 (UTC)
Received: from [10.35.206.45] (unknown [10.35.206.45])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8D0310013D9;
        Wed, 11 Nov 2020 14:58:43 +0000 (UTC)
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a
 task
To:     Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        bvanassche@acm.org, m.lombardi85@gmail.com
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
 <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
 <184667b1-032b-c36f-d1e7-5cfef961c763@oracle.com>
 <71691FED-C164-482C-B629-A8B89B81E566@oracle.com>
 <a936cc4e-1610-5201-5960-107689b81820@redhat.com>
 <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Message-ID: <5111dcb0-ef0d-fc11-ee1a-ae2a9b30150a@redhat.com>
Date:   Wed, 11 Nov 2020 15:58:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <68e77a2c-c868-669f-0c4f-0a5bb0259249@oracle.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



Dne 11. 11. 20 v 3:16 Mike Christie napsal(a):
> Hey, I tested this out and I do not think this will happen. We will get stuck waiting on the TMF completion for the affected cmd/cmds.
> 
> In conn_cmd_list we would have [CMD1 -> ABORT TMF]. Those cmds get moved to the tmp list. It might happen where CMD1's CMD_T_ABORTED bit is set, and iscsit_release_commands_from_conn will would put it back onto the conn_cmd_list. But then it will see the ABORT on the list. We will then wait on the ABORT in:
> 
> iscsit_release_commands_from_conn -> iscsit_free_cmd -> transport_generic_free_cmd.

Hi Mike,

I'm not sure if I understood this part.

The commands are moved to the tmp_list;
we check for CMD_T_ABORTED and eventually move the commands from tmp_list back to conn_cmd_list
because it's the abort task the one that should do the cleanup.

iscsit_release_commands_from_conn() then scans the tmp_list and calls iscsit_free_cmd()... but not against
those commands with CMD_T_ABORTED flag set because we just moved them back to conn_cmd_list
and aren't linked to tmp_list anymore.

Am I missing something?

Maurizio

