Return-Path: <SRS0=QSh0=Z7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5568FC43603
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 10:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3324720836
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Dec 2019 10:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfLIKYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Dec 2019 05:24:47 -0500
Received: from authsmtp37.register.it ([81.88.55.100]:34065 "EHLO
        authsmtp.register.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726279AbfLIKYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2019 05:24:47 -0500
Received: from [192.168.1.1] ([93.41.32.9])
        by cmsmtp with ESMTPSA
        id eGDdi8NKUaqMNeGDdiqrFH; Mon, 09 Dec 2019 11:24:46 +0100
X-Rid:  guido@trentalancia.com@93.41.32.9
Message-ID: <1575887085.5344.20.camel@trentalancia.com>
Subject: Re: [PATCH v2] scsi: ignore Synchronize Cache command failures to
 keep using drives not supporting it
From:   Guido Trentalancia <guido@trentalancia.com>
To:     linux-scsi@vger.kernel.org
Date:   Mon, 09 Dec 2019 11:24:45 +0100
In-Reply-To: <1575886009.5344.17.camel@trentalancia.com>
References: <1575886009.5344.17.camel@trentalancia.com>
X-Priority: 1
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfKQ1bICB2ptyeSj1fY9MIBbroRJ0pletPypsDe78l1VHXRpIzKvZ5or/COI7ct7GRGZHnuEI6m0cLsLnnd0UxX0DTs25/faEBOeFurptkZFp06hIyHlD
 PZsbpbrJnq1/mvJxIc75V1Hs58z736Ce3xj89AFrjFYa6OO6RFXyANSTUNOsryngxxhvxxNPyUi7Pw==
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Kernel bug filed here:

https://bugzilla.kernel.org/show_bug.cgi?id=203635

On Mon, 09/12/2019 at 11.06 +0100, Guido Trentalancia wrote:
> Many obsolete hard drives do not support the Synchronize Cache SCSI
> command. Such command is generally issued during fsync() calls which
> at the moment therefore fail with the ILLEGAL_REQUEST sense key.
> 
> Since this failure is currently treated as critical in the kernel
> SCSI
> disk driver, such obsolete hard drives cannot be used anymore (at
> least
> since kernel 4.10, maybe even earlier): they cannot be formatted,
> mounted and/or checked using tools such as e2fsprogs.
> 
> Because there is nothing which can be done if the drive does not
> support
> such command, such ILLEGAL_REQUEST should be treated as non-critical
> so
> that the underlying operation does not fail and the obsolete hard
> drive
> can be used normally.
> 
> This second version of the patch (v2) disables the Write Cache
> feature
> as a precaution on hard drives which do not support the Synchronize
> Cache
> command and therefore the cache flushing functionality.
> 
> Although the Write Cache is disabled (v2) when using such hard drives
> which do not feature the Synchronize Cache SCSI command, there is
> still
> some risk of data loss in case of power cuts, USB cable disconnects
> and
> so on, which depend on the drive itself and not on this patch or the
> rest of the kernel code: YOU HAVE BEEN WARNED - THE DRIVE
> MANIFACTURER
> SHOULD HAVE BEEN WARNED YOU IN THE FIRST PLACE - IN DOUBT, UPGRADE TO
> A
> NEWER HARD DRIVE !!
> 
> Tested on a Maxtor OneTouch USB 200Gb External Hard Drive.
> 
> Signed-off-by: Guido Trentalancia <guido@trentalancia.com>
> ---
>  drivers/scsi/sd.c |   29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
> [...]
