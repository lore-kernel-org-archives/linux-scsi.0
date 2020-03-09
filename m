Return-Path: <SRS0=qdS7=42=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3322C10F29
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A189222D9
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Mar 2020 19:05:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rip2ZN2j";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="rip2ZN2j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgCITF5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Mar 2020 15:05:57 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54202 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727446AbgCITF5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Mar 2020 15:05:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id B34598EE130;
        Mon,  9 Mar 2020 12:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1583780756;
        bh=Sc2QuKXp+NYFLLim1wGQCTi595rhsEhjkPDtHttA/bo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=rip2ZN2jXDLYfxkCI2x+J4QLdKtXYg48VBI75Y2vb3xo9s6/b5T/qSlAJ5TWk3trD
         G9mf9cfsBjXmLSRGQCCy71Rv68AddkypZq+Qt/1Qg7LD7M+rbTVfF6pHYDDspWMT4p
         JjX2N6b6cObRXby3W4DJC3OMn4E7jXq/2Md68nQE=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id irZaresNlL-y; Mon,  9 Mar 2020 12:05:56 -0700 (PDT)
Received: from [153.66.254.194] (unknown [50.35.76.230])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 526E98EE121;
        Mon,  9 Mar 2020 12:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1583780756;
        bh=Sc2QuKXp+NYFLLim1wGQCTi595rhsEhjkPDtHttA/bo=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=rip2ZN2jXDLYfxkCI2x+J4QLdKtXYg48VBI75Y2vb3xo9s6/b5T/qSlAJ5TWk3trD
         G9mf9cfsBjXmLSRGQCCy71Rv68AddkypZq+Qt/1Qg7LD7M+rbTVfF6pHYDDspWMT4p
         JjX2N6b6cObRXby3W4DJC3OMn4E7jXq/2Md68nQE=
Message-ID: <1583780754.3429.26.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: avoid repetitive logging of device offline
 messages
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Date:   Mon, 09 Mar 2020 12:05:54 -0700
In-Reply-To: <20200309181416.10665-1-emilne@redhat.com>
References: <20200309181416.10665-1-emilne@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-03-09 at 14:14 -0400, Ewan D. Milne wrote:
> Large queues of I/O to offline devices that are eventually
> submitted when devices are unblocked result in a many repeated
> "rejecting I/O to offline device" messages.  These messages
> can fill up the dmesg buffer in crash dumps so no useful
> prior messages remain.  In addition, if a serial console
> is used, the flood of messages can cause a hard lockup in
> the console code.
> 
> Introduce a flag indicating the message has already been logged
> for the device, and reset the flag when scsi_device_set_state()
> changes the device state.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi_lib.c    | 8 ++++++--
>  include/scsi/scsi_device.h | 2 ++
>  2 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41..d3a6d97 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1240,8 +1240,11 @@ scsi_prep_state_check(struct scsi_device
> *sdev, struct request *req)
>  		 * commands.  The device must be brought online
>  		 * before trying any recovery commands.
>  		 */
> -		sdev_printk(KERN_ERR, sdev,
> -			    "rejecting I/O to offline device\n");
> +		if (!sdev->offline_already) {
> +			sdev->offline_already = 1;
> +			sdev_printk(KERN_ERR, sdev,
> +				    "rejecting I/O to offline
> device\n");
> +		}

Offline->online is a legal transition, so you'll need to clear this
flag when that happens so we get another offline message if it goes
offline again.

James

