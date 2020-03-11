Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B805CC18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D2D1222C3
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583927437;
	bh=0QZIZ6z4r//h99dqhvoPJr28cgoyW+Awh/esZL/Xdlo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=TC5QLl3a+tP9C0+8icxJNOJmNvITMVXNvXT0MJ+QZTOj0scYx7r1tiQVT8cViAEmh
	 X+spZTog8VUJXf4gNDBeXG+cV6I9ZLznjZ9PxEYtkSjj3HJ1Qsr8mDrELkQgDkjBaW
	 9+K+3blM/g/aMcS8n8bi137Nfm0ZvjO0GjOJn3Dc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgCKLue (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 07:50:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgCKLue (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Mar 2020 07:50:34 -0400
Received: from onda.lan (unknown [217.110.198.118])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B861E2146E;
        Wed, 11 Mar 2020 11:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583927433;
        bh=0QZIZ6z4r//h99dqhvoPJr28cgoyW+Awh/esZL/Xdlo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=faex73CAVSzJi+pmyTcYP9sIGrW4npHmO5kYhOVghj7YOD5ZWLX5JuwjxXzv3SBCk
         Ald909m2mEjZrEr9OlPEm+Tqu5uPZfiIAEAfIMB2fzEbOs/ZP+IqEgiuAfTiLBGkjP
         9DPC/Ywctl/wD8GhzwH4zNmtJvhX+wglDSXW5aLc=
Date:   Wed, 11 Mar 2020 12:50:24 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Matthew Wilcox <willy@infradead.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kai =?UTF-8?B?TcOka2lzYXJh?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        megaraidlinux.pdl@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        esc.storagedev@microsemi.com, Doug Gilbert <dgilbert@interlog.com>,
        HighPoint Linux Team <linux@highpoint-tech.com>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Hannes Reinecke <hare@suse.com>, dc395x@twibble.org,
        Oliver Neukum <oliver@neukum.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Khalid Aziz <khalid@gonehiking.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Ali Akcaagac <aliakc@web.de>,
        Don Brace <don.brace@microsemi.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Avri Altman <avri.altman@wdc.com>,
        GOTO Masanori <gotom@debian.or.jp>
Subject: Re: [PATCH 00/42] Manually convert SCSI documentation to ReST
 format
Message-ID: <20200311125024.6acd2567@onda.lan>
In-Reply-To: <yq14kuvu6cc.fsf@oracle.com>
References: <cover.1583136624.git.mchehab+huawei@kernel.org>
        <yq14kuvu6cc.fsf@oracle.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Em Tue, 10 Mar 2020 19:40:19 -0400
"Martin K. Petersen" <martin.petersen@oracle.com> escreveu:

> 
> Mauro,
> 
> > This patch series manually convert all SCSI documentation files to
> > ReST.
> >
> > This is part of a bigger series that finaly finishes the migration to
> > ReST.  After that, we can focus on more interesting tasks from the
> > documentation PoV, like cleaning obsolete stuff and filling the gaps.
> 
> Applied to 5.7/scsi-queue.
> 
> For some reason patch 23 didn't show up in the mbox so I had a bunch of
> conflicts due to the ncr53c8xx entry missing from index.rst. I thought
> you had somehow lost that patch along the way and decided to proceed
> regardless. However, it turns out the patch was missing due to a lore
> issue. By the time I figured out what the problem was, I had made it to
> the end of the series. And as a result, in my tree the ncr53c8xx patch
> comes last.

No problem. Yeah, sometimes some of those patches are big, and
vger ends by silently dropping the big guys.

Btw, maybe due to the conflict you had, I double-checked that two
files ended by being deleted instead of converted (looking at
today's linux-next).

So, I'm sending a followup patch re-adding them after the conversion.

Feel free to either apply it as a separate patch at the end or to
fold with the previously applied patches. Whatever works best for you.

Regards,
Mauro
