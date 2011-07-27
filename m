From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND 03/11] bnx2fc: Support 'sequence cleanup' task
Date: Wed, 27 Jul 2011 15:40:57 +0400
Message-ID: <1311766857.5029.1.camel@mulgrave>
References: <1311717109-14077-1-git-send-email-bprakash@broadcom.com>
	 <1311717109-14077-4-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41348 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618Ab1G0Llm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2011 07:41:42 -0400
In-Reply-To: <1311717109-14077-4-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, mchan@broadcom.com, devel@open-fcoe.org

On Tue, 2011-07-26 at 14:51 -0700, Bhanu Prakash Gollapudi wrote:
> For the devices that support sequence level error recovery, based on =
the REC
> response, the firmware has to be informed about the offset from which=
 the
> retransmission should happen. Driver initiates sequence cleanup task =
to
> firmware so that the firmware can program the task. Upon the sequence=
 cleanup
> completion, SRR is issued to retransmit the sequence.
>=20
> Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc.h     |   10 ++++
>  drivers/scsi/bnx2fc/bnx2fc_hwi.c |   97 ++++++++++++++++++++++++++++=
++++++
>  drivers/scsi/bnx2fc/bnx2fc_io.c  |  106 ++++++++++++++++++++++++++++=
++++++++++
>  3 files changed, 213 insertions(+), 0 deletions(-)

Well, I got another two patches include, but this one doesn't compile:

  CC [M]  drivers/scsi/bnx2fc/bnx2fc_io.o
drivers/scsi/bnx2fc/bnx2fc_io.c: In function
=E2=80=98bnx2fc_initiate_seq_cleanup=E2=80=99:
drivers/scsi/bnx2fc/bnx2fc_io.c:987:8: error: =E2=80=98struct bnx2fc_el=
s_cb_arg=E2=80=99
has no member named =E2=80=98r_ctl=E2=80=99
drivers/scsi/bnx2fc/bnx2fc_io.c:988:8: error: =E2=80=98struct bnx2fc_el=
s_cb_arg=E2=80=99
has no member named =E2=80=98offset=E2=80=99
drivers/scsi/bnx2fc/bnx2fc_io.c: In function
=E2=80=98bnx2fc_process_seq_cleanup_compl=E2=80=99:
drivers/scsi/bnx2fc/bnx2fc_io.c:1235:21: error: =E2=80=98struct
bnx2fc_els_cb_arg=E2=80=99 has no member named =E2=80=98offset=E2=80=99
drivers/scsi/bnx2fc/bnx2fc_io.c:1236:29: error: =E2=80=98struct
bnx2fc_els_cb_arg=E2=80=99 has no member named =E2=80=98r_ctl=E2=80=99
drivers/scsi/bnx2fc/bnx2fc_io.c:1252:2: error: implicit declaration of
function =E2=80=98bnx2fc_send_srr=E2=80=99
make[1]: *** [drivers/scsi/bnx2fc/bnx2fc_io.o] Error 1
make: *** [drivers/scsi/bnx2fc/bnx2fc.ko] Error 2

I assume it has to be combined with one of the other patches to make a
bisectable unit?

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
