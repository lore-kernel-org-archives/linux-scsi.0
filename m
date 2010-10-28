From: Peter Chang <dpf@google.com>
Subject: Re: question about DID_RESET handling
Date: Thu, 28 Oct 2010 14:34:10 -0700
Message-ID: <AANLkTinHYCDRNkYyaDdSk3hzSUbcRMoSPDiC97ANwvDB@mail.gmail.com>
References: <20101028162239.10346b0ye9g07iww@webmail.meer.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:50386 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933750Ab0J1Ved convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Oct 2010 17:34:33 -0400
Received: from wpaz33.hot.corp.google.com (wpaz33.hot.corp.google.com [172.24.198.97])
	by smtp-out.google.com with ESMTP id o9SLYWCL000491
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 14:34:32 -0700
Received: from qwd7 (qwd7.prod.google.com [10.241.193.199])
	by wpaz33.hot.corp.google.com with ESMTP id o9SLYVQK030009
	for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 14:34:31 -0700
Received: by qwd7 with SMTP id 7so2476604qwd.24
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2010 14:34:31 -0700 (PDT)
In-Reply-To: <20101028162239.10346b0ye9g07iww@webmail.meer.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Le 28 octobre 2010 13:22, weasel@meer.net <weasel@meer.net> a =E9crit :
>
> during a test that creates a CRC error (target to initiator) by dropp=
ing
> a data word from a frame w/o recomputing the CRC, i can induce a 'loo=
p'
> case. the controller sees the the CRC error, issues a device reset, a=
nd
> the scsi request comes back w/ DID_RESET set (rather than DID_PARITY =
or
> something else since it has already done the reset). i have an issue =
out
> to the controller vendor about this, but sallying forth to
> linux-scsi-land regardless...

i should have=A0added that my mumbling about frames is because the
controller is doing SAS to SATA translation. their target reset logic
and how they 'squash' the scsi request's 'return value' are done in
their firmware block, and i'm not sure how doable/convenient/etc it is
to get more verbose errors from their firmware (ie, they can't
translate dropped words into an underrun, but they might be able to
say something like ata's ICRC).

> scsi_decide_disposition() looking at a command w/ DID_RESET returns
> SUCCESS and then scsi_io_completion() unconditionally retries the
> command. w/ our injector setup to corrupt alternating data frames i c=
an
> induce an 'infinite loop' in the case where the controller's reset wo=
rks
> and then the scsi READ(10) fails.
>
> anyway, i'd like to avoid this loop regardless of 'odd' controller
> behavior so am asking about the two possible fixes i see and to see i=
f
> there's some other way.
>
> - make scsi_decide_disposition()'s handling of DID_RESET just use the
> =A0maybe_retry logic.
>
> =A0however, (being new to this area) scsi_io_completion() calls
> =A0scsi_end_request() in case some data actually got read. i don't se=
e that
> =A0a request w/ DID_RESET set can have data, but if it really can, th=
en...
>
> - copy retry logic to scsi_io_completion() in the DID_RESET case. usi=
ng
> =A0cmd->retries seems safe here since it won't ahve gotten updated in
> =A0scsi_decide_disposition(), but maybe a comment there might be nice=
=2E
>
> am i offbase/missing something/lacking sufficient details?
>
> \p
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
