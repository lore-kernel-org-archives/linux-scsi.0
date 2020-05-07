Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853A7C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 15:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28B7C207DD
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 15:34:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ts.fujitsu.com header.i=@ts.fujitsu.com header.b="GiD+KHE8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726538AbgEGPeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 11:34:25 -0400
Received: from mail1.bemta25.messagelabs.com ([195.245.230.69]:37015 "EHLO
        mail1.bemta25.messagelabs.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgEGPeY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 7 May 2020 11:34:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ts.fujitsu.com;
        s=200619tsfj; t=1588865662; i=@ts.fujitsu.com;
        bh=9jLCyMS+NJA1/GiB9td/8msyydEVwXvXDjLxZRIXzbs=;
        h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=GiD+KHE8lmVqclsviNCrRGoLJXZWbqoACOFZ1+jip16gd5jODmFvXIqPEUPVSS8YT
         HYTF/M1yO8qQFNZyV/HsvxPmHpKNGBvKKBZqnyn8zeT6dPqN+cU7XC2sxJBOTpEHEp
         7gKU4ZnTi84flNMnqFBEIo34xkcIqtuj48Tqsc+EFK8YCmSSVecTQcf4BXmId3Erpb
         smIc5slyJjMacch74ACJ1qCz4Z+h2wq6N+M5E01pFPS4S9Pt5U5nCJzFEq2pTDiBdr
         wxtOkF4KksSihoqmsXd30sTN2lm8LicviyJChVXl2q6YDYm7XyZgmVbtT3CpR4gyQ1
         J0R5H2XT1x/xA==
Received: from [100.112.198.209] (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256 bits))
        by server-5.bemta.az-b.eu-west-1.aws.symcld.net id 09/B2-40486-D7A24BE5; Thu, 07 May 2020 15:34:21 +0000
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCIsWRWlGSWpSXmKPExsViZ8MRolurtSX
  OYNs8TYtpH34yW3Rf38Fmsfz4PyaL9Uc2MFq0Ln3L5MDqcfmKt8fHp7dYPN7vu8rm8XmTXABL
  FGtmXlJ+RQJrxqIbJ9kL/vJWvPn4g62B8Q93FyMXh5DATEaJW++fMnUxcnKwCRhIrJh0nwXEF
  hYIlLgxbQobSJGIwFVGicPXloAleAUcJaYtXcLYxcjBwSKgItHwkRUkLCoQLvFiyx9WiBJBiZ
  Mzn4CVMwuYSczb/JAZwhaXuPVkPhOELS+x/e0c5gmM3LOQtMxC0jILScssJC0LGFlWMVokFWW
  mZ5TkJmbm6BoaGOgaGhrpGlpa6hqamOolVukm6aWW6panFpfoGuollhfrFVfmJuek6OWllmxi
  BAZoSsHxiTsY16x9r3eIUZKDSUmUd8nnzXFCfEn5KZUZicUZ8UWlOanFhxhlODiUJHi/KW6JE
  xIsSk1PrUjLzAFGC0xagoNHSYSXXQkozVtckJhbnJkOkTrFqMux8+i8RcxCLHn5ealS4rxfFI
  CKBECKMkrz4EbAIvcSo6yUMC8jAwODEE9BalFuZgmq/CtGcQ5GJWHeHpBLeDLzSuA2vQI6ggn
  oiM+fNoEcUZKIkJJqYOrdve+V29qQ6GaL3S93+sU/v1Wdmh/3Q97nDtPkNPMNFcnK/yxWBa1e
  pnhw5cN9T5VWz797MYP59kIR/7Kz9pLdE35NeZo869nWj1tjj7Za7dioVnpULDP9yrXLN6wDn
  bi/xE2M+KuZf3ZhavPJ+vZVKf1Pvh7Y7/1xzcL/MWU/Dly0SE9KOdz+bbKgrHHe1EO7E5f/2u
  MuyMDwcM1MXvHz6751nbqy9lb7zjuZ5w1Vr7+uKK8pPLXIeX/T+Q3r52yz17936GpS4vyG325
  JH7dnMDC3HF/h+yxUJU1tztuKNfpui3vvu8l3zHK5o7lsZr1N0ceDLBN5k+6vr/4r08a44XHu
  UsPUuK4T678a1y6VVWIpzkg01GIuKk4EAEQxJn1XAwAA
X-Env-Sender: bstroesser@ts.fujitsu.com
X-Msg-Ref: server-16.tower-287.messagelabs.com!1588865660!1134!1
X-Originating-IP: [62.60.8.84]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.50.1; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 30158 invoked from network); 7 May 2020 15:34:21 -0000
Received: from unknown (HELO mailhost3.uk.fujitsu.com) (62.60.8.84)
  by server-16.tower-287.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 7 May 2020 15:34:21 -0000
Received: from [172.17.80.59] ([172.17.80.59])
        by mailhost3.uk.fujitsu.com (8.14.5/8.14.5) with ESMTP id 047FXTTo007067;
        Thu, 7 May 2020 16:33:47 +0100
From:   Bodo Stroesser <bstroesser@ts.fujitsu.com>
Subject: Lun unlink from configFS for Loopback after TMR execution hangs
 forever
To:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <mchristi@redhat.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Message-ID: <ffee233a-fe6d-e1c9-7071-9fb463453b0c@ts.fujitsu.com>
Date:   Thu, 7 May 2020 17:33:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.1.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I am testing with Loopback and found, that after a
Loopback LUN has executed a TMR, I can no longer unlink
the LUN.

The rm command hangs in transport_clear_lun_ref() at
wait_for_completion(&lun->lun_shutdown_comp)

The reason is, that transport_lun_remove_cmd() is not
called at the end of target_tmr_work().

It seems, that in other fabrics this call happens implicitly
when the fabric driver calls transport_generic_free_cmd()
during its ->queue_tm_rsp().

Unfortunately the Loopback seems to not comply to the common
way of calling transport_generic_free_cmd() from ->queue_*(),
but calls it from its ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the
se_cmd->se_lun pointer.
Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So it seems, that Loopback driver is doing wrong.

OTOH, target_tmr_work() seems to be the only place, where
transport_cmd_check_stop_to_fabric() is called without
calling transport_lun_remove_cmd() before.

Now I'm wondering, how to fix the problem:
1) Just (re-)add a call to transport_lun_remove_cmd() before
    calling transport_cmd_check_stop_to_fabric() in
    target_tmr_work()
2) Change Loopback driver to comply with the usual way
    of using transport_generic_free_cmd()

I think I'd prefer 1 and already tested it, works fine for
Loopback. Currently I'm not able to test other fabrics, but
AFAICS the change should not harm other fabric drivers,
because transport_lun_remove_cmd() uses a bit to make safe,
that lun_ref is dropped only once.
Additionally, before commit 2c9fa49e100f "scsi: target/core:
  Make ABORT and LUN RESET handling synchronous" the code
contained the transport_lun_remove_cmd() call.

Regards,
Bodo
