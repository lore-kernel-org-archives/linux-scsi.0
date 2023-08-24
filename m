Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B307C71145
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 09:06:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbjHXJFo convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 05:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240271AbjHXJFR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 05:05:17 -0400
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Aug 2023 02:05:15 PDT
Received: from fgw23-4.mail.saunalahti.fi (fgw23-4.mail.saunalahti.fi [62.142.5.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 218B01991
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 02:05:15 -0700 (PDT)
Received: from smtpclient.apple (85-156-116-237.elisa-laajakaista.fi [85.156.116.237])
        by fgw23.mail.saunalahti.fi (Halon) with ESMTPSA
        id 2c4a95d8-425d-11ee-b972-005056bdfda7;
        Thu, 24 Aug 2023 12:04:04 +0300 (EEST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.700.6\))
Subject: Re: [PATCH 1/2] scsi: tape: add third party poweron reset handling
From:   =?utf-8?B?IkthaSBNw6RraXNhcmEgKEtvbHVtYnVzKSI=?= 
        <kai.makisara@kolumbus.fi>
In-Reply-To: <20230822181413.1210647-1-jmeneghi@redhat.com>
Date:   Thu, 24 Aug 2023 12:03:53 +0300
Cc:     linux-scsi@vger.kernel.org, loberman@redhat.com, jhutz@cmu.edu
Content-Transfer-Encoding: 8BIT
Message-Id: <21D7F30A-5878-4FD7-9FF2-51C3327526F9@kolumbus.fi>
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
To:     John Meneghini <jmeneghi@redhat.com>
X-Mailer: Apple Mail (2.3731.700.6)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On 22. Aug 2023, at 21.14, John Meneghini <jmeneghi@redhat.com> wrote:
> 
> Many tape devices will automatically rewind following a poweron/reset.
> This can result in data loss as other operations in the driver can write
> to the tape when the position is unknown. E.g. MTEOM can write a
> filemark at the beginning of the tape. This patch adds code to detect
> poweron/reset unit attentions and prevents the driver from writing to
> the tape when the position could be unknown.
> 
> Customer reported problem description:
> 
> ...

Good catch!

I think that, in an ideal world, the lower levels should detect the reset (STp->device->was_reset),
but this depends on how you define the model from the user point of view (what the virtual
HBA is). But, in the real world, this is a good safeguard and it solves a real problem.

Thanks, Kai

> Suggested-by: Jeffrey Hutzelman <jhutz@cmu.edu>
> Signed-off-by: John Meneghini <jmeneghi@redhat.com>
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi <mailto:kai.makisara@kolumbus.fi>>
> ---
> drivers/scsi/st.c | 2 ++
> 1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 14d7981ddcdd..338aa8c42968 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -414,6 +414,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
> if (cmdstatp->have_sense &&
>    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
> STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
> + if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
> + STp->pos_unknown = 1; /* ASC => power on / reset */
> 
> STp->pos_unknown |= STp->device->was_reset;
> 
> -- 
> 2.39.3
> 

