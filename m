From: Roland Dreier <roland@purestorage.com>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Tue, 16 May 2017 12:59:29 -0700
Message-ID: <CAL1RGDVBvgzaQTRfWS14=S1M1DuzKGPYzAPWWeQyAASDQ=05Rw@mail.gmail.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
 <1488485325.5580.9.camel@haakon3.risingtidesystems.com> <20170305173528.00006b41@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f49.google.com ([209.85.214.49]:35923 "EHLO
        mail-it0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdEPT7u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2017 15:59:50 -0400
Received: by mail-it0-f49.google.com with SMTP id o5so69168294ith.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2017 12:59:50 -0700 (PDT)
In-Reply-To: <20170305173528.00006b41@gmx.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sebastian Herbszt <herbszt@gmx.de>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, jsmart2021@gmail.com, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>

On Sun, Mar 5, 2017 at 8:35 AM, Sebastian Herbszt <herbszt@gmx.de> wrote:
> Just like Hannes I do favour integration. I guess it could be
> comparable to qla2xxx + tcm_qla2xxx, lpfc + lpfc_scst and
> lpfc + tcm_lpfc. That approach might even help Bart with his
> target driver unification if he didn't give up on that topic.

Resurrecting this old topic - sorry for not seeing this go by initially.

For context, I have a lot of experience debugging the qla2xxx target
code - we did a lot of work to get error/exception paths correct.
Basic FC target support is pretty straightforward but handling SAN log
in / log out events and other strange things that initiators do took a
lot of effort.

Anyway, my feeling is that the integration of tcm_qla2xxx and qla2xxx
was overall a net negative.  Having the target driver grafted onto the
side of an already-complex driver that has a bunch of code not
relevant to the target (SCSI error handling, logging into and timing
out remote target ports, etc) made the code harder to debug and harder
to get right.

Of course I'm in favor of making common code really common.  So
certainly we should have a common library of SLI-4 code that both the
initiator and target driver share.  And if there is more commonality,
that's great.  But any code similar to "if (initiator) ... else ..."
is really suspect to me - grepping for "qla_ini_mode_enabled" shows
great examples like

                if (fcport->scan_state == QLA_FCPORT_SCAN) {
                        if ((qla_dual_mode_enabled(vha) ||
                            qla_ini_mode_enabled(vha)) &&
                            atomic_read(&fcport->state) == FCS_ONLINE) {
                                qla2x00_mark_device_lost(vha, fcport,
                                        ql2xplogiabsentdevice, 0);
                                if (fcport->loop_id != FC_NO_LOOP_ID &&
                                    (fcport->flags & FCF_FCP2_DEVICE) == 0 &&
                                    fcport->port_type != FCT_INITIATOR &&
                                    fcport->port_type != FCT_BROADCAST) {
                                        ql_dbg(ql_dbg_disc, vha, 0xffff,
                                            "%s %d %8phC post del sess\n",
                                            __func__, __LINE__,
                                            fcport->port_name);

                                        qlt_schedule_sess_for_deletion_lock
                                                (fcport);
                                        continue;
                                }
                        }
                }

Handling "dual mode" (both initiator and target on the same port at
the same time) is a design challenge, but I don't think the current
qla2xxx driver is an example of a maintainable way to do that.

(I'm agnostic about what to do about SLI-3 - perhaps the cleanest
thing to do is split the driver between SLI-4 and SLI-3, and handle
the initiator and target drivers for those two cases as appropriate)

I'd love to discuss this further and come up with a design that meets
the concerns about integration but also learns the lessons from
tcm_qla2xxx.

 - R.
