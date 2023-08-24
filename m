Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B79C27C40
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 09:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbjHXJOW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 05:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236836AbjHXJNz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 05:13:55 -0400
Received: from fgw21-4.mail.saunalahti.fi (fgw21-4.mail.saunalahti.fi [62.142.5.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4309E67
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 02:13:53 -0700 (PDT)
Received: from smtpclient.apple (85-156-116-237.elisa-laajakaista.fi [85.156.116.237])
        by fgw21.mail.saunalahti.fi (Halon) with ESMTPSA
        id 8a5091a8-425e-11ee-abf4-005056bdd08f;
        Thu, 24 Aug 2023 12:13:51 +0300 (EEST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH 2/2] scsi: tape: add unexpected rewind handling
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20230822181413.1210647-2-jmeneghi@redhat.com>
Date:   Thu, 24 Aug 2023 12:13:38 +0300
Cc:     linux-scsi@vger.kernel.org, loberman@redhat.com, jhutz@cmu.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <4C6BF678-6623-48D1-8238-37B312BCA085@kolumbus.fi>
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
 <20230822181413.1210647-2-jmeneghi@redhat.com>
To:     John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3731.700.6)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 22. Aug 2023, at 21.14, John Meneghini <jmeneghi@redhat.com> wrote:
> 
> Handle the unexpected condition where the tape drive reports
> that tape is rewinding.
> 
> ...
> I'm providing this patch because I think it's valuable for testing
> purposes and it should be safe. Any time the device unexpectedly
> reports "Rewind is in progress", it should be safe to set
> pos_unknown in the driver.
> 
I am a bit hesitant about this, because it does not recognize if the rewind in
progress was initiated by the user or not. In immediate mode (ST_NOWAIT
option), a user rewind may be still in progress when a (impatient) user
tries to do something else.

One possibility would be to make this conditional on !STp->immediate.

Another, perhaps better, method would be to use the STps->rw state
variable. A new state ST_REWINDING could be introduced (or state
should be set to ST_IDLE when rewinding).

(Looking at the state, I think it should be set to something else than
ST_WRITING more frequently. This could, in some cases prevent
improper automatic writing of filemarks. See, for instance, the problem
with failing rewinds in the report with PATCH 1/2.)

Thanks, Kai


> Tested-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
> ---
> drivers/scsi/st.c | 3 +++
> 1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 338aa8c42968..b641490ed9d1 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -416,6 +416,9 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
> STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
> if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
> STp->pos_unknown = 1; /* ASC => power on / reset */
> + if (cmdstatp->have_sense && cmdstatp->sense_hdr.asc == 0
> + && cmdstatp->sense_hdr.ascq == 0x1a)
> + STp->pos_unknown = 1; /* ASCQ => rewind in progress */
> 
> STp->pos_unknown |= STp->device->was_reset;
> 
> -- 
> 2.39.3
> 

