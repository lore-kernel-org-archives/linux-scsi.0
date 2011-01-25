From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [PATCH v2] [SCSI] scsi_dh_hp_sw: fix deadlock in start_stop_endio
Date: Tue, 25 Jan 2011 13:16:18 -0500
Message-ID: <AANLkTinmejSc_7Bqo8a-_jp4vYOCucjPOO9t-dCNC_r5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44250 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1AYSQj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jan 2011 13:16:39 -0500
Received: by fxm20 with SMTP id 20so61210fxm.19
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jan 2011 10:16:38 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

On Tue, Jan 25, 2011 at 11:52 AM, Mike Snitzer <snitzer@redhat.com> wro=
te:
> The use of blk_execute_rq_nowait() implies __blk_put_request() is nee=
ded
> in start_stop_endio() rather than blk_put_request() --
> blk_finish_request() is called with queue lock already held.
>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
> =A0drivers/scsi/device_handler/scsi_dh_hp_sw.c | =A0 =A03 ++-
> =A01 files changed, 2 insertions(+), 1 deletions(-)
>
> v2: fix endio cut and paste typo in patch header

Bleh, the patch subject needs to be updated too: s/stpg_endio/start_sto=
p_endio/

Sorry for the imprecise submission!
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
