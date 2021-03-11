Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E778C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:42:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C7E364FDD
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 18:42:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKSmP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 13:42:15 -0500
Received: from fgw20-4.mail.saunalahti.fi ([62.142.5.107]:29984 "EHLO
        fgw20-4.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229887AbhCKSll (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 13:41:41 -0500
Received: from imac.makisara.private (87-92-207-71.rev.dnainternet.fi [87.92.207.71])
        by fgw20.mail.saunalahti.fi (Halon) with ESMTPSA
        id 6572b0a0-8299-11eb-ba24-005056bd6ce9;
        Thu, 11 Mar 2021 20:41:30 +0200 (EET)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [Bug 212183] New: st read statistics inaccurate when requested
 and physical block mismatch
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <bug-212183-11613@https.bugzilla.kernel.org/>
Date:   Thu, 11 Mar 2021 20:41:28 +0200
Cc:     linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F4FE5318-5537-4032-A63A-5E9D6FEF67D3@kolumbus.fi>
References: <bug-212183-11613@https.bugzilla.kernel.org/>
To:     bugzilla-daemon@bugzilla.kernel.org
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On 9. Mar 2021, at 16.34, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=212183
> 
>            Bug ID: 212183
>           Summary: st read statistics inaccurate when requested and
>                    physical block mismatch
>           Product: IO/Storage
>           Version: 2.5
>    Kernel Version: 5.3.1
>          Hardware: All
>                OS: Linux
>              Tree: Mainline
>            Status: NEW
>          Severity: low
>          Priority: P1
>         Component: SCSI
>          Assignee: linux-scsi@vger.kernel.org
>          Reporter: etienne.mollier@cgg.com
>        Regression: No
> 
> Created attachment 295769
>  --> https://bugzilla.kernel.org/attachment.cgi?id=295769&action=edit
> st.c patch working around stats issue when blocks size mismatch
> 
> Greetings,
> 
> when reading from tape with requested blocks larger than physical, statistics
> go wrong as using the requested size for the calculation, instead of the actual

…

The code around your suggested patch looks like this:

		if (scsi_req(req)->result) {
			atomic64_add(atomic_read(&STp->stats->last_read_size)
				- STp->buffer->cmdstat.residual,
				&STp->stats->read_byte_cnt);
			if (STp->buffer->cmdstat.residual > 0)
				atomic64_inc(&STp->stats->resid_cnt);
		} else
			atomic64_add(atomic_read(&STp->stats->last_read_size),
				&STp->stats->read_byte_cnt);

Your patch makes the else branch look like the first command in the
if branch. If the SILI option bit is not set, the command result should be
non-zero when the read block is shorter than the requested size. If the
SILI bit is set, this is not considered error and the else part is executed.
Your patch applies to this case?

If we trust that the residual (resid_len) is set correctly, the conditional
branches could be omitted and the residual could be subtracted always:
-----
-diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 841ad2fc369a..4f1f2abfbca3 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -498,15 +498,11 @@ static void st_do_stats(struct scsi_tape *STp, struct request *req)
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_read_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
 		atomic64_inc(&STp->stats->read_cnt);
-		if (scsi_req(req)->result) {
-			atomic64_add(atomic_read(&STp->stats->last_read_size)
-				- STp->buffer->cmdstat.residual,
-				&STp->stats->read_byte_cnt);
-			if (STp->buffer->cmdstat.residual > 0)
-				atomic64_inc(&STp->stats->resid_cnt);
-		} else
-			atomic64_add(atomic_read(&STp->stats->last_read_size),
-				&STp->stats->read_byte_cnt);
+		atomic64_add(atomic_read(&STp->stats->last_read_size)
+			     - STp->buffer->cmdstat.residual,
+			     &STp->stats->read_byte_cnt);
+		if (STp->buffer->cmdstat.residual > 0)
+			atomic64_inc(&STp->stats->resid_cnt);
 	} else {
 		now = ktime_sub(now, STp->stats->other_time);
 		atomic64_add(ktime_to_ns(now), &STp->stats->tot_io_time);
----

Opinions? (I don’t nowadays have access to any reasonable SCSI tape drive to test
this.)

Thanks,
Kai

